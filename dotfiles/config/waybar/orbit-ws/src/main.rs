use std::collections::{HashMap, HashSet};
use std::fs;
use std::io::{self, Write};

use serde::Deserialize;
use swayipc::{Connection, Event, EventType, Node, NodeType};

// ── Config ──

#[derive(Debug, Deserialize)]
struct Config {
    colors: HashMap<String, String>,
    settings: Settings,
}

#[derive(Debug, Deserialize)]
struct Settings {
    workspace_nums: Option<Vec<i32>>,
    num_color: Option<String>,
    empty_icon: Option<String>,
    empty_color: Option<String>,
    default_icon: Option<String>,
    default_color: Option<String>,
    ws_separator: Option<String>,
    focused_format: Option<String>,
    focused_bg_shade: Option<f64>,
    num_dim_factor: Option<f64>,
    icon_dim_factor: Option<f64>,
    empty_icon_dim: Option<f64>,
    icon_desaturate: Option<f64>,
    tooltip_enabled: Option<bool>,
    tooltip_format: Option<String>,
    tooltip_separator: Option<String>,
    reconnect_delay: Option<u64>,
    output_class: Option<String>,
    strip_prefixes: Option<Vec<String>>,
    urgent_enabled: Option<bool>,
    urgent_color: Option<String>,
    icon_separator: Option<String>,
    pad_left: Option<String>,
    pad_right: Option<String>,
    unfocused_icon: Option<String>,
    focused_icon: Option<String>,
    urgent_icon: Option<String>,
}

// ── Errors ──

#[derive(Debug, thiserror::Error)]
enum Error {
    #[error("Can't read config '{path}': {source}")]
    ConfigRead { path: String, source: std::io::Error },
    #[error("Can't parse config '{path}': {source}")]
    ConfigParse { path: String, source: toml::de::Error },
    #[error("sway IPC error: {0}")]
    Ipc(#[from] swayipc::Error),
    #[error("can't write to stdout: {0}")]
    Stdout(#[from] std::io::Error),
    #[error("event stream ended")]
    StreamEnded,
}

// ── State ──

#[derive(Debug, Clone, Default)]
struct WindowInfo {
    app_id: String,
    workspace_id: i64,
    urgent: bool,
}

#[derive(Debug, Clone, Default)]
struct WorkspaceInfo {
    id: i64,
    num: i32,
    focused: bool,
}

// ── App ID normalization ──

fn normalize_app_id(raw: &str, prefixes: &[String]) -> String {
    let mut s = raw;
    for prefix in prefixes {
        if let Some(stripped) = s.strip_prefix(prefix.as_str()) {
            s = stripped;
            break;
        }
    }
    s.replace('.', "")
}

// ── Tree extraction (windows only) ──

fn extract_windows(node: &Node, current_ws: Option<i64>, prefixes: &[String]) -> Vec<WindowInfo> {
    let mut windows = Vec::new();
    match node.node_type {
        NodeType::Workspace => {
            if node.name.as_deref() == Some("__i3_scratch") {
                return windows;
            }
            let ws_id = node.id;
            for child in &node.nodes {
                windows.extend(extract_windows(child, Some(ws_id), prefixes));
            }
            for child in &node.floating_nodes {
                windows.extend(extract_windows(child, Some(ws_id), prefixes));
            }
        }
        NodeType::Con | NodeType::FloatingCon => {
            let has_app = node.app_id.as_ref().is_some_and(|s| !s.is_empty())
                || node
                    .window_properties
                    .as_ref()
                    .and_then(|wp| wp.class.as_ref())
                    .is_some_and(|s| !s.is_empty());

            if has_app {
                let raw = node
                    .app_id
                    .clone()
                    .or_else(|| {
                        node.window_properties
                            .as_ref()
                            .and_then(|wp| wp.class.clone())
                    })
                    .unwrap_or_default();
                let app_id = normalize_app_id(&raw, prefixes);
                if let Some(ws_id) = current_ws {
                    windows.push(WindowInfo { app_id, workspace_id: ws_id, urgent: node.urgent });
                }
            }
            for child in &node.nodes {
                windows.extend(extract_windows(child, current_ws, prefixes));
            }
            for child in &node.floating_nodes {
                windows.extend(extract_windows(child, current_ws, prefixes));
            }
        }
        _ => {
            for child in &node.nodes {
                windows.extend(extract_windows(child, current_ws, prefixes));
            }
            for child in &node.floating_nodes {
                windows.extend(extract_windows(child, current_ws, prefixes));
            }
        }
    }
    windows
}

// ── Color helpers ──

fn dim_color(hex: &str, factor: f64, offset: f64) -> String {
    let h = hex.trim_start_matches('#');
    if h.len() != 6 {
        return hex.to_string();
    }
    let r = u8::from_str_radix(&h[0..2], 16).unwrap_or(0) as f64;
    let g = u8::from_str_radix(&h[2..4], 16).unwrap_or(0) as f64;
    let b = u8::from_str_radix(&h[4..6], 16).unwrap_or(0) as f64;
    let r = ((r * factor) + offset).min(255.0) as u8;
    let g = ((g * factor) + offset).min(255.0) as u8;
    let b = ((b * factor) + offset).min(255.0) as u8;
    format!("#{:02x}{:02x}{:02x}", r, g, b)
}

fn desaturate_color(hex: &str, factor: f64) -> String {
    let h = hex.trim_start_matches('#');
    if h.len() != 6 || factor == 0.0 {
        return hex.to_string();
    }
    let r = u8::from_str_radix(&h[0..2], 16).unwrap_or(0) as f64;
    let g = u8::from_str_radix(&h[2..4], 16).unwrap_or(0) as f64;
    let b = u8::from_str_radix(&h[4..6], 16).unwrap_or(0) as f64;
    let gray = 0.299 * r + 0.587 * g + 0.114 * b;
    let r2 = (r + (gray - r) * factor).round() as u8;
    let g2 = (g + (gray - g) * factor).round() as u8;
    let b2 = (b + (gray - b) * factor).round() as u8;
    format!("#{:02x}{:02x}{:02x}", r2, g2, b2)
}

fn shade_color(hex: &str, factor: f64) -> String {
    let h = hex.trim_start_matches('#');
    if h.len() != 6 {
        return hex.to_string();
    }
    let r = u8::from_str_radix(&h[0..2], 16).unwrap_or(0) as f64;
    let g = u8::from_str_radix(&h[2..4], 16).unwrap_or(0) as f64;
    let b = u8::from_str_radix(&h[4..6], 16).unwrap_or(0) as f64;
    let r = (r * factor).min(255.0) as u8;
    let g = (g * factor).min(255.0) as u8;
    let b = (b * factor).min(255.0) as u8;
    format!("#{:02x}{:02x}{:02x}", r, g, b)
}

// ── Render ──

fn render(config: &Config, workspaces: &[WorkspaceInfo], windows: &[WindowInfo]) -> String {
    let s = &config.settings;

    let num_color = s.num_color.as_deref().unwrap_or("#a6adc8");
    let empty_icon = s.empty_icon.as_deref().unwrap_or("\u{00B7}");
    let empty_color = s.empty_color.as_deref().unwrap_or("#585b70");
    let default_icon = s.default_icon.as_deref().unwrap_or("?");
    let default_color = s.default_color.as_deref().unwrap_or("#a6adc8");
    let ws_sep = s.ws_separator.as_deref().unwrap_or("  ");
    let focused_fmt = s.focused_format.as_deref().unwrap_or("<b>{}</b>");
    let focused_bg = s
        .focused_bg_shade
        .map(|f| shade_color("#242a2e", f))
        .unwrap_or_else(|| "#363a42".to_string());
    let num_dim = s.num_dim_factor.unwrap_or(0.35);
    let icon_dim = s.icon_dim_factor.unwrap_or(0.35);
    let empty_icon_d = s.empty_icon_dim.unwrap_or(icon_dim);
    let icon_desat = s.icon_desaturate.unwrap_or(0.0);
    let tooltip_enabled = s.tooltip_enabled.unwrap_or(true);
    let tooltip_sep = s.tooltip_separator.as_deref().unwrap_or("\n");
    let output_class = s.output_class.as_deref().unwrap_or("workspaces");
    let urgent_enabled = s.urgent_enabled.unwrap_or(true);
    let urgent_color = s.urgent_color.as_deref().unwrap_or("#f38ba8");

    let mut ws_windows: HashMap<i64, Vec<&WindowInfo>> = HashMap::new();
    for win in windows {
        ws_windows.entry(win.workspace_id).or_default().push(win);
    }

    let urgent_ws: HashSet<i64> = windows
        .iter()
        .filter(|w| w.urgent)
        .map(|w| w.workspace_id)
        .collect();

    let has_urgent = !urgent_ws.is_empty();

    let mut segments: Vec<String> = Vec::new();

    for ws in workspaces {
        let win_list = ws_windows.get(&ws.id).map(|v| v.as_slice()).unwrap_or(&[]);
        let count = win_list.len();
        let is_urgent = urgent_enabled && urgent_ws.contains(&ws.id);

        let num_c = if ws.focused {
            num_color.to_string()
        } else {
            dim_color(num_color, num_dim, 0.0)
        };

        let ws_text = if count == 0 {
            let ec = dim_color(empty_color, empty_icon_d, 0.0);
            format!("<span color='{}'>{}</span> <span color='{}'>{}</span>", num_c, ws.num, ec, empty_icon)
        } else if is_urgent {
            let icon = s.urgent_icon.as_deref().unwrap_or(default_icon);
            format!("<span color='{}'>{}</span> <span color='{}'>{}</span>", num_c, ws.num, urgent_color, icon)
        } else {
            let parts: Vec<String> = win_list
                .iter()
                .map(|win| {
                    let has_color = config.colors.contains_key(&win.app_id);
                    let icon = if !has_color {
                        default_icon
                    } else if ws.focused {
                        s.focused_icon.as_deref().unwrap_or(default_icon)
                    } else {
                        s.unfocused_icon.as_deref().unwrap_or(default_icon)
                    };
                    let color = config
                        .colors
                        .get(&win.app_id)
                        .map(|s| s.as_str())
                        .unwrap_or(default_color);
                    let c = if ws.focused {
                        color
                    } else {
                        &dim_color(&desaturate_color(color, icon_desat), icon_dim, 0.0)
                    };
                    format!("<span color='{}'>{}</span>", c, icon)
                })
                .collect();
            let icon_sep = s.icon_separator.as_deref().unwrap_or(" ");
            format!("<span color='{}'>{}</span> {}", num_c, ws.num, parts.join(icon_sep))
        };

        if ws.focused {
            segments.push(focused_fmt.replace("{bg}", &focused_bg).replace("{}", &ws_text));
        } else {
            segments.push(ws_text);
        }
    }

    let text = segments.join(ws_sep);
    let pad_left = s.pad_left.as_deref().unwrap_or("");
    let pad_right = s.pad_right.as_deref().unwrap_or("");
    let text = format!("{}{}{}", pad_left, text, pad_right);

    let tooltip = if tooltip_enabled {
        let lines: Vec<String> = workspaces
            .iter()
            .filter_map(|ws| {
                let count = ws_windows.get(&ws.id).map(|v| v.len()).unwrap_or(0);
                if count > 0 {
                    let line = if let Some(fmt) = &s.tooltip_format {
                        fmt.replace("{num}", &ws.num.to_string())
                            .replace("{count}", &count.to_string())
                    } else {
                        format!("ws{}: {} ventana{}", ws.num, count, if count == 1 { "" } else { "s" })
                    };
                    Some(line)
                } else {
                    None
                }
            })
            .collect();
        lines.join(tooltip_sep)
    } else {
        String::new()
    };

    let class = if has_urgent {
        serde_json::json!([output_class, "urgent"])
    } else {
        serde_json::json!([output_class])
    };

    let output = serde_json::json!({
        "text": text,
        "tooltip": tooltip,
        "class": class
    });
    serde_json::to_string(&output)
        .unwrap_or_else(|_| format!(r#"{{"text":"error","class":"{}"}}"#, output_class))
}

// ── Config loading ──

fn load_config() -> Result<Config, Error> {
    let config_path = std::env::args()
        .nth(1)
        .unwrap_or_else(|| {
            let home = std::env::var("HOME").unwrap_or_else(|_| "/home/ixos".to_string());
            format!("{}/.config/sway/workspaces.toml", home)
        });
    let content = fs::read_to_string(&config_path)
        .map_err(|source| Error::ConfigRead { path: config_path.clone(), source })?;
    let config: Config = toml::from_str(&content)
        .map_err(|source| Error::ConfigParse { path: config_path, source })?;
    Ok(config)
}

// ── Daemon ──

fn get_state(conn: &mut Connection, settings: &Settings) -> Result<(Vec<WorkspaceInfo>, Vec<WindowInfo>), Error> {
    let sway_workspaces = conn.get_workspaces()?;
    let tree = conn.get_tree()?;

    let mut ws_map: HashMap<i32, WorkspaceInfo> = HashMap::new();
    for w in sway_workspaces {
        ws_map.insert(w.num, WorkspaceInfo {
            id: w.id,
            num: w.num,
            focused: w.focused,
        });
    }

    let nums = settings.workspace_nums.clone().unwrap_or_else(|| {
        let mut v: Vec<i32> = ws_map.keys().copied().collect();
        v.sort();
        v
    });

    let workspaces: Vec<WorkspaceInfo> = nums
        .into_iter()
        .map(|n| ws_map.remove(&n).unwrap_or(WorkspaceInfo { id: 0, num: n, focused: false }))
        .collect();

    let prefixes: Vec<String> = settings.strip_prefixes.clone()
        .unwrap_or_else(|| vec!["org.".into(), "com.".into(), "net.".into(), "io.".into()]);
    let windows = extract_windows(&tree, None, &prefixes);

    Ok((workspaces, windows))
}

fn run_daemon(config: &Config) -> Result<(), Error> {
    let mut query_conn = Connection::new()?;
    let event_conn = Connection::new()?;
    let mut events = event_conn.subscribe([EventType::Workspace, EventType::Window])?;

    let (workspaces, windows) = get_state(&mut query_conn, &config.settings)?;
    let output = render(config, &workspaces, &windows);
    println!("{}", output);
    io::stdout().flush()?;

    loop {
        match events.next() {
            Some(Ok(Event::Workspace(_))) | Some(Ok(Event::Window(_))) => {
                let state = get_state(&mut query_conn, &config.settings).or_else(|_| {
                    query_conn = Connection::new()?;
                    get_state(&mut query_conn, &config.settings)
                });
                match state {
                    Ok((workspaces, windows)) => {
                        let output = render(config, &workspaces, &windows);
                        println!("{}", output);
                        io::stdout().flush()?;
                    }
                    Err(e) => return Err(e),
                }
            }
            Some(Ok(_)) => {}
            Some(Err(e)) => return Err(Error::from(e)),
            None => return Err(Error::StreamEnded),
        }
    }
}

fn main() {
    let config = match load_config() {
        Ok(c) => c,
        Err(e) => {
            eprintln!("orbit-ws: {}", e);
            std::process::exit(1);
        }
    };
    let delay = config.settings.reconnect_delay.unwrap_or(1);
    loop {
        if let Err(e) = run_daemon(&config) {
            eprintln!("orbit-ws: {}, reconnecting in {}s", e, delay);
            std::thread::sleep(std::time::Duration::from_secs(delay));
        }
    }
}

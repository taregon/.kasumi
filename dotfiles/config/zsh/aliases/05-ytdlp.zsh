# yt-dlp
alias yt-720='yt-dlp --windows-filenames --write-url-link --geo-bypass --trim-filenames 125 -o "%(webpage_url_domain)s [%(id)s] %(uploader)s - %(title)s.%(ext)s" -f "bv[height=720][ext=mp4]+ba[ext=m4a]" --merge-output-format mp4'
alias yt-1080='yt-dlp --windows-filenames --write-url-link --geo-bypass --trim-filenames 125 -o "%(webpage_url_domain)s [%(id)s] %(uploader)s - %(title)s.%(ext)s" -f "bv[height=1080][ext=mp4]+ba[ext=m4a]" --merge-output-format mp4'
alias yt-dlp='yt-dlp --windows-filenames --write-url-link --geo-bypass --trim-filenames 125 -o "%(webpage_url_domain)s [%(id)s] %(uploader)s - %(title)s.%(ext)s"'
alias yt-mp3='yt-dlp -f ba -x --audio-format mp3'
alias yt-update="python3 -m pip install -U yt-dlp"

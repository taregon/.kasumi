" QUICKFIX SYNTAX PERSONALIZADO
" Columnas:
" archivo │ línea:col │ estado │ texto

if exists('b:current_syntax')
  finish
endif

" ─────────────────────────────────────────────
" Archivo
syn match qfFileName /^[^│]*/ nextgroup=qfSeparator1

" Línea:col
syn match qfSeparator1 /│/ contained nextgroup=qfLineNr
syn match qfLineNr /[^│]*/ contained nextgroup=qfSeparator2

" Estado (Added / Removed / Changed)
syn match qfSeparator2 /│/ contained nextgroup=qfStatus
syn match qfStatus /[^│]*/ contained nextgroup=qfSeparator3

" Texto final
syn match qfSeparator3 /│/ contained nextgroup=qfText
syn match qfText /.*/ contained

" Sub-matches del estado
syn match qfAdded   /\<Added\>/   containedin=qfStatus
syn match qfRemoved /\<Removed\>/ containedin=qfStatus
syn match qfChanged /\<Changed\>/ containedin=qfStatus

" Highlight links
hi def link qfFileName Directory
hi def link qfLineNr   LineNr
hi def link qfText     Normal

hi def link qfAdded    DiffAdd
hi def link qfRemoved  DiffDelete
hi def link qfChanged  DiffChange

hi def link qfSeparator1 Delimiter
hi def link qfSeparator2 Delimiter
hi def link qfSeparator3 Delimiter

let b:current_syntax = 'qf'

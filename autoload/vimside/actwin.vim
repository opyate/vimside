" ============================================================================
" actwin.vim
"
" File:          actwin.vim
" Summary:       action window
" Author:        Richard Emberson <richard.n.embersonATgmailDOTcom>
" Last Modified: 2013
"
" ============================================================================
" Intro: {{{1
" ============================================================================

" let s:LOG = function("vimside#log#log")
" let s:ERROR = function("vimside#log#error")

function! s:LOG(msg)
  execute "redir >> ". "AW_LOG"
  silent echo "INFO: ". a:msg
  execute "redir END"
endfunction
function! s:ERROR(msg)
  execute "redir >> ". "AW_LOG"
  silent echo "ERROR: ". a:msg
  execute "redir END"
endfunction

" TODO
" color_column :hi ColorColumn ctermbg=lightgrey guibg=lightgrey
" allow toggle with key_map, leader cmd
"    toggle: {
"      key_map: "t",
"      leader_cmd: "t",
"      builtin_cmd: "t",
"    }

" toggle: km uc bc
" leader_cmds
" builtin cmds
"
" toggle
"   is_XXX_enable
"   is_XXX_on
"
"   source window
"     sign
"       category
"       different kinds
"       current position
"     entity
"       row (sign or highlight)
"       column (color or highlight)
"       row & column
"       cursorcolumn
"   actwin window
"     cursorline cl
"     text highlight th
"     lines highlight lh

"
" vimside properties
" vimside.quickfix.texthl.group=
" vimside.quickfix.texthl.ctermfg=
"
" for line inf readfile(prop_file)
"   if [found, name, value] = ParseProp(line)
"   if found
"   endif
" endfor
"  let [namepath, value] = split(line, "=")
"  let names = split(namepath, ".")
"
"  vimside.actwin.quickfix.window.sign.error.textln.group=
"  vimside.actwin.quickfix.window.sign.error.textln.cterm=
"

"
" term= bold underline reverse italic standout NONE
" cterm= bold underline reverse italic standout NONE
" ctermfg
" ctermbg
" gui=
" guifg=
" guibg=
"  attrs
"    bold
"    underline
"    reverse
"    italic
"    standout
"    NONE
"  ctermfg color_nr or simple_color_name
"  ctermbg color_nr or simple_color_name
"  guifg  color_name
"  guibg  color_name
"  
"  group="Comment"
"  group="Comment"
"  texthl={ ... fg/bg}
"  texthl=group
"  linehl={ fg/bg}
"  linehl=group
"
"

"
" remove entry, list of entries
" help: 
" active row/column highlight 
" range of lines
"
"http://vim.wikia.com/wiki/Deleting_a_buffer_without_closing_the_window
"
"http://stackoverflow.com/questions/2447109/showing-a-different-background-colour-in-vim-past-80-characters
"http://stackoverflow.com/questions/235439/vim-80-column-layout-concerns
"http://vim.wikia.com/wiki/Highlight_current_line
"
"sort entries
"various sort functions
"
"help: no display, one line, full help vim help
"
"range of source lines per target line
"sign a range of lines
"
"
"options
"row/column display

let s:is_color_column_enabled = 0

let s:split_cmd_default = "new"
let s:split_size_default = "10"
let s:split_below_default = 1
let s:split_right_default = 0
let s:edit_cmd_default = "enew"
let s:tab_cmd_default = "tabnew"

let s:dislay_source_sign_toggle_default = "ss"
let s:dislay_source_sign_is_on_default = 0
let s:dislay_source_color_line_toggle_default = "cl"
let s:dislay_source_color_line_is_on_default = 0
let s:dislay_source_color_column_toggle_default = "cc"
let s:dislay_source_color_column_is_on_default = 0

let s:dislay_window_cursor_line_toggle_default = "wcl"
let s:dislay_window_cursor_line_is_on_default = 0
let s:dislay_window_highlight_line_toggle_default = "whl"
let s:dislay_window_highlight_line_is_on_default = 0
let s:dislay_window_highlight_line_is_full_default = 0
let s:dislay_window_highlight_line_all_text_default = 0

let s:dislay_window_sign_toggle_default = "sw"
let s:dislay_window_sign_is_on_default = 0
let s:dislay_window_sign_all_text_default = 0


let s:winname_default="ActWin"

" control whether or not buffer entry events trigger 
" save/restore option code execution
let s:buf_change = 1

" actwin {
"   is_global: 0,
"   is_info_open: 0,
"   source_win_nr: source_win_nr
"   source_buffer_nr: source_buffer_nr
"   source_buffer_name: source_buffer_name
"   buffer_nr
"   win_nr
"   uid: unique id
"   tag: tag
"   first_buffer_line: first_buffer_line
"   current_line: current_line
"   linenos_to_entrynos: []
"   entrynos_to_linenos: []
"   entrynos_to_nos_of_lines: []
"   is_info_open: 0
"   data {
"   }
" }
" data {
"   title: ""
"   winname: ""
"   buffer_nr: number
"   action: create/modify/append/replace default create
"   help: {
"     do_show: 0
"     is_open: 0
"     .....
"   }
"   window: {
"     split; {
"        cmd: "new"
"        size: "10"
"        below: 1
"        right: 0
"     }
"     edit: {
"        cmd: "enew"
"     }
"     tab: {
"        cmd: "tabnew"
"     }
"   }
"   key_map: {
"     window_key_map_show: ""
"     source_builtin_cmd_show: ""
"     source_leader_cmd_show: ""
"     help: ""
"     select: []
"     select_mouse: []
"     enter_mouse: []
"     down: []
"     up: []
"     close: []
"   }
"   builtin_cmd: {
"   }
"   leader_cmd: {
"     up: cp
"     down: cn
"     close: ccl
"   }
"   sign: {
"     category: QuickFix
"     abbreviation: qf
"     kinds: {
"       kname: {text, textlh, linehl }
"       .....
"     }
"   }
"   actions: {
"     enter:
"     leave:
"     select:
"   }
"   entries: [ 
"     file:
"     line:
"     optional col: (default 0)
"     content: [lines] and/or line
"     id: unique identifying number 
"     kind: 'error'
"     optional actions: {
"       enter:
"       leave:
"       select:
"     } (default global actions)
"   ]
" }
"


" quickfix commands
"  :cc 
"  :cn 
"  :cp 
"  :cr 
"  :cl 
"    override
"      http://vim.wikia.com/wiki/Replace_a_builtin_command_using_cabbrev
"      cabbrev e <c-r>=(getcmdtype()==':' && getcmdpos()==1 ? 'E' : 'e')<CR>
"    leader
" open quickfix commands
"    existing
"      <Leader>ve
"
"

" functions that can be bound to keys (key mappings)
" key_map
let s:cmds_window_defs = {
      \ "window_key_map_show": [ "ToggleWindowKeyMapInfo", "Display window key-map info" ],
      \ "source_builtin_cmd_show": [ "ToggleSourceBuiltinCmdInfo", "Display source builtin cmd info" ],
      \ "source_leader_cmd_show": [ "ToggleSourceLeaderCmdInfo", "Display source leader cmd info" ],
      \ "help": [ "OnHelp", "Display help" ],
      \ "select": [ "OnSelect", "Select current line" ],
      \ "enter_mouse": [ "OnEnterMouse", "Use mouse to set current line" ],
      \ "down": [ "OnDown", "Move down to next line" ],
      \ "top": [ "OnTop", "Move to top line" ],
      \ "bottom": [ "OnBottom", "Move to bottom line" ],
      \ "up": [ "OnUp", "Move up to next line" ],
      \ "left": [ "OnLeft", "Move left one postion" ],
      \ "right": [ "OnRight", "Move right one postion" ],
      \ "close": [ "OnClose", "Close window"]
      \ }

" mappings to override existing builtin commands
let s:cmds_source_defs = {
      \ "first": [ "g:VimsideActWinFirst", "Goto first line" ],
      \ "last": [ "g:VimsideActWinLast", "Goto last line" ],
      \ "previous": [ "g:VimsideActWinUp", "Move up to next line" ],
      \ "next": [ "g:VimsideActWinDown", "Move down to next line" ],
      \ "enter": [ "g:VimsideActWinEnter", "Enter window" ],
      \ "close": [ "g:VimsideActWinClose", "Close window" ]
      \ }

" globals = {
"   type1: actwin1
"   type2: actwin2
"   .....
" }
let s:globals = {}

" locals = {
"   src_buffer_nos1: {
"      tag1: actwin1
"      tag2: actwin2
"      tag3: actwin3
"      ....
"   }
"   src_buffer_nos2: {
"      ....
"   }
"   ....
" }
"
" source_buffer_nr -> tags 
"    tags 1-1 target_buffer_nr
"
let s:locals = {}

" TODO maps from unique id -> actwin
let s:uid_to_actwin = {}

" maps actwin buffer number to actwin
let s:actwin_buffer_nr_to_actwin = {}

" --------------------------------------------
" Util
" --------------------------------------------


let s:next_uid = 0
function! s:NextUID()
  let l:uid = s:next_uid
  let s:next_uid += 1
  return l:uid
endfunction

function! s:Redraw()
  if has('gui_running') || has('gui_macvim')
    redraw
  else
    redraw!
  endif
endfunction

" MUST be called from local buffer
" return [0, _] or [1, actwin]
function! s:GetBufferActWin()
  if exists("b:buffer_nr") && has_key(s:actwin_buffer_nr_to_actwin, b:buffer_nr)
    return [1, s:actwin_buffer_nr_to_actwin[b:buffer_nr]]
  else
    return [0, ""]
  endif
endfunction

function! s:GetActWin(buffer_nr)
  if has_key(s:actwin_buffer_nr_to_actwin, a:buffer_nr)
    return [1, s:actwin_buffer_nr_to_actwin[a:buffer_nr]]
  else
    return [0, ""]
  endif
endfunction

" --------------------------------------------
" Initialize
" --------------------------------------------

" MUST be called from local buffer
function! s:Initialize(actwin)
call s:LOG("Initialize TOP")
call s:LOG("Initialize current buffer=". bufnr("%"))

  " must create handlers first
  call s:CreateFileHandlers(a:actwin)

  call s:MakeAutoCmds(a:actwin)
  call s:MakeCmds(a:actwin)


  " TODO is this needed ... only when using the same window
  " how about using enter/leave buffer autocmd maps instead
  let b:insertmode = &insertmode
  let b:showcmd = &showcmd
  let b:cpo = &cpo
  let b:report = &report
  let b:list = &list
  set noinsertmode
  set noshowcmd
  set cpo&vim
  let &report = 10000
  set nolist

  set bufhidden=hide

  setlocal nonumber
  setlocal foldcolumn=0
  setlocal nofoldenable
  setlocal nospell
  setlocal nobuflisted
call s:LOG("Initialize current buffer=". bufnr("%"))
call s:LOG("Initialize BOTTOM")
endfunction

" --------------------------------------------
" Source File Handlers
" --------------------------------------------

function! s:CreateFileHandlers(actwin)
  let a:actwin.files = []
  let a:actwin.handlers = {}
  let a:actwin.handlers['on_new_file'] = []
  let a:actwin.handlers['on_close'] = []
endfunction

function! s:CallNewFileHandlers(actwin, file, entrynos)
call s:LOG("s:CallNewFileHandlers: TOP file=". a:file)
  call add(a:actwin.files, a:file)

  for l:Handler in a:actwin.handlers.on_new_file
    call l:Handler(a:actwin, a:file, a:entrynos)
  endfor
call s:LOG("s:CallNewFileHandlers: BOTTOM")
endfunction

function! s:CallOnCloseHandlers(actwin)
  let l:onclosehandlers = a:actwin.handlers.on_close
  for l:file in a:actwin.files
    for l:Handler in l:onclosehandlers
      call l:Handler(a:actwin, l:file)
    endfor
  endfor
  let a:actwin.files = []
endfunction

" --------------------------------------------
" Auto Cmds
" --------------------------------------------

" MUST be called from local buffer
function! s:MakeAutoCmds(actwin)
call s:LOG("MakeAutoCmds current buffer=". bufnr("%"))
  augroup ACT_WIN_AUTOCMD
    " autocmd!
    
    execute "autocmd BufEnter <buffer=". bufnr("%") ."> call s:BufEnter()"
    execute "autocmd BufLeave <buffer=". bufnr("%") ."> call s:BufLeave()"

    execute "autocmd BufWinEnter <buffer=". bufnr("%") ."> call s:BufWinEnter()"
    execute "autocmd BufWinLeave <buffer=". bufnr("%") ."> call s:BufWinLeave()"
  augroup END
endfunction

function! s:CloseAutoCmds(actwin)
call s:LOG("CloseAutoCmds close buffer=". a:actwin.buffer_nr)
call s:LOG("CloseAutoCmds current buffer=". bufnr("%"))
 augroup ACT_WIN_AUTOCMD
   execute "autocmd! *  <buffer=". a:actwin.buffer_nr .">"
 augroup END
endfunction

" --------------------------------------------
" Cmds
" --------------------------------------------

" MUST be called from local buffer
function! s:MakeCmds(actwin)
  call s:MakeWindowKeyMappings(a:actwin)
  call s:MakeWindowLeaderCommands(a:actwin)
  call s:MakeWindowBuiltinCommands(a:actwin)

  call s:MakeSourceKeyMappings(a:actwin)
  call s:MakeSourceLeaderCommands(a:actwin)
  call s:MakeSourceBuiltinCommands(a:actwin)
endfunction

" MUST be called from local buffer
function! s:ClearCmds(actwin)
  call s:ClearSourceKeyMappings(a:actwin)
  call s:ClearSourceLeaderCommands(a:actwin)
  call s:ClearSourceBuiltinCommands(a:actwin)
endfunction

" MUST be called from local buffer
function! s:MakeWindowKeyMappings(actwin)
  if ! empty(a:actwin.data.cmds.window.key_map)
    for [l:key, l:value] in items(a:actwin.data.cmds.window.key_map)
      let [l:fn, l:txt] = s:cmds_window_defs[l:key]
      for l:v in l:value
        execute 'nnoremap <script> <silent> <buffer> '. l:v .' :call <SID>'. l:fn .'()<CR>'
      endfor
    endfor
  endif
endfunction

" MUST be called from local buffer
function! s:MakeWindowLeaderCommands(actwin)
  if ! empty(a:actwin.data.cmds.window.leader_cmd)
    for [l:key, l:value] in items(a:actwin.data.cmds.window.leader_cmd)
      let [l:fn, l:txt] = s:cmds_window_defs[l:key]
      for l:v in l:value
        execute ":nnoremap <silent> <buffer> <Leader>". l:v ." :call ". l:fn ."()<CR>"
      endfor
    endfor
  endif
endfunction

" MUST be called from local buffer
function! s:MakeWindowBuiltinCommands(actwin)
  if ! empty(a:actwin.data.cmds.window.builtin_cmd)
    for [l:key, l:value] in items(a:actwin.data.cmds.window.builtin_cmd)
      let [l:fn, l:txt] = s:cmds_window_defs[l:key]
      for l:v in l:value
        execute "cabbrev <silent> <buffer> ". l:v ." <c-r>=(getcmdtype()==':' && getcmdpos()==1 ? 'call ". l:fn ."()' : '". l:v ."')<CR>"
      endfor
    endfor
  endif
endfunction




" MUST be called from local buffer
function! s:MakeSourceKeyMappings(actwin)
  if ! empty(a:actwin.data.cmds.source.key_map)
    let l:leader_cmd = a:actwin.data.cmds.source.key_map
    let l:buffer_nr =  a:actwin.buffer_nr
    let l:is_global = a:actwin.is_global

    if l:is_global
      for [l:key, l:value] in items(l:leader_cmd)
        let [l:fn, l:txt] = s:cmds_source_defs[l:key]
        for l:v in l:value
          execute ":nnoremap <silent> ". l:v ." :silent call ". l:fn ."(". l:buffer_nr .")<CR>"
        endfor
      endfor

    else
      let s:buf_change = 0
      execute 'silent '. a:actwin.source_win_nr.'wincmd w'
        for [l:key, l:value] in items(l:leader_cmd)
          let [l:fn, l:txt] = s:cmds_source_defs[l:key]
          for l:v in l:value
            execute ":nnoremap <silent> <buffer> ". l:v ." :silent call ". l:fn ."(". l:buffer_nr .")<CR>"
          endfor
        endfor
      execute 'silent '. a:actwin.win_nr.'wincmd w'
      let s:buf_change = 1
    endif
  endif
endfunction

function! s:ClearSourceKeyMappings(actwin)
  if ! empty(a:actwin.data.cmds.source.key_map)
    let s:buf_change = 0
    let l:is_global = a:actwin.is_global

    if l:is_global
      for l:value in values(a:actwin.data.cmds.source.key_map)
        for l:v in l:value
          execute "nunmap ". l:v
        endfor
      endfor
    else
      " execute 'silent '. a:actwin.source_win_nr.'wincmd w'
      execute ':buffer '. a:actwin.source_buffer_nr
      for l:value in values(a:actwin.data.cmds.source.key_map)
        for l:v in l:value
          execute "nunmap <buffer> ". l:v
        endfor
      endfor
      execute 'silent '. a:actwin.win_nr.'wincmd w'
    endif
    let s:buf_change = 1
  endif
endfunction

" MUST be called from local buffer
function! s:MakeSourceLeaderCommands(actwin)
  if ! empty(a:actwin.data.cmds.source.leader_cmd)
    let l:leader_cmd = a:actwin.data.cmds.source.leader_cmd
    let l:buffer_nr =  a:actwin.buffer_nr
    let l:is_global = a:actwin.is_global

    if l:is_global
      for [l:key, l:value] in items(l:leader_cmd)
        let [l:fn, l:txt] = s:cmds_source_defs[l:key]
        for l:v in l:value
          execute ":nnoremap <silent> <Leader>". l:v ." :silent call ". l:fn ."(". l:buffer_nr .")<CR>"
        endfor
      endfor

    else
      let s:buf_change = 0
      execute 'silent '. a:actwin.source_win_nr.'wincmd w'
call s:LOG("s:MakeSourceLeaderCommands: win_rn=". a:actwin.source_win_nr )
        for [l:key, l:value] in items(l:leader_cmd)
          let [l:fn, l:txt] = s:cmds_source_defs[l:key]
          for l:v in l:value
call s:LOG("s:MakeSourceLeaderCommands: key=". l:key .", value=" . l:v)
            execute ":nnoremap <buffer> <silent> <Leader>". l:v ." :silent call ". l:fn ."(". l:buffer_nr .")<CR>"
          endfor
        endfor
      execute 'silent '. a:actwin.win_nr.'wincmd w'
      let s:buf_change = 1
    endif
  endif
endfunction

" MUST be called from local buffer
function! s:ClearSourceLeaderCommands(actwin)
  if ! empty(a:actwin.data.cmds.source.leader_cmd)
    let s:buf_change = 0
    let l:is_global = a:actwin.is_global

    if l:is_global
      for l:value in values(a:actwin.data.cmds.source.leader_cmd)
        for l:v in l:value
          execute ":nunmap <silent> <Leader>". l:v
        endfor
      endfor
    else
      " execute 'silent '. a:actwin.source_win_nr.'wincmd w'
      execute ':buffer '. a:actwin.source_buffer_nr
call s:LOG("s:ClearSourceLeaderCommands: win_rn=". a:actwin.source_win_nr )
      for l:value in values(a:actwin.data.cmds.source.leader_cmd)
        for l:v in l:value
call s:LOG("s:ClearSourceLeaderCommands: value=" . l:v)
          execute ":nunmap <buffer> <Leader>". l:v
        endfor
      endfor
      execute 'silent '. a:actwin.win_nr.'wincmd w'
    endif
    let s:buf_change = 1
  endif
endfunction



function! s:MakeSourceBuiltinCommands(actwin)
  " :cabbrev e <c-r>=(getcmdtype()==':' && getcmdpos()==1 ? 'E' : 'e')<CR>
  if ! empty(a:actwin.data.cmds.source.builtin_cmd)
    let l:builtin_cmd = a:actwin.data.cmds.source.builtin_cmd
    let l:buffer_nr =  a:actwin.buffer_nr
    let l:is_global = a:actwin.is_global

    if l:is_global
      for [l:key, l:value] in items(l:builtin_cmd)
        let [l:fn, l:txt] = s:cmds_source_defs[l:key]
        for l:v in l:value
          execute "cabbrev <silent> ". l:v ." <c-r>=(getcmdtype()==':' && getcmdpos()==1 ? 'call ". l:fn ."(". l:buffer_nr .")' : '". l:v ."')<CR>"
        endfor
      endfor

    else
      let s:buf_change = 0
      execute 'silent '. a:actwin.win_nr.'wincmd w'
      for [l:key, l:value] in items(l:builtin_cmd)
        let [l:fn, l:txt] = s:cmds_source_defs[l:key]
        for l:v in l:value
        execute "cabbrev <silent> ". l:v ." <c-r>=(getcmdtype()==':' && getcmdpos()==1 ? 'call ". l:fn ."(". l:buffer_nr .")' : '". l:v ."')<CR>"
        endfor
      endfor
      execute 'silent '. a:actwin.win_nr.'wincmd w'
      let s:buf_change = 1
    endif
  endif
endfunction

" MUST be called from local buffer
function! s:ClearSourceBuiltinCommands(actwin)
  " :cabbrev e <c-r>=(getcmdtype()==':' && getcmdpos()==1 ? 'E' : 'e')<CR>
  " cunabbrev e
  if ! empty(a:actwin.data.cmds.source.builtin_cmd)
    let s:buf_change = 0
    let l:builtin_cmd = a:actwin.data.cmds.source.builtin_cmd
    let l:is_global = a:actwin.is_global

    if l:is_global
      for l:value in values(l:builtin_cmd)
        for l:v in l:value
          execute "cunabbrev ". l:v
        endfor
      endfor

    else
      execute 'silent '. a:actwin.win_nr.'wincmd w'
      for l:value in values(l:builtin_cmd)
        for l:v in l:value
          execute "cunabbrev ". l:v
        endfor
      endfor
      execute 'silent '. a:actwin.win_nr.'wincmd w'

    endif
    let s:buf_change = 1
  endif
endfunction



" --------------------------------------------
" Main entry function
" --------------------------------------------

function! vimside#actwin#DisplayLocal(tag, data)
call s:LOG("DisplayLocal TOP")
  let l:data = deepcopy(a:data)
  let l:source_buffer_name = bufname("%")
  let l:source_buffer_nr = bufnr("%")
  let l:source_win_nr = bufwinnr(l:source_buffer_nr)
call s:LOG("DisplayLocal l:source_buffer_nr=". l:source_buffer_nr)
call s:LOG("DisplayLocal l:source_win_nr=". l:source_win_nr)

  if has_key(s:locals, l:source_buffer_nr)
    let l:bnr_dic = s:locals[l:source_buffer_nr]
    if has_key(l:bnr_dic, a:tag)
      let l:action = s:GetAction(l:data)
      if l:action == 'm'
        " modify
        let l:actwin = l:bnr_dic[a:tag]
      elseif l:action == 'a'
        " append
        let l:actwin = l:bnr_dic[a:tag]
      elseif l:action == 'r'
        " replace
        let l:actwin = l:bnr_dic[a:tag]
      else
        " create
        let l:uid = s:NextUID()
        let l:actwin = {
            \ "is_global": 0,
            \ "is_info_open": 0,
            \ "source_win_nr": l:source_win_nr,
            \ "source_buffer_nr": l:source_buffer_nr,
            \ "source_buffer_name": l:source_buffer_name,
            \ "tag": a:tag,
            \ "uid": l:uid,
            \ "data": l:data
          \ }
        let l:bnr_dic[a:tag] = l:actwin

        let l:action = 'c'
      endif

    else
      let l:uid = s:NextUID()
      let l:actwin = {
          \ "is_global": 0,
          \ "is_info_open": 0,
          \ "source_win_nr": l:source_win_nr,
          \ "source_buffer_nr": l:source_buffer_nr,
          \ "source_buffer_name": l:source_buffer_name,
          \ "tag": a:tag,
          \ "uid": l:uid,
          \ "data": l:data
        \ }
      let l:bnr_dic[a:tag] = l:actwin

      let l:action = 'c'
    endif

  else
    let l:uid = s:NextUID()
    let l:actwin = {
        \ "is_global": 0,
        \ "is_info_open": 0,
        \ "source_win_nr": l:source_win_nr,
        \ "source_buffer_nr": l:source_buffer_nr,
        \ "source_buffer_name": l:source_buffer_name,
        \ "tag": a:tag,
        \ "uid": l:uid,
        \ "data": l:data
      \ }
    let l:bnr_dic = {}
    let l:bnr_dic[a:tag] = l:actwin
    let s:locals[l:source_buffer_nr] = l:bnr_dic

    let l:action = 'c'
  endif
call s:LOG("DisplayLocal action=". l:action)

  " make adjustments, modification and replacements
  if l:action == 'c'
    " save actwin by its uid
    let s:uid_to_actwin[l:actwin.uid] = l:actwin
    " create = new display
    call s:Adjust(l:actwin.data)
  elseif l:action == 'm'
    " modify = change non-entries
    call s:Modify(l:actwin.data, l:data)
  elseif l:action == 'r'
    " replace entries
    call s:ReplaceEntries(l:actwin.data, l:data)
  else
    " append entries
    call s:AppendEntries(l:actwin.data, l:data)
  endif

  if l:action == 'c'
    let l:window =  l:data.window
    let l:winname =  l:data.winname

    let l:window = l:actwin.data.window
    if has_key(l:window, 'split')
call s:LOG("DisplayLocal split")
      let l:split = l:window.split

      " save current values
      let l:below = &splitbelow
      let &splitbelow = l:split.below

      let l:right = &splitright
      let &splitright = l:split.right

      let l:cmd = l:split.cmd
      let l:size = l:split.size

      silent execute l:size . l:cmd .' '. l:winname

      " restore values
      let &splitbelow = l:below
      let &splitright = l:right

    elseif has_key(l:window, 'edit')
call s:LOG("DisplayLocal edit")
      let l:edit = l:window.edit
      let l:cmd = l:edit.cmd
call s:LOG("DisplayLocal l:cmd=". l:cmd)
call s:LOG("DisplayLocal current buffer=". bufnr("%"))
      " execute l:cmd .' '. l:winname
      execute l:cmd 
call s:LOG("DisplayLocal current buffer=". bufnr("%"))

    elseif has_key(l:window, 'tab')
call s:LOG("DisplayLocal tab")
      let l:tab = l:window.tab
      let l:cmd = l:tab.cmd
      execute l:cmd .' '. l:winname

    endif

    " save the buffer and window number
    let l:actwin.buffer_nr = bufnr("%")
    let l:actwin.win_nr = bufwinnr(l:actwin.buffer_nr)
    let b:return_win_nr = l:source_win_nr 

call s:LOG("DisplayLocal l:actwin.buffer_nr=". l:actwin.buffer_nr)
    let b:buffer_nr = l:actwin.buffer_nr
    let s:actwin_buffer_nr_to_actwin[l:actwin.buffer_nr] = l:actwin

let s:buf_change = 0
    call s:Initialize(l:actwin)
  endif

  call s:LoadDisplay(l:actwin)

  call s:DisplayDefine(l:actwin)

  call s:DisplayEnable(l:actwin)

call s:LOG("Display actwin_buffer=". l:actwin.buffer_nr)

  call s:EnterEntry(0, l:actwin)

let s:buf_change = 1

 echo  "Show cmds: <F2>"

call s:LOG("DisplayLocal BOTTOM")
endfunction

if 0 " GLOBAL
function! vimside#actwin#DisplayGlobal(type, data)
  let l:data = deepcopy(a:data)
  let l:source_buffer_name = bufname("%")
  let l:source_buffer_nr = bufnr("%")

  if has_key(s:globals, a:type)
    let l:action = s:GetAction(l:data)
    " not modify replace or append
    if l:action == 'm' || l:action == 'r' || l:action == 'a'
      let l:actwin = s:globals[a:type]
    else
      let l:uid = s:NextUID()
      let l:actwin = {
          \ "is_global": 1,
          \ "source_buffer_nr": l:source_buffer_nr,
          \ "source_buffer_name": l:source_buffer_name,
          \ "type": a:type,
          \ "uid": l:uid,
          \ "data": l:data
        \ }
      let s:globals[a:type] = l:actwin

      let l:action = 'c'
    endif
  else
    let l:uid = s:NextUID()
    let l:actwin = {
        \ "is_global": 1,
        \ "source_buffer_nr": l:source_buffer_nr,
        \ "source_buffer_name": l:source_buffer_name,
        \ "type": a:type,
        \ "uid": l:uid,
        \ "data": l:data
      \ }
    let s:globals[a:type] = l:actwin

    let l:action = 'c'
  endif
call s:LOG("DisplayGlobal action=". l:action)

  " make adjustments, modification and replacements
  if l:action == 'c'
    " save actwin by its uid
    let s:uid_to_actwin[l:actwin.uid] = l:actwin
    " create = new display
    call s:Adjust(l:actwin.data)
  elseif l:action == 'm'
    " modify = change non-entries
    call s:Modify(l:actwin.data, l:data)
  elseif l:action == 'r'
    " replace entries
    call s:ReplaceEntries(l:actwin.data, l:data)
  else
    " append entries
    call s:AppendEntries(l:actwin.data, l:data)
  endif








  call s:AdjustInput()

  if s:running == 0
    let s:original_buffer_name = bufname("%")
    let s:original_buffer_nr = bufnr("%")

    let s:_splitbelow = &splitbelow
    let &splitbelow = 1

    " do split cmd
    if l:split_mode != ""
      " exe 'keepalt '. l:split_mode
      let l:winname = has_key(s:dic, 'winname') ? s:dic.winname : s:winname_default
      execute s:split_size . l:split_mode .' '. l:winname
    endif
  endif


  " only does something it s:running == 0
  call s:Initialize()

  call s:LoadDisplay()
  call s:DisplayDefine(l:actwin)

call s:LOG("Display actwin_buffer=". bufnr("%"))

  call s:EnterEntry(0, l:actwin)

call s:LOG("Display BOTTOM")
endfunction
endif " GLOBAL

"   action: create/modify/append create
function! s:GetAction(data)
  if has_key(a:data, 'action') 
    if a:data.action == 'c' 
      return 'c'
    elseif a:data.action == 'm' 
      return 'm'
    elseif a:data.action == 'a' 
      return 'a'
    elseif a:data.action == 'r' 
      return 'r'
    endif
  endif 

  return 'c'
endfunction

function! s:AdjustMapping(owner, mapname, ref_map_defs)
  if ! has_key(a:owner, a:mapname)
    let a:owner[a:mapname] = {}
  else
    let map = {}
    for [l:key, l:value] in items(a:owner[a:mapname])
      if ! has_key(a:ref_map_defs, l:key)
        call s:ERROR('AdjustMapping '. a:mapname .' - bad key "'. l:key .'"')
      elseif type(l:value) == type("") 
        let map[l:key] = [ l:value ]
      elseif type(l:value) == type([])
        let map[l:key] = l:value
      else
        call s:ERROR('AdjustMapping '. a:mapname .' - for key "'. l:key .'" bad value type: '. type(l:value))
      endif
      unlet l:value
    endfor
    let a:owner[a:mapname] = map
  endif
endfunction

if 0 " NOTUSED
function! s:CheckMapping(mapname, keyvals, ref_map_defs)
  for [l:key, l:value] in items(a:keyvals)
    if ! has_key(a:ref_map_defs, l:key)
      call s:ERROR('Adjust '. a:mapname .' - bad key "'. l:key .'"')
    elseif type(l:value) != type("") && type(l:value) != type([])
      call s:ERROR('Adjust '. a:mapname .' - for key "'. l:key .'" bad value type: '. type(l:value))
    endif

    unlet l:value
  endfor
endfunction
endif " NOTUSED

function! s:Adjust(data)
call s:LOG("Adjust  TOP")
  if ! has_key(a:data, 'winname')
    let a:data['winname'] = s:winname_default
  endif

  "--------------
  " cmds
  "--------------
  if ! has_key(a:data, 'cmds')
    let a:data['cmds'] = {}
  endif
  let l:cmds = a:data.cmds

  if ! has_key(l:cmds, 'window')
    let l:cmds['window'] = {}
  endif
  let l:window = l:cmds.window

  if ! has_key(l:cmds, 'source')
    let l:cmds['source'] = {}
  endif
  let l:source = l:cmds.source

  " window cmds
  call s:AdjustMapping(l:window, 'key_map', s:cmds_window_defs)

if 0 " NOUSE
  if ! has_key(l:window, 'key_map')
    let l:window['key_map'] = {}
  else
    call s:CheckMapping('key_map', l:window.key_map, s:cmds_window_defs)

" NOUSE
    for [l:key, l:value] in items(l:window.key_map)
      if ! has_key(s:cmds_window_defs, l:key)
        call s:ERROR('Adjust key_map - bad key "'. l:key .'"')
      elseif type(l:value) != type("") && type(l:value) != type([])
        call s:ERROR('Adjust key_map - for key "'. l:key .'" bad value type: '. type(l:value))
      endif

      unlet l:value
    endfor
  endif
endif " NOUSE

  call s:AdjustMapping(l:window, 'builtin_cmd', s:cmds_window_defs)
  call s:AdjustMapping(l:window, 'leader_cmd', s:cmds_window_defs)

if 0 " NOUSE
  if ! has_key(l:window, 'builtin_cmd')
    let l:window['builtin_cmd'] = {}
  else
    call s:CheckMapping('builtin_cmd', l:window.builtin_cmd, s:cmds_window_defs)
  endif

  if ! has_key(l:window, 'leader_cmd')
    let l:window['leader_cmd'] = {}
  else
    call s:CheckMapping('leader_cmd', l:window.leader_cmd, s:cmds_window_defs)
  endif
endif " NOUSE

  " source cmds
  call s:AdjustMapping(l:source, 'key_map', s:cmds_source_defs)
  call s:AdjustMapping(l:source, 'builtin_cmd', s:cmds_source_defs)
  call s:AdjustMapping(l:source, 'leader_cmd', s:cmds_source_defs)

if 0 " NOUSE
  if ! has_key(l:source, 'key_map')
    let l:source['key_map'] = {}
  else
    call s:CheckMapping('key_map', l:source.key_map, s:cmds_source_defs)
  endif

  if ! has_key(l:source, 'builtin_cmd')
    let l:source['builtin_cmd'] = {}
  else
    call s:CheckMapping('builtin_cmd', l:source.builtin_cmd, s:cmds_source_defs)

" NOUSE
    for [l:key, l:value] in items(l:source.builtin_cmd)
      if ! has_key(s:cmds_source_defs, l:key)
        call s:ERROR('Adjust builtin_cmd - bad key "'. l:key .'"')
      elseif type(l:value) != type("") && type(l:value) != type([])
        call s:ERROR('Adjust builtin_cmd - for key "'. l:key .'" bad value type: '. type(l:value))
      endif

      unlet l:value
    endfor
  endif

  if ! has_key(l:source, 'leader_cmd')
    let l:source['leader_cmd'] = {}
  else
    call s:CheckMapping('leader_cmd', l:source.leader_cmd, s:cmds_source_defs)

    for [l:key, l:value] in items(l:source.leader_cmd)
      if ! has_key(s:cmds_source_defs, l:key)
        call s:ERROR('Adjust leader_cmd - bad key "'. l:key .'"')
      elseif type(l:value) != type("") && type(l:value) != type([])
        call s:ERROR('Adjust leader_cmd - for key "'. l:key .'" bad value type: '. type(l:value))
      endif

      unlet l:value
    endfor
  endif
endif " NOUSE

  "--------------
  " window
  "--------------
  if ! has_key(a:data, 'window')
    let a:data['window'] = {
      \ "split": {
        \ "cmd": s:split_cmd_default,
        \ "size": s:split_size_default,
        \ "below": s:split_below_default,
        \ "right": s:split_right_default 
        \ }
      \ }
  else
    let l:window = a:data.window
    if has_key(l:window, 'split')
      let l:split = l:window.split
      if ! has_key(l:split, 'cmd')
        let l:split['cmd'] = s:split_cmd_default
      endif
      if ! has_key(l:split, 'size')
        let l:split['size'] = s:split_size_default
      endif
      if ! has_key(l:split, 'below')
        let l:split['below'] = s:split_below_default
      endif
      if ! has_key(l:split, 'right')
        let l:split['right'] = s:split_right_default
      endif

    elseif has_key(l:window, 'edit')
      let l:edit = l:window.edit
      if ! has_key(l:edit, 'cmd')
        let l:edit['cmd'] = s:edit_cmd_default
      endif

    elseif has_key(l:window, 'tab')
      let l:tab = l:window.tab
      if ! has_key(l:tab, 'cmd')
        let l:tab['cmd'] = s:tab_cmd_default
      endif

    else
      let l:window['split'] = {
          \ "cmd": s:split_cmd_default,
          \ "size": s:split_size_default,
          \ "below": s:split_below_default,
          \ "right": s:split_right_default 
        \ }
    endif
  endif

  if ! has_key(a:data, 'display')
    let a:data['display'] = {
        \ "source": {
          \ "sign": {
            \ "is_enable": 0
          \ },
          \ "color_line": {
            \ "is_enable": 0
          \ },
          \ "color_column": {
            \ "is_enable": 0
          \ }
        \ },
        \ "window": {
          \ "cursor_line": {
            \ "is_enable": 0
          \ },
          \ "highlight_line": {
            \ "is_enable": 0
          \ },
          \ "sign": {
            \ "is_enable": 0
          \ }
        \ }
      \ }
  else
    let l:display = a:data.display

    " display.source
    if ! has_key(l:display, 'source')
      let l:display['source'] = { 
          \ "sign": {
            \ "is_enable": 0
          \ }
        \ }
    else
      let l:source = l:display.source

      " display.source.sign
      if ! has_key(l:source, 'sign')
        let l:display['sign'] = {
          \ "is_enable": 0
          \ }
      else
        let l:sign = l:source.sign

        if ! has_key(l:sign, 'is_enable')
          let l:sign['is_enable'] = 0
        else
          if ! has_key(l:sign, 'toggle')
            let l:sign['toggle'] = s:dislay_source_sign_toggle_default
          endif
          if ! has_key(l:sign, 'is_on')
            let l:sign['is_on'] = s:dislay_source_sign_is_on_default
          endif

          if ! has_key(l:sign, 'kinds')
            let l:sign['kinds'] = {}
          endif
          if has_key(l:sign, 'default_kind')
            let l:default_kind = l:sign.default_kind
            if ! has_key(l:sign.kinds, l:default_kind)
              " TODO issue warning????
              unlet l:sign.default_kind
            endif
          endif
        endif
      endif

      " display.source.color_line
      if ! has_key(l:source, 'color_line')
        let l:display['color_line'] = {
          \ "is_enable": 0
          \ }
      else
        let l:color_line = l:source.color_line

        if ! has_key(l:color_line, 'is_enable')
          let l:color_line['is_enable'] = 0
        else
          if ! has_key(l:color_line, 'toggle')
            let l:color_line['toggle'] = s:dislay_source_color_line_toggle_default
          endif
          if ! has_key(l:color_line, 'is_on')
            let l:color_line['is_on'] = s:dislay_source_color_line_is_on_default
          endif
          if ! has_key(l:color_line, 'kinds')
            let l:color_line['kinds'] = {}
          endif
          if has_key(l:color_line, 'default_kind')
            let l:default_kind = l:color_line.default_kind
            if ! has_key(l:color_line.kinds, l:default_kind)
              " TODO issue warning????
              unlet l:color_line.default_kind
            endif
          endif
        endif
      endif

      " display.source.color_column
      if ! has_key(l:source, 'color_column')
        let l:display['color_column'] = {
          \ "is_enable": 0
          \ }
      else
        let l:color_column = l:source.color_column
        if ! has_key(l:color_column, 'is_enable')
          let l:color_column['is_enable'] = 0
        else
          if ! has_key(l:color_column, 'toggle')
            let l:color_column['toggle'] = s:dislay_source_color_column_toggle_default
          endif
          if ! has_key(l:color_column, 'is_on')
            let l:color_column['is_on'] = s:dislay_source_color_column_is_on_default
          endif

        endif
      endif
      
    endif



    " display.window
    if ! has_key(l:display, 'window')
      let l:display['window'] = { 
          \ "cursor_line": {
            \ "is_enable": 0
          \ },
          \ "highlight_line": {
            \ "is_enable": 0
          \ },
          \ "highlight_text": {
            \ "is_enable": 0
          \ }
        \ }
    else
      let l:window = l:display.window

      " display.window.cursor_line
      if ! has_key(l:window, 'cursor_line')
        let l:display['cursor_line'] = {
          \ "is_enable": 0
          \ }
      else
        let l:cursor_line = l:window.cursor_line

        if ! has_key(l:cursor_line, 'is_enable')
          let l:cursor_line['is_enable'] = 0
        else
          if ! has_key(l:cursor_line, 'toggle')
            let l:cursor_line['toggle'] = s:dislay_window_cursor_line_toggle_default
          endif
          if ! has_key(l:cursor_line, 'is_on')
            let l:cursor_line['is_on'] = s:dislay_window_cursor_line_is_on_default
          endif
        endif
      endif

      " display.window.highlight_line
      if ! has_key(l:window, 'highlight_line')
        let l:display['highlight_line'] = {
          \ "is_enable": 0
          \ }
      else
        let l:highlight_line = l:window.highlight_line

        if ! has_key(l:highlight_line, 'is_enable')
          let l:highlight_line['is_enable'] = 0
        else
          if ! has_key(l:highlight_line, 'toggle')
            let l:highlight_line['toggle'] = s:dislay_window_highlight_line_toggle_default
          endif
          if ! has_key(l:highlight_line, 'is_on')
            let l:highlight_line['is_on'] = s:dislay_window_highlight_line_is_on_default
          endif
          if ! has_key(l:highlight_line, 'is_full')
            let l:highlight_line['is_full'] = s:dislay_window_highlight_line_is_full_default
          endif
          if ! has_key(l:highlight_line, 'all_text')
            let l:highlight_line['all_text'] = s:dislay_window_highlight_line_all_text_default
          endif
        endif

        " TODO highlight colors
      endif

      " display.window.sign
      if ! has_key(l:window, 'sign')
        let l:display['sign'] = {
          \ "is_enable": 0
          \ }
      else
        let l:sign = l:window.sign
        if ! has_key(l:sign, 'is_enable')
          let l:sign['is_enable'] = 0
        endif
        if ! has_key(l:sign, 'toggle')
          let l:sign['toggle'] = s:dislay_window_sign_toggle_default
        endif
        if ! has_key(l:sign, 'is_on')
          let l:sign['is_on'] = s:dislay_window_sign_is_on_default
        endif
        if ! has_key(l:sign, 'all_text')
          let l:sign['all_text'] = s:dislay_window_sign_all_text_default
        endif

        if ! has_key(l:sign, 'kinds')
          let l:sign['kinds'] = {}
        endif
        if has_key(l:sign, 'default_kind')
          let l:default_kind = l:sign.default_kind
          if ! has_key(l:sign.kinds, l:default_kind)
            " TODO issue warning????
            unlet l:sign.default_kind
          endif
        endif
      endif
    endif
  endif

  if ! has_key(a:data, 'help')
    let a:data['help'] = {
      \ "do_show": 0,
      \ "is_open": 0
      \ }
  else
    if ! has_key(a:data.help, 'do_show')
      let a:data.help['do_show'] = 0
    endif
    if ! has_key(a:data.help, 'is_open')
      let a:data.help['is_open'] = 0
    endif
  endif

  if ! has_key(a:data, 'actions')
    let a:data['actions'] = {
      \ "enter": function("s:EnterActionDoNothing"),
      \ "select": function("s:SelectActionDoNothing"),
      \ "leave": function("s:LeaveActionDoNothing")
      \ }
  else
    if ! has_key(a:data.actions, 'enter')
      let a:data.actions['enter'] = function("s:EnterActionDoNothing")
    endif
    if ! has_key(a:data.actions, 'select')
      let a:data.actions['select'] = function("s:SelectActionDoNothing")
    endif
    if ! has_key(a:data.actions, 'leave')
      let a:data.actions['leave'] = function("s:LeaveActionDoNothing")
    endif
  endif
  if ! has_key(a:data, 'formatter')
      let a:data['formatter'] = function("s:FormatterDefault")
  endif

  if has_key(a:data, 'entries')
    for l:entry in a:data.entries
      if has_key(l:entry, 'file')
        let l:file = l:entry.file
        if filereadable(l:file)
          let l:entry.file = fnamemodify(l:file, ":p")
        endif
      endif
    endfor
  endif


call s:LOG("Adjust  BOTTOM")
endfunction

"   sign: {
"     category: QuickFix
"     kinds: {
"       kname: {text, textlh, linehl }
"     }
"   }
function! s:Modify(org_data, new_data)
  " Change sign
  "   category 
  "   abbreviation
  "   kinds
" TODO SIGN data.display.source.sign
  let l:has_org_data_sign = has_key(a:org_data, 'display') && has_key(a:org_data.display, 'source') && has_key(a:org_data.display.source, 'sign')
  let l:has_new_data_sign = has_key(a:new_data, 'display') && has_key(a:new_data.display, 'source') && has_key(a:new_data.display.source, 'sign')

  if l:has_org_data_sign && l:has_new_data_sign
    " TODO
  elseif l:has_org_data_sign 
    " TODO
  elseif l:has_new_data_sign 
    " register sign
    let l:sign = a:new_data.display.source.sign
    if ! vimside#sign#HasCategory(l:sign.category)
      vimside#sign#AddCategory(l:sign.category, l:sign)
    endif
  endif

  " Change action
  "   enter
  "   leave
  "   select
  "   If the new data has actions, then copy those key/values that it
  "   does not have from the original data; otherwise, copy the
  "   complete actions from original to new.
  if has_key(a:new_data, 'actions')
    let l:new_actions = a:new_data.actions
    if ! has_key(l:new_actions, 'enter')
      let l:new_actions['enter'] = a:org_data.actions.enter
    endif
    if ! has_key(l:new_actions, 'select')
      let l:new_actions['select'] = a:org_data.actions.select
    endif
    if ! has_key(l:new_actions, 'leave')
      let l:new_actions['leave'] = a:org_data.actions.leave
    endif
  else
    let a:new_data['actions'] = a:original.actions
  endif

endfunction

" remove org entries and copy new entries
function! s:ReplaceEntries(org_data, new_data)
  if has_key(a:new_data, 'entries')
    let a:org_data['entries'] = a:new_data.entries
  else
    let a:org_data['entries'] = []
  endif
endfunction

" copy entries from new_data.entries to org_data.entries
function! s:AppendEntries(org_data, new_data)
  if ! has_key(a:new_data, 'entries')
    " nothing to add
    return
  endif
  let l:new_entries = a:new_data.entries

  if ! has_key(a:org_data, 'entries')
    let a:org_data['entries'] = []
  endif

  let l:org_entries = a:org_data.entries

  for l:entry in l:new_entries
    call add(l:org_entries, l:entry)
  endfor
endfunction





function! s:AdjustInput()
  if ! has_key(s:dic, 'actions')
    let s:dic['actions'] = {
      \ "enter": function("s:EnterActionDoNothing"),
      \ "select": function("s:SelectActionDoNothing"),
      \ "leave": function("s:LeaveActionDoNothing")
      \ }
  else
    if ! has_key(s:dic.actions, 'enter')
      let s:dic.actions['enter'] = function("s:EnterActionDoNothing")
    endif
    if ! has_key(s:dic.actions, 'select')
      let s:dic.actions['select'] = function("s:SelectActionDoNothing")
    endif
    if ! has_key(s:dic.actions, 'leave')
      let s:dic.actions['leave'] = function("s:LeaveActionDoNothing")
    endif
  endif
endfunction

function! s:LoadDisplay(actwin)
call s:LOG("LoadDisplay current buffer=". bufnr("%"))
  setlocal buftype=nofile
  setlocal modifiable
  setlocal noswapfile
  setlocal nowrap

  execute "1,$d"

  call s:BuildDisplay(a:actwin)
  call cursor(a:actwin.first_buffer_line, 1)
  let a:actwin.current_line = a:actwin.first_buffer_line

 setlocal nomodifiable
endfunction

" --------------------------------------------
" FastHelp  
" --------------------------------------------

function! s:CreateToggleInfo(data_win, data_element, key_value, defs, actwin)
  let a:actwin.is_info_open = ! a:actwin.is_info_open 

  if ! a:actwin.is_info_open
    let a:actwin.first_buffer_line = 1
call s:LOG("CreateToggleInfo lines=[]")
    return []
  endif

  let l:cmds = a:actwin.data.cmds
  let l:data_win = l:cmds[a:data_win]
  let l:elements = l:data_win[a:data_element]

  let l:lines = []
  let l:size = 25

  if a:data_win == 'source'
    let l:title = 'Scala'
  elseif a:data_win == 'window'
    let l:title = a:actwin.data.winname
  else
    let l:title = "Window"
  endif

  if type(a:key_value) == type([]) && len(a:key_value) == 1
    let l:head = l:title ." ". a:data_element ." (toggle: '". a:key_value[0] ."')"
  else
    let l:head = l:title ." ". a:data_element ." (toggle: '". string(a:key_value) ."')"
  endif

  call add(l:lines, l:head)
  call add(l:lines, repeat('-', len(l:head)))


  for l:key in sort(keys(l:elements))
    let l:value = l:elements[l:key]
    let [l:fn, l:txt] = a:defs[l:key]
    if type(l:value) == type("")
      let l:head =  l:key ." '". l:value . "'"
      let l:len = len(l:head)
      call add(l:lines, l:head. repeat(' ', l:size - l:len) .': '. l:txt)
      
    elseif type(l:value) == type([])
      let l:vs = ""
      for l:v in l:value
        if l:vs == ""
          let l:vs = "'". l:v . "'"
        else
          let l:vs .= " '". l:v . "'"
        endif
      endfor
      let l:head =  l:key ." ". l:vs

      let l:len = len(l:head)
      call add(l:lines, l:head. repeat(' ', l:size - l:len) .': '. l:txt)

    endif

    unlet l:value
  endfor
  call add(l:lines, "")

call s:LOG("CreateToggleInfo lines=". string(l:lines))
  let a:actwin.first_buffer_line = len(lines) + 1
  return l:lines

endfunction


" --------------------------------------------
" Build Display
" --------------------------------------------
function! s:BuildDisplay(actwin)
call s:LOG("BuildDisplay TOP")
  let l:Formatter = a:actwin.data.formatter

  let a:actwin.first_buffer_line = 1

  let l:linenos_to_entrynos = []
  let l:entrynos_to_linenos = []
  let l:entrynos_to_nos_of_lines = []

  let l:linenos = 0
  let l:entrynos = 0
  let l:lines = []
  let l:lineslen = 0
  for entry in a:actwin.data.entries
    let l:current_lineslen = l:lineslen

    call l:Formatter(lines, entry)

    let l:lineslen = len(l:lines)
    let l:delta = l:lineslen - l:current_lineslen
    if l:delta == 1
      call add(l:linenos_to_entrynos, l:entrynos)
    else
      call extend(l:linenos_to_entrynos, repeat([l:entrynos], l:delta))
    endif

    call add(l:entrynos_to_linenos, l:lineslen)
    call add(l:entrynos_to_nos_of_lines, l:delta)

    let l:entrynos += 1

  endfor
call s:LOG("BuildDisplay current buffer=". bufnr("%"))

  call setline(a:actwin.first_buffer_line, lines)
  let a:actwin.linenos_to_entrynos = l:linenos_to_entrynos
  let a:actwin.entrynos_to_linenos = l:entrynos_to_linenos
  let a:actwin.entrynos_to_nos_of_lines = l:entrynos_to_nos_of_lines

call s:LOG("BuildDisplay BOTTOM")
endfunction

" ============================================================================
" Display: {{{1
"   LifeCycle:
"     Define
"     Enable
"     EnableFile
"     Toggle
"     Entry
"       Enter
"       Leave
"     DisableFile
"     Disable
"     Destroy
"
"
" Display Source LifeCycle: {{{1
"     Define - create structures
"       s:SourceDefineSigns(a:actwin)
"     Enable - enable on buffered files
"       s:SourceEnableSigns(a:actwin)
"     EnableFile (goto file previously not displayed)
"       s:SourceEnableFileSigns(a:actwin, a:file)
"     Toggle - toggle between effect on/off (Enable/Disable)
"       g:ToggleSigns(buffer_nr)
"       - ToggleSignMatch
"       - ToggleShowColumn - colorcolumn
"
" s:EnterEntry(0, l:actwin)
"   calls s:EnterActionQuickFix(entrynos, actwin)
"      calls s:SourceSetAtEntry(entrynos, actwin)
" s:SelectEntry(0, l:actwin)
"   calls s:SelectActionQuickFix(entrynos, actwin)
"      calls s:SourceGoToEntry(entrynos, actwin)
" s:LeaveEntry(0, l:actwin)
"   calls s:LeaveActionQuickFix(entrynos, actwin)
"      calls s:RemoveAtEntry(a:entrynos, a:actwin)
"
"     Entry
"       Enter - side effect of entering Window line
"       Leave - side effect of leaving Window line
"     DisableFile - disable on file that has been unbuffered
"     Disable - disable on buffered files
"       s:SourceDisableSigns(a:actwin)
"     Destroy - remove structures
"       s:SourceDestroySigns(a:actwin)
"
" Display Window LifeCycle: {{{1
"     Define - create structures
"       s:WindowDefineCursorLine(a:actwin)
"       s:WindowDefineHighlightLine(a:actwin)
"       s:WindowDefineSign(a:actwin)
"     Enable
"     EnableFile
"     Toggle - toggle between effect on/off (Enable/Disable)
"       g:ToggleCursorLine()
"       g:ToggleHighlightLine()
"       g:ToggleSign()
"     Entry
"       Enter call by s:EnterEntry(0, l:actwin)
"           s:WindowEnterCursorLine(a:entrynos, a:actwin)
"           s:WindowEnterHighlightLine(a:entrynos, a:actwin)
"           s:WindowEnterSign(a:entrynos, a:actwin)
"       Leave call by s:LeaveEntry(entrynos, actwin)
"           s:WindowLeaveCursorLine(a:entrynos, a:actwin)
"           s:WindowLeaveHighlightLine(a:entrynos, a:actwin)
"           s:WindowLeaveSign(a:entrynos, a:actwin)
"     DisableFile
"     Disable
"     Destroy - remove structures
"       s:WindowDestroyCursorLine(a:actwin)
"       s:WindowDestroyHighlightLine(a:actwin)
"       s:WindowDestroySign(a:actwin)
" ============================================================================

function! s:DisplayDefine(actwin)
  let l:display = a:actwin.data.display

  " source
  let l:source = l:display.source
  if l:source.sign.is_enable
    call s:SourceDefineSigns(a:actwin)
  endif
  if l:source.color_line.is_enable
    call s:SourceDefineColorLine(a:actwin)
  endif
  if l:source.color_column.is_enable
    call s:SourceDefineColorColumn(a:actwin)
  endif

  " window
  let l:window = l:display.window

  if l:window.cursor_line.is_enable
    call s:WindowDefineCursorLine(a:actwin)
  endif

  if l:window.highlight_line.is_enable
    call s:WindowDefineHighlightLine(a:actwin)
  endif

  if l:window.sign.is_enable
    call s:WindowDefineSign(a:actwin)
  endif

  " handlers
  call add(a:actwin.handlers.on_new_file, function("s:DisplayEnableFile"))
  call add(a:actwin.handlers.on_close, function("s:DisplayDisableFile"))
endfunction

function! s:DisplayEnable(actwin)
  let l:display = a:actwin.data.display

  " source
  let l:source = l:display.source
  if l:source.sign.is_enable
    call s:SourceEnableSigns(a:actwin)
  endif
  if l:source.color_line.is_enable
    call s:SourceEnableColorLine(a:actwin)
  endif
  if l:source.color_column.is_enable
    call s:SourceEnableColorColumn(a:actwin)
  endif

  " window
  let l:window = l:display.window

endfunction

function! s:DisplayEnableFile(actwin, file, entrynos)
call s:LOG("DisplayEnableFile TOP")
  let l:display = a:actwin.data.display

  " source
  let l:source = l:display.source
  if l:source.sign.is_enable
    call s:SourceEnableFileSigns(a:actwin, a:file, a:entrynos)
  endif
  if l:source.color_line.is_enable
    call s:SourceEnableFileColorLine(a:actwin, a:file, a:entrynos)
  endif
  if l:source.color_column.is_enable
    call s:SourceEnableFileColorColumn(a:actwin, a:file, a:entrynos)
  endif

  " window
  let l:window = l:display.window

call s:LOG("DisplayEnableFile BOTTOM")
endfunction


function! s:DisplayEntryEnter(entrynos, actwin)
call s:LOG("s:DisplayEntryEnter TOP")
  let l:display = a:actwin.data.display

  " source
  let l:source = l:display.source

  if l:source.color_line.is_enable
    call s:SourceEntryEnterColorLine(a:actwin, a:entrynos)
  endif
  if l:source.color_column.is_enable
    call s:SourceEntryEnterColorColumn(a:actwin, a:entrynos)
  endif

  " window
  let l:window = l:display.window

  if l:window.cursor_line.is_enable
    call s:WindowEnterCursorLine(a:entrynos, a:actwin)
  endif

  if l:window.highlight_line.is_enable
    call s:WindowEnterHighlightLine(a:entrynos, a:actwin)
  endif

  if l:window.sign.is_enable
    call s:WindowEnterSign(a:entrynos, a:actwin)
  endif

call s:LOG("s:DisplayEntryEnter BOTTOM")
endfunction

function! s:DisplayEntryLeave(entrynos, actwin)
call s:LOG("s:DisplayEntryLeave TOP")
  let l:display = a:actwin.data.display

  " source
  let l:source = l:display.source
  if l:source.color_line.is_enable
    call s:SourceEntryLeaveColorLine(a:actwin, a:entrynos)
  endif
  if l:source.color_column.is_enable
    call s:SourceEntryLeaveColorColumn(a:actwin, a:entrynos)
  endif



  " window
  let l:window = l:display.window

  if l:window.cursor_line.is_enable
    call s:WindowLeaveCursorLine(a:entrynos, a:actwin)
  endif

  if l:window.highlight_line.is_enable
    call s:WindowLeaveHighlightLine(a:entrynos, a:actwin)
  endif

  if l:window.sign.is_enable
    call s:WindowLeaveSign(a:entrynos, a:actwin)
  endif
call s:LOG("s:DisplayEntryLeave BOTTOM")
endfunction

" MUST be called from local buffer
function! s:DisplayDisableFile(actwin, file)
  let l:display = a:actwin.data.display

  " source
  let l:source = l:display.source
"  if l:source.sign.is_enable
"    call s:DisableFileSigns(a:actwin, a:file)
"  endif

  " window
  let l:window = l:display.window

endfunction

" MUST be called from local buffer
function! s:DisplayDisable(actwin)
  let l:display = a:actwin.data.display

  " source
  let l:source = l:display.source
  if l:source.sign.is_enable
    call s:SourceDisableSigns(a:actwin)
  endif
  if l:source.color_line.is_enable
    call s:SourceDisableColorLine(a:actwin)
  endif
  if l:source.color_column.is_enable
    call s:SourceDisableColorColumn(a:actwin)
  endif

  " window
  let l:window = l:display.window

endfunction

" MUST be called from local buffer
function! s:DisplayDestroy(actwin)
call s:LOG("s:DisplayDestroy TOP")
  let l:display = a:actwin.data.display

  " source
  let l:source = l:display.source
  if l:source.sign.is_enable
    call s:SourceDestroySigns(a:actwin)
  endif
  if l:source.color_line.is_enable
    call s:SourceDestroyColorLine(a:actwin)
  endif

  if l:source.color_column.is_enable
    call s:SourceDestroyColorColumn(a:actwin)
  endif
if s:is_color_column_enabled
    execute 'silent '. a:actwin.source_win_nr.'wincmd w | :set colorcolumn='
endif

  " window
  let l:window = l:display.window

  if l:window.cursor_line.is_enable
    call s:WindowDestroyCursorLine(a:actwin)
  endif

  if l:window.highlight_line.is_enable
    call s:WindowDestroyHighlightLine(a:actwin)
  endif

  if l:window.sign.is_enable
    call s:WindowDestroySign(a:actwin)
  endif
call s:LOG("s:DisplayDestroy BOTTOM")
endfunction

" ------------------------------
" Display Source: {{{1
"   Define
"    Toggle
"    Enable
"     Enter
"     Leave
"    Disable
"   Destroy
" ------------------------------

" ------------------------------
" Sign {{{1
" ------------------------------

function! s:SourceDefineSigns(actwin)
call s:LOG("SourceDefineSigns TOP")
  let l:sign = a:actwin.data.display.source.sign
  let l:category = l:sign.category

  if has_key(l:sign, 'toggle')
    let b:sign_toggle = l:sign.toggle
    unlet l:sign.toggle
  endif

  if has_key(l:sign, 'kinds') && ! vimside#sign#HasCategory(l:category)
    call vimside#sign#AddCategory(l:category, l:sign)
  endif
call s:LOG("SourceDefineSigns BOTTOM")
endfunction

function! s:SourceEnableSigns(actwin)
call s:LOG("SourceEnableSigns TOP")
  let l:data = a:actwin.data
  let l:sign = l:data.display.source.sign
  let l:category = l:sign.category
  for l:entry in l:data.entries
    let l:file = l:entry.file
    let l:bnr = bufnr(l:file)
    if l:bnr > 0
      let l:line = l:entry.line
      let l:kind = l:entry.kind
      call vimside#sign#PlaceFile(l:line, l:file, l:category, l:kind)
    else
call s:LOG("SourceEnableSigns not placed file=". l:file)
    endif
  endfor

  if exists("b:sign_toggle")
    execute ":nnoremap <silent> <Leader>". b:sign_toggle ." :call g:ToggleSigns(". a:actwin.buffer_nr .")<CR>"
    let b:is_toggle = 0
  endif
call s:LOG("SourceEnableSigns BOTTOM")
endfunction

function! s:SourceEnableFileSigns(actwin, file, entrynos)
call s:LOG("SourceEnableFileSigns TOP")
  let l:file = fnamemodify(a:file, ":p")
  let l:data = a:actwin.data
  let l:sign = a:actwin.data.display.source.sign
  let l:category = l:sign.category
  let l:entry = l:data.entries[a:entrynos]
  let l:file = l:entry.file
  let l:bnr = bufnr(l:file)
  if l:bnr > 0 && a:file == l:file
    let l:line = l:entry.line
    let l:kind = l:entry.kind
    call vimside#sign#PlaceFile(l:line, l:file, l:category, l:kind)
call s:LOG("SourceEnableFileSigns placed file=". l:file)
  endif

call s:LOG("SourceEnableFileSigns BOTTOM")
endfunction


function! g:ToggleSigns(buffer_nr)
call s:LOG("ToggleSigns TOP")
  let [l:found, l:actwin] = s:GetActWin(a:buffer_nr)
  if ! l:found
    call s:ERROR("s:ToggleSigns actwin not found")
    return
  endif

  let l:data = l:actwin.data
  let l:has_data_sign = has_key(l:data, 'display') && has_key(l:data.display, 'source') && has_key(l:data.display.source, 'sign')
  if l:has_data_sign
    let l:sign = l:data.display.source.sign
    let b:is_toggle = ! b:is_toggle
    call vimside#sign#Toggle(l:sign.category, b:is_toggle)
  endif
call s:LOG("ToggleSigns BOTTOM")
endfunction

function! s:SourceDisableSigns(actwin)
call s:LOG("SourceDisableSigns TOP")
  let l:sign = a:actwin.data.display.source.sign
  call vimside#sign#ClearCategory(l:sign.category)
call s:LOG("SourceDisableSigns BOTTOM")
endfunction

function! s:SourceDestroySigns(actwin)
call s:LOG("SourceDestroySigns TOP")
  let l:sign = a:actwin.data.display.source.sign
  call vimside#sign#RemoveCategory(l:sign.category)
call s:LOG("SourceDestroySigns BOTTOM")
endfunction

" ------------------------------
" ColorLine {{{1
" ------------------------------

function! s:SourceDefineColorLine(actwin)
call s:LOG("SourceDefineColorLine TOP")
  let l:color_line = a:actwin.data.display.source.color_line
  let l:category = l:color_line.category

  if has_key(l:color_line, 'toggle')
" let b:sign_toggle = l:sign.toggle
    let b:color_line_toggle = l:color_line.toggle
    unlet l:color_line.toggle
  endif

  if has_key(l:color_line, 'kinds') && ! vimside#sign#HasCategory(l:category)
    call vimside#sign#AddCategory(l:category, l:color_line)
  endif
call s:LOG("SourceDefineColorLine BOTTOM")
endfunction

function! s:SourceEnableColorLine(actwin)
call s:LOG("SourceEnableColorLine TOP")

  if exists("b:color_line_toggle")
    execute ":nnoremap <silent> <Leader>". b:color_line_toggle ." :call g:ToggleCursorLine(". a:actwin.buffer_nr .")<CR>"
    let b:is_toggle_color_line = 0
  endif
call s:LOG("SourceEnableColorLine BOTTOM")
endfunction

function! s:SourceEnableFileColorLine(actwin, file, entrynos)
call s:LOG("SourceEnableFileColorLine TOP")
  let l:file = fnamemodify(a:file, ":p")
  let l:data = a:actwin.data
  let l:color_line = a:actwin.data.display.source.color_line
  let l:category = l:color_line.category

  let l:bnr = bufnr(l:file)
  if l:bnr > 0 && a:file == l:file
    let l:entry = l:data.entries[a:entrynos]
    let l:file = l:entry.file
    let l:line = l:entry.line

    let l:kind = l:entry.kind
    let l:kinds = l:color_line.kinds
    if ! has_key(l:kinds, l:kind)
      if has_key(l:color_line, 'default_kind')
        let l:kind = l:color_line.default_kind
      else
        let l:kind = 'marker'
        for l:key in keys(l:kinds)
          let l:kind = l:key
          break
        endfor
      endif
    endif

    
call s:LOG("SourceEnableFileSigns placed file=". l:file)
    if ! vimside#sign#PlaceFile(l:line, l:file, l:category, l:kind)
      call s:ERROR("SourceEnableFileSigns placed line=". l:line .", file=". l:file .", l:category=". l:category .", l:kind=". l:kind )
    endif
  endif
call s:LOG("SourceEnableFileColorLine BOTTOM")
endfunction

function! s:SourceEntryEnterColorLine(actwin, entrynos)
call s:LOG("SourceEntryEnterColorLine TOP")
  let l:data = a:actwin.data
  let l:color_line = l:data.display.source.color_line
  let l:category = l:color_line.category

  let l:entry = l:data.entries[a:entrynos]
  let l:line = l:entry.line
  let l:file = l:entry.file

  let l:kind = l:entry.kind
  let l:kinds = l:color_line.kinds
  if ! has_key(l:kinds, l:kind)
    if has_key(l:color_line, 'default_kind')
      let l:kind = l:color_line.default_kind
    else
      let l:kind = 'marker'
      for l:key in keys(l:kinds)
        let l:kind = l:key
        break
      endfor
    endif
  endif

  let l:bnr = bufnr(l:file)
call s:LOG("SourceEntryEnterColorLine file=". l:file)
call s:LOG("SourceEntryEnterColorLine bnr=". l:bnr)
  if l:bnr > 0
    if ! vimside#sign#PlaceFile(l:line, l:file, l:category, l:kind)
      call s:ERROR("SourceEntryEnterColorLine placed line=". l:line .", file=". l:file .", l:category=". l:category .", l:kind=". l:kind )
    endif
  endif

call s:LOG("SourceEntryEnterColorLine BOTTOM")
endfunction

function! s:SourceEntryLeaveColorLine(actwin, entrynos)
call s:LOG("SourceEntryLeaveColorLine TOP")
  let l:data = a:actwin.data
  let l:color_line = l:data.display.source.color_line
  let l:category = l:color_line.category

  let l:kind = 'marker'
  for l:key in keys(l:color_line.kinds)
    let l:kind = l:key
    break
  endfor

  let l:entry = l:data.entries[a:entrynos]
  let l:file = l:entry.file
call s:LOG("SourceEntryLeaveColorLine file=". l:file)
  let l:line = l:entry.line
  " call vimside#sign#UnPlaceFileByLine(l:file, l:category, l:kind, l:line)
  " call vimside#sign#UnPlaceFile(l:file, l:category, l:kind)
  call vimside#sign#ClearCategory(l:category)

call s:LOG("SourceEntryLeaveColorLine BOTTOM")
endfunction

function! g:ToggleColorLine(buffer_nr)
call s:LOG("ToggleColorLine TOP")
  let [l:found, l:actwin] = s:GetActWin(a:buffer_nr)
  if ! l:found
    call s:ERROR("s:ToggleColorLine actwin not found")
    return
  endif

  let l:color_line = a:actwin.data.display.source.color_line
  let b:is_toggle_color_line = ! b:is_toggle_color_line
  call vimside#sign#Toggle(l:color_line.category, b:is_toggle_color_line)
call s:LOG("ToggleColorLine BOTTOM")
endfunction

function! s:SourceDisableColorLine(actwin)
call s:LOG("SourceDisableColorLine TOP")
  let l:color_line = a:actwin.data.display.source.color_line
  call vimside#sign#ClearCategory(l:color_line.category)
call s:LOG("SourceDisableColorLine BOTTOM")
endfunction

function! s:SourceDestroyColorLine(actwin)
call s:LOG("SourceDestroyColorLine TOP")
  let l:color_line = a:actwin.data.display.source.color_line
  call vimside#sign#RemoveCategory(l:color_line.category)
call s:LOG("SourceDestroyColorLine BOTTOM")
endfunction

" ------------------------------
" ColorColumn {{{1
" ------------------------------
function! s:SourceDefineColorColumn(actwin)
call s:LOG("SourceDefineColorColumn TOP")
call s:LOG("SourceDefineColorColumn BOTTOM")
endfunction

function! s:SourceEnableColorColumn(actwin)
call s:LOG("SourceEnableColorColumn TOP")

  if exists("b:color_line_toggle")
    execute ":nnoremap <silent> <Leader>". b:color_column_toggle ." :call g:ToggleCursorColumn(". a:actwin.buffer_nr .")<CR>"
    let b:is_toggle_color_column = 0
  endif
call s:LOG("SourceEnableColorColumn BOTTOM")
endfunction

function! s:SourceEnableFileColorColumn(actwin, file, entrynos)
call s:LOG("SourceEnableFileColorColumn TOP")

  let l:data = a:actwin.data
  let l:entry = l:data.entries[a:entrynos]
  let l:file = l:entry.file
  let l:colnos = has_key(l:entry, 'col') ? l:entry.col : -1
  let l:bnr = bufnr(l:file)
call s:LOG("s:SourceEnableFileColorColumn: file=". l:file)
call s:LOG("s:SourceEnableFileColorColumn: bnr=". l:bnr)
  if l:bnr > 0 && l:file == a:file
    let l:win_nr = bufwinnr(l:bnr)
call s:LOG("s:SourceEntryEnterColorColumn: DO_COLOR file win_nr=". l:win_nr)


    if l:win_nr > 0
let s:buf_change = 0
      if l:colnos > 0
        execute 'silent '. l:win_nr.'wincmd w | :set colorcolumn='. l:colnos
      else
        execute 'silent '. l:win_nr.'wincmd w | :set colorcolumn='
      endif
let s:buf_change = 1

call s:LOG("s:SourceEntryEnterColorColumn: RETURN a:actwin.win_nr=". a:actwin.win_nr)
      execute 'silent '. a:actwin.win_nr.'wincmd w'
    endif
  endif
call s:LOG("SourceEnableFileColorColumn BOTTOM")
endfunction

function! s:SourceEntryEnterColorColumn(actwin, entrynos)
call s:LOG("SourceEntryEnterColorColumn TOP")

  let l:data = a:actwin.data
  let l:entry = l:data.entries[a:entrynos]
  let l:file = l:entry.file
  let l:colnos = has_key(l:entry, 'col') ? l:entry.col : -1
  let l:bnr = bufnr(l:file)
call s:LOG("s:SourceEntryEnterColorColumn: file=". l:file)
call s:LOG("s:SourceEntryEnterColorColumn: bnr=". l:bnr)
  if l:bnr > 0 
    let l:win_nr = bufwinnr(l:bnr)
call s:LOG("s:SourceEntryEnterColorColumn: DO_COLOR file win_nr=". l:win_nr)


    if l:win_nr > 0
let s:buf_change = 0
      if l:colnos > 0
        execute 'silent '. l:win_nr.'wincmd w | :set colorcolumn='. l:colnos
      else
        execute 'silent '. l:win_nr.'wincmd w | :set colorcolumn='
      endif
let s:buf_change = 1

call s:LOG("s:SourceEntryEnterColorColumn: RETURN a:actwin.win_nr=". a:actwin.win_nr)
      execute 'silent '. a:actwin.win_nr.'wincmd w'
    endif
  endif

call s:LOG("SourceEntryEnterColorColumn BOTTOM")
endfunction

function! s:SourceEntryLeaveColorColumn(actwin, entrynos)
call s:LOG("SourceEntryLeaveColorColumn TOP")

  let l:data = a:actwin.data
  let l:entry = l:data.entries[a:entrynos]
  let l:file = l:entry.file
  " let l:colnos = has_key(l:entry, 'col') ? l:entry.col : -1

  let l:bnr = bufnr(l:file)
call s:LOG("s:SourceEntryLeaveColorColumn: file=". l:file)
call s:LOG("s:SourceEntryLeaveColorColumn: bnr=". l:bnr)
  if l:bnr > 0
    let l:win_nr = bufwinnr(l:bnr)
call s:LOG("s:SourceEntryLeaveColorColumn: DO_COLOR file win_nr=". l:win_nr)

    if l:win_nr > 0
call s:LOG("s:SourceEntryLeaveColorColumn: CLEAR")
let s:buf_change = 0
      execute 'silent '. l:win_nr.'wincmd w | :set colorcolumn='
let s:buf_change = 1

call s:LOG("s:SourceEntryEnterColorColumn: RETURN a:actwin.win_nr=". a:actwin.win_nr)
      execute 'silent '. a:actwin.win_nr.'wincmd w'
    endif
  endif


call s:LOG("SourceEntryLeaveColorColumn BOTTOM")
endfunction

function! s:SourceDisableColorColumn(actwin)
call s:LOG("SourceDisableColorColumn TOP")
call s:LOG("SourceDisableColorColumn BOTTOM")
endfunction


function! s:SourceDestroyColorColumn(actwin)
call s:LOG("SourceDestroyColorColumn TOP")
call s:LOG("s:SourceDestroyColorColumn: REMOVE COLOR source win_nr=". a:actwin.source_win_nr)
  execute 'silent '. a:actwin.source_win_nr.'wincmd w | :set colorcolumn='
call s:LOG("SourceDestroyColorColumn BOTTOM")
endfunction

" ------------------------------
" Display Window: {{{1
"   Define
"    Enter
"    Leave
"    Toggle
"   Destroy
" ------------------------------

" ------------------------------
" CursorLine {{{1
" ------------------------------

" MUST be called from local buffer
function! s:WindowDefineCursorLine(actwin)
  let l:cursor_line = a:actwin.data.display.window.cursor_line

  if l:cursor_line.is_on
    setlocal modifiable
    setlocal cursorline
    setlocal nomodifiable
  endif

  " execute ":nnoremap <silent> <Leader>". l:cursor_line.toggle ." :call g:ToggleCursorLine(". l:buffer_nr .")<CR>"
  execute ":nnoremap <silent> <buffer> <Leader>". l:cursor_line.toggle ." :call g:ToggleCursorLine()<CR>"

endfunction

function! s:WindowEnterCursorLine(entrynos, actwin)
  " emtpy
endfunction

function! s:WindowLeaveCursorLine(entrynos, actwin)
  " emtpy
endfunction


function! g:ToggleCursorLine()
call s:LOG("ToggleCursorLine TOP")
  let [l:found, l:actwin] = s:GetBufferActWin()
  if ! l:found
    call s:ERROR("s:ToggleCursorLine actwin not found")
    return
  endif

  let l:cursor_line = l:actwin.data.display.window.cursor_line
  let l:cursor_line.is_enable = ! l:cursor_line.is_enable

  setlocal modifiable
  if l:cursor_line.is_enable
    setlocal cursorline
  else
    setlocal nocursorline
  endif
  setlocal nomodifiable

call s:LOG("ToggleCursorLine BOTTOM")
endfunction

" MUST be called from local buffer
function! s:WindowDestroyCursorLine(actwin)
  " empty
endfunction

" ------------------------------
" HighlightLine {{{1
" ------------------------------

" MUST be called from local buffer
function! s:WindowDefineHighlightLine(actwin)
  let l:highlight_line = a:actwin.data.display.window.highlight_line

  execute ":nnoremap <silent> <buffer> <Leader>". l:highlight_line.toggle ." :call g:ToggleHighlightLine()<CR>"

  if l:highlight_line.is_full
    let l:currentline = a:actwin.current_line
" call s:LOG("s:WindowDefineHighlightLine currentline=". l:currentline)
    let l:winWidth = winwidth(0)
    let l:winHeight = line('$')

    let l:cnt = 1
    setlocal modifiable
    execute "normal! 1G"
    for l:line in getline(0, l:winHeight)
      execute "normal! ". (l:winWidth - len(l:line)) ."A "
      " execute "normal! j"
      let l:cnt += 1
      execute "normal! ".l:cnt."G"
    endfor
    execute "normal! ".l:currentline."G"
    setlocal nomodifiable
  endif

endfunction

function! s:EnterHighlightLine(entrynos, actwin)
call s:LOG("WindowEnterHighlightLine TOP")
  let l:highlight_line = a:actwin.data.display.window.highlight_line

" call s:LOG("s:WindowEnterHighlightLine entrynos=". a:entrynos)

  let l:entry = a:actwin.data.entries[a:entrynos]
  let l:content = l:entry.content
  let l:nos_lines = (type(l:content) == type("")) ? 0 : (len(l:content)-1)
  if l:highlight_line.all_text
    let l:line_start = a:actwin.entrynos_to_linenos[a:entrynos]  - l:nos_lines + a:actwin.first_buffer_line - 1
  else
    let l:line_start = a:actwin.entrynos_to_linenos[a:entrynos]  - l:nos_lines + a:actwin.first_buffer_line - 1
    let l:nos_lines = 0
  endif
  let l:nos_columns = l:highlight_line.nos_columns

" call s:LOG("s:WindowEnterHighlightLine line_start=". l:line_start)
" call s:LOG("s:WindowEnterHighlightLine nos_lines=". l:nos_lines)
  let l:highlight_line.sids = s:HighlightDisplay(l:line_start, l:line_start + l:nos_lines, l:nos_columns)

  let l:highlight_line.is_on = 1

endfunction

function! s:WindowLeaveHighlightLine(entrynos, actwin)
call s:LOG("s:WindowLeaveHighlightLine entrynos=". a:entrynos)
  let l:highlight_line = a:actwin.data.display.window.highlight_line

  if has_key(l:highlight_line, 'sids')
    call s:HighlightClear(l:highlight_line.sids)
    unlet l:highlight_line.sids
  endif

endfunction

function! g:ToggleHighlightLine()
call s:LOG("ToggleHighlightLine TOP")
  let [l:found, l:actwin] = s:GetBufferActWin()
  if ! l:found
    call s:ERROR("s:ToggleHighlightLine actwin not found")
    return
  endif

call s:LOG("ToggleHighlightLine l:actwin.current_line=". l:actwin.current_line)
  let l:linenos = l:actwin.current_line
  let l:entrynos = l:actwin.linenos_to_entrynos[l:linenos-1]

  let l:highlight_line = l:actwin.data.display.window.highlight_line
  let l:highlight_line.is_enable = ! l:highlight_line.is_enable

  if l:highlight_line.is_enable
    call s:WindowEnterHighlightLine(l:entrynos, l:actwin)
  else
    call s:WindowLeaveHighlightLine(l:entrynos, l:actwin)
  endif

call s:LOG("ToggleHighlightLine BOTTOM")
endfunction

" MUST be called from local buffer
function! s:WindowDestroyHighlightLine(actwin)
call s:LOG("WindowDestroyHighlightLine TOP")
  let l:highlight_line = a:actwin.data.display.window.highlight_line

  if has_key(l:highlight_line, 'sids')
    call s:HighlightClear(l:highlight_line.sids)
    unlet l:highlight_line.sids
  endif

  if l:highlight_line.is_full
    let l:currentline = a:actwin.current_line
    let l:winHeight = line('$')

    let l:cnt = 1
    setlocal modifiable
    execute "normal! 1G"
    for l:line in getline(0, l:winHeight)                
      execute "normal! $b1 D"
      " execute "normal! b"
      " execute "normal! 1 "
      " execute "normal! D"
      let l:cnt += 1
      execute "normal! ".l:cnt."G"
    endfor
    execute "normal! ".l:currentline."G"
    setlocal nomodifiable
  endif


  let l:highlight_line.is_on = 0
endfunction


" ------------------------------
" Sign {{{1
" ------------------------------

function! s:WindowDefineSign(actwin)
call s:LOG("WindowDefineSign TOP")
  let l:sign = a:actwin.data.display.window.sign

  execute ":nnoremap <silent> <buffer> <Leader>". l:sign.toggle ." :call g:ToggleSign()<CR>"

  let l:category = l:sign.category

  if has_key(l:sign, 'kinds') && ! vimside#sign#HasCategory(l:category)
    call vimside#sign#AddCategory(l:category, l:sign)
  endif
endfunction

function! s:WindowEnterSign(entrynos, actwin)
call s:LOG("WindowEnterSign TOP")
call s:LOG("WindowEnterSign entrynos=". a:entrynos)
  let l:sign = a:actwin.data.display.window.sign
  let l:buffer_nr = a:actwin.buffer_nr
  let l:category = l:sign.category
  let l:entry = a:actwin.data.entries[a:entrynos]

  let l:kind = l:entry.kind
  let l:kinds = l:sign.kinds
  if ! has_key(l:kinds, l:kind)
    if has_key(l:sign, 'default_kind')
      let l:kind = l:sign.default_kind
    else
      let l:kind = 'marker'
      for l:key in keys(l:kinds)
        let l:kind = l:key
        break
      endfor
    endif
  endif
call s:LOG("WindowEnterSign kind=". l:kind)

  let l:content = l:entry.content
  let l:nos_lines = (type(l:content) == type("")) ? 0 : (len(l:content)-1)
  " let l:line_start = a:actwin.entrynos_to_linenos[a:entrynos]  - l:nos_lines + a:actwin.first_buffer_line - 1
  "
  if l:sign.all_text
    let l:line_start = a:actwin.entrynos_to_linenos[a:entrynos]  - l:nos_lines + a:actwin.first_buffer_line - 1
    let l:cnt = 0
    while l:cnt <= l:nos_lines
      call vimside#sign#PlaceBuffer(l:line_start+l:cnt, l:buffer_nr, l:category, l:kind)
      let l:cnt += 1
    endwhile
  else
    let l:line_start = a:actwin.entrynos_to_linenos[a:entrynos]  - l:nos_lines + a:actwin.first_buffer_line - 1
    call vimside#sign#PlaceBuffer(l:line_start, l:buffer_nr, l:category, l:kind)
  endif

" call vimside#sign#PlaceBuffer(l:line_start, l:buffer_nr, l:category, l:kind)

if 0 " example of text file sign
  let l:file = l:entry.file
  call vimside#sign#PlaceFile(l:line, l:file, l:category, l:kind)
endif " example of text file sign

call s:LOG("WindowEnterSign BOTTOM")
endfunction

function! s:WindowLeaveSign(entrynos, actwin)
call s:LOG("WindowLeaveSign TOP")
call s:LOG("WindowLeaveSign entrynos=". a:entrynos)
  let l:sign = a:actwin.data.display.window.sign
  let l:buffer_nr = a:actwin.buffer_nr
  let l:category = l:sign.category
  let l:entry = a:actwin.data.entries[a:entrynos]
  let l:file = l:entry.file

  let l:kind = l:entry.kind
  let l:kinds = l:sign.kinds
  if ! has_key(l:kinds, l:kind)
    if has_key(l:sign, 'default_kind')
      let l:kind = l:sign.default_kind
    else
      let l:kind = 'marker'
      for l:key in keys(l:kinds)
        let l:kind = l:key
        break
      endfor
    endif
  endif
call s:LOG("WindowLeaveSign kind=". l:kind)

  let l:content = l:entry.content
  let l:nos_lines = (type(l:content) == type("")) ? 0 : (len(l:content)-1)
  " let l:line_start = a:actwin.entrynos_to_linenos[a:entrynos]  - l:nos_lines + a:actwin.first_buffer_line - 1
  if l:sign.all_text
    let l:line_start = a:actwin.entrynos_to_linenos[a:entrynos]  - l:nos_lines + a:actwin.first_buffer_line - 1
    let l:cnt = 0
    while l:cnt <= l:nos_lines
      call vimside#sign#UnPlaceBuffer(l:buffer_nr, l:category, l:kind, l:line_start+l:cnt)
      let l:cnt += 1
    endwhile
  else
    let l:line_start = a:actwin.entrynos_to_linenos[a:entrynos]  - l:nos_lines + a:actwin.first_buffer_line - 1
    call vimside#sign#UnPlaceBuffer(l:buffer_nr, l:category, l:kind, l:line_start)
  endif



if 0 " example of text file sign
  let l:file = l:entry.file
  call vimside#sign#UnPlaceFileByLine(l:line, l:file, l:category, l:kind)
endif " example of text file sign

call s:LOG("WindowLeaveSign BOTTOM")
endfunction

function! g:ToggleSign()
call s:LOG("ToggleSign TOP")
  let [l:found, l:actwin] = s:GetBufferActWin()
  if ! l:found
    call s:ERROR("s:ToggleSign actwin not found")
    return
  endif

call s:LOG("ToggleSign l:actwin.current_line=". l:actwin.current_line)
  let l:linenos = l:actwin.current_line
  let l:entrynos = l:actwin.linenos_to_entrynos[l:linenos-1]

  let l:sign = l:actwin.data.display.window.sign
  let l:sign.is_enable = ! l:sign.is_enable

  if l:sign.is_enable
    call s:WindowEnterSign(l:entrynos, l:actwin)
  else
    call s:WindowLeaveSign(l:entrynos, l:actwin)
  endif

call s:LOG("ToggleSign BOTTOM")
endfunction

function! s:WindowDestroySign(actwin)
call s:LOG("WindowDestroySign TOP")
  let l:sign = a:actwin.data.display.window.sign
  let l:category = l:sign.category

  call vimside#sign#RemoveCategory(l:category)
endfunction


" ============================================================================
" Util {{{1
" ============================================================================

if 0 " NOT USED
" return [line, ...]
function! s:GetLines(actwin)
  let l:lines = []
  for entry in a:actwin.data.entries
    let l:content = entry.content
    call add(l:lines, l:content)
  endfor

  return l:lines
endfunction
endif " NOT USED

" return [found, line]
function! s:GetEntry(entrynos, actwin)
  if a:entrynos < 0
    return [0, {}]
  else
    let l:entries = a:actwin.data.entries
    if a:entrynos < len(l:entries)
      return [1, l:entries[a:entrynos]]
    else
      return [0, {}]
    endif
endfunction

" ============================================================================
" Close {{{1
" ============================================================================

" TODO how to close from a different buffer???
" MUST be called from local buffer
function! vimside#actwin#Close()
call s:LOG("vimside#actwin#Close TOP")
  let [l:found, l:actwin] = s:GetBufferActWin()
  if ! l:found
    call s:ERROR("vimside#actwin#Close: actwin not found")
    return
  endif
  call s:Close(l:actwin)
endfunction

function! s:OnClose()
call s:LOG("s:OnClose TOP")
  let [l:found, l:actwin] = s:GetBufferActWin()
  if ! l:found
    call s:ERROR("s:OnClose: actwin not found")
    return
  endif

  call s:Close(l:actwin)
call s:LOG("s:OnClose BOTTOM")
endfunction

" MUST be called from local buffer
function! s:Close(actwin)
  let l:actwin = a:actwin
call s:LOG("s:Close l:actwin.buffer_nr=". l:actwin.buffer_nr)

  call s:DisplayDisable(l:actwin)

  call s:DisplayDestroy(l:actwin)

  call s:ClearCmds(l:actwin)

  " If we needed to split the main window, close the split one.
  let l:window = l:actwin.data.window
  if has_key(l:window, 'split')
call s:LOG("s:Close split")
execute 'silent '. l:actwin.win_nr.'wincmd w'
    exec "wincmd c"
" execute 'silent '. l:actwin.win_nr.'wincmd w'
  elseif has_key(l:window, 'edit')
call s:LOG("s:Close edit")
    let l:source_buffer_nr = l:actwin.source_buffer_nr
call s:LOG("s:Close source_buffer_nr=". l:source_buffer_nr)
    execute "buffer ". l:source_buffer_nr
    " exec "e!#"
  elseif has_key(l:window, 'tab')
call s:LOG("s:Close tab")
execute 'silent '. l:actwin.win_nr.'wincmd w'
    exec "e!#"
" execute 'silent '. l:actwin.buffer_nr.'wincmd w'
    " exec "wincmd c"
  endif

  execute "bwipeout ". l:actwin.buffer_nr 
  call s:CloseAutoCmds(l:actwin)
execute 'silent '. l:actwin.source_win_nr.'wincmd w'

  call s:CallOnCloseHandlers(l:actwin)

  " Clear any messages.
  "  echo ""

  unlet s:actwin_buffer_nr_to_actwin[l:actwin.buffer_nr]
call s:LOG("Close BOTTOM")
endfunction

" ============================================================================
" KeyMappings: {{{1
" ============================================================================

" MUST be called from local buffer
function! s:OnHelp()
call s:LOG("OnHelp TOP")
  let [l:found, l:actwin] = s:GetBufferActWin()
  if ! l:found
    call s:ERROR("s:OnHelp: actwin not found")
    return
  endif

  let l:help = l:actwin.data.help

  if l:help.do_show
    " TODO remove is_open   
    let l:help.is_open = !l:help.is_open
    call vimside#actwin#DisplayLocal('testhelp', l:help.data)
  endif

call s:LOG("OnHelp BOTTOM")
endfunction

" MUST be called from local buffer
function! s:ToggleWindowKeyMapInfo()
  call s:Toggle('window_key_map_show', 'window', 'key_map', s:cmds_window_defs)
endfunction

function! s:ToggleSourceBuiltinCmdInfo()
  call s:Toggle('source_builtin_cmd_show', 'source', 'builtin_cmd', s:cmds_source_defs)
endfunction

function! s:ToggleSourceLeaderCmdInfo()
  call s:Toggle('source_leader_cmd_show', 'source', 'leader_cmd', s:cmds_source_defs)
endfunction

function! s:Toggle(key_name, data_win, data_element, defs)
call s:LOG("Toggle TOP")
  let [l:found, l:actwin] = s:GetBufferActWin()
  if ! l:found
    call s:ERROR("s:Toggle: actwin not found")
    return
  endif

  let l:key_value = l:actwin.data.cmds.window.key_map[a:key_name]

  setlocal modifiable

  " Save position.
  normal! ma
    
  " Remove existing help
  if (l:actwin.first_buffer_line > 1)
call s:LOG("Toggle delete")
    exec "keepjumps 1,".(l:actwin.first_buffer_line - 1) "d _"
  endif
    
  call append(0, s:CreateToggleInfo(a:data_win, a:data_element, l:key_value, a:defs, l:actwin))

  silent! normal! g`a
  delmarks a

  setlocal nomodifiable
  redraw
call s:LOG("Toggle BOTTOM")
endfunction

" MUST be called from local buffer
function! s:EnterCurrentEntry(actwin)
  let l:current_line = a:actwin.current_line
  let l:current_entrynos = a:actwin.linenos_to_entrynos[l:current_line-1]
  call s:EnterEntry(l:current_entrynos, a:actwin)
endfunction


" MUST be called from local buffer
" cursor entering given entrynos
function! s:EnterEntry(entrynos, actwin)
call s:LOG("s:EnterEntry TOP entrynos=". a:entrynos)

  call s:DisplayEntryEnter(a:entrynos, a:actwin)
  call a:actwin.data.actions.enter(a:entrynos, a:actwin)

call s:LOG("s:EnterEntry BOTTOM")
endfunction

" MUST be called from local buffer
function! s:SelectEntry(entrynos, actwin)
  call a:actwin.data.actions.select(a:entrynos, a:actwin)
endfunction

" MUST be called from local buffer
function! s:LeaveCurrentEntry(actwin)
  let l:current_line = a:actwin.current_line
  let l:current_entrynos = a:actwin.linenos_to_entrynos[l:current_line-1]
  call s:LeaveEntry(l:current_entrynos, a:actwin)
endfunction

" MUST be called from local buffer
" cursor leaving given entrynos
function! s:LeaveEntry(entrynos, actwin)
call s:LOG("s:LeaveEntry TOP entrynos=". a:entrynos)

  call a:actwin.data.actions.leave(a:entrynos, a:actwin)
  call s:DisplayEntryLeave(a:entrynos, a:actwin)

call s:LOG("s:LeaveEntry BOTTOM")
endfunction





" MUST be called from local buffer
function! s:OnEnterMouse()
call s:LOG("s:OnEnterMouse: TOP")
  let [l:found, l:actwin] = s:GetBufferActWin()
  if ! l:found
    call s:ERROR("s:OnEnterMouse: actwin not found")
    return
  endif

  let l:line = line(".")

  if l:line > (l:actwin.first_buffer_line - 1)
    let l:linenos = l:line - l:actwin.first_buffer_line + 1
    let l:current_line = l:actwin.current_line
    let l:current_entrynos = l:actwin.linenos_to_entrynos[l:current_line-1]
    let l:entrynos = l:actwin.linenos_to_entrynos[l:linenos-1]

    if l:entrynos != l:current_entrynos
      call s:LeaveEntry(l:current_entrynos, l:actwin)
      call s:EnterEntry(l:entrynos, l:actwin)
      let l:actwin.current_line = l:linenos
    endif
  endif

call s:LOG("s:OnEnterMouse: BOTTOM")
endfunction

" MUST be called from local buffer <CR> -> OnSelect
function! s:OnSelect()
call s:LOG("s:OnSelect: TOP")
  let [l:found, l:actwin] = s:GetBufferActWin()
  if ! l:found
    call s:ERROR("s:OnSelect: actwin not found")
    return
  endif

  let l:line = line(".")

  if l:line > (l:actwin.first_buffer_line - 1)
    let l:linenos = l:line - l:actwin.first_buffer_line + 1
    let l:entrynos = l:actwin.linenos_to_entrynos[l:linenos-1]

    call s:SelectEntry(l:entrynos, l:actwin)
    let l:actwin.current_line = l:linenos
  else
    call feedkeys("\<CR>", 'n')
  endif

call s:LOG("s:OnSelect: BOTTOM")
endfunction

" MUST be called from local buffer
function! s:OnTop()
call s:LOG("s:OnTop: TOP")
  let [l:found, l:actwin] = s:GetBufferActWin()
  if ! l:found
    call s:ERROR("s:OnTop: actwin not found")
    return
  endif

  let l:line = line(".")

  if l:line > (l:actwin.first_buffer_line - 1)
    let l:linenos = l:line - l:actwin.first_buffer_line + 1
    let l:entrynos = l:actwin.linenos_to_entrynos[l:linenos-1]
call s:LOG("s:OnTop l:entrynos=". l:entrynos)

    call s:LeaveEntry(l:entrynos, l:actwin)

    let l:nos_of_linenos = l:linenos
    if l:nos_of_linenos == 1
      call feedkeys('k', 'n')
    else
      call feedkeys(repeat('k', l:nos_of_linenos), 'n')
    endif


    call s:EnterEntry(0, l:actwin)
    let l:actwin.current_line = 1
call s:LOG("s:OnTop l:actwin.current_line=". l:actwin.current_line)
  endif
call s:LOG("s:OnTop: BOTTOM")
endfunction

" MUST be called from local buffer
function! s:OnBottom()
call s:LOG("s:OnBottom: TOP")
  let [l:found, l:actwin] = s:GetBufferActWin()
  if ! l:found
    call s:ERROR("s:OnBottom: actwin not found")
    return
  endif

  let l:line = line(".")

  if l:line > (l:actwin.first_buffer_line - 1)
    let l:entrynos_to_linenos = l:actwin.entrynos_to_linenos
    let l:linenos = l:line - l:actwin.first_buffer_line + 1
    let l:entrynos = l:actwin.linenos_to_entrynos[l:linenos-1]
call s:LOG("s:OnBottom l:entrynos=". l:entrynos)

    let l:len = len(l:entrynos_to_linenos)
call s:LOG("s:OnBottom l:len=". l:len)
    if l:entrynos < l:len - 1
      call s:LeaveEntry(l:entrynos, l:actwin)

      let l:entries = l:actwin.data.entries
      let l:entries_len = len(l:entries)
      let l:delta_lines = 0
      let l:cnt = l:entrynos
      while l:cnt < l:entries_len
        let l:delta_lines += l:actwin.entrynos_to_nos_of_lines[l:cnt]
        let l:cnt += 1
      endwhile
      let l:nos_of_linenos = l:delta_lines
      if l:nos_of_linenos == 1
        call feedkeys('j', 'n')
      else
        call feedkeys(repeat('j', l:nos_of_linenos), 'n')
      endif


      call s:EnterEntry(l:entries_len-1, l:actwin)
      let l:actwin.current_line += l:delta_lines
call s:LOG("s:OnBottom l:actwin.current_line=". l:actwin.current_line)
    endif
  endif

call s:LOG("s:OnBottom: BOTTOM")
endfunction

" MUST be called from local buffer
function! s:OnUp()
call s:LOG("s:OnUp: TOP")
  let [l:found, l:actwin] = s:GetBufferActWin()
  if ! l:found
    call s:ERROR("s:OnUp: actwin not found")
    return
  endif

  let l:line = line(".")

  if l:line > (l:actwin.first_buffer_line - 1)
    let l:linenos = l:line - l:actwin.first_buffer_line + 1
    let l:entrynos = l:actwin.linenos_to_entrynos[l:linenos-1]
call s:LOG("s:OnUp l:entrynos=". l:entrynos)

    call s:LeaveEntry(l:entrynos, l:actwin)

    let l:nos_of_linenos = l:actwin.entrynos_to_nos_of_lines[l:entrynos-1] 
    let l:new_linenos = l:actwin.entrynos_to_linenos[l:entrynos-1] 
call s:LOG("s:OnUp l:nos_of_linenos=". l:nos_of_linenos)
    if l:nos_of_linenos == 1
      call feedkeys('k', 'n')
    elseif l:nos_of_linenos > 1
      call feedkeys(repeat('k', l:nos_of_linenos), 'n')
    endif


    call s:EnterEntry(l:entrynos-1, l:actwin)
    let l:actwin.current_line = l:new_linenos
call s:LOG("s:OnUp l:actwin.current_line=". l:actwin.current_line)
  else
    call feedkeys('k', 'n')
  endif

call s:LOG("s:OnUp: BOTTOM")
endfunction

" MUST be called from local buffer
function! s:OnDown()
call s:LOG("s:OnDown: TOP")
  let [l:found, l:actwin] = s:GetBufferActWin()
  if ! l:found
    call s:ERROR("s:OnDown: actwin not found")
    return
  endif

  let l:line = line(".")

  if l:line > (l:actwin.first_buffer_line - 1)
    let l:entrynos_to_linenos = l:actwin.entrynos_to_linenos
    let l:linenos = l:line - l:actwin.first_buffer_line + 1
    let l:entrynos = l:actwin.linenos_to_entrynos[l:linenos-1]
call s:LOG("s:OnDown l:entrynos=". l:entrynos)

    let l:len = len(l:entrynos_to_linenos)
call s:LOG("s:OnDown l:len=". l:len)
    if l:entrynos < l:len - 1
      call s:LeaveEntry(l:entrynos, l:actwin)

      let l:nos_of_linenos = l:actwin.entrynos_to_nos_of_lines[l:entrynos] 
      let l:new_linenos = l:entrynos_to_linenos[l:entrynos+1] 
call s:LOG("s:OnDown l:nos_of_linenos=". l:nos_of_linenos)
      let l:nos_of_linenos -= 1
      if l:nos_of_linenos == 1
        call feedkeys('j', 'n')
      elseif l:nos_of_linenos > 1
        call feedkeys(repeat('j', l:nos_of_linenos), 'n')
      endif


      call s:EnterEntry(l:entrynos+1, l:actwin)
      let l:actwin.current_line = l:new_linenos
call s:LOG("s:OnDown l:actwin.current_line=". l:actwin.current_line)
    endif

if 0 " IS_THIS_NEEDED
  else
    call feedkeys('j', 'n')
endif " IS_THIS_NEEDED

  endif

call s:LOG("s:OnDown: BOTTOM")
endfunction

function! s:OnLeft()
call s:LOG("s:OnLeft: TOP")
  call feedkeys('h', 'n')
call s:LOG("s:OnLeft: BOTTOM")
endfunction

function! s:OnRight()
call s:LOG("s:OnRight: TOP")
  call feedkeys('l', 'n')
call s:LOG("s:OnLeft: BOTTOM")
endfunction

" ============================================================================
" Leader Commands: {{{1
" ============================================================================

function! g:VimsideActWinFirst(buffer_nr)
call s:LOG("g:VimsideActWinFirst: TOP")
  " If called from ActWin
  let l:current_buffer_nr = bufnr("%")
  if a:buffer_nr == l:current_buffer_nr
    call s:OnTop()
    return
  endif

  let [l:found, l:actwin] = s:GetActWin(a:buffer_nr)
  if ! l:found
    call s:ERROR("s:VimsideActWinFirst: actwin not found")
    return
  endif

  let l:win_nr = bufwinnr(a:buffer_nr)
  let l:current_win_nr = bufwinnr(l:current_buffer_nr)
  let b:return_win_nr = l:current_win_nr 

let s:buf_change = 0
  execute 'silent '. l:win_nr.'wincmd w'
  let l:line = line(".")

  if l:line > (l:actwin.first_buffer_line - 1)
    let l:linenos = l:line - l:actwin.first_buffer_line + 1
    let l:entrynos = l:actwin.linenos_to_entrynos[l:linenos-1]
call s:LOG("s:OnTop l:entrynos=". l:entrynos)

    call s:LeaveEntry(l:entrynos, l:actwin)

    let l:nos_of_linenos = l:linenos
execute 'silent '. l:win_nr.'wincmd w'
    let l:line = line(".") - l:actwin.first_buffer_line + 1
    if l:nos_of_linenos == 1
      execute 'silent '. l:win_nr.'wincmd w | :call cursor(('. l:line .'-1),1)'
    else
      execute 'silent '. l:win_nr.'wincmd w | :call cursor(('. l:line .'-'. l:nos_of_linenos .'),1)'
    endif


    call s:EnterEntry(0, l:actwin)
    redraw

    let l:actwin.current_line = 1
call s:LOG("s:OnTop l:actwin.current_line=". l:actwin.current_line)
  endif

  execute 'silent '. b:return_win_nr.'wincmd w'
let s:buf_change = 1

call histdel(":", "VimsideActWinFirst")
echo ""

call s:LOG("g:VimsideActWinFirst: BOTTOM")
endfunction

function! g:VimsideActWinLast(buffer_nr)
call s:LOG("g:VimsideActWinLast: TOP")
  " If called from ActWin
  let l:current_buffer_nr = bufnr("%")
  if a:buffer_nr == l:current_buffer_nr
    call s:OnBottom()
    return
  endif

  let [l:found, l:actwin] = s:GetActWin(a:buffer_nr)
  if ! l:found
    call s:ERROR("s:VimsideActWinLast: actwin not found")
    return
  endif

  let l:win_nr = bufwinnr(a:buffer_nr)
  let l:current_win_nr = bufwinnr(l:current_buffer_nr)
  let b:return_win_nr = l:current_win_nr 

let s:buf_change = 0
  execute 'silent '. l:win_nr.'wincmd w'
  let l:line = line(".")

  if l:line > (l:actwin.first_buffer_line - 1)
    let l:linenos = l:line - l:actwin.first_buffer_line + 1
    let l:entrynos = l:actwin.linenos_to_entrynos[l:linenos-1]
    let l:entrynos_to_linenos = l:actwin.entrynos_to_linenos
call s:LOG("s:OnTop l:entrynos=". l:entrynos)

    let l:len = len(l:entrynos_to_linenos)
call s:LOG("s:VimsideActWinLast l:len=". l:len)
    if l:entrynos < l:len - 1
      call s:LeaveEntry(l:entrynos, l:actwin)

      let l:entries = l:actwin.data.entries
      let l:entries_len = len(l:entries)
      let l:delta_lines = 0
      let l:cnt = l:entrynos
      while l:cnt < l:entries_len
        let l:delta_lines += l:actwin.entrynos_to_nos_of_lines[l:cnt]
        let l:cnt += 1
      endwhile

      let l:nos_of_linenos = l:line+l:delta_lines -1
      call cursor(l:nos_of_linenos, 1)

      call s:EnterEntry(l:entries_len-1, l:actwin)
      let l:actwin.current_line = l:nos_of_linenos
      redraw
call s:LOG("s:VimsideActWinLast l:actwin.current_line=". l:actwin.current_line)

    endif
  endif

  execute 'silent '. b:return_win_nr.'wincmd w'
let s:buf_change = 1

call histdel(":", "VimsideActWinLast")
echo ""
call s:LOG("g:VimsideActWinLast: BOTTOM")
endfunction

" Called from external buffer
function! g:VimsideActWinUp(buffer_nr)
call s:LOG("g:VimsideActWinUp: TOP")
  " If called from ActWin
  let l:current_buffer_nr = bufnr("%")
  if a:buffer_nr == l:current_buffer_nr
    call s:OnUp()
    return
  endif

  let [l:found, l:actwin] = s:GetActWin(a:buffer_nr)
  if ! l:found
    call s:ERROR("s:VimsideActWinUp: actwin not found")
    return
  endif

  let l:current_win_nr = bufwinnr(l:current_buffer_nr)
let b:return_win_nr = l:current_win_nr 
  let l:win_nr = bufwinnr(a:buffer_nr)

  let l:linenos_to_entrynos = l:actwin.linenos_to_entrynos
  let l:entrynos_to_linenos = l:actwin.entrynos_to_linenos
  let l:entrynos_to_nos_of_lines = l:actwin.entrynos_to_nos_of_lines

  let l:linenos = l:actwin.current_line
  let l:entrynos = l:linenos_to_entrynos[l:linenos-1]

  " let l:len = len(l:actwin.data.entries)
  if l:entrynos > 0
let s:buf_change = 0

execute 'silent '. l:win_nr.'wincmd w'
    call s:LeaveEntry(l:entrynos, l:actwin)

    let l:new_linenos = l:entrynos_to_linenos[l:entrynos-1] 
    let l:nos_of_linenos = l:entrynos_to_nos_of_lines[l:entrynos-1] 

    " TODO Selection is not Entry
    " call s:SelectEntry(l:entrynos-1, l:actwin)

execute 'silent '. l:win_nr.'wincmd w'
    let l:line = line(".") - l:actwin.first_buffer_line + 1
    if l:nos_of_linenos == 1
      execute 'silent '. l:win_nr.'wincmd w | :call cursor(('. l:line .'-1),1)'
    else
      execute 'silent '. l:win_nr.'wincmd w | :call cursor(('. l:line .'-'. l:nos_of_linenos .'),1)'
    endif

    call s:EnterEntry(l:entrynos-1, l:actwin)
redraw
" execute 'silent '. l:current_win_nr.'wincmd w'
execute 'silent '. b:return_win_nr.'wincmd w'


let s:buf_change = 1

    let l:actwin.current_line = l:new_linenos
  endif
call histdel(":", "VimsideActWinUp")
echo ""
call s:LOG("g:VimsideActWinUp: BOTTOM")
endfunction

" Called from external buffer
function! g:VimsideActWinDown(buffer_nr)
call s:LOG("g:VimsideActWinDown: TOP")
  " If called from ActWin
  let l:current_buffer_nr = bufnr("%")
  if a:buffer_nr == l:current_buffer_nr
    call s:OnDown()
    return
  endif

  let [l:found, l:actwin] = s:GetActWin(a:buffer_nr)
  if ! l:found
    call s:ERROR("s:VimsideActWinDown: actwin not found")
    return
  endif

let b:return_win_nr = bufwinnr(l:current_buffer_nr)
  let l:win_nr = bufwinnr(a:buffer_nr)

  let l:linenos_to_entrynos = l:actwin.linenos_to_entrynos
  let l:entrynos_to_linenos = l:actwin.entrynos_to_linenos
  let l:entrynos_to_nos_of_lines = l:actwin.entrynos_to_nos_of_lines

  let l:linenos = l:actwin.current_line
  let l:entrynos = l:linenos_to_entrynos[l:linenos-1]
call s:LOG("g:VimsideActWinDown l:linenos=". l:linenos)
call s:LOG("g:VimsideActWinDown l:entrynos=". l:entrynos)

  let l:len = len(l:actwin.data.entries)
  if l:entrynos < l:len - 1
let s:buf_change = 0

execute 'silent '. l:win_nr.'wincmd w'
    call s:LeaveEntry(l:entrynos, l:actwin)

    let l:new_linenos = l:entrynos_to_linenos[l:entrynos+1] 
    let l:nos_of_linenos = l:entrynos_to_nos_of_lines[l:entrynos] 
call s:LOG("g:VimsideActWinDown l:new_linenos=". l:new_linenos)
call s:LOG("g:VimsideActWinDown l:nos_of_linenos=". l:nos_of_linenos)

    " TODO Selection is not Entry
    " call s:SelectEntry(l:entrynos+1, l:actwin)

execute 'silent '. l:win_nr.'wincmd w'
    let l:line = line(".") - l:actwin.first_buffer_line + 1
call s:LOG("g:VimsideActWinDown l:line=". l:line)
    if l:nos_of_linenos == 1
      execute 'silent '. l:win_nr.'wincmd w | :call cursor(('. l:line .'+1),1)'
    else
      execute 'silent '. l:win_nr.'wincmd w | :call cursor(('. l:line .'+'. l:nos_of_linenos .'),1)'
    endif


    call s:EnterEntry(l:entrynos+1, l:actwin)
redraw
execute 'silent '. b:return_win_nr.'wincmd w'

let s:buf_change = 1

    let l:actwin.current_line = l:new_linenos
  endif
call histdel(":", "VimsideActWinDown")
echo ""
call s:LOG("g:VimsideActWinDown: BOTTOM")
endfunction

function! g:VimsideActWinEnter(buffer_nr)
call s:LOG("g:VimsideActWinEnter: TOP buffer_nr=". a:buffer_nr)
  " If called from ActWin, do nothing
  let l:current_buffer_nr = bufnr("%")
  if a:buffer_nr == l:current_buffer_nr
    return
  endif

  let [l:found, l:actwin] = s:GetActWin(a:buffer_nr)
  if ! l:found
    call s:ERROR("s:VimsideActWinEnter: actwin not found")
    return
  endif

  execute 'silent '. l:actwin.win_nr.'wincmd w'

call histdel(":", "VimsideActWinEnter")
call s:LOG("g:VimsideActWinEnter: BOTTOM")
endfunction

" Called from external buffer
function! g:VimsideActWinClose(buffer_nr)
call s:LOG("g:VimsideActWinClose: TOP buffer_nr=". a:buffer_nr)
  let [l:found, l:actwin] = s:GetActWin(a:buffer_nr)
  if ! l:found
    call s:ERROR("s:VimsideActWinClose: actwin not found")
    return
  endif

  let b:return_win_nr = bufwinnr(bufnr("%"))

  execute 'silent '. l:actwin.win_nr.'wincmd w'
  call s:Close(l:actwin)
  execute 'silent '. b:return_win_nr.'wincmd w'

call histdel(":", "VimsideActWinClose")
echo ""
call s:LOG("g:VimsideActWinClose: BOTTOM")
endfunction

" ============================================================================
" AutoCmd Functions: {{{1
" ============================================================================

" called after entering or switching to buffer
function! s:BufEnter()
  if s:buf_change
call s:LOG("s:BufEnter: TOP ". bufnr("%"))
    let b:insertmode = &insertmode
    let b:showcmd = &showcmd
    let b:cpo = &cpo
    let b:report = &report
    let b:list = &list
call s:LOG("s:BufEnter: BOTTOM")
  endif
endfunction

" called when switching from buffer to another buffer
function! s:BufLeave()
  if s:buf_change
call s:LOG("s:BufLeave: TOP ".  bufnr("%"))
    if exists("b:insertmode")
      let &insertmode = b:insertmode
      unlet b:insertmode
    endif
    if exists("b:showcmd")
      let &showcmd = b:showcmd
      unlet b:showcmd
    endif
    if exists("b:cpo")
      let &cpo = b:cpo
      unlet b:cpo
    endif
    if exists("b:report")
      let &report = b:report
      unlet b:report
    endif
    if exists("b:list")
      let &list = b:list
      unlet b:list
    endif
call s:LOG("s:BufLeave: BOTTOM")
  endif
endfunction

" called when buffer is displayed in window
" when loaded or no longer hidden
function! s:BufWinEnter()
call s:LOG("s:BufWinEnter: buffer_nr=". bufnr("%"))
  let [l:found, l:actwin] = s:GetActWin(bufnr("%"))
  if ! l:found
    call s:ERROR("s:BufWinEnter actwin not found")
    return
  endif

  call s:EnterCurrentEntry(l:actwin)
endfunction

" called before buffer is removed from window
" Note that buffer "%" may not be buffer being unloaded
function! s:BufWinLeave()
" call s:LOG("s:BufWinLeave: buffer_nr=". bufnr("%"))
" call s:LOG("s:BufWinLeave: afile=". expand('<afile>')) 
call s:LOG("s:BufWinLeave: afile nr=". bufnr(expand('<afile>'))) 
  " call s:DisplayDestroy()
  
  let [l:found, l:actwin] = s:GetActWin(bufnr(expand('<afile>')))
  if ! l:found
    call s:ERROR("s:BufWinLeave actwin not found")
    return
  endif

  call s:LeaveCurrentEntry(l:actwin)
endfunction

" ============================================================================
" Formatter Functions: {{{1
" ============================================================================

function! s:FormatterDefault(lines, entry)
" call s:LOG("s:FormatterDefault: TOP")
  let content = a:entry.content
  if type(content) == type([])
    call extend(a:lines, content)
  else
    call add(a:lines, content)
  endif
" call s:LOG("s:FormatterDefault: BOTTOM")
endfunction

" ============================================================================
" Default Action Functions: {{{1
" ============================================================================

" --------------------------------------------
" Behavior: Do Nothing, Text
" --------------------------------------------

" Set Non-ActWin cursor file and postion but stay in ActWin
function! s:EnterActionDoNothing(entrynos, actwin)
call s:LOG("s:EnterActionDoNothing: entrynos=". a:entrynos)
endfunction

" Goto Non-ActWin cursor file and postion
function! s:SelectActionDoNothing(entrynos, actwin)
call s:LOG("s:SelectActionDoNothing")
endfunction

" Do Nothing
function! s:LeaveActionDoNothing(entrynos, actwin)
call s:LOG("s:LeaveActionDoNothing: entrynos=". a:entrynos)
endfunction

" --------------------------------------------
" Behavior: QuickFix
" --------------------------------------------
" Set Non-ActWin cursor file and postion but stay in ActWin
function! s:EnterActionQuickFix(entrynos, actwin)
call s:LOG("s:EnterActionQuickFix: TOP entrynos=". a:entrynos)
  call s:SourceSetAtEntry(a:entrynos, a:actwin)
call s:LOG("s:EnterActionQuickFix: BOTTOM")
endfunction

" Goto Non-ActWin cursor file and postion
function! s:SelectActionQuickFix(entrynos, actwin)
call s:LOG("s:SelectActionQuickFix TOP")
  call s:SourceGoToEntry(a:entrynos, a:actwin)
call s:LOG("s:SelectActionQuickFix BOTTOM")
endfunction

" Do Nothing
function! s:LeaveActionQuickFix(entrynos, actwin)
call s:LOG("s:LeaveActionQuickFix: TOP entrynos=". a:entrynos)
  call s:RemoveAtEntry(a:entrynos, a:actwin)
call s:LOG("s:LeaveActionQuickFix: BOTTOM")
endfunction

" --------------------------------------------
" Behavior: History/Search Command Window
" --------------------------------------------

" --------------------------------------------
" Behavior: Type Inspector, Multi-line Structured
" --------------------------------------------

" --------------------------------------------
" Behavior: Type Inspector
" --------------------------------------------


" ============================================================================
" Support Action Function: {{{1
" ============================================================================


" Set Non-ActWin cursor file and postion but stay in ActWin
function! s:SourceSetAtEntry(entrynos, actwin)
let s:buf_change = 0
call s:LOG("s:SourceSetAtEntry: entrynos=". a:entrynos)
  let [l:found, l:entry] = s:GetEntry(a:entrynos, a:actwin)
  if l:found && has_key(l:entry, 'file')
    let l:file = l:entry.file
    let l:bnr = bufnr(l:file)
call s:LOG("s:SourceSetAtEntry: bnr=". l:bnr)
    let l:win_nr = bufwinnr(l:bnr)
call s:LOG("s:SourceSetAtEntry: file=". l:file)
call s:LOG("s:SourceSetAtEntry: win_nr=". l:win_nr)
call s:LOG("s:SourceSetAtEntry: source_buffer_nr bufwinnr=". bufwinnr(a:actwin.source_buffer_nr))

    let l:new_file = 0
    if l:win_nr == -1
execute 'silent '. a:actwin.source_win_nr.'wincmd w'
      execute "edit ". l:file
execute 'silent '. bufwinnr(a:actwin.win_nr).'wincmd w'
      let l:bnr = bufnr(l:file)
call s:LOG("s:SourceSetAtEntry: bnr=". l:bnr)
      let l:win_nr = bufwinnr(l:bnr)
call s:LOG("s:SourceSetAtEntry: win_nr=". l:win_nr)
      let l:new_file = 1
    endif

    if l:win_nr > 0
let b:return_win_nr = l:win_nr
      let l:linenos = has_key(l:entry, 'line') ? l:entry.line : 1
      let l:colnos = has_key(l:entry, 'col') ? l:entry.col : -1
call s:LOG("s:SourceSetAtEntry: linenos=". l:linenos)
call s:LOG("s:SourceSetAtEntry: colnos=". l:colnos)
      if l:colnos > 1
        execute 'silent '. l:win_nr.'wincmd w | :normal! '. l:linenos .'G' . (l:colnos-1) . "l"
      else
        execute 'silent '. l:win_nr.'wincmd w | :normal! '. l:linenos .'G'
      endif

      if l:new_file 
        call s:CallNewFileHandlers(a:actwin, l:file, a:entrynos)
      endif


if s:is_color_column_enabled
  if l:colnos > 0
    execute 'silent '. l:win_nr.'wincmd w | :set colorcolumn='. l:colnos
  else
    execute 'silent '. l:win_nr.'wincmd w | :set colorcolumn='
  endif
endif

      " execute 'keepjumps silent '. actwin_buffer.'wincmd 2'
execute 'silent '. a:actwin.win_nr.'wincmd w'
    endif
  endif
call s:LOG("s:SourceSetAtEntry: BOTTOM")
let s:buf_change = 1
endfunction

function! s:RemoveAtEntry(entrynos, actwin)
let s:buf_change = 0
call s:LOG("s:RemoveAtEntry: entrynos=". a:entrynos)
  let [l:found, l:entry] = s:GetEntry(a:entrynos, a:actwin)
  if l:found && has_key(l:entry, 'file')
    let l:file = l:entry.file
    let l:linenos = has_key(l:entry, 'line') ? l:entry.line : 1

  endif
call s:LOG("s:RemoveAtEntry: BOTTOM")
let s:buf_change = 1
endfunction

" Goto Non-ActWin cursor file and postion
function! s:SourceGoToEntry(entrynos, actwin)
call s:LOG("s:SourceGoToEntry: in Non-ActWin entrynos=". a:entrynos)
  let [l:found, l:entry] = s:GetEntry(a:entrynos, a:actwin)
  if l:found && has_key(l:entry, 'file')
    let l:file = l:entry.file
    let l:win_nr = bufwinnr(l:file)
call s:LOG("s:SourceGoToEntry: win_nr=". l:win_nr)
    if l:win_nr > 0
let b:return_win_nr = l:win_nr
      let l:linenos = has_key(l:entry, 'line') ? l:entry.line : 1
      let l:colnos = has_key(l:entry, 'col') ? l:entry.col : -1
call s:LOG("s:SourceGoToEntry: linenos=". l:linenos)
call s:LOG("s:SourceGoToEntry: colnos=". l:colnos)
      if l:colnos > 1
        execute 'silent '. l:win_nr.'wincmd w | :normal! '. l:linenos .'G' . l:colnos . "l"
      else
        execute 'silent '. l:win_nr.'wincmd w | :normal! '. l:linenos .'G'
      endif

if s:is_color_column_enabled
  if l:colnos > 1
    execute 'silent '. l:win_nr.'wincmd w | :set colorcolumn='. l:colnos
  else
    execute 'silent '. l:win_nr.'wincmd w | :set colorcolumn='
  endif
endif

    endif
  endif
call s:LOG("s:SourceGoToEntry: BOTTOM")
endfunction

" ============================================================================
" Highlight Patterns: {{{1
" ============================================================================

function! s:GetOption(name)
  let [found, value] = g:vimside.GetOption(a:name)
  if ! found
    throw "Option not found: '". a:name ."'
  endif
  return value
endfunction

function! s:Color_2_Number(color)
  " is it a name
  let rgbtxt = forms#color#util#ConvertName_2_RGB(a:color)
  if rgbtxt == ''
    let nos = forms#color#term#ConvertRGBTxt_2_Int(a:color)
  else
    let nos = forms#color#term#ConvertRGBTxt_2_Int(rgbtxt)
  endif
  return nos
endfunction

function! s:InitGui()
  if &background == 'light' 
    let selectedColor = s:GetOption('tailor-expand-selection-highlight-color-light')

  else " &background == 'dark'
    let selectedColor = s:GetOption('tailor-expand-selection-highlight-color-dark')
  endif
call s:LOG("s:InitGui: selectedColor=". selectedColor) 
  execute "hi VimsideActWin_HL gui=bold guibg=#" . selectedColor
endfunction

function! s:InitCTerm()
  if exists("g:vimside.plugins.forms") && g:vimside.plugins.forms
    if &background == 'light' 
      let selectedColor = s:GetOption('tailor-expand-selection-highlight-color-light')
    else " &background == 'dark'
      let selectedColor = s:GetOption('tailor-expand-selection-highlight-color-dark')
    endif
call s:LOG("s:InitCTerm: selectedColor=". selectedColor) 
    let selectedNumber = s:Color_2_Number(selectedColor)
  else
    if &background == 'light' 
      " TODO: hardcode for now
      let selectedNumber = '87'
    else " &background == 'dark'
      " TODO: hardcode for now
      let selectedNumber = '87'
    endif
  endif
call s:LOG("s:InitCTerm: selectedNumber=". selectedNumber) 
  execute "hi VimsideActWin_HL cterm=bold ctermbg=" . selectedNumber
endfunction

function! s:InitializeHighlight()
  if has("gui_running")
    call s:InitGui()
  else
    call s:InitCTerm()
  endif
endfunction

call s:InitializeHighlight()

function! s:GetLinesMatchPatterns(line_start, line_end, nos_columns)
  let lnum1 = a:line_start
  let lnum2 = a:line_end
  let endCol = 200

  if a:nos_columns > 0
    let l:nos_columns = a:nos_columns + 1

    if lnum1 == lnum2
      " one lines
      
      let patterns = [ '\%'.lnum1.'l\%<'. l:nos_columns .'c' ]
    elseif lnum1+1 == lnum2
      let pat1 = '\%'.lnum1.'l\%<'. l:nos_columns .'c'
      let pat2 = '\%'.lnum2.'l\%<'. l:nos_columns .'c'
      let patterns = [ pat1, pat2 ]
    else
      " general case
      let patterns = [ ]
      let l:ln = lnum1
      while l:ln <= lnum2
        let pat = '\%'.l:ln.'l\%<'. l:nos_columns .'c'
        call add(patterns, pat)
        let l:ln += 1
      endwhile

    endif

  else
    if lnum1 == lnum2
      " one lines
      " let range = [ '\%'.lnum1.'l\%>'.(0).'v.*\%<'.(endCol+2).'v' ]
      " let patterns = [ '\%'.lnum1.'l', '\%3c' ]
      
      let patterns = [ '\%'.lnum1.'l' ]
    elseif lnum1+1 == lnum2
      " two lines
      " let pat1 = '\%'.lnum1.'l\%>'.(col1+1).'v.*\%<'.(endCol).'v'
      " let pat1 = '\%'.lnum1.'l\%>'.(0).'v.*\%<'.(endCol).'v'
      " let pat2 = '\%'.lnum2.'l\%>'.(1).'v.*\%<'.(endCol).'v'

      let pat1 = '\%'.lnum1.'l'
      let pat2 = '\%'.lnum2.'l'
      let patterns = [ pat1, pat2 ]
    else
      " general case
      let patterns = [ ]
      let l:ln = lnum1
      while l:ln <= lnum2
        let pat = '\%'.l:ln.'l'
        call add(patterns, pat)
        let l:ln += 1
      endwhile

    endif
  endif

call s:LOG("s:GetLinesMatchPatterns: patterns=". string(patterns)) 
  return patterns
endfunction

function! s:HighlightClear(sids)
" call s:LOG("s:HighlightClear: TOP") 
" call s:LOG("s:HighlightClear: clearing sids") 
  for sid in a:sids
" call s:LOG("s:HighlightClear: clear sid=". sid) 
    try
      if matchdelete(sid) == -1
" call s:LOG("s:HighlightClear: failed to clear sid=". sid) 
      endif
    catch /.*/
" call s:LOG("ERROR s:HighlightClear: sid=". sid) 
    endtry
  endfor
" call s:LOG("s:HighlightClear: matches=". string(getmatches())) 
" call s:LOG("s:HighlightClear: BOTTOM") 
endfunction

" returns list of sids
function! s:HighlightDisplay(line_start, line_end, nos_columns)
" call s:LOG("s:HighlightDisplay: line_start=". a:line_start .", line_end=". a:line_end) 
  let patterns = s:GetLinesMatchPatterns(a:line_start, a:line_end, a:nos_columns)
  let l:sids = []
  for pattern in patterns
    let sid = matchadd("VimsideActWin_HL", pattern)
" call s:LOG("s:HighlightDisplay: sid=". sid) 
    call add(l:sids, sid)
  endfor
  return l:sids
endfunction

" ============================================================================
" Test: {{{1
" ============================================================================

function! vimside#actwin#TestQuickFix()

"   help: {
"     do_show: 0
"     is_open: 0
"     .....
"   }
"   builtin_cmd: {
"   }
"   leader_cmd: {
"   }
"   sign: {
"     category: QuickFix
"     kinds: {
"       kname: {text, textlh, linehl }
"     }
"   }
"     file:
"     line:
"     kind: 'error'
"
  let l:helpdata = {
        \ "title": "Help Window",
        \ "winname": "Help",
        \ "window": {
          \ "edit": {
          \ "cmd": "enew"
          \ }
        \ },
        \ "cmds": {
          \ "window": {
            \ "key_map": {
              \ "close": "q"
            \ }
          \ }
        \ },
        \ "actions": {
          \ "enter": function("s:EnterActionDoNothing"),
          \ "select": function("s:SelectActionDoNothing"),
          \ "leave": function("s:LeaveActionDoNothing")
        \ },
        \ "entries": [
        \  { 'content': [
            \  "This is some help text",
            \  "  Help text line 1",
            \  "  Help text line 2",
            \  "  Help text line 3",
            \  "  Help text line 4",
            \  "  Help text line 5",
            \  "  Help text line 6"
            \ ],
          \ "kind": "info"
          \ }
        \ ]
    \ }

  let l:data = {
        \ "title": "Test Window",
        \ "winname": "Test",
        \ "help": {
          \ "do_show": 1,
          \ "data": l:helpdata,
        \ },
        \ "cmds": {
          \ "source": {
            \ "builtin_cmd": {
              \ "first": "cr",
              \ "last": "cl",
              \ "previous": "cp",
              \ "next": "cn",
              \ "enter": "ce",
              \ "close": "ccl"
            \ },
            \ "leader_cmd": {
              \ "previous": "cp",
              \ "next": "cn",
              \ "close": "ccl"
            \ },
          \ },
          \ "window": {
            \ "key_map": {
              \ "window_key_map_show": "<F2>",
              \ "source_builtin_cmd_show": "<F3>",
              \ "source_leader_cmd_show": "<F4>",
              \ "help": "<F1>",
              \ "select": [ "<CR>", "<2-LeftMouse>"],
              \ "enter_mouse": "<LeftMouse> <LeftMouse>",
              \ "top": [ "gg", "1G", "<PageUp>"],
              \ "bottom": [ "G", "<PageDown>"],
              \ "down": [ "j", "<Down>"],
              \ "up": [ "k", "<Up>"],
              \ "close": "q"
            \ },
          \ },
        \ },
        \ "display": {
          \ "source": {
            \ "sign": {
              \ "is_enable": 0,
              \ "category": "TestWindow",
              \ "abbreviation": "tw",
              \ "toggle": "tw",
              \ "default_kind": "marker",
              \ "kinds": {
                \ "error": {
                  \ "text": "EE",
                  \ "texthl": "Todo",
                  \ "linehl": "Error"
                \ },
                \ "warn": {
                  \ "text": "WW",
                  \ "texthl": "ToDo",
                  \ "linehl": "StatusLine"
                \ },
                \ "info": {
                  \ "text": "II",
                  \ "texthl": "DiffAdd",
                  \ "linehl": "Ignore"
                \ },
                \ "marker": {
                  \ "text": "MM",
                  \ "texthl": "Search",
                  \ "linehl": "Ignore"
                \ }
              \ }
            \ },
            \ "color_line": {
              \ "is_enable": 0,
              \ "is_on": 0,
              \ "category": "ColorLine",
              \ "toggle": "cl",
              \ "abbreviation": "cl",
              \ "default_kind": "marker",
              \ "kinds": {
                \ "error": {
                  \ "text": "EE",
                  \ "texthl": "Error",
                  \ "linehl": "Error"
                \ },
                \ "marker": {
                  \ "text": "MM",
                  \ "texthl": "Search",
                  \ "linehl": "Search"
                \ }
              \ }
            \ },
            \ "color_column": {
              \ "is_enable": 1,
              \ "is_on": 0,
            \ }
          \ },
          \ "window": {
            \ "cursor_line": {
              \ "toggle": "wcl",
              \ "is_enable": 1,
              \ "is_on": 0
            \ },
            \ "highlight_line": {
              \ "toggle": "whl",
              \ "is_enable": 0,
              \ "is_on": 0,
              \ "is_full": 1,
              \ "nos_columns": 0,
              \ "all_text": 1
            \ },
            \ "sign": {
              \ "is_enable": 0,
              \ "all_text": 1,
              \ "category": "SourceWindow",
              \ "abbreviation": "sw",
              \ "toggle": "sw",
              \ "default_kind": "marker",
              \ "kinds": {
                \ "error": {
                  \ "text": "EE"
                \ },
                \ "warn": {
                  \ "linehl": "StatusLine",
                  \ "text": "WW"
                \ },
                \ "info": {
                  \ "texthl": "DiffAdd",
                  \ "text": "II"
                \ },
                \ "marker": {
                  \ "text": "MM"
                \ }
              \ }
            \ }
          \ }
        \ },
        \ "actions": {
          \ "enter": function("s:EnterActionQuickFix"),
          \ "select": function("s:SelectActionQuickFix"),
          \ "leave": function("s:LeaveActionQuickFix")
        \ },
        \ "entries": [
        \  { 'content': "Entry 1 line one",
          \ "file": "src/main/scala/com/megaannum/Foo.scala",
          \ "line": 1,
          \ "col": 1,
          \ "kind": "error"
          \ },
        \  { 'content': "Entry 2 line two",
          \ "file": "src/main/scala/com/megaannum/Foo.scala",
          \ "line": 3,
          \ "col": 6,
          \ "kind": "warn"
          \ },
        \  { 'content': [
            \  "Entry 3 line three line 0",
            \  "   Entry 3 line four line 1",
            \  "   Entry 3 line five line 2"
            \ ],
          \ "file": "src/main/scala/com/megaannum/Foo.scala",
          \ "line": 5,
          \ "col": 7,
          \ "kind": "info"
          \ },
        \  { 'content': "Entry 4 line six",
          \ "file": "src/main/scala/com/megaannum/Foo.scala",
          \ "line": 7,
          \ "col": 2,
          \ "kind": "error"
          \ },
        \  { 'content': [
            \  "Entry 5 line seven line 0",
            \  "   Entry 5 line eigth line 1",
            \  "   Entry 5 line nine line 2"
            \ ],
          \ "file": "src/main/scala/com/megaannum/Foo.scala",
          \ "line": 9,
          \ "col": 4,
          \ "kind": "warn"
          \ },
        \  { 'content': [
            \  "Entry 6 line ten"
            \ ],
          \ "file": "src/main/scala/com/megaannum/Foo.scala",
          \ "line": 10,
          \ "col": 8,
          \ "kind": "info"
          \ },
        \  { 'content': [
            \  "Entry 7 line eleven",
            \  "  Entry 7 line 1"
            \ ],
          \ "file": "src/main/scala/com/megaannum/Foo.scala",
          \ "line": 11,
          \ "col": 10,
          \ "kind": "error"
          \ },
        \  { 'content': "line thirteen Bar",
          \ "file": "src/main/scala/com/megaannum/Bar.scala",
          \ "line": 12,
          \ "col": 10,
          \ "kind": "warn"
          \ },
        \  { 'content': "line fourteen Bar",
          \ "file": "src/main/scala/com/megaannum/Bar.scala",
          \ "line": 15,
          \ "col": 5,
          \ "kind": "info"
          \ },
        \  { 'content': "line fifteen",
          \ "file": "src/main/scala/com/megaannum/Foo.scala",
          \ "line": 15,
          \ "kind": "error"
          \ },
        \  { 'content': "line sixteen",
          \ "file": "src/main/scala/com/megaannum/Foo.scala",
          \ "line": 16,
          \ "col": 5,
          \ "kind": "warn"
          \ }
        \ ]
    \ }
  call vimside#actwin#DisplayLocal('testqf', l:data)

endfunction

function! vimside#actwin#TestHelp()
  let l:data = {
        \ "title": "Help Window",
        \ "winname": "Help",
        \ "cmds": {
          \ "window": {
            \ "key_map": {
              \ "close": "q"
            \ }
          \ }
        \ },
        \ "actions": {
          \ "enter": function("s:EnterActionDoNothing"),
          \ "select": function("s:SelectActionDoNothing"),
          \ "leave": function("s:LeaveActionDoNothing")
        \ },
        \ "entries": [
        \  { 'content': [
            \  "This is some help text",
            \  "  Help text line 1",
            \  "  Help text line 2",
            \  "  Help text line 3",
            \  "  Help text line 4",
            \  "  Help text line 5",
            \  "  Help text line 6"
            \ ],
          \ "kind": "info"
          \ }
        \ ]
    \ }
  call vimside#actwin#DisplayLocal('testhelp', l:data)
endfunction

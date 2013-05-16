" Logger utilities

let s:save_cpo = &cpo
set cpo&vim

let s:logger_impl = {
\  "name": "",
\  "path": "",
\  "rotation": 3,
\}

let s:cmd = expand('<sfile>:p:h') . '/log.js'

function! s:_write(path, name, level, msg) 
  let f = tempname()
  call writefile([printf("%s [%s] [%s]: %s", strftime("%Y/%m/%d %H:%M:%S"), a:name, a:level, a:msg)], f)
  if has("win32") || has("win64")
    call system("wscript " . join([s:cmd, f, a:path], " "))
  else
    exe "silent! !cat ".shellescape(f) ">>".shellescape(a:path)
  endif
endfunction

function! s:logger_impl.info(...) dict
  call s:_write(self.path, self.name, "INF", join(a:000, " "))
endfunction

function! s:logger_impl.error(...) dict
  call s:_write(self.path, self.name, "ERR", join(a:000, " "))
endfunction

function! s:logger_impl.warn(...) dict
  call s:_write(self.path, self.name, "WRN", join(a:000, " "))
endfunction

function! s:new(name, ...)
  let path = get(a:000, 0, len($TEMP) > 0 ? $TEMP : $TMP)
  let l = copy(s:logger_impl)
  let l.name = a:name
  let l.path = printf("%s/%s-%s.log", path, a:name, strftime("%Y%m%d"))
  return l
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

" vim:set et ts=2 sts=2 sw=2 tw=0:

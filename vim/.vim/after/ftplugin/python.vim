setlocal colorcolumn=80
set noai nocin nosi shiftwidth=4 tabstop=4 softtabstop=4 expandtab
setlocal wildignore=*.pyc

" {{{ Leeren @VimConf 2020
set include=^\\s*\\(from\\\|import\\)\\s*\\zs\\(\\S\\+\\s\\{-}\\)*\\ze\\($\\\|\ as\\)

function! PyInclude(fname)
    let parts = split(a:fname, ' import ')
    let l = parts[0]
    if len(parts) > 1
        let r = parts[1]
        let joined = join([l, r], '.')
        let fp = substitute(joined, '\.', '/', 'g') . '.py'
        let found = glob(fp, 1)
        if len(found)
            return found
        endif
    endif
    return substitute(l, '\.', '/', 'g') . '.py'
endfunction
setlocal includeexpr=PyInclude(v:fname)  " ij <class/function>
setlocal define=^\\s*\\<\\(def\\\|class\\)\\>  " dj <class/function>

map <buffer> <F3> :call Flake8()<CR>



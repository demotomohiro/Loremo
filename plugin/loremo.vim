"NeoVim global plugin for using NeoVim on terminal inside NeoVim
"Maintainer: Tomohiro

"w:LoremoKeyBindMode = 1 -> local mode
"                      0 -> remote mode
function! s:ToggleMode()
    if &buftype != 'terminal'
        return
    endif
    if !exists("w:LoremoKeyBindMode")
        let w:LoremoKeyBindMode = 1
    else
        let w:LoremoKeyBindMode = !w:LoremoKeyBindMode
    endif
    let l:modename = w:LoremoKeyBindMode ? "local" : "remote"
    execute 'setlocal statusline=%f\ '.'【'.l:modename.'】'
endfunction

"1 -> local mode, 0 -> remote mode
function! s:GetMode()
    return exists("w:LoremoKeyBindMode") ? w:LoremoKeyBindMode : 1
endfunction

function! loremo#SetToggleModeKey(k, autoChangeMode) abort
    exec 'tnoremap <silent> '.a:k.' <C-\><C-n>:call <SID>ToggleMode()<CR>a'
    let changeMode = a:autoChangeMode ? '|if <SID>GetMode()==0|startinsert|endif<CR>' : '<CR>'
    exec 'nnoremap <silent> '.a:k.' :call <SID>ToggleMode()'.changeMode
endfunction

function! loremo#TKeyBind(k, c)
    exec 'tnoremap <expr> '.a:k." <SID>GetMode() ? '<C-\\><C-n>".a:c."' : '".a:k."'"
endfunction

function! loremo#TKeyBindExpr(k, e)
    let l:e = substitute(a:e, '<loremoEsc>', '<C-\><C-n>', 'g')
    exec 'tnoremap <expr> '.a:k.' <SID>GetMode() ? ('.l:e.") : '".a:k."'"
endfunction

function! loremo#GKeyBind(modes, k, v) abort
    for m in split(a:modes, '\zs')
        if m == 't'
            call loremo#TKeyBind(a:k, a:v)
            continue
        elseif m == 'T'
            call loremo#TKeyBind(a:k, a:v.'i')
            continue
        elseif m == 'i'
            let cmd = '<ESC>'.a:v
        else
            let cmd = a:v
        endif
        exec m.'noremap '.a:k." ".cmd
    endfor
endfunction

command! -nargs=+ LoremoSetToggleModeKey call loremo#SetToggleModeKey(<f-args>)
command! -nargs=+ LoremoTnoremap call loremo#TKeyBind(<f-args>)
command! -nargs=+ LoremoGnoremap call loremo#GKeyBind(<f-args>)

"tnoremap <M-,> <C-\><C-n>:echo <SID>GetMode()<CR>

"tnoremap <expr> <M-q> <SID>GetMode() ? '<C-\><C-n>:q' : '<M-q>'

"Example:
"Set key to change local/remote mode.
" LoremoSetToggleModeKey <M-.> 1

"Map terminal mode keys.
" call loremo#TKeyBind('<A-q>', ':q')
" LoremoTnoremap <A-j> <C-w>j
"Map insert/normal/terminal mode keys.
" LoremoGnoremap int <A-k> <C-w>k


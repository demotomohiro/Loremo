# Loremo
Loremo is a neovim plugin to help using neovim inside neovim by adding local/remote mode to each window displaying terminal buffer.
In local mode, all mapped key inputs are consumed by local(outer) neovim and not sent to remote(inner) neovim.
It is not different from usual terminal mode.
In remote mode, mapped key inputs are ignored by local neovim and sent to remote neovim.
So key mappings on remote neovim works.

## Why use neovim inside neovim and loremo?
For example, I use neovim inside neovim when I run neovim, `:terminal<CR>`, ssh to a remote machine, run tmux and neovim on the machine.
NVIM REFERENCE MANUAL tells following mapping:
```viml
:tnoremap <A-h> <C-\><C-n><C-w>h
```
(Map Alt-h key to move to left window in terminal mode)
It works in local neovim.
But on remote neovim(neovim inside neovim), that key mapping doesn't work.
Because all mapped keys are consumed by local neovim and not sent to a remote neovim.
So if you have key mappings in terminal mode, using neovim inside neovim is awful.

There are some ways to avoid running neovim inside neovim and use neovim to edit files on remote host.
Netrw plugin makes reading files, writing files, browsing over a network.
sshfs command can mount a directory on the remote host to local machine and you can access remote files as if they were local files.
But I wanted to have 2 or more terminal windows/tabs and use them inside neovim on remote host in the same way on local machine.

## How to install
Loremo is a global plugin.
Copy loremo.vim to ~/.local/share/nvim/site/plugin
```console
$ mkdir -p ~/.local/share/nvim/site/plugin
$ cp loremo.vim ~/.local/share/nvim/site/plugin
```

## How to use
Add following lines to your config file.
```console
"Load loremo.vim
source ~/.local/share/nvim/site/plugin/loremo.vim
"Assign Alt-. key to change local/remote mode.
LoremoSetToggleModeKey <M-.> 1
"Add key mappings using LoremoGnoremap/LoremoTnoremap command or loremo#GKeyBind function.
LoremoGnoremap int <A-h> <C-w>h
```

Only key mappings made by loremo commands/functions affect local/remote mode.
If you want to use remote neovim with same key mappings as local neovim, add same mappings with *map command or install loremo.vim and copy your local configuration file to remote machine.

## Commands
LoremoSetToggleModeKey {KeySeq} {autoChangeMode}
Set the key sequence {KeySeq} to Toggle local/remote mode.
If {autoChangeMode} == 1, automatically change to insert mode when mode is toggled from local to remote.
Following example assign Alt-. key to toggle mode.
```viml
LoremoSetToggleModeKey <M-.> 1
```

LoremoTnoremap {lhs} {rhs}
Map the key sequence {lhs} to {rhs} like tnoremap command, but it is affected by local/remote mode.
This command prepend `<C-\\><C-n>` to {rhs} in local mode.
Following example assign Alt-h key to Ctrl-w h key sequece which move to left window.
```viml
LoremoTnoremap <A-h> <C-w>h
```

LoremoGnoremap {modes} {lhs} {rhs}
Map the key sequence {lhs} to {rhs} for each modes specified by {modes}.
Each charactor in {modes} specify mode.
i = input
n = normal
t = terminal
Following example assign Alt-h key to Ctrl-w h key sequece which move to left window and it works insert, normal and terminal mode.
```viml
LoremoGnoremap int <A-h> <C-w>h
```

If you find this plugin useful and want to make a donation, you can send bitcoins to following address:
1PztUAzRf42BrzziGFeXh2hynT3qDkUADS

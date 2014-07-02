# Introducing the just-tmux gem

If you need to open tmux windows to run scripts from the command-line then this gem might be for you.

Example:


    require 'just-tmux'

    tmux_config =<<EOF
    <?dynarex schema="tmux[session, shell, default_dir]/window(command, name, dir)"?>
    session: fun
    shell: bash
    default_dir: ~

    lis
    pwd  home  /home/james/ruby
    EOF

    # note: the window name and directory are optional

    dynarex = Dynarex.new
    dynarex.import tmux_config
    dynarex.save 'tmux-config.xml'
    puts JustTmux.new('tmux-config.xml').to_s

output:

    tmux new-session -d -s fun -n bash 'bash'
    tmux send-keys 'cd /home/james && lis' Enter
    tmux new-window -n home bash
    tmux send-keys 'cd /home/james/ruby && pwd' Enter


Note: A Dynarex document can now be passed in.

tmux justtmux gem windows commandline

# opam configuration
# source /Users/wilbowma/.opam/opam-init/init.fish > /dev/null 2> /dev/null; or true
fish_add_path /usr/local/sbin
fish_add_path /usr/local/opt/ruby/bin
fish_add_path ~/.cargo/bin
fish_add_path ~/workspace/racket/racket/bin
fish_add_path ~/plt/bin
fish_add_path ~/bin
set -x -g JOBS (math (nproc --all)" / 2")
set -x -g SSH_AUTH_SOCK {{SSH_AUTH_SOCK}}
set -x -g PLTHOME ~/workspace/racket

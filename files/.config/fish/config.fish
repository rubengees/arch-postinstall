set fish_greeting

set fish_color_command 005fff
set fish_color_autosuggestion 777777
set fish_color_comment 9e9e9e
set fish_color_quote ffd700

set -xg COREPACK_ENABLE_AUTO_PIN 0
set -xg ANDROID_HOME $HOME/Android/Sdk

fish_add_path $HOME/Android/Sdk/platform-tools
fish_add_path $HOME/.local/share/JetBrains/Toolbox/scripts

alias cd="z"
alias cdi="zi"

alias cat="bat"

alias zed="zeditor"

alias gull="git pull"
alias gush="git push"
alias gitch="git switch"
alias geckout="git checkout"

alias dcu="docker compose up -d --remove-orphans"
alias dcd="docker compose down"

zoxide init fish | source

# - - - - - - - - - - - - - - - - - - - -
# * My Funcs
# - - - - - - - - - - - - - - - - - - - -

function bro() {
    tldr "$@"
}
function mkcd() {
    last=$(eval "echo \$$#")
    if [ ! -n "$last" ]; then
        echo "Enter a directory name"
    elif [ -d $last ]; then
        echo "\`$last' already exists"
    else
        mkdir $@ && cd $last
    fi
}
function cd() {
    builtin cd "$@" && ls -G
}
function extract() {
    echo Extracting $1 ...
    if [ -f $1 ]; then
        case $1 in
        *.tar.bz2) tar xjf $1 ;;
        *.tar.gz) tar xzf $1 ;;
        *.bz2) bunzip2 $1 ;;
        *.rar) rar x $1 ;;
        *.gz) gunzip $1 ;;
        *.tar) tar xf $1 ;;
        *.tbz2) tar xjf $1 ;;
        *.tgz) tar xzf $1 ;;
        *.zip) unzip $1 ;;
        *.Z) uncompress $1 ;;
        *.7z) 7z x $1 ;;
        *) echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}
function '-'(){
    cd -
}
function '..'(){
    cd ..
}
function '~'(){
    cd ~
}
fag(){
  local line
  line=`ag "$1" | fzf` \
    && code $(cut -d':' -f1 <<< "$line") +$(cut -d':' -f2 <<< "$line")
}    


# - - - - - - - - - - - - - - - - - - - -
# * Ranger Config
# - - - - - - - - - - - - - - - - - - - -

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8i
export EDITOR=code


# - - - - - - - - - - - - - - - - - - - -
# * Zinit Init
# - - - - - - - - - - - - - - - - - - - -

# NOTE: [install zinit](sh -c "$(curl -fsSL https://raw.githubusercontent.com/zdharma/zinit/master/doc/install.sh)")
### Added by Zinit's installer
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma/zinit%F{220})…%f"
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone https://github.com/zdharma/zinit "$HOME/.zinit/bin" &&
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" ||
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi
source "$HOME/.zinit/bin/zinit.zsh"

# - - - - - - - - - - - - - - - - - - - -
# * Zinit Plugin
# - - - - - - - - - - - - - - - - - - - -

# zinit lucid has'docker' for \
#   as'completion' is-snippet \
#   'https://github.com/docker/cli/blob/master/contrib/completion/zsh/_docker' \
#   \
#   as'completion' is-snippet \
#   'https://github.com/docker/compose/blob/master/contrib/completion/zsh/_docker-compose'
#  NOTE (xiangjun.ma) pro example <https://github.com/zdharma-continuum/zinit/issues/8>

zinit wait'0a' lucid for \
 atinit"ZINIT[COMPINIT_OPTS]=-C; zpcompinit; zpcdreplay" \
    zdharma-continuum/fast-syntax-highlighting \
 atload"!_zsh_autosuggest_start" \
    zsh-users/zsh-autosuggestions \
    hlissner/zsh-autopair\
 blockf \
  MichaelAquilina/zsh-you-should-use \
    clarketm/zsh-completions

zinit wait lucid for \
    OMZ::lib/git.zsh \
 atload"unalias grv g" \
    OMZ::plugins/git/git.plugin.zsh
 
zinit wait lucid for \
    Aloxaf/fzf-tab \
    tj/git-extras


PS1="READY >"
zinit ice wait'!' lucid
zinit ice depth=1; zinit light romkatv/powerlevel10k

# - - - - - - - - - - - - - - - - - - - -
# * Vim Cursor style
# - - - - - - - - - - - - - - - - - - - -

# NOTE: (https://unix.stackexchange.com/questions/433273/changing-cursor-style-based-on-mode-in-both-zsh-and-vim) <<<<
bindkey -v
export KEYTIMEOUT=1
# Change cursor shape for different vi modes.
function zle-keymap-select() {
    if [[ ${KEYMAP} == vicmd ]] ||
        [[ $1 = 'block' ]]; then
        echo -ne '\e[1 q'
    elif [[ ${KEYMAP} == main ]] ||
        [[ ${KEYMAP} == viins ]] ||
        [[ ${KEYMAP} = '' ]] ||
        [[ $1 = 'beam' ]]; then
        echo -ne '\e[5 q'
    fi
}
zle -N zle-keymap-select
zle-line-init() {
    zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    echo -ne "\e[5 q"
}
zle -N zle-line-init
echo -ne '\e[5 q'                # Use beam shape cursor on startup.
preexec() { echo -ne '\e[5 q'; } # Use beam shape cursor for each new prompt


# - - - - - - - - - - - - - - - - - - - -
# * Source
# - - - - - - - - - - - - - - - - - - - -

# NOTE:To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh




# - - - - - - - - - - - - - - - - - - - -
# * Export Path
# - - - - - - - - - - - - - - - - - - - -

export PATH="/usr/local/opt/libpq/bin:$PATH"
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

# - - - - - - - - - - - - - - - - - - - -
# * Pyspark 
# - - - - - - - - - - - - - - - - - - - -
# NOTE <https://stackoverflow.com/questions/31841509/pyspark-exception-java-gateway-process-exited-before-sending-the-driver-its-po>
export JAVA_HOME=$(/usr/libexec/java_home -v 1.8)
export PATH=$JAVA_HOME/bin:$PATH


# - - - - - - - - - - - - - - - - - - - -
# * Fzf
# - - - - - - - - - - - - - - - - - - - -

# fzf config <https://segmentfault.com/a/1190000016186043>
export FZF_DEFAULT_OPTS='--preview "bat --theme="TwoDark" --style="numbers,changes,header" --color=always --line-range :500 {}"'
export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow --glob "!{.git,node_modules}/*" 2> /dev/null'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="rg --sort-files --files --null 2> /dev/null | xargs -0 dirname | uniq"


# - - - - - - - - - - - - - - - - - - - -
# * Rust
# - - - - - - - - - - - - - - - - - - - -
export PATH="/Users/xiangjunma/.cargo/bin:$PATH"


# - - - - - - - - - - - - - - - - - - - -
# * fzf-tab
# - - - - - - - - - - - - - - - - - - - -
# disable sort when completing `git checkout`
zstyle ':completion:*:git-checkout:*' sort false
# set descriptions format to enable group support
zstyle ':completion:*:descriptions' format '[%d]'
# set list-colors to enable filename colorizing
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# preview directory's content with exa when completing cd
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'exa -1 --color=always $realpath'
# switch group using `,` and `.`
zstyle ':fzf-tab:*' switch-group ',' '.'
zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup

# - - - - - - - - - - - - - - - - - - - -
# * BindKey
# - - - - - - - - - - - - - - - - - - - -
bindkey '^F' autosuggest-accept
bindkey '^[^?' backward-kill-word
# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/opt/homebrew/Caskroom/miniconda/base/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/homebrew/Caskroom/miniconda/base/etc/profile.d/conda.sh" ]; then
        . "/opt/homebrew/Caskroom/miniconda/base/etc/profile.d/conda.sh"
    else
        export PATH="/opt/homebrew/Caskroom/miniconda/base/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<


# - - - - - - - - - - - - - - - - - - - -
# * Others
# - - - - - - - - - - - - - - - - - - - -

export DISPLAY=:0
export PATH="$PATH:/Library/TeX/texbin"
export TERM=xterm-256color
export HISTFILE=~/.zsh_history
export HISTSIZE=100000
export SAVEHIST=10000
setopt SHARE_HISTORY
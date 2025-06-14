# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="bira"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)
source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"


export PATH="$PATH:$HOME/.cargo/bin"
export PATH="$PATH:/opt/nvim-linux-x86_64/bin"
export PATH="$PATH:/home/sunny/.local/bin"
export PATH="$PATH:/usr/local/go/bin"

alias gotowin="cd /media/sunny/Windows/Users/saror" 

function f() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

function nf() {
  for filepath in "$@"; do
    mkdir -p "$(dirname $filepath)" && touch "$filepath"
  done
}

function gacp() {
    if [ "$#" -lt 3 ]; then
        echo "Usage: gacp <files...> <commit_message> <branch>"
        echo "Example: gacp file1.txt file2.js 'update files' main"
        return 1
    fi
    
    args=("$@")
    num_args=${#args[@]}
    
    branch="${args[$num_args]}"
    commit_msg="${args[$num_args-1]}"
    files=("${args[@]:0:$num_args-2}")
    
    for file in "${files[@]}"; do
        if [ ! -e "$file" ]; then
            echo "Warning: File '$file' does not exist"
            continue
        fi
        git add "$file"
    done
    
    git commit -m "$commit_msg"
    git push origin "$branch"
}

function gc() {
    if [ "$#" -lt 3 ]; then
        echo "Usage: gacp <files...> <commit_message> <branch>"
        echo "Example: gacp file1.txt file2.js 'update files' main"
        return 1
    fi
    
    args=("$@")
    num_args=${#args[@]}
    
    commit_msg="${args[$num_args-1]}"
    files=("${args[@]:0:$num_args-1}")
    
    for file in "${files[@]}"; do
        if [ ! -e "$file" ]; then
            echo "Warning: File '$file' does not exist"
            continue
        fi
        git add "$file"
    done
    
    git commit -m "$commit_msg"
}

if [ -z "$(ls -A /media/sunny/int_drive/)" ]; then
    sudo mount --mkdir /dev/nvme0n1p3 /media/sunny/int_drive
fi

tmac() {
    local session="${1:-default}"
    tmux has-session -t "$session" 2>/dev/null || tmux new-session -d -s "$session"
    tmux attach -t "$session"
}
_tmac_complete() {
    local word=${COMP_WORDS[COMP_CWORD]}
    local sessions=$(tmux list-sessions -F "#{session_name}" 2>/dev/null)
    COMPREPLY=( $(compgen -W "$sessions" -- "$word") )
}
complete -F _tmac_complete tmac

tmux_pick_session() {
  if [ -n "$TMUX" ]; then
    return
  fi
  local sessions new_session session
  sessions=$(tmux list-sessions -F "#{session_name}" 2>/dev/null)
  if [[ -z "$sessions" ]]; then
    read "new_session?Enter new session name: "
    clear
    tmux new-session -s "${new_session:-default}"
    clear
    return
  fi
  session=$(echo -e "$sessions\nNew Session" | fzf --reverse --height 40% --prompt="Select tmux session: ")
  if [[ "$session" == "New Session" ]]; then
    read "new_session?Enter new session name: "
    clear
    tmux new-session -s "${new_session}"
    clear
  elif [[ -n "$session" ]]; then
    clear
    tmux attach -t "$session"
    clear
  else
    echo "Did not get any session input, exiting...."
  fi
}

tmux_pick_session


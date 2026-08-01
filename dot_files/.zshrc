# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"



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

export EDITOR='nvim'

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

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

export LS_COLORS='di=1;38;2;230;80;27:fi=1;38;2;233;127;74'
export LS_COLORS='di=1;38;2;230;80;27:fi=1;38;2;247;227;150'

# source ROS 2 jazzy
source /opt/ros/jazzy/setup.zsh

# WARN and ERROR colours 
export RCUTILS_COLORIZED_OUTPUT=1

roscd() {
  # Bezpečnější kontrola s uvozovkami
  if [ -n "$COLCON_PREFIX_PATH" ]; then
    if [ -z "$1" ]; then
      cd "$COLCON_PREFIX_PATH/../src" || return 1
      return 0
    fi
    # Nejprve zkusit najít balíček v aktuálním workspace
    local package_path
    package_path=$(
      colcon list --base-paths "$COLCON_PREFIX_PATH/.." 2>/dev/null | \
      grep -E "^$1\s" | awk '{print $2}'
    )
    if [ -n "$package_path" ]; then
      cd "$package_path" || return 1
      return 0
    fi
  fi

  if [ -z "$1" ]; then
    cd /opt/ros/jazzy/share || return 1
    return 0
  fi

  # Poté zkusit najít balíček mezi nainstalovanými
  local package_path
  package_path=$(ros2 pkg prefix --share "$1" 2> /dev/null)
  if [ -n "$package_path" ]; then
    cd "$package_path" || return 1
    return 0
  fi

  # Pokud nic nevyjde, skoč do workspace src (pokud existuje)
  if [ -n "$COLCON_PREFIX_PATH" ]; then
    cd "$COLCON_PREFIX_PATH/../src" || return 1
  fi
}

_roscd_complete() {
  local current_word="${COMP_WORDS[COMP_CWORD]}"
  local packages=""

  # Získání lokálních balíčků přes colcon (jen pokud jsme ve workspace)
  if [ -n "$COLCON_PREFIX_PATH" ]; then
    packages=$(colcon list --base-paths "$COLCON_PREFIX_PATH/.." 2>/dev/null | awk '{print $1}')
  fi

  # Rychlé získání systémových balíčků (mnohem rychlejší než 'ros2 pkg list')
  local installed_pkgs
  if [ -d "/opt/ros/jazzy/share" ]; then
    installed_pkgs=$(ls /opt/ros/jazzy/share 2>/dev/null)
    packages="$packages $installed_pkgs"
  else
    # Fallback, pokud z nějakého důvodu složka neexistuje
    packages="$packages $(ros2 pkg list 2>/dev/null)"
  fi

  # Vytvoření nabídky pro autocompletion
  COMPREPLY=($(compgen -W "$packages" -- "$current_word"))
}

# Inicializace kompatibility, pokud náhodou používáš Zsh
if [ -n "$ZSH_VERSION" ]; then
  autoload -U +X bashcompinit && bashcompinit
fi

complete -F _roscd_complete roscd

# Directories and regular files
export LS_COLORS='di=1;38;2;233;127;74:'  # directory
LS_COLORS+='fi=1;38;2;247;227;150:'      # regular file

ZSH_HIGHLIGHT_STYLES[arg0]='fg=#607B8F,bold'

ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=#E97F4A,bold'

ZSH_HIGHLIGHT_STYLES[argument]='fg=#607B8F,bold'

ZSH_HIGHLIGHT_STYLES[builtin]='fg=#607B8F,bold'

ZSH_HIGHLIGHT_STYLES[sudo]='fg=#607B8F,bold'

function y() {
  local tmp="$(mktemp -t yazi-cwd.XXXXXX)" cwd
  yazi "$@" --cwd-file="$tmp"
  IFS= read -r -d '' cwd < "$tmp"
  [ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && cd -- "$cwd"
  rm -f -- "$tmp"
}

alias sz="source ~/.zshrc"
alias sm="bash ~/.local/bin/foot-theme-switch.sh"
alias e="exit"
alias z="nvim ~/.zshrc"
alias t="bash /home/vaclav/git/Edge-Teams-Container/run.sh"

alias cb="colcon build"

alias s="nvim ~/.config/sway/config"
alias s4="cd ~/git/ss-26-internal/internal/04_uav_system_start/"
alias s5="cd ~/git/ss-26-internal/internal/05_mrim_task/"

# Created by `pipx` on 2026-04-17 12:42:11
export PATH="$PATH:/home/vaclav/.local/bin"

# ROS 2 my workspace

source /home/vaclav/ros2_ws/install/setup.zsh

export ROS_WORKSPACE=/home/vaclav/ros2_ws/
export ACADOS_SOURCE_DIR=~/git/acados
export ACADOS_PYTHON_BIN=~/.venv/acados

roscd() {
  # Bezpečnější kontrola s uvozovkami
  if [ -n "$COLCON_PREFIX_PATH" ]; then
    if [ -z "$1" ]; then
      cd "$COLCON_PREFIX_PATH/../src" || return 1
      return 0
    fi
    # Nejprve zkusit najít balíček v aktuálním workspace
    local package_path
    package_path=$(
      colcon list --base-paths "$COLCON_PREFIX_PATH/.." 2>/dev/null | \
      grep -E "^$1\s" | awk '{print $2}'
    )
    if [ -n "$package_path" ]; then
      cd "$package_path" || return 1
      return 0
    fi
  fi

  if [ -z "$1" ]; then
    cd /opt/ros/jazzy/share || return 1
    return 0
  fi

  # Poté zkusit najít balíček mezi nainstalovanými
  local package_path
  package_path=$(ros2 pkg prefix --share "$1" 2> /dev/null)
  if [ -n "$package_path" ]; then
    cd "$package_path" || return 1
    return 0
  fi

  # Pokud nic nevyjde, skoč do workspace src (pokud existuje)
  if [ -n "$COLCON_PREFIX_PATH" ]; then
    cd "$COLCON_PREFIX_PATH/../src" || return 1
  fi
}

_roscd_complete() {
  local current_word="${COMP_WORDS[COMP_CWORD]}"
  local packages=""

  # Získání lokálních balíčků přes colcon (jen pokud jsme ve workspace)
  if [ -n "$COLCON_PREFIX_PATH" ]; then
    packages=$(colcon list --base-paths "$COLCON_PREFIX_PATH/.." 2>/dev/null | awk '{print $1}')
  fi

  # Rychlé získání systémových balíčků (mnohem rychlejší než 'ros2 pkg list')
  local installed_pkgs
  if [ -d "/opt/ros/jazzy/share" ]; then
    installed_pkgs=$(ls /opt/ros/jazzy/share 2>/dev/null)
    packages="$packages $installed_pkgs"
  else
    # Fallback, pokud z nějakého důvodu složka neexistuje
    packages="$packages $(ros2 pkg list 2>/dev/null)"
  fi

  # Vytvoření nabídky pro autocompletion
  COMPREPLY=($(compgen -W "$packages" -- "$current_word"))
}

# Inicializace kompatibility, pokud náhodou používáš Zsh
if [ -n "$ZSH_VERSION" ]; then
  autoload -U +X bashcompinit && bashcompinit
fi

complete -F _roscd_complete roscd

# Automatické spuštění yazi ze Sway zkratky
if [[ "$AUTO_YAZI" == "1" ]]; then
    unset AUTO_YAZI
    y
fi

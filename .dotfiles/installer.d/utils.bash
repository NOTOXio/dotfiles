log_info() {
  echo -e "[\e[32mINFO\e[0m] $*"
}

log_warn() {
  echo -e "[\e[33mWARN\e[0m] $*"
}

log_error() {
  echo -e "[\e[31mERROR\e[0m] $*"
}

pacman_install() {
  (($# == 0)) && return 0

  local -a options=(
    -S
    --needed
    --noconfirm
  )

  log_info "Installing: $*"
  sudo pacman "${options[@]}" "$@" 2>&1 | grep -v "is up to date -- skipping"
}

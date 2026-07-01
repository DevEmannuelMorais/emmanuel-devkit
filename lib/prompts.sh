confirm() {
  local message="$1"
  local answer

  read -r -p "$message [S/N]: " answer

  case "$answer" in
    s|S|sim|SIM|Sim)
      return 0
      ;;
    *)
      return 1
      ;;
  esac
}
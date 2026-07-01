# ============================================================
# Migrations - Emmanuel DevKit
# ============================================================

edevGetRcFile() {
  if [[ -n "$EDEV_RC_FILE" ]]; then
    echo "$EDEV_RC_FILE"
    return 0
  fi

  if [[ "$SHELL" == *"zsh"* ]]; then
    echo "$HOME/.zshrc"
    return 0
  fi

  echo "$HOME/.bashrc"
}

edevEnsureFile() {
  local filePath="$1"

  if [[ ! -f "$filePath" ]]; then
    touch "$filePath"
  fi
}

edevEnsureDevkitBlock() {
  local rcFile="$1"
  local startMark="# >>> Emmanuel DevKit >>>"
  local endMark="# <<< Emmanuel DevKit <<<"

  edevEnsureFile "$rcFile"

  if grep -q "$startMark" "$rcFile"; then
    return 0
  fi

  log "Criando bloco do Emmanuel DevKit em: $rcFile"

  {
    echo ""
    echo "$startMark"
    echo "export EDEV_HOME=\"$EDEV_HOME\""
    echo "export PATH=\"\$EDEV_HOME/bin:\$PATH\""
    echo "$endMark"
  } >> "$rcFile"

  ok "Bloco do Emmanuel DevKit criado."
}

edevEnsureShellIntegration() {
  local rcFile="$1"
  local sourceLine='[[ -f "$EDEV_HOME/shell/edev.zsh" ]] && source "$EDEV_HOME/shell/edev.zsh"'
  local endMark="# <<< Emmanuel DevKit <<<"

  edevEnsureDevkitBlock "$rcFile"

  if grep -q 'shell/edev.zsh' "$rcFile"; then
    ok "Integração shell já configurada."
    return 0
  fi

  log "Adicionando integração shell do Emmanuel DevKit..."

  if grep -q "$endMark" "$rcFile"; then
    sed -i "/$endMark/i $sourceLine" "$rcFile"
  else
    echo "$sourceLine" >> "$rcFile"
  fi

  ok "Integração shell adicionada em: $rcFile"
}

edevWarnOldDevCli() {
  local rcFile="$1"

  if grep -q '\$HOME/cli/.dev-cli.zsh' "$rcFile" 2>/dev/null || grep -q "$HOME/cli/.dev-cli.zsh" "$rcFile" 2>/dev/null; then
    warn "Foi encontrado o Dev CLI antigo no seu arquivo de shell."
    warn "Recomendado comentar/remover manualmente depois de validar o Emmanuel DevKit:"
    echo '  [[ -f "$HOME/cli/.dev-cli.zsh" ]] && source "$HOME/cli/.dev-cli.zsh"'
  fi
}

edevMigrate() {
  local rcFile

  rcFile="$(edevGetRcFile)"

  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "🔄 Emmanuel DevKit Migrations"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

  edevEnsureShellIntegration "$rcFile"
  edevWarnOldDevCli "$rcFile"

  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  ok "Migrations executadas com sucesso."
  warn "Para aplicar no terminal atual, rode:"
  echo "source $rcFile"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""
}
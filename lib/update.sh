# ============================================================
# Update - Emmanuel DevKit
# ============================================================

edevVersion() {
  local versionFile="$EDEV_HOME/VERSION"

  if [[ -f "$versionFile" ]]; then
    echo "Emmanuel DevKit $(cat "$versionFile")"
    return 0
  fi

  echo "Emmanuel DevKit versao nao informada"
}

edevUpdate() {
  if [[ -z "$EDEV_HOME" ]]; then
    fail "EDEV_HOME nao definido."
    return 1
  fi

  if [[ ! -d "$EDEV_HOME" ]]; then
    fail "Diretorio do DevKit nao encontrado: $EDEV_HOME"
    return 1
  fi

  if [[ ! -d "$EDEV_HOME/.git" ]]; then
    fail "Este DevKit nao parece ter sido instalado via git clone."
    warn "Para atualizar automaticamente, instale clonando o repositorio."
    return 1
  fi

  log "Verificando atualizacoes do Emmanuel DevKit..."
  cd "$EDEV_HOME" || return 1

  local currentBranch
  currentBranch="$(git branch --show-current)"

  if [[ -z "$currentBranch" ]]; then
    fail "Nao foi possivel identificar a branch atual."
    return 1
  fi

  local changedFiles
  changedFiles="$(git status --porcelain)"

  if [[ -n "$changedFiles" && "$EDEV_FORCE_UPDATE" != "true" ]]; then
    warn "Existem alteracoes locais no DevKit."
    echo ""
    git status --short
    echo ""
    fail "Atualizacao cancelada para evitar sobrescrever alteracoes."
    warn "Se quiser forcar, use: EDEV_FORCE_UPDATE=true edev update"
    return 1
  fi

  if [[ "$EDEV_FORCE_UPDATE" == "true" ]]; then
    warn "Forcando limpeza de alteracoes locais..."
    git reset --hard
    git clean -fd
  fi

  log "Buscando atualizacoes..."
  git fetch origin "$currentBranch"

  log "Atualizando branch $currentBranch..."
  git pull --ff-only origin "$currentBranch"

  chmod +x "$EDEV_HOME/bin/edev" 2>/dev/null || true
  chmod +x "$EDEV_HOME/install.sh" 2>/dev/null || true
  chmod +x "$EDEV_HOME/uninstall.sh" 2>/dev/null || true

  ok "Emmanuel DevKit atualizado com sucesso."
  edevVersion

  warn "Se novos comandos nao aparecerem, recarregue o terminal:"
  echo "source ~/.zshrc"
  echo "ou"
  echo "source ~/.bashrc"
}

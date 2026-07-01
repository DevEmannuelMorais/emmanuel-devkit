setupBase() {
  log "Atualizando pacotes..."
  sudo apt update

  log "Instalando pacotes base..."
  sudo apt install -y \
    git \
    curl \
    wget \
    unzip \
    zip \
    vim \
    nano \
    build-essential \
    ca-certificates \
    lsof \
    jq \
    tree

  mkdir -p "$EDEV_WORKSPACE"
  mkdir -p "$EDEV_PROJECTS_DIR"
  mkdir -p "$EDEV_APPS_DIR"

  ok "Ambiente base configurado."
}
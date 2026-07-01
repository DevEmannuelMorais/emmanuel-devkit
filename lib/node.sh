setupNode() {
  setupBase

  if hasCommand nvm; then
    ok "nvm já instalado."
  else
    if confirm "Deseja instalar NVM?"; then
      curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
      ok "NVM instalado. Reabra o terminal ou rode source ~/.bashrc/source ~/.zshrc."
    fi
  fi

  if confirm "Deseja instalar Node LTS?"; then
    export NVM_DIR="$HOME/.nvm"

    if [[ -s "$NVM_DIR/nvm.sh" ]]; then
      source "$NVM_DIR/nvm.sh"
      nvm install --lts
      nvm use --lts
    else
      warn "NVM ainda não está carregado nesta sessão."
    fi
  fi
}
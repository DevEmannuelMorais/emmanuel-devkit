installMise() {
  if hasCommand mise; then
    ok "mise já instalado."
    return 0
  fi

  if confirm "Deseja instalar o mise para gerenciar Java e outras ferramentas?"; then
    curl https://mise.run | sh

    if [[ -f "$HOME/.local/bin/mise" ]]; then
      eval "$("$HOME/.local/bin/mise" activate bash)"
    fi

    ok "mise instalado."
  else
    warn "mise não instalado."
  fi
}

setupJavaLegacy() {
  setupBase
  installMise

  if hasCommand mise; then
    if confirm "Deseja instalar Java 8?"; then
      mise install java@temurin-8
    fi

    if confirm "Deseja instalar Java 11?"; then
      mise install java@temurin-11
      mise use -g java@temurin-11
    fi
  fi

  if confirm "Deseja instalar Maven?"; then
    sudo apt install -y maven
  fi

  if confirm "Deseja instalar Apache Ant?"; then
    sudo apt install -y ant
  fi

  warn "Java 6 não será baixado automaticamente por segurança/licença."
  warn "Coloque manualmente o JDK 6 em: $EDEV_JAVA6_HOME"

  ok "Ambiente Java legado configurado."
}

setupJavaModern() {
  setupBase
  installMise

  if hasCommand mise; then
    if confirm "Deseja instalar Java 17?"; then
      mise install java@temurin-17
    fi

    if confirm "Deseja instalar Java 21?"; then
      mise install java@temurin-21
      mise use -g java@temurin-21
    fi
  fi

  if confirm "Deseja instalar Maven?"; then
    sudo apt install -y maven
  fi

  if confirm "Deseja instalar Gradle?"; then
    sudo apt install -y gradle
  fi

  ok "Ambiente Java moderno configurado."
}

javaInfo() {
  echo ""
  echo "JAVA_HOME: ${JAVA_HOME:-N/A}"
  java -version 2>&1 || true
  echo ""
  mise current java 2>/dev/null || true
}

javaInstall() {
  if [[ -z "$1" ]]; then
    fail "Informe a versão. Exemplo: edev java install temurin-17"
    return 1
  fi

  requireCommand mise || return 1
  mise install "java@$1"
}

javaUse() {
  if [[ -z "$1" ]]; then
    fail "Informe a versão. Exemplo: edev java use temurin-17"
    return 1
  fi

  requireCommand mise || return 1
  mise use -g "java@$1"
  java -version
}
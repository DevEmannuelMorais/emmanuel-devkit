# ============================================================
# Java - Emmanuel DevKit
# ============================================================

installMise() {
  if hasCommand mise; then
    ok "mise já instalado."
    return 0
  fi

  if confirm "Deseja instalar o mise para gerenciar Java e outras ferramentas?"; then
    curl https://mise.run | sh
    export PATH="$HOME/.local/bin:$PATH"

    if [[ -x "$HOME/.local/bin/mise" ]]; then
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
  warn "Caso precise, coloque o JDK 6 em: $EDEV_JAVA6_HOME"

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

javaHelp() {
  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "☕ Emmanuel DevKit - Java"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "Comandos oficiais:"
  echo "  edev java info                     Mostra Java ativo, Javac, JAVA_HOME e mise"
  echo "  edev java list                     Lista versões Java instaladas pelo mise"
  echo "  edev java remote                   Lista versões Java disponíveis no mise"
  echo "  edev java install <versao>         Instala uma versão. Ex: temurin-11"
  echo "  edev java use-global <versao>      Define Java global. Ex: temurin-17"
  echo "  edev java use-local <versao>       Define Java local no projeto atual"
  echo "  edev java use <versao>             Alias para use-global"
  echo "  edev java where                    Mostra caminho do Java ativo no mise"
  echo "  edev java which                    Mostra binário java ativo no mise"
  echo "  edev java 6                        Seleciona Java 6 global pelo mise"
  echo "  edev java 8                        Seleciona Java 8 global"
  echo "  edev java 11                       Seleciona Java 11 global"
  echo "  edev java 17                       Seleciona Java 17 global"
  echo "  edev java 21                       Seleciona Java 21 global"
  echo ""
  echo "Atalhos no terminal:"
  echo "  javaInfo"
  echo "  javaList"
  echo "  javaRemote"
  echo "  javaInstall temurin-11"
  echo "  javaUseGlobal temurin-17"
  echo "  javaUseLocal temurin-11"
  echo "  javaWhere"
  echo "  javaWhich"
  echo "  java6"
  echo "  java8"
  echo "  java11"
  echo "  java17"
  echo "  java21"
  echo ""
  echo "Java 6:"
  echo "  O DevKit não baixa Java 6 automaticamente."
  echo "  Para usar, registre manualmente no mise como: java@jdk6"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""
}

javaRemovePathEntry() {
  local removePath="$1"
  local currentPath

  if [[ -z "$removePath" ]]; then
    return 0
  fi

  currentPath=":$PATH:"
  currentPath="${currentPath//:$removePath:/:}"
  currentPath="${currentPath#:}"
  currentPath="${currentPath%:}"

  export PATH="$currentPath"
}

javaClearManualPath() {
  if [[ -n "$JAVA_HOME" ]]; then
    javaRemovePathEntry "$JAVA_HOME/bin"
  fi

  if [[ -n "$EDEV_JAVA6_HOME" ]]; then
    javaRemovePathEntry "$EDEV_JAVA6_HOME/bin"
  fi

  javaRemovePathEntry "$HOME/apps/jdks/jdk6/bin"

  unset JAVA_HOME
  hash -r 2>/dev/null || true
}

javaInfoHome() {
  local javaHome="$1"
  local label="$2"

  if [[ ! -x "$javaHome/bin/java" ]]; then
    fail "$label não encontrado em: $javaHome"
    return 1
  fi

  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "☕ $label"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "JAVA_HOME: $javaHome"
  echo ""

  echo "Java:"
  "$javaHome/bin/java" -version 2>&1 || true
  echo ""

  echo "Javac:"
  "$javaHome/bin/javac" -version 2>&1 || true
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""
}

javaInfo() {
  case "$1" in
    6|java6|jdk6)
      javaInfoHome "$EDEV_JAVA6_HOME" "Java 6"
      return $?
      ;;

    ""|current)
      ;;

    *)
      fail "Versão inválida para info: $1"
      echo "Use: edev java info ou edev java info 6"
      return 1
      ;;
  esac

  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "☕ Java Environment"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "Java:"
  java -version 2>&1 || echo "Java N/A"
  echo ""

  echo "Javac:"
  javac -version 2>&1 || echo "Javac N/A"
  echo ""

  echo "JAVA_HOME: ${JAVA_HOME:-N/A}"
  echo ""

  echo "Maven:"
  mvn -version 2>/dev/null | head -n 4 || echo "Maven N/A"
  echo ""

  echo "Mise Java:"
  mise current java 2>/dev/null || echo "Java não configurado no mise"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""
}

javaList() {
  requireCommand mise || return 1

  log "Listando versões Java instaladas pelo mise..."
  mise ls java
}

javaRemote() {
  requireCommand mise || return 1

  log "Listando versões Java disponíveis no mise..."
  mise ls-remote java
}

javaInstall() {
  if [[ -z "$1" ]]; then
    fail "Informe a versão. Exemplo: edev java install temurin-11"
    echo "Outros exemplos:"
    echo "  edev java install temurin-8"
    echo "  edev java install temurin-11"
    echo "  edev java install temurin-17"
    echo "  edev java install temurin-21"
    return 1
  fi

  requireCommand mise || return 1

  log "Instalando Java $1..."
  mise install "java@$1"
  ok "Java $1 instalado."
}

javaUseGlobal() {
  local version="$1"

  if [[ -z "$version" ]]; then
    fail "Informe a versão. Exemplo: edev java use-global temurin-17"
    return 1
  fi

  if [[ "$version" == "default" ]]; then
    version="$EDEV_JAVA_DEFAULT"
  fi

  requireCommand mise || return 1

  javaClearManualPath

  log "Selecionando Java global: $version"
  mise use -g "java@$version"

  hash -r 2>/dev/null || true

  ok "Java global ativo:"
  java -version
}

javaUseLocal() {
  local version="$1"

  if [[ -z "$version" ]]; then
    fail "Informe a versão. Exemplo: edev java use-local temurin-11"
    return 1
  fi

  requireCommand mise || return 1

  javaClearManualPath

  log "Selecionando Java local do projeto: $version"
  mise use "java@$version"

  hash -r 2>/dev/null || true

  ok "Java local configurado no projeto."
  java -version
}

javaWhere() {
  requireCommand mise || return 1

  log "Mostrando caminho da instalação Java ativa..."
  mise where java
}

javaWhich() {
  requireCommand mise || return 1

  log "Mostrando binário java ativo..."
  mise which java
}

javaUse6() {
  javaUseGlobal "jdk6"
}

javaUse8() {
  javaUseGlobal "temurin-8"
}

javaUse11() {
  javaUseGlobal "temurin-11"
}

javaUse17() {
  javaUseGlobal "temurin-17"
}

javaUse21() {
  javaUseGlobal "temurin-21"
}
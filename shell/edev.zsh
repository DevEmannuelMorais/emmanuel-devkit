# ============================================================
# Emmanuel DevKit - Shell Integration
# ============================================================

# Evita carregar duas vezes no mesmo terminal
if [[ -n "$EDEV_SHELL_LOADED" ]]; then
  return 0
fi

EDEV_SHELL_LOADED="true"

# ============================================================
# Config
# ============================================================

if [[ -z "$EDEV_HOME" ]]; then
  EDEV_HOME="$(cd "$(dirname "${(%):-%x}")/.." && pwd)"
fi

: "${EDEV_CONFIG_DIR:=$HOME/.config/edev}"
: "${EDEV_CONFIG_FILE:=$EDEV_CONFIG_DIR/config}"

if [[ -f "$EDEV_CONFIG_FILE" ]]; then
  source "$EDEV_CONFIG_FILE"
fi

: "${EDEV_SHOW_BANNER:=true}"
: "${EDEV_SHOW_TIPS:=true}"
: "${EDEV_WORKSPACE:=$HOME/dev}"
: "${EDEV_PROJECTS_DIR:=$EDEV_WORKSPACE/projects}"
: "${EDEV_STUDIES_DIR:=$EDEV_WORKSPACE/studies}"
: "${EDEV_APPS_DIR:=$HOME/apps}"
: "${EDEV_JDKS_HOME:=$EDEV_APPS_DIR/jdks}"
: "${EDEV_JAVA6_HOME:=$EDEV_JDKS_HOME/jdk6}"

# ============================================================
# Visual
# ============================================================

edevGetOsName() {
  if [[ -r /etc/os-release ]]; then
    local prettyName
    prettyName="$(grep '^PRETTY_NAME=' /etc/os-release | cut -d= -f2- | tr -d '"')"

    if [[ -n "$prettyName" ]]; then
      echo "$prettyName"
      return 0
    fi
  fi

  uname -s 2>/dev/null || echo "N/A"
}

edevGetRuntimeName() {
  if [[ -n "$WSL_DISTRO_NAME" ]]; then
    echo "WSL"
    return 0
  fi

  if grep -qi "microsoft" /proc/version 2>/dev/null; then
    echo "WSL"
    return 0
  fi

  uname -s 2>/dev/null || echo "N/A"
}

edevGetShellName() {
  basename "${SHELL:-zsh}"
}

edevGetNodeVersion() {
  node -v 2>/dev/null || echo "N/A"
}

edevGetJavaVersion() {
  local javaVersion

  javaVersion="$(java -version 2>&1 | awk -F '"' '/version/ {print $2; exit}')"

  if [[ -z "$javaVersion" ]]; then
    echo "N/A"
    return 0
  fi

  echo "$javaVersion"
}

edevGetPythonVersion() {
  if command -v python3 >/dev/null 2>&1; then
    python3 --version 2>/dev/null | cut -d' ' -f2
    return 0
  fi

  if command -v python >/dev/null 2>&1; then
    python --version 2>/dev/null | cut -d' ' -f2
    return 0
  fi

  echo "N/A"
}

edevGetGitBranch() {
  if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    git branch --show-current 2>/dev/null
    return 0
  fi

  echo "N/A"
}

edevBanner() {
  local userName
  local hostName
  local osName
  local runtimeName
  local shellName
  local nodeVersion
  local javaVersion
  local pythonVersion
  local gitBranch

  userName="${USER:-$(whoami 2>/dev/null || echo "N/A")}"
  hostName="$(hostname -s 2>/dev/null || hostname 2>/dev/null || echo "N/A")"
  osName="$(edevGetOsName)"
  runtimeName="$(edevGetRuntimeName)"
  shellName="$(edevGetShellName)"
  nodeVersion="$(edevGetNodeVersion)"
  javaVersion="$(edevGetJavaVersion)"
  pythonVersion="$(edevGetPythonVersion)"
  gitBranch="$(edevGetGitBranch)"

  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "🚀 Emmanuel DevKit"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "Usuário    $userName@$hostName"
  echo "Sistema    $osName"
  echo "Ambiente   $runtimeName"
  echo "Shell      $shellName"
  echo "Node       $nodeVersion"
  echo "Java       $javaVersion"
  echo "Python     $pythonVersion"
  echo "Git        $gitBranch"
  echo ""
  echo "Workspace  $EDEV_WORKSPACE"
  echo "Help       eh | edev help"
  echo "Atalhos    ea | atalhos"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""
}

edevCompactInfo() {
  local osName
  local runtimeName
  local nodeVersion
  local javaVersion
  local pythonVersion

  osName="$(edevGetOsName)"
  runtimeName="$(edevGetRuntimeName)"
  nodeVersion="$(edevGetNodeVersion)"
  javaVersion="$(edevGetJavaVersion)"
  pythonVersion="$(edevGetPythonVersion)"

  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "🚀 Emmanuel DevKit - Ambiente"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "Sistema    $osName"
  echo "Ambiente   $runtimeName"
  echo "Node       $nodeVersion"
  echo "Java       $javaVersion"
  echo "Python     $pythonVersion"
  echo ""
  echo "Workspace  $EDEV_WORKSPACE"
  echo "Projetos   $EDEV_PROJECTS_DIR"
  echo "Estudos    $EDEV_STUDIES_DIR"
  echo ""
  echo "Help       edev help"
  echo "Atalhos    ea"
  echo "Doctor     edev doctor"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""
}

# ============================================================
# Atalhos principais
# ============================================================

alias e='edev'
alias eh='edev help'
alias ev='edev version'
alias eu='edev update'
alias edoc='edev doctor'
alias ea='edevAliases'
alias atalhos='edevAliases'

# ============================================================
# Setup
# ============================================================

alias esu='edev setup'
alias esbase='edev setup base'
alias esnode='edev setup node'
alias eslegacy='edev setup java-legacy'
alias esmodern='edev setup java-modern'
alias esservers='edev setup servers'
alias esall='edev setup all'

# ============================================================
# Java
# ============================================================

unalias javaInfo 2>/dev/null || true
unalias javaList 2>/dev/null || true
unalias javaRemote 2>/dev/null || true
unalias javaInstall 2>/dev/null || true
unalias javaUseGlobal 2>/dev/null || true
unalias javaUseLocal 2>/dev/null || true
unalias javaWhere 2>/dev/null || true
unalias javaWhich 2>/dev/null || true
unalias java6 2>/dev/null || true
unalias java8 2>/dev/null || true
unalias java11 2>/dev/null || true
unalias java17 2>/dev/null || true
unalias java21 2>/dev/null || true

edevRemovePathEntry() {
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

edevClearManualJavaPath() {
  if [[ -n "$JAVA_HOME" ]]; then
    edevRemovePathEntry "$JAVA_HOME/bin"
  fi

  if [[ -n "$EDEV_JAVA6_HOME" ]]; then
    edevRemovePathEntry "$EDEV_JAVA6_HOME/bin"
  fi

  edevRemovePathEntry "$HOME/apps/jdks/jdk6/bin"

  unset JAVA_HOME
  hash -r 2>/dev/null || true
}

javaInfo() {
  edev java info "$@"
}

javaList() {
  edev java list
}

javaRemote() {
  edev java remote
}

javaInstall() {
  edev java install "$@"
}

javaUseGlobal() {
  if [[ -z "$1" ]]; then
    echo "❌ Informe a versão. Exemplo: javaUseGlobal temurin-17"
    return 1
  fi

  edevClearManualJavaPath
  edev java use-global "$1" || return 1
  hash -r 2>/dev/null || true
}

javaUseLocal() {
  if [[ -z "$1" ]]; then
    echo "❌ Informe a versão. Exemplo: javaUseLocal temurin-11"
    return 1
  fi

  edevClearManualJavaPath
  edev java use-local "$1" || return 1
  hash -r 2>/dev/null || true
}

javaWhere() {
  edev java where
}

javaWhich() {
  edev java which
}

java6() {
  local javaHome="${EDEV_JAVA6_HOME:-$HOME/apps/jdks/jdk6}"

  if [[ ! -x "$javaHome/bin/java" ]]; then
    echo "❌ Java 6 não encontrado em: $javaHome"
    echo "Coloque o JDK 6 nesse caminho ou crie um link simbólico."
    echo ""
    echo "Exemplo:"
    echo "  mkdir -p ~/apps/jdks"
    echo "  ln -sfn /caminho/do/jdk1.6.0_45 ~/apps/jdks/jdk6"
    return 1
  fi

  edevClearManualJavaPath

  export JAVA_HOME="$javaHome"
  export PATH="$JAVA_HOME/bin:$PATH"

  hash -r 2>/dev/null || true

  echo "✅ Java 6 ativo na sessão atual:"
  java -version
}

java8() {
  javaUseGlobal "temurin-8"
}

java11() {
  javaUseGlobal "temurin-11"
}

java17() {
  javaUseGlobal "temurin-17"
}

java21() {
  javaUseGlobal "temurin-21"
}

# ============================================================
# Servidores
# ============================================================

alias es='edev server'

alias tci='edev server tomcat info'
alias tcl='edev server tomcat list'
alias tcs='edev server tomcat start'
alias tcstop='edev server tomcat stop'
alias tcr='edev server tomcat restart'
alias tcst='edev server tomcat status'
alias tclog='edev server tomcat log'
alias tclog80='edev server tomcat log80'
alias tcd='edev server tomcat deploy'
alias tcclean='edev server tomcat clean-deploy'
alias tckill='edev server tomcat kill'

alias tomcatStart='edev server tomcat start'
alias tomcatStop='edev server tomcat stop'
alias tomcatRestart='edev server tomcat restart'
alias tomcatLog='edev server tomcat log'
alias tomcatLog80='edev server tomcat log80'
alias tomcatDeploy='edev server tomcat deploy'
alias tomcatKill='edev server tomcat kill'

alias jbi='edev server jboss info'
alias jbl='edev server jboss list'
alias jbs='edev server jboss start'
alias jbbg='edev server jboss start-bg'
alias jbbg81='edev server jboss start-bg-8081'
alias jbbg82='edev server jboss start-bg-8082'
alias jbstop='edev server jboss stop'
alias jbr='edev server jboss restart'
alias jbst='edev server jboss status'
alias jblog='edev server jboss log'
alias jblog80='edev server jboss log80'
alias jbd='edev server jboss deploy'
alias jbdep='edev server jboss deployments'
alias jbclean='edev server jboss clean-deploy'
alias jbds='edev server jboss test-ds'
alias jbkill='edev server jboss kill'

alias jbossStart='edev server jboss start'
alias jbossStop='edev server jboss stop'
alias jbossRestart='edev server jboss restart'
alias jbossLog='edev server jboss log'
alias jbossLog80='edev server jboss log80'
alias jbossDeploy='edev server jboss deploy'
alias jbossDeployments='edev server jboss deployments'
alias jbossTestDs='edev server jboss test-ds'
alias jbossKill='edev server jboss kill'

# ============================================================
# Pastas
# ============================================================

unalias dev 2>/dev/null || true
unalias projects 2>/dev/null || true
unalias studies 2>/dev/null || true

dev() {
  cd "$EDEV_WORKSPACE" || return 1
}

projects() {
  cd "$EDEV_PROJECTS_DIR" || return 1
}

studies() {
  cd "$EDEV_STUDIES_DIR" || return 1
}

# ============================================================
# Git / Docker
# ============================================================

alias gs='git status'
alias ga='git add'
alias gc='git commit -m'
alias gp='git push'
alias gpl='git pull'
alias gl='git log --oneline --graph --decorate --all -n 30'
alias gb='git branch -a'

alias dc='docker compose'
alias dcu='docker compose up -d'
alias dcd='docker compose down'
alias dcl='docker compose logs -f --tail=100'
alias dps='docker ps'

# ============================================================
# Ajuda
# ============================================================

devinfo() {
  edevCompactInfo
}

edevAliases() {
  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "⚡ Emmanuel DevKit - Atalhos"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "Geral:"
  echo "  e        → edev"
  echo "  eh       → edev help"
  echo "  ev       → edev version"
  echo "  eu       → edev update"
  echo "  edoc     → edev doctor"
  echo "  ea       → mostra estes atalhos"
  echo ""
  echo "Java:"
  echo "  javaInfo"
  echo "  javaList"
  echo "  javaRemote"
  echo "  javaInstall temurin-11"
  echo "  javaUseGlobal temurin-17"
  echo "  javaUseLocal temurin-11"
  echo "  javaWhere"
  echo "  javaWhich"
  echo "  java6"
  echo "  java8 | java11 | java17 | java21"
  echo ""
  echo "Tomcat:"
  echo "  tci      → info"
  echo "  tcs      → start"
  echo "  tcstop   → stop"
  echo "  tclog    → log"
  echo "  tcd      → deploy"
  echo ""
  echo "JBoss/WildFly:"
  echo "  jbi      → info"
  echo "  jbs      → start"
  echo "  jbbg     → start background"
  echo "  jbstop   → stop"
  echo "  jblog    → log"
  echo "  jbd      → deploy"
  echo "  jbds     → testar datasource"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""
}

# ============================================================
# Banner
# ============================================================

if [[ -o interactive && "$EDEV_SHOW_BANNER" == "true" && -z "$EDEV_BANNER_SHOWN" ]]; then
  EDEV_BANNER_SHOWN="true"
  edevBanner
fi

# ============================================================
# Emmanuel DevKit - Shell Integration
# ============================================================

# Evita carregar duas vezes no mesmo terminal
if [[ -n "$EDEV_SHELL_LOADED" ]]; then
  return 0
fi

: "${EDEV_CONFIG_DIR:=$HOME/.config/edev}"
: "${EDEV_CONFIG_FILE:=$EDEV_CONFIG_DIR/config}"

if [[ -f "$EDEV_CONFIG_FILE" ]]; then
  source "$EDEV_CONFIG_FILE"
fi

export EDEV_SHELL_LOADED="true"

# ============================================================
# Configuracoes
# ============================================================

: "${EDEV_SHOW_BANNER:=true}"
: "${EDEV_SHOW_TIPS:=true}"
: "${EDEV_WORKSPACE:=$HOME/dev}"
: "${EDEV_PROJECTS_DIR:=$EDEV_WORKSPACE/projects}"
: "${EDEV_STUDIES_DIR:=$EDEV_WORKSPACE/studies}"

# ============================================================
# Visual
# ============================================================

edevBanner() {
  local nodeVersion
  local javaVersion
  local gitBranch
  local currentDir

  nodeVersion="$(node -v 2>/dev/null || echo "N/A")"
  javaVersion="$(java -version 2>&1 | sed -n 's/.*version "\(.*\)".*/\1/p' | head -n1)"
  currentDir="$(pwd)"

  [[ -z "$javaVersion" ]] && javaVersion="N/A"

  if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    gitBranch="$(git branch --show-current 2>/dev/null)"
  else
    gitBranch="N/A"
  fi

  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "🚀 Emmanuel DevKit"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "📁 Dir:    $currentDir"
  echo "🌿 Git:    $gitBranch"
  echo "🟢 Node:   $nodeVersion"
  echo "☕ Java:   $javaVersion"
  echo "🧰 Help:   eh"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

  if [[ "$EDEV_SHOW_TIPS" == "true" ]]; then
    echo "Dicas: e doctor | es jboss info | es tomcat info | eu"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  fi

  echo ""
}

edevCompactInfo() {
  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "🚀 Emmanuel DevKit"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "Workspace: $EDEV_WORKSPACE"
  echo "Projetos:  $EDEV_PROJECTS_DIR"
  echo "Estudos:   $EDEV_STUDIES_DIR"
  echo "🧰 Help:    eh | edev help"
  echo "⚡ Atalhos: atalhos"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""
}

# ============================================================
# Atalhos principais do edev
# ============================================================

alias e='edev'
alias eh='edev help'
alias ev='edev version'
alias eu='edev update'
alias edoc='edev doctor'

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

alias javaInfo='edev java info'
alias javaList='edev java list'
alias javaRemote='edev java remote'
alias javaInstall='edev java install'
alias javaUseGlobal='edev java use-global'
alias javaUseLocal='edev java use-local'
alias javaWhere='edev java where'
alias javaWhich='edev java which'

alias java8='edev java 8'
alias java11='edev java 11'
alias java17='edev java 17'
alias java21='edev java 21'

# Compatibilidade com seu CLI antigo
alias javaInfo='edev java info'
alias java8='edev java use temurin-8'
alias java11='edev java use temurin-11'
alias java17='edev java use temurin-17'
alias java21='edev java use temurin-21'

# ============================================================
# Servidores - atalhos gerais
# ============================================================

alias es='edev server'

# ============================================================
# Tomcat
# ============================================================

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

# Compatibilidade com nomes antigos
alias tomcatStart='edev server tomcat start'
alias tomcatStop='edev server tomcat stop'
alias tomcatRestart='edev server tomcat restart'
alias tomcatLog='edev server tomcat log'
alias tomcatLog80='edev server tomcat log80'
alias tomcatDeploy='edev server tomcat deploy'
alias tomcatKill='edev server tomcat kill'

# ============================================================
# WildFly / JBoss
# ============================================================

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

# Compatibilidade com nomes antigos
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
# Git prático
# ============================================================

alias gs='git status'
alias ga='git add'
alias gc='git commit -m'
alias gp='git push'
alias gpl='git pull'
alias gl='git log --oneline --graph --decorate --all -n 30'
alias gb='git branch -a'

# ============================================================
# Docker prático
# ============================================================

alias dc='docker compose'
alias dcu='docker compose up -d'
alias dcd='docker compose down'
alias dcl='docker compose logs -f --tail=100'
alias dps='docker ps'

# ============================================================
# Funcoes auxiliares
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
  echo ""
  echo "Setup:"
  echo "  esbase   → edev setup base"
  echo "  eslegacy → edev setup java-legacy"
  echo "  esmodern → edev setup java-modern"
  echo "  esall    → edev setup all"
  echo ""
  echo "Java:"
  echo "  eji      → edev java info"
  echo "  ej11     → edev java use temurin-11"
  echo "  ej17     → edev java use temurin-17"
  echo "  ej21     → edev java use temurin-21"
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

alias atalhos='edevAliases'

# ============================================================
# Banner ao abrir terminal
# ============================================================

if [[ -o interactive && "$EDEV_SHOW_BANNER" == "true" && -z "$EDEV_BANNER_SHOWN" ]]; then
  export EDEV_BANNER_SHOWN="true"
  edevBanner
fi
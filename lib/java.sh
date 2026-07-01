# ============================================================
# Dev CLI - Emmanuel
# ============================================================

log() {
  echo "➡️  $1"
}

ok() {
  echo "✅ $1"
}

warn() {
  echo "⚠️  $1"
}

fail() {
  echo "❌ $1"
}

devhelp() {
  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "🚀 Dev CLI - Emmanuel"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "devinfo          Mostra informações do ambiente"
  echo ""
  echo "Pastas:"
  echo "  dev            Vai para ~/dev"
  echo "  projects       Vai para ~/dev/projects"
  echo "  studies        Vai para ~/dev/studies"
  echo ""
  echo "Git:"
  echo "  gs             Git status"
  echo "  ga .           Git add"
  echo "  gc 'msg'       Git commit"
  echo "  gp             Git push"
  echo "  gl             Git log visual"
  echo ""
  echo "Docker:"
  echo "  dc             Docker Compose"
  echo "  dcu            Sobe containers em background"
  echo "  dcd            Para/remove containers do projeto"
  echo "  dcl            Mostra logs do Compose"
  echo "  dps            Lista containers ativos"
  echo ""
  echo "Node:"
  echo "  node22         Seleciona Node 22"
  echo "  node24         Seleciona Node 24"
  echo "  nodelts        Seleciona Node LTS"
  echo ""
  echo "Angular:"
  echo "  ngv            Mostra versão do Angular CLI"
  echo "  ngnew nome     Cria projeto Angular"
  echo "  ngserve        Roda projeto Angular atual"
  echo ""
  echo "Java:"
  echo "  javaInfo              Mostra versão ativa, JAVA_HOME e mise"
  echo "  javaList              Lista versões Java instaladas"
  echo "  javaRemote            Lista versões Java disponíveis"
  echo "  javaInstall versao    Instala uma versão. Ex: javaInstall temurin-11"
  echo "  javaUseGlobal versao  Define Java global. Ex: javaUseGlobal temurin-17"
  echo "  javaUseLocal versao   Define Java local no projeto. Ex: javaUseLocal temurin-11"
  echo "  javaWhere             Mostra caminho do Java ativo no mise"
  echo "  javaWhich             Mostra binário java ativo"
  echo "  java8                 Seleciona Java 8 global"
  echo "  java11                Seleciona Java 11 global"
  echo "  java17                Seleciona Java 17 global"
  echo "  java21                Seleciona Java 21 global"
  echo ""
  echo "Servidores:"
  echo "  serverinfo      Mostra caminhos configurados dos servidores"
  echo "  jbossStart      Inicia WildFly/JBoss"
  echo "  jbossStart8081  Inicia WildFly/JBoss na porta 8081"
  echo "  jbossStop       Para WildFly/JBoss"
  echo "  jbossRestart    Reinicia WildFly/JBoss"
  echo "  jbossLog        Acompanha log do WildFly/JBoss"
  echo "  jbossLog80      Mostra ultimas 80 linhas do log do WildFly/JBoss"
  echo "  jbossDeploy     Gera WAR e faz deploy no WildFly/JBoss"
  echo "  jbossDeployments Lista pasta de deployments do WildFly/JBoss"
  echo "  jbossTestDs     Testa DataSource ClienteDS"
  echo "  jbossKill       Mata processo do WildFly/JBoss na força"
  echo ""
  echo "  tomcatStart     Inicia Tomcat"
  echo "  tomcatStop      Para Tomcat"
  echo "  tomcatRestart   Reinicia Tomcat"
  echo "  tomcatLog       Acompanha log do Tomcat"
  echo "  tomcatLog80     Mostra ultimas 80 linhas do log do Tomcat"
  echo "  tomcatDeploy    Gera WAR e faz deploy no Tomcat"
  echo "  tomcatKill      Mata processo do Tomcat na força"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""
}

devinfo() {
  local node_version
  local java_version
  local python_version

  node_version=$(node -v 2>/dev/null || echo "N/A")
  java_version=$(java -version 2>&1 | sed -n 's/.*version "\(.*\)".*/\1/p' | head -n1)
  python_version=$(python --version 2>/dev/null | cut -d' ' -f2)

  [[ -z "$java_version" ]] && java_version="N/A"
  [[ -z "$python_version" ]] && python_version="N/A"

  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "🚀 Development Environment Ready"
  echo "👤 Emmanuel"
  echo "🐧 Ubuntu 24.04 LTS / WSL2"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "Node   $node_version"
  echo "Java   $java_version"
  echo "Python $python_version"
  echo ""
  echo "Workspace: ~/dev"
  echo "Help:      devhelp"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""
}

node22() {
  log "Selecionando Node 22..."
  nvm install 22
  nvm use 22
  ok "Node ativo: $(node -v)"
}

node24() {
  log "Selecionando Node 24..."
  nvm install 24
  nvm use 24
  ok "Node ativo: $(node -v)"
}

nodelts() {
  log "Selecionando Node LTS..."
  nvm install --lts
  nvm use --lts
  ok "Node ativo: $(node -v)"
}

ngv() {
  log "Verificando Angular CLI..."
  ng version
}

ngnew() {
  if [[ -z "$1" ]]; then
    fail "Informe o nome do projeto. Exemplo: ngnew meu-app"
    return 1
  fi

  log "Criando projeto Angular: $1"
  ng new "$1"
}

ngserve() {
  log "Iniciando Angular em http://localhost:4200"
  npm start
}

# ============================================================
# Java - mise
# ============================================================

javaInfo() {
  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "☕ Java Environment"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "Java:"
  java -version 2>&1 || echo "Java N/A"
  echo ""
  echo "JAVA_HOME: ${JAVA_HOME:-N/A}"
  echo ""
  echo "Mise Java:"
  mise current java 2>/dev/null || echo "Java não configurado no mise"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""
}

javaList() {
  log "Listando versões Java instaladas pelo mise..."
  mise ls java
}

javaRemote() {
  log "Listando versões Java disponíveis no mise..."
  mise ls-remote java
}

javaInstall() {
  if [[ -z "$1" ]]; then
    fail "Informe a versão. Exemplo: javaInstall temurin-11"
    echo "Outros exemplos:"
    echo "  javaInstall temurin-8"
    echo "  javaInstall temurin-11"
    echo "  javaInstall temurin-17"
    echo "  javaInstall temurin-21"
    return 1
  fi

  log "Instalando Java $1..."
  mise install "java@$1"
  ok "Java $1 instalado."
}

javaUseGlobal() {
  if [[ -z "$1" ]]; then
    fail "Informe a versão. Exemplo: javaUseGlobal temurin-17"
    return 1
  fi

  log "Selecionando Java global: $1"
  mise use -g "java@$1"
  ok "Java global ativo:"
  java -version
}

javaUseLocal() {
  if [[ -z "$1" ]]; then
    fail "Informe a versão. Exemplo: javaUseLocal temurin-11"
    return 1
  fi

  log "Selecionando Java local do projeto: $1"
  mise use "java@$1"
  ok "Java local configurado no projeto."
  java -version
}

javaWhere() {
  log "Mostrando caminho da instalação Java ativa..."
  mise where java
}

javaWhich() {
  log "Mostrando binário java ativo..."
  mise which java
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

java8() {
  javaUseGlobal "temurin-8"
}

java6() {
  export JAVA_HOME="$EDEV_JAVA6_HOME"
  export PATH="$JAVA_HOME/bin:$PATH"
  java -version
}

# ============================================================
# Servidores - Tomcat / WildFly JBoss
# ============================================================

DEV_APP_NAME="${DEV_APP_NAME:-cliente-legado}"
DEV_PROJECT_DIR="${DEV_PROJECT_DIR:-$HOME/dev/projects/java/cliente-legado}"
DEV_TOMCAT_HOME="${DEV_TOMCAT_HOME:-$HOME/apps/tomcats/tomcat9}"
DEV_WILDFLY_HOME="${DEV_WILDFLY_HOME:-$HOME/apps/jbosses/wildfly26}"

serverinfo() {
  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "🖥️  Servidores locais"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "App:         $DEV_APP_NAME"
  echo "Projeto:     $DEV_PROJECT_DIR"
  echo "Tomcat:      $DEV_TOMCAT_HOME"
  echo "WildFly:     $DEV_WILDFLY_HOME"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""
}

jbossStart() {
  log "Iniciando WildFly/JBoss..."
  "$DEV_WILDFLY_HOME/bin/standalone.sh"
}

jbossStart8081() {
  log "Iniciando WildFly/JBoss na porta 8081..."
  "$DEV_WILDFLY_HOME/bin/standalone.sh" -Djboss.http.port=8081
}

jbossStop() {
  log "Parando WildFly/JBoss..."
  "$DEV_WILDFLY_HOME/bin/jboss-cli.sh" --connect command=:shutdown
  ok "WildFly/JBoss parado."
}

jbossRestart() {
  warn "Reiniciando WildFly/JBoss..."
  jbossStop || true
  sleep 2
  jbossStart
}

jbossLog() {
  tail -f "$DEV_WILDFLY_HOME/standalone/log/server.log"
}

jbossLog80() {
  tail -n 80 "$DEV_WILDFLY_HOME/standalone/log/server.log"
}

jbossDeployments() {
  ls -la "$DEV_WILDFLY_HOME/standalone/deployments"
}

jbossCleanDeploy() {
  log "Removendo deploy anterior do WildFly/JBoss..."

  rm -f "$DEV_WILDFLY_HOME/standalone/deployments/$DEV_APP_NAME.war"
  rm -f "$DEV_WILDFLY_HOME/standalone/deployments/$DEV_APP_NAME.war.deployed"
  rm -f "$DEV_WILDFLY_HOME/standalone/deployments/$DEV_APP_NAME.war.failed"
  rm -f "$DEV_WILDFLY_HOME/standalone/deployments/$DEV_APP_NAME.war.isdeploying"
  rm -f "$DEV_WILDFLY_HOME/standalone/deployments/$DEV_APP_NAME.war.undeployed"

  ok "Deploy anterior removido."
}

jbossDeploy() {
  log "Gerando WAR do projeto..."
  cd "$DEV_PROJECT_DIR" || return 1

  mvn clean package

  jbossCleanDeploy

  log "Copiando WAR para WildFly/JBoss..."
  cp "$DEV_PROJECT_DIR/target/$DEV_APP_NAME.war" "$DEV_WILDFLY_HOME/standalone/deployments/"

  ok "Deploy enviado para WildFly/JBoss."
  jbossLog80
}

jbossKill() {
  warn "Finalizando processos WildFly/JBoss na força..."
  pkill -f wildfly || true
  pkill -f jboss || true
  ok "Processos finalizados."
}

jbossPort() {
  lsof -i :8080
}

jbossPort8081() {
  lsof -i :8081
}

jbossManagementPort() {
  lsof -i :9990
}

jbossTestDs() {
  log "Testando DataSource ClienteDS..."
  "$DEV_WILDFLY_HOME/bin/jboss-cli.sh" --connect \
    '/subsystem=datasources/data-source=ClienteDS:test-connection-in-pool'
}

tomcatStart() {
  log "Iniciando Tomcat..."
  "$DEV_TOMCAT_HOME/bin/startup.sh"
  ok "Tomcat iniciado."
}

tomcatStop() {
  log "Parando Tomcat..."
  "$DEV_TOMCAT_HOME/bin/shutdown.sh" || true
  ok "Tomcat parado."
}

tomcatRestart() {
  warn "Reiniciando Tomcat..."
  tomcatStop
  sleep 2
  tomcatStart
}

tomcatLog() {
  tail -f "$DEV_TOMCAT_HOME/logs/catalina.out"
}

tomcatLog80() {
  tail -n 80 "$DEV_TOMCAT_HOME/logs/catalina.out"
}

tomcatCleanDeploy() {
  log "Removendo deploy anterior do Tomcat..."

  rm -rf "$DEV_TOMCAT_HOME/webapps/$DEV_APP_NAME"
  rm -f "$DEV_TOMCAT_HOME/webapps/$DEV_APP_NAME.war"

  ok "Deploy anterior removido."
}

tomcatDeploy() {
  log "Gerando WAR do projeto..."
  cd "$DEV_PROJECT_DIR" || return 1

  mvn clean package

  tomcatStop
  tomcatCleanDeploy

  log "Copiando WAR para Tomcat..."
  cp "$DEV_PROJECT_DIR/target/$DEV_APP_NAME.war" "$DEV_TOMCAT_HOME/webapps/"

  tomcatStart

  ok "Deploy enviado para Tomcat."
  tomcatLog80
}

tomcatKill() {
  warn "Finalizando processos Tomcat na força..."
  pkill -f tomcat || true
  ok "Processos finalizados."
}

tomcatPort() {
  lsof -i :8080
}

deployJboss() {
  jbossDeploy
}

deployTomcat() {
  tomcatDeploy
}
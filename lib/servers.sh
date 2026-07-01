# ============================================================
# Servers - Tomcat / WildFly JBoss
# ============================================================

: "${EDEV_APP_NAME:=cliente-legado}"
: "${EDEV_PROJECT_DIR:=$HOME/dev/projects/java/$EDEV_APP_NAME}"

setupServers() {
  setupBase

  mkdir -p "$EDEV_APPS_DIR/tomcats"
  mkdir -p "$EDEV_APPS_DIR/jbosses"

  installTomcat
  installWildFly

  ok "Servidores configurados."
}

installTomcat() {
  if [[ -d "$EDEV_TOMCAT_HOME" ]]; then
    ok "Tomcat ja instalado em: $EDEV_TOMCAT_HOME"
    return 0
  fi

  if ! confirm "Deseja baixar e instalar o Tomcat $EDEV_TOMCAT_VERSION?"; then
    warn "Tomcat nao instalado."
    return 0
  fi

  local fileName="apache-tomcat-$EDEV_TOMCAT_VERSION.tar.gz"
  local url="https://archive.apache.org/dist/tomcat/tomcat-9/v$EDEV_TOMCAT_VERSION/bin/$fileName"
  local installDir="$EDEV_APPS_DIR/tomcats"

  mkdir -p "$installDir"

  cd "$installDir" || return 1

  if [[ ! -f "$fileName" ]]; then
    log "Baixando Tomcat..."
    wget "$url"
  else
    ok "Arquivo do Tomcat ja existe: $fileName"
  fi

  if [[ ! -d "apache-tomcat-$EDEV_TOMCAT_VERSION" ]]; then
    log "Extraindo Tomcat..."
    tar -xzf "$fileName"
  else
    ok "Diretorio do Tomcat ja existe."
  fi

  ln -sfn "apache-tomcat-$EDEV_TOMCAT_VERSION" tomcat9
  chmod +x "$EDEV_TOMCAT_HOME/bin/"*.sh

  ok "Tomcat instalado em: $EDEV_TOMCAT_HOME"
}

installWildFly() {
  if [[ -d "$EDEV_WILDFLY_HOME" ]]; then
    ok "WildFly/JBoss ja instalado em: $EDEV_WILDFLY_HOME"
    return 0
  fi

  if ! confirm "Deseja baixar e instalar o WildFly $EDEV_WILDFLY_VERSION?"; then
    warn "WildFly/JBoss nao instalado."
    return 0
  fi

  local fileName="wildfly-$EDEV_WILDFLY_VERSION.tar.gz"
  local url="https://github.com/wildfly/wildfly/releases/download/$EDEV_WILDFLY_VERSION/$fileName"
  local installDir="$EDEV_APPS_DIR/jbosses"

  mkdir -p "$installDir"

  cd "$installDir" || return 1

  if [[ ! -f "$fileName" ]]; then
    log "Baixando WildFly/JBoss..."
    wget "$url"
  else
    ok "Arquivo do WildFly/JBoss ja existe: $fileName"
  fi

  if [[ ! -d "wildfly-$EDEV_WILDFLY_VERSION" ]]; then
    log "Extraindo WildFly/JBoss..."
    tar -xzf "$fileName"
  else
    ok "Diretorio do WildFly/JBoss ja existe."
  fi

  ln -sfn "wildfly-$EDEV_WILDFLY_VERSION" wildfly26
  chmod +x "$EDEV_WILDFLY_HOME/bin/"*.sh

  ok "WildFly/JBoss instalado em: $EDEV_WILDFLY_HOME"
}

tomcatCommand() {
  case "$1" in
    start)
      tomcatStart
      ;;

    stop)
      tomcatStop
      ;;

    restart)
      tomcatRestart
      ;;

    status)
      tomcatStatus
      ;;

    log)
      tomcatLog
      ;;

    log80)
      tomcatLog80
      ;;

    port)
      tomcatPort
      ;;

    deploy)
      tomcatDeploy
      ;;

    clean-deploy)
      tomcatCleanDeploy
      ;;

    kill)
      tomcatKill
      ;;

    *)
      fail "Comando Tomcat invalido."
      echo "Use: edev server tomcat start|stop|restart|status|log|log80|port|deploy|clean-deploy|kill"
      return 1
      ;;
  esac
}

tomcatStart() {
  if [[ ! -x "$EDEV_TOMCAT_HOME/bin/startup.sh" ]]; then
    fail "Tomcat nao encontrado em: $EDEV_TOMCAT_HOME"
    return 1
  fi

  log "Iniciando Tomcat..."
  "$EDEV_TOMCAT_HOME/bin/startup.sh"
  ok "Tomcat iniciado."
}

tomcatStop() {
  if [[ ! -x "$EDEV_TOMCAT_HOME/bin/shutdown.sh" ]]; then
    fail "Tomcat nao encontrado em: $EDEV_TOMCAT_HOME"
    return 1
  fi

  log "Parando Tomcat..."
  "$EDEV_TOMCAT_HOME/bin/shutdown.sh" || true
  ok "Tomcat parado."
}

tomcatRestart() {
  warn "Reiniciando Tomcat..."
  tomcatStop
  sleep 2
  tomcatStart
}

tomcatStatus() {
  if pgrep -f "$EDEV_TOMCAT_HOME" >/dev/null 2>&1; then
    ok "Tomcat esta rodando."
    return 0
  fi

  warn "Tomcat nao esta rodando."
}

tomcatLog() {
  local logFile="$EDEV_TOMCAT_HOME/logs/catalina.out"

  if [[ ! -f "$logFile" ]]; then
    fail "Log do Tomcat nao encontrado: $logFile"
    return 1
  fi

  tail -f "$logFile"
}

tomcatLog80() {
  local logFile="$EDEV_TOMCAT_HOME/logs/catalina.out"

  if [[ ! -f "$logFile" ]]; then
    fail "Log do Tomcat nao encontrado: $logFile"
    return 1
  fi

  tail -n 80 "$logFile"
}

tomcatPort() {
  log "Verificando porta 8080..."
  lsof -i :8080 || warn "Nada encontrado na porta 8080."
}

tomcatCleanDeploy() {
  log "Removendo deploy anterior do Tomcat..."

  rm -rf "$EDEV_TOMCAT_HOME/webapps/$EDEV_APP_NAME"
  rm -f "$EDEV_TOMCAT_HOME/webapps/$EDEV_APP_NAME.war"

  ok "Deploy anterior removido."
}

tomcatDeploy() {
  if [[ ! -d "$EDEV_PROJECT_DIR" ]]; then
    fail "Projeto nao encontrado: $EDEV_PROJECT_DIR"
    return 1
  fi

  if [[ ! -d "$EDEV_TOMCAT_HOME" ]]; then
    fail "Tomcat nao encontrado em: $EDEV_TOMCAT_HOME"
    return 1
  fi

  log "Gerando WAR do projeto..."
  cd "$EDEV_PROJECT_DIR" || return 1

  mvn clean package

  tomcatStop
  tomcatCleanDeploy

  log "Copiando WAR para Tomcat..."
  cp "$EDEV_PROJECT_DIR/target/$EDEV_APP_NAME.war" "$EDEV_TOMCAT_HOME/webapps/"

  tomcatStart

  ok "Deploy enviado para Tomcat."
  tomcatLog80
}

tomcatKill() {
  warn "Finalizando processos Tomcat na forca..."
  pkill -f "$EDEV_TOMCAT_HOME" || true
  ok "Processos Tomcat finalizados."
}

jbossCommand() {
  case "$1" in
    start)
      jbossStart
      ;;

    start-bg)
      jbossStartBackground
      ;;

    start-8081)
      jbossStartPort "8081"
      ;;

    start-8082)
      jbossStartPort "8082"
      ;;

    stop)
      jbossStop
      ;;

    restart)
      jbossRestart
      ;;

    status)
      jbossStatus
      ;;

    log)
      jbossLog
      ;;

    log80)
      jbossLog80
      ;;

    port)
      jbossPort
      ;;

    management-port)
      jbossManagementPort
      ;;

    deployments)
      jbossDeployments
      ;;

    deploy)
      jbossDeploy
      ;;

    clean-deploy)
      jbossCleanDeploy
      ;;

    test-ds)
      jbossTestDs
      ;;

    kill)
      jbossKill
      ;;

    *)
      fail "Comando WildFly/JBoss invalido."
      echo "Use: edev server jboss start|start-bg|start-8081|start-8082|stop|restart|status|log|log80|port|management-port|deployments|deploy|clean-deploy|test-ds|kill"
      return 1
      ;;
  esac
}

jbossStart() {
  if [[ ! -x "$EDEV_WILDFLY_HOME/bin/standalone.sh" ]]; then
    fail "WildFly/JBoss nao encontrado em: $EDEV_WILDFLY_HOME"
    return 1
  fi

  log "Iniciando WildFly/JBoss..."
  "$EDEV_WILDFLY_HOME/bin/standalone.sh"
}

jbossStartBackground() {
  if [[ ! -x "$EDEV_WILDFLY_HOME/bin/standalone.sh" ]]; then
    fail "WildFly/JBoss nao encontrado em: $EDEV_WILDFLY_HOME"
    return 1
  fi

  local consoleLog="$EDEV_WILDFLY_HOME/standalone/log/console.log"

  log "Iniciando WildFly/JBoss em background..."
  nohup "$EDEV_WILDFLY_HOME/bin/standalone.sh" > "$consoleLog" 2>&1 &

  sleep 2

  ok "WildFly/JBoss iniciado em background."
  warn "Log do console: $consoleLog"
}

jbossStartPort() {
  local port="$1"

  if [[ -z "$port" ]]; then
    fail "Porta nao informada."
    return 1
  fi

  if [[ ! -x "$EDEV_WILDFLY_HOME/bin/standalone.sh" ]]; then
    fail "WildFly/JBoss nao encontrado em: $EDEV_WILDFLY_HOME"
    return 1
  fi

  log "Iniciando WildFly/JBoss na porta $port..."
  "$EDEV_WILDFLY_HOME/bin/standalone.sh" -Djboss.http.port="$port"
}

jbossStop() {
  if [[ ! -x "$EDEV_WILDFLY_HOME/bin/jboss-cli.sh" ]]; then
    fail "CLI do WildFly/JBoss nao encontrado em: $EDEV_WILDFLY_HOME"
    return 1
  fi

  log "Parando WildFly/JBoss..."
  "$EDEV_WILDFLY_HOME/bin/jboss-cli.sh" --connect command=:shutdown
  ok "WildFly/JBoss parado."
}

jbossRestart() {
  warn "Reiniciando WildFly/JBoss..."
  jbossStop || true
  sleep 2
  jbossStart
}

jbossStatus() {
  if pgrep -f "$EDEV_WILDFLY_HOME" >/dev/null 2>&1; then
    ok "WildFly/JBoss esta rodando."
    return 0
  fi

  warn "WildFly/JBoss nao esta rodando."
}

jbossLog() {
  local logFile="$EDEV_WILDFLY_HOME/standalone/log/server.log"

  if [[ ! -f "$logFile" ]]; then
    fail "Log do WildFly/JBoss nao encontrado: $logFile"
    return 1
  fi

  tail -f "$logFile"
}

jbossLog80() {
  local logFile="$EDEV_WILDFLY_HOME/standalone/log/server.log"

  if [[ ! -f "$logFile" ]]; then
    fail "Log do WildFly/JBoss nao encontrado: $logFile"
    return 1
  fi

  tail -n 80 "$logFile"
}

jbossPort() {
  log "Verificando portas comuns do WildFly/JBoss..."
  lsof -i :8080 || true
  lsof -i :8081 || true
  lsof -i :8082 || true
}

jbossManagementPort() {
  log "Verificando porta de gerenciamento 9990..."
  lsof -i :9990 || warn "Nada encontrado na porta 9990."
}

jbossDeployments() {
  local deployDir="$EDEV_WILDFLY_HOME/standalone/deployments"

  if [[ ! -d "$deployDir" ]]; then
    fail "Diretorio de deployments nao encontrado: $deployDir"
    return 1
  fi

  ls -la "$deployDir"
}

jbossCleanDeploy() {
  local deployDir="$EDEV_WILDFLY_HOME/standalone/deployments"

  if [[ ! -d "$deployDir" ]]; then
    fail "Diretorio de deployments nao encontrado: $deployDir"
    return 1
  fi

  log "Removendo deploy anterior do WildFly/JBoss..."

  rm -f "$deployDir/$EDEV_APP_NAME.war"
  rm -f "$deployDir/$EDEV_APP_NAME.war.deployed"
  rm -f "$deployDir/$EDEV_APP_NAME.war.failed"
  rm -f "$deployDir/$EDEV_APP_NAME.war.isdeploying"
  rm -f "$deployDir/$EDEV_APP_NAME.war.undeployed"
  rm -f "$deployDir/$EDEV_APP_NAME.war.dodeploy"

  ok "Deploy anterior removido."
}

jbossDeploy() {
  local deployDir="$EDEV_WILDFLY_HOME/standalone/deployments"

  if [[ ! -d "$EDEV_PROJECT_DIR" ]]; then
    fail "Projeto nao encontrado: $EDEV_PROJECT_DIR"
    return 1
  fi

  if [[ ! -d "$deployDir" ]]; then
    fail "Diretorio de deployments nao encontrado: $deployDir"
    return 1
  fi

  log "Gerando WAR do projeto..."
  cd "$EDEV_PROJECT_DIR" || return 1

  mvn clean package

  jbossCleanDeploy

  log "Copiando WAR para WildFly/JBoss..."
  cp "$EDEV_PROJECT_DIR/target/$EDEV_APP_NAME.war" "$deployDir/"

  ok "Deploy enviado para WildFly/JBoss."
  jbossLog80
}

jbossTestDs() {
  if [[ ! -x "$EDEV_WILDFLY_HOME/bin/jboss-cli.sh" ]]; then
    fail "CLI do WildFly/JBoss nao encontrado em: $EDEV_WILDFLY_HOME"
    return 1
  fi

  log "Testando DataSource ClienteDS..."
  "$EDEV_WILDFLY_HOME/bin/jboss-cli.sh" --connect \
    '/subsystem=datasources/data-source=ClienteDS:test-connection-in-pool'
}

jbossKill() {
  warn "Finalizando processos WildFly/JBoss na forca..."
  pkill -f "$EDEV_WILDFLY_HOME" || true
  ok "Processos WildFly/JBoss finalizados."
}
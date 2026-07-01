# ============================================================
# Servers - Tomcat / WildFly JBoss
# ============================================================

: "${EDEV_APPS_DIR:=$HOME/apps}"
: "${EDEV_TOMCAT_VERSION:=9.0.118}"
: "${EDEV_WILDFLY_VERSION:=26.1.3.Final}"
: "${EDEV_TOMCAT_HOME:=$EDEV_APPS_DIR/tomcats/tomcat9}"
: "${EDEV_WILDFLY_HOME:=$EDEV_APPS_DIR/jbosses/wildfly26}"

setupServers() {
  setupBase

  mkdir -p "$EDEV_APPS_DIR/tomcats"
  mkdir -p "$EDEV_APPS_DIR/jbosses"

  installTomcat
  installWildFly

  ok "Servidores configurados."
}

getRealPath() {
  local path="$1"

  readlink -f "$path" 2>/dev/null || echo "$path"
}

getDirectoryName() {
  local path="$1"
  local realPath

  realPath="$(getRealPath "$path")"

  basename "$realPath"
}

showProcessPorts() {
  local searchPath="$1"
  local pids

  pids="$(pgrep -f "$searchPath" || true)"

  if [[ -z "$pids" ]]; then
    warn "Nenhum processo encontrado para: $searchPath"
    return 0
  fi

  echo "Processos encontrados:"

  while IFS= read -r pid; do
    if [[ -z "$pid" ]]; then
      continue
    fi

    echo "  PID: $pid"

    local ports
    ports="$(lsof -Pan -p "$pid" -iTCP -sTCP:LISTEN 2>/dev/null | awk 'NR > 1 {print $9}' | sort -u || true)"

    if [[ -z "$ports" ]]; then
      warn "  Nenhuma porta TCP LISTEN encontrada para o PID $pid."
    else
      echo "$ports" | while IFS= read -r port; do
        echo "    Porta aberta: $port"
      done
    fi
  done <<< "$pids"
}

# ============================================================
# Tomcat
# ============================================================

installTomcat() {
  installTomcatVersion "$EDEV_TOMCAT_VERSION"
}

installTomcatVersion() {
  local version="$1"

  if [[ -z "$version" ]]; then
    fail "Informe a versao do Tomcat. Exemplo: edev server tomcat install-version 9.0.118"
    return 1
  fi

  local majorVersion
  majorVersion="${version%%.*}"

  local fileName="apache-tomcat-$version.tar.gz"
  local url="https://archive.apache.org/dist/tomcat/tomcat-$majorVersion/v$version/bin/$fileName"
  local installDir="$EDEV_APPS_DIR/tomcats"
  local versionDir="$installDir/apache-tomcat-$version"

  if [[ -d "$versionDir" ]]; then
    ok "Tomcat $version ja instalado em: $versionDir"
    return 0
  fi

  if ! confirm "Deseja baixar e instalar o Tomcat $version?"; then
    warn "Tomcat $version nao instalado."
    return 0
  fi

  mkdir -p "$installDir"

  cd "$installDir" || return 1

  if [[ ! -f "$fileName" ]]; then
    log "Baixando Tomcat $version..."
    wget "$url"
  else
    ok "Arquivo do Tomcat ja existe: $fileName"
  fi

  log "Extraindo Tomcat $version..."
  tar -xzf "$fileName"

  chmod +x "$versionDir/bin/"*.sh

  ok "Tomcat $version instalado em: $versionDir"

  if confirm "Deseja usar o Tomcat $version como versao ativa?"; then
    tomcatUseVersion "$version"
  fi
}

tomcatUseVersion() {
  local version="$1"

  if [[ -z "$version" ]]; then
    fail "Informe a versao do Tomcat. Exemplo: edev server tomcat use-version 9.0.118"
    return 1
  fi

  local versionDir="$EDEV_APPS_DIR/tomcats/apache-tomcat-$version"

  if [[ ! -d "$versionDir" ]]; then
    fail "Tomcat $version nao encontrado em: $versionDir"
    warn "Instale antes com: edev server tomcat install-version $version"
    return 1
  fi

  if [[ -e "$EDEV_TOMCAT_HOME" && ! -L "$EDEV_TOMCAT_HOME" ]]; then
    fail "O caminho ativo do Tomcat existe e nao e link simbolico: $EDEV_TOMCAT_HOME"
    warn "Nao vou sobrescrever uma pasta real automaticamente."
    return 1
  fi

  ln -sfn "$versionDir" "$EDEV_TOMCAT_HOME"

  ok "Tomcat ativo alterado para: $version"
  tomcatInfo
}

tomcatList() {
  local tomcatDir="$EDEV_APPS_DIR/tomcats"

  if [[ ! -d "$tomcatDir" ]]; then
    warn "Diretorio de Tomcats nao encontrado: $tomcatDir"
    return 0
  fi

  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "🐱 Tomcats instalados"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

  find "$tomcatDir" -maxdepth 1 -type d -name "apache-tomcat-*" -printf "  %f\n" | sort

  echo ""
  echo "Ativo:"
  echo "  $EDEV_TOMCAT_HOME -> $(getRealPath "$EDEV_TOMCAT_HOME")"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""
}

tomcatConfiguredPorts() {
  local configFile="$EDEV_TOMCAT_HOME/conf/server.xml"

  if [[ ! -f "$configFile" ]]; then
    warn "server.xml nao encontrado: $configFile"
    return 0
  fi

  echo "Portas configuradas no server.xml:"

  grep -E '<Connector port=' "$configFile" \
    | sed -E 's/.*port="([^"]+)".*/  Porta configurada: \1/' \
    | sort -u
}

tomcatInfo() {
  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "🐱 Tomcat Info"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "Home:       $EDEV_TOMCAT_HOME"
  echo "Real path:  $(getRealPath "$EDEV_TOMCAT_HOME")"
  echo "Versao dir: $(getDirectoryName "$EDEV_TOMCAT_HOME")"
  echo ""

  if [[ -x "$EDEV_TOMCAT_HOME/bin/version.sh" ]]; then
    "$EDEV_TOMCAT_HOME/bin/version.sh" 2>/dev/null \
      | grep -E "Server version|Server number|JVM Version" || true
  fi

  echo ""
  tomcatConfiguredPorts
  echo ""
  tomcatStatus
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""
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

    info)
      tomcatInfo
      ;;

    list)
      tomcatList
      ;;

    install-version)
      tomcatInstallVersion "$2"
      ;;

    use-version)
      tomcatUseVersion "$2"
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
      tomcatDeploy "$2"
      ;;

    clean-deploy)
      tomcatCleanDeploy
      ;;

    kill)
      tomcatKill
      ;;

    *)
      fail "Comando Tomcat invalido."
      echo "Use: edev server tomcat start|stop|restart|status|info|list|install-version|use-version|log|log80|port|deploy|clean-deploy|kill"
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

  sleep 2

  ok "Tomcat iniciado."
  tomcatStatus
}

tomcatStop() {
  if [[ ! -x "$EDEV_TOMCAT_HOME/bin/shutdown.sh" ]]; then
    fail "Tomcat nao encontrado em: $EDEV_TOMCAT_HOME"
    return 1
  fi

  log "Parando Tomcat..."
  "$EDEV_TOMCAT_HOME/bin/shutdown.sh" || true

  sleep 2

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
    showProcessPorts "$EDEV_TOMCAT_HOME"
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
  log "Verificando portas comuns do Tomcat..."
  lsof -i :8080 || true
  lsof -i :8081 || true
  lsof -i :8082 || true
}

tomcatCleanDeployName() {
  local appName="$1"

  if [[ -z "$appName" ]]; then
    fail "Nome da aplicacao nao informado para limpar deploy."
    return 1
  fi

  log "Removendo deploy anterior do Tomcat: $appName"

  rm -rf "$EDEV_TOMCAT_HOME/webapps/$appName"
  rm -f "$EDEV_TOMCAT_HOME/webapps/$appName.war"

  ok "Deploy anterior removido."
}

tomcatCleanDeploy() {
  projectResolveCurrent "$1" || return 1
  tomcatCleanDeployName "$EDEV_PROJECT_ARTIFACT_NAME"
}

tomcatDeploy() {
  local projectPath="${1:-$(pwd)}"

  projectResolveCurrent "$projectPath" || return 1

  if [[ "$EDEV_PROJECT_PACKAGING" != "war" ]]; then
    fail "Deploy no Tomcat espera projeto WAR. Packaging atual: $EDEV_PROJECT_PACKAGING"
    return 1
  fi

  if [[ ! -d "$EDEV_TOMCAT_HOME" ]]; then
    fail "Tomcat nao encontrado em: $EDEV_TOMCAT_HOME"
    return 1
  fi

  log "Gerando WAR do projeto..."
  cd "$EDEV_PROJECT_ROOT" || return 1

  mvn clean package

  projectResolveCurrent "$EDEV_PROJECT_ROOT" || return 1

  if [[ ! -f "$EDEV_PROJECT_ARTIFACT_FILE" ]]; then
    fail "WAR nao encontrado em target."
    return 1
  fi

  tomcatStop
  tomcatCleanDeployName "$EDEV_PROJECT_ARTIFACT_NAME"

  log "Copiando WAR para Tomcat..."
  cp "$EDEV_PROJECT_ARTIFACT_FILE" "$EDEV_TOMCAT_HOME/webapps/"

  tomcatStart

  ok "Deploy enviado para Tomcat."
  echo "Aplicacao: $EDEV_PROJECT_ARTIFACT_NAME"
  echo "Arquivo:    $EDEV_PROJECT_ARTIFACT_FILE"
  tomcatLog80
}

tomcatKill() {
  warn "Finalizando processos Tomcat na forca..."
  pkill -f "$EDEV_TOMCAT_HOME" || true
  ok "Processos Tomcat finalizados."
}

# ============================================================
# WildFly / JBoss
# ============================================================

installWildFly() {
  installWildFlyVersion "$EDEV_WILDFLY_VERSION"
}

installWildFlyVersion() {
  local version="$1"

  if [[ -z "$version" ]]; then
    fail "Informe a versao do WildFly. Exemplo: edev server jboss install-version 26.1.3.Final"
    return 1
  fi

  local fileName="wildfly-$version.tar.gz"
  local url="https://github.com/wildfly/wildfly/releases/download/$version/$fileName"
  local installDir="$EDEV_APPS_DIR/jbosses"
  local versionDir="$installDir/wildfly-$version"

  if [[ -d "$versionDir" ]]; then
    ok "WildFly/JBoss $version ja instalado em: $versionDir"
    return 0
  fi

  if ! confirm "Deseja baixar e instalar o WildFly $version?"; then
    warn "WildFly/JBoss $version nao instalado."
    return 0
  fi

  mkdir -p "$installDir"

  cd "$installDir" || return 1

  if [[ ! -f "$fileName" ]]; then
    log "Baixando WildFly/JBoss $version..."
    wget "$url"
  else
    ok "Arquivo do WildFly/JBoss ja existe: $fileName"
  fi

  log "Extraindo WildFly/JBoss $version..."
  tar -xzf "$fileName"

  chmod +x "$versionDir/bin/"*.sh

  ok "WildFly/JBoss $version instalado em: $versionDir"

  if confirm "Deseja usar o WildFly/JBoss $version como versao ativa?"; then
    jbossUseVersion "$version"
  fi
}

jbossUseVersion() {
  local version="$1"

  if [[ -z "$version" ]]; then
    fail "Informe a versao do WildFly. Exemplo: edev server jboss use-version 26.1.3.Final"
    return 1
  fi

  local versionDir="$EDEV_APPS_DIR/jbosses/wildfly-$version"

  if [[ ! -d "$versionDir" ]]; then
    fail "WildFly/JBoss $version nao encontrado em: $versionDir"
    warn "Instale antes com: edev server jboss install-version $version"
    return 1
  fi

  if [[ -e "$EDEV_WILDFLY_HOME" && ! -L "$EDEV_WILDFLY_HOME" ]]; then
    fail "O caminho ativo do WildFly/JBoss existe e nao e link simbolico: $EDEV_WILDFLY_HOME"
    warn "Nao vou sobrescrever uma pasta real automaticamente."
    return 1
  fi

  ln -sfn "$versionDir" "$EDEV_WILDFLY_HOME"

  ok "WildFly/JBoss ativo alterado para: $version"
  jbossInfo
}

jbossList() {
  local jbossDir="$EDEV_APPS_DIR/jbosses"

  if [[ ! -d "$jbossDir" ]]; then
    warn "Diretorio de WildFly/JBoss nao encontrado: $jbossDir"
    return 0
  fi

  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "🦅 WildFly/JBoss instalados"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

  find "$jbossDir" -maxdepth 1 -type d -name "wildfly-*" -printf "  %f\n" | sort

  echo ""
  echo "Ativo:"
  echo "  $EDEV_WILDFLY_HOME -> $(getRealPath "$EDEV_WILDFLY_HOME")"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""
}

jbossConfiguredPorts() {
  local configFile="$EDEV_WILDFLY_HOME/standalone/configuration/standalone.xml"

  if [[ ! -f "$configFile" ]]; then
    warn "standalone.xml nao encontrado: $configFile"
    return 0
  fi

  echo "Portas configuradas no standalone.xml:"

  local httpPort
  local httpsPort
  local managementPort

  httpPort="$(grep -oE 'jboss.http.port:[0-9]+' "$configFile" | head -n1 | cut -d: -f2)"
  httpsPort="$(grep -oE 'jboss.https.port:[0-9]+' "$configFile" | head -n1 | cut -d: -f2)"
  managementPort="$(grep -oE 'jboss.management.http.port:[0-9]+' "$configFile" | head -n1 | cut -d: -f2)"

  [[ -n "$httpPort" ]] && echo "  HTTP:       $httpPort"
  [[ -n "$httpsPort" ]] && echo "  HTTPS:      $httpsPort"
  [[ -n "$managementPort" ]] && echo "  Management: $managementPort"

  if [[ -z "$httpPort" && -z "$httpsPort" && -z "$managementPort" ]]; then
    warn "Nao foi possivel identificar portas no standalone.xml."
  fi
}

jbossInfo() {
  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "🦅 WildFly/JBoss Info"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "Home:       $EDEV_WILDFLY_HOME"
  echo "Real path:  $(getRealPath "$EDEV_WILDFLY_HOME")"
  echo "Versao dir: $(getDirectoryName "$EDEV_WILDFLY_HOME")"
  echo ""

  jbossConfiguredPorts
  echo ""
  jbossStatus
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""
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

    start-bg-8081)
      jbossStartBackgroundPort "8081"
      ;;

    start-bg-8082)
      jbossStartBackgroundPort "8082"
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

    info)
      jbossInfo
      ;;

    list)
      jbossList
      ;;

    install-version)
      installWildFlyVersion "$2"
      ;;

    use-version)
      jbossUseVersion "$2"
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
      jbossDeploy "$2"
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
      echo "Use: edev server jboss start|start-bg|start-8081|start-8082|start-bg-8081|start-bg-8082|stop|restart|status|info|list|install-version|use-version|log|log80|port|management-port|deployments|deploy|clean-deploy|test-ds|kill"
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

  sleep 4

  ok "WildFly/JBoss iniciado em background."
  warn "Log do console: $consoleLog"
  jbossStatus
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

jbossStartBackgroundPort() {
  local port="$1"

  if [[ -z "$port" ]]; then
    fail "Porta nao informada."
    return 1
  fi

  if [[ ! -x "$EDEV_WILDFLY_HOME/bin/standalone.sh" ]]; then
    fail "WildFly/JBoss nao encontrado em: $EDEV_WILDFLY_HOME"
    return 1
  fi

  local consoleLog="$EDEV_WILDFLY_HOME/standalone/log/console.log"

  log "Iniciando WildFly/JBoss em background na porta $port..."
  nohup "$EDEV_WILDFLY_HOME/bin/standalone.sh" -Djboss.http.port="$port" > "$consoleLog" 2>&1 &

  sleep 4

  ok "WildFly/JBoss iniciado em background na porta $port."
  warn "Log do console: $consoleLog"
  jbossStatus
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
    showProcessPorts "$EDEV_WILDFLY_HOME"
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

jbossCleanDeployName() {
  local appName="$1"
  local deployDir="$EDEV_WILDFLY_HOME/standalone/deployments"

  if [[ -z "$appName" ]]; then
    fail "Nome da aplicacao nao informado para limpar deploy."
    return 1
  fi

  if [[ ! -d "$deployDir" ]]; then
    fail "Diretorio de deployments nao encontrado: $deployDir"
    return 1
  fi

  log "Removendo deploy anterior do WildFly/JBoss: $appName"

  rm -f "$deployDir/$appName.war"
  rm -f "$deployDir/$appName.war.deployed"
  rm -f "$deployDir/$appName.war.failed"
  rm -f "$deployDir/$appName.war.isdeploying"
  rm -f "$deployDir/$appName.war.undeployed"
  rm -f "$deployDir/$appName.war.dodeploy"

  ok "Deploy anterior removido."
}

jbossCleanDeploy() {
  projectResolveCurrent "$1" || return 1
  jbossCleanDeployName "$EDEV_PROJECT_ARTIFACT_NAME"
}

jbossDeploy() {
  local projectPath="${1:-$(pwd)}"
  local deployDir="$EDEV_WILDFLY_HOME/standalone/deployments"

  projectResolveCurrent "$projectPath" || return 1

  if [[ "$EDEV_PROJECT_PACKAGING" != "war" ]]; then
    fail "Deploy no WildFly/JBoss espera projeto WAR. Packaging atual: $EDEV_PROJECT_PACKAGING"
    return 1
  fi

  if [[ ! -d "$deployDir" ]]; then
    fail "Diretorio de deployments nao encontrado: $deployDir"
    return 1
  fi

  log "Gerando WAR do projeto..."
  cd "$EDEV_PROJECT_ROOT" || return 1

  mvn clean package

  projectResolveCurrent "$EDEV_PROJECT_ROOT" || return 1

  if [[ ! -f "$EDEV_PROJECT_ARTIFACT_FILE" ]]; then
    fail "WAR nao encontrado em target."
    return 1
  fi

  jbossCleanDeployName "$EDEV_PROJECT_ARTIFACT_NAME"

  log "Copiando WAR para WildFly/JBoss..."
  cp "$EDEV_PROJECT_ARTIFACT_FILE" "$deployDir/"

  ok "Deploy enviado para WildFly/JBoss."
  echo "Aplicacao: $EDEV_PROJECT_ARTIFACT_NAME"
  echo "Arquivo:    $EDEV_PROJECT_ARTIFACT_FILE"
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
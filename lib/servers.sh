setupServers() {
  setupBase

  mkdir -p "$EDEV_APPS_DIR/tomcats"
  mkdir -p "$EDEV_APPS_DIR/jbosses"

  installTomcat
  installWildFly
}

installTomcat() {
  if [[ -d "$EDEV_TOMCAT_HOME" ]]; then
    ok "Tomcat já instalado em: $EDEV_TOMCAT_HOME"
    return 0
  fi

  if ! confirm "Deseja baixar e instalar o Tomcat $EDEV_TOMCAT_VERSION?"; then
    warn "Tomcat não instalado."
    return 0
  fi

  local fileName="apache-tomcat-$EDEV_TOMCAT_VERSION.tar.gz"
  local url="https://archive.apache.org/dist/tomcat/tomcat-9/v$EDEV_TOMCAT_VERSION/bin/$fileName"

  cd "$EDEV_APPS_DIR/tomcats"

  wget "$url"
  tar -xzf "$fileName"
  ln -sfn "apache-tomcat-$EDEV_TOMCAT_VERSION" tomcat9

  chmod +x "$EDEV_TOMCAT_HOME/bin/"*.sh

  ok "Tomcat instalado em: $EDEV_TOMCAT_HOME"
}

installWildFly() {
  if [[ -d "$EDEV_WILDFLY_HOME" ]]; then
    ok "WildFly/JBoss já instalado em: $EDEV_WILDFLY_HOME"
    return 0
  fi

  if ! confirm "Deseja baixar e instalar o WildFly $EDEV_WILDFLY_VERSION?"; then
    warn "WildFly/JBoss não instalado."
    return 0
  fi

  local fileName="wildfly-$EDEV_WILDFLY_VERSION.tar.gz"
  local url="https://github.com/wildfly/wildfly/releases/download/$EDEV_WILDFLY_VERSION/$fileName"

  cd "$EDEV_APPS_DIR/jbosses"

  wget "$url"
  tar -xzf "$fileName"
  ln -sfn "wildfly-$EDEV_WILDFLY_VERSION" wildfly26

  chmod +x "$EDEV_WILDFLY_HOME/bin/"*.sh

  ok "WildFly/JBoss instalado em: $EDEV_WILDFLY_HOME"
}

tomcatCommand() {
  case "$1" in
    start)
      "$EDEV_TOMCAT_HOME/bin/startup.sh"
      ;;
    stop)
      "$EDEV_TOMCAT_HOME/bin/shutdown.sh" || true
      ;;
    restart)
      "$EDEV_TOMCAT_HOME/bin/shutdown.sh" || true
      sleep 2
      "$EDEV_TOMCAT_HOME/bin/startup.sh"
      ;;
    log)
      tail -f "$EDEV_TOMCAT_HOME/logs/catalina.out"
      ;;
    *)
      fail "Comando Tomcat inválido."
      echo "Use: edev server tomcat start|stop|restart|log"
      ;;
  esac
}

jbossCommand() {
  case "$1" in
    start)
      "$EDEV_WILDFLY_HOME/bin/standalone.sh"
      ;;
    stop)
      "$EDEV_WILDFLY_HOME/bin/jboss-cli.sh" --connect command=:shutdown
      ;;
    restart)
      "$EDEV_WILDFLY_HOME/bin/jboss-cli.sh" --connect command=:shutdown || true
      sleep 2
      "$EDEV_WILDFLY_HOME/bin/standalone.sh"
      ;;
    log)
      tail -f "$EDEV_WILDFLY_HOME/standalone/log/server.log"
      ;;
    *)
      fail "Comando WildFly/JBoss inválido."
      echo "Use: edev server jboss start|stop|restart|log"
      ;;
  esac
}
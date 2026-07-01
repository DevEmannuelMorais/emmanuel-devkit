# ============================================================
# Paths - Emmanuel DevKit
# ============================================================

: "${EDEV_CONFIG_DIR:=$HOME/.config/edev}"
: "${EDEV_CONFIG_FILE:=$EDEV_CONFIG_DIR/config}"

if [[ -f "$EDEV_CONFIG_FILE" ]]; then
  source "$EDEV_CONFIG_FILE"
fi

: "${EDEV_WORKSPACE:=$HOME/dev}"
: "${EDEV_PROJECTS_DIR:=$EDEV_WORKSPACE/projects}"
: "${EDEV_STUDIES_DIR:=$EDEV_WORKSPACE/studies}"
: "${EDEV_APPS_DIR:=$HOME/apps}"
: "${EDEV_JDKS_HOME:=$EDEV_APPS_DIR/jdks}"

: "${EDEV_JAVA_DEFAULT:=temurin-17}"

: "${EDEV_TOMCAT_VERSION:=9.0.118}"
: "${EDEV_WILDFLY_VERSION:=26.1.3.Final}"

: "${EDEV_TOMCAT_HOME:=$EDEV_APPS_DIR/tomcats/tomcat9}"
: "${EDEV_WILDFLY_HOME:=$EDEV_APPS_DIR/jbosses/wildfly26}"
: "${EDEV_JAVA6_HOME:=$EDEV_JDKS_HOME/jdk6}"

: "${EDEV_SHOW_BANNER:=true}"
: "${EDEV_SHOW_TIPS:=true}"
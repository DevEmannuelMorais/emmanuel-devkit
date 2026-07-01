# ============================================================
# Maven - Emmanuel DevKit
# ============================================================

: "${EDEV_MAVEN_LEGACY_VERSION:=3.2.5}"
: "${EDEV_MAVEN_MODERN_VERSION:=3.9.16}"

mavenHelp() {
  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "📦 Emmanuel DevKit - Maven"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "Comandos oficiais:"
  echo "  edev maven help                  Mostra esta ajuda"
  echo "  edev maven info                  Mostra Maven ativo"
  echo "  edev maven list                  Lista Mavens instalados pelo mise"
  echo "  edev maven remote                Lista Mavens disponíveis no mise"
  echo "  edev maven install <versao>      Instala Maven. Ex: 3.2.5"
  echo "  edev maven use <versao>          Define Maven global. Ex: 3.9.16"
  echo "  edev maven 6                     Seleciona Maven legado: $EDEV_MAVEN_LEGACY_VERSION"
  echo "  edev maven 39                    Seleciona Maven moderno: $EDEV_MAVEN_MODERN_VERSION"
  echo ""
  echo "Atalhos no terminal:"
  echo "  mavenInfo"
  echo "  mavenList"
  echo "  mavenRemote"
  echo "  mavenInstall 3.2.5"
  echo "  mavenUse 3.9.16"
  echo "  maven6"
  echo "  maven39"
  echo ""
  echo "Exemplos:"
  echo "  java6"
  echo "  maven6"
  echo "  mvn -version"
  echo ""
  echo "  java17"
  echo "  maven39"
  echo "  mvn -version"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""
}

mavenInfo() {
  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "📦 Maven Environment"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

  echo "Maven:"
  mvn -version 2>/dev/null || echo "Maven N/A"
  echo ""

  echo "Mise Maven:"
  mise current maven 2>/dev/null || echo "Maven não configurado no mise"

  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""
}

mavenList() {
  requireCommand mise || return 1

  log "Listando versões Maven instaladas pelo mise..."
  mise ls maven
}

mavenRemote() {
  requireCommand mise || return 1

  log "Listando versões Maven disponíveis no mise..."
  mise ls-remote maven
}

mavenInstall() {
  local version="$1"

  if [[ -z "$version" ]]; then
    fail "Informe a versão. Exemplo: edev maven install 3.2.5"
    echo "Outros exemplos:"
    echo "  edev maven install 3.2.5"
    echo "  edev maven install 3.9.16"
    return 1
  fi

  requireCommand mise || return 1

  log "Instalando Maven $version..."
  mise install "maven@$version"

  ok "Maven $version instalado."
}

mavenUse() {
  local version="$1"

  if [[ -z "$version" ]]; then
    fail "Informe a versão. Exemplo: edev maven use 3.9.16"
    return 1
  fi

  requireCommand mise || return 1

  log "Selecionando Maven global: $version"
  mise use -g "maven@$version"

  hash -r 2>/dev/null || true

  ok "Maven global ativo:"
  mvn -version
}

mavenUse6() {
  mavenUse "$EDEV_MAVEN_LEGACY_VERSION"
}

mavenUse39() {
  mavenUse "$EDEV_MAVEN_MODERN_VERSION"
}
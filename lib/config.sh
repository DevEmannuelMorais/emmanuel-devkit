# ============================================================
# Config - Emmanuel DevKit
# ============================================================

configEnsureFile() {
  mkdir -p "$EDEV_CONFIG_DIR"

  if [[ ! -f "$EDEV_CONFIG_FILE" ]]; then
    touch "$EDEV_CONFIG_FILE"
  fi
}

configKeys() {
  cat <<'EOF'
workspace.dir
projects.dir
studies.dir
apps.dir
jdks.dir
java.default
tomcat.version
wildfly.version
tomcat.home
wildfly.home
shell.banner
shell.tips
EOF
}

configVarForKey() {
  case "$1" in
    workspace.dir)
      echo "EDEV_WORKSPACE"
      ;;

    projects.dir)
      echo "EDEV_PROJECTS_DIR"
      ;;

    studies.dir)
      echo "EDEV_STUDIES_DIR"
      ;;

    apps.dir)
      echo "EDEV_APPS_DIR"
      ;;

    jdks.dir)
      echo "EDEV_JDKS_HOME"
      ;;

    java.default)
      echo "EDEV_JAVA_DEFAULT"
      ;;

    tomcat.version)
      echo "EDEV_TOMCAT_VERSION"
      ;;

    wildfly.version)
      echo "EDEV_WILDFLY_VERSION"
      ;;

    tomcat.home)
      echo "EDEV_TOMCAT_HOME"
      ;;

    wildfly.home)
      echo "EDEV_WILDFLY_HOME"
      ;;

    shell.banner)
      echo "EDEV_SHOW_BANNER"
      ;;

    shell.tips)
      echo "EDEV_SHOW_TIPS"
      ;;

    *)
      return 1
      ;;
  esac
}

configNormalizeValue() {
  local value="$1"

  if [[ "$value" == "~" ]]; then
    echo "$HOME"
    return 0
  fi

  if [[ "$value" == "~/"* ]]; then
    echo "$HOME/${value#"~/"}"
    return 0
  fi

  echo "$value"
}

configQuoteValue() {
  printf "%q" "$1"
}

configGetValueByVar() {
  local varName="$1"

  echo "${!varName}"
}

configPath() {
  echo "$EDEV_CONFIG_FILE"
}

configInit() {
  configEnsureFile

  ok "Arquivo de configuracao pronto em:"
  echo "$EDEV_CONFIG_FILE"
}

configList() {
  configEnsureFile

  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "⚙️  Emmanuel DevKit Config"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "Arquivo: $EDEV_CONFIG_FILE"
  echo ""

  while IFS= read -r configKey; do
    local varName
    local value

    varName="$(configVarForKey "$configKey")"
    value="$(configGetValueByVar "$varName")"

    printf "  %-18s = %s\n" "$configKey" "$value"
  done < <(configKeys)

  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""
}

configGet() {
  local configKey="$1"
  local varName

  if [[ -z "$configKey" ]]; then
    fail "Informe a chave. Exemplo: edev config get workspace.dir"
    return 1
  fi

  varName="$(configVarForKey "$configKey" || true)"

  if [[ -z "$varName" ]]; then
    fail "Chave invalida: $configKey"
    configShowKeys
    return 1
  fi

  configGetValueByVar "$varName"
}

configSet() {
  local configKey="$1"
  local rawValue="$2"
  local varName
  local value
  local quotedValue
  local tempFile

  if [[ -z "$configKey" || -z "$rawValue" ]]; then
    fail "Use: edev config set chave valor"
    echo "Exemplo: edev config set workspace.dir ~/dev"
    return 1
  fi

  varName="$(configVarForKey "$configKey" || true)"

  if [[ -z "$varName" ]]; then
    fail "Chave invalida: $configKey"
    configShowKeys
    return 1
  fi

  value="$(configNormalizeValue "$rawValue")"
  quotedValue="$(configQuoteValue "$value")"

  configEnsureFile

  tempFile="$(mktemp)"

  grep -v -E "^${varName}=" "$EDEV_CONFIG_FILE" > "$tempFile" || true
  printf "%s=%s\n" "$varName" "$quotedValue" >> "$tempFile"

  mv "$tempFile" "$EDEV_CONFIG_FILE"

  export "$varName=$value"

  ok "Configuracao atualizada:"
  echo "$configKey=$value"
}

configUnset() {
  local configKey="$1"
  local varName
  local tempFile

  if [[ -z "$configKey" ]]; then
    fail "Informe a chave. Exemplo: edev config unset workspace.dir"
    return 1
  fi

  varName="$(configVarForKey "$configKey" || true)"

  if [[ -z "$varName" ]]; then
    fail "Chave invalida: $configKey"
    configShowKeys
    return 1
  fi

  configEnsureFile

  tempFile="$(mktemp)"
  grep -v -E "^${varName}=" "$EDEV_CONFIG_FILE" > "$tempFile" || true
  mv "$tempFile" "$EDEV_CONFIG_FILE"

  unset "$varName"

  ok "Configuracao removida: $configKey"
  warn "Recarregue o terminal para voltar ao valor padrao."
}

configEdit() {
  configEnsureFile

  "${EDITOR:-nano}" "$EDEV_CONFIG_FILE"
}

configReset() {
  if [[ ! -f "$EDEV_CONFIG_FILE" ]]; then
    ok "Nenhum arquivo de configuracao encontrado."
    return 0
  fi

  if ! confirm "Deseja apagar a configuracao global do Emmanuel DevKit?"; then
    warn "Reset cancelado."
    return 0
  fi

  cp "$EDEV_CONFIG_FILE" "$EDEV_CONFIG_FILE.bkp"
  rm -f "$EDEV_CONFIG_FILE"

  ok "Configuracao removida."
  warn "Backup criado em: $EDEV_CONFIG_FILE.bkp"
}

configShowKeys() {
  echo ""
  echo "Chaves disponiveis:"
  configKeys | sed 's/^/  /'
  echo ""
}

configCommand() {
  case "$1" in
    list|"")
      configList
      ;;

    get)
      configGet "$2"
      ;;

    set)
      configSet "$2" "$3"
      ;;

    unset)
      configUnset "$2"
      ;;

    path)
      configPath
      ;;

    init)
      configInit
      ;;

    edit)
      configEdit
      ;;

    reset)
      configReset
      ;;

    keys)
      configShowKeys
      ;;

    *)
      fail "Comando config invalido."
      echo "Use: edev config list|get|set|unset|path|init|edit|reset|keys"
      return 1
      ;;
  esac
}
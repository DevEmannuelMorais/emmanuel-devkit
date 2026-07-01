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

hasCommand() {
  command -v "$1" >/dev/null 2>&1
}

requireCommand() {
  if ! hasCommand "$1"; then
    fail "Comando não encontrado: $1"
    return 1
  fi
}

edevHelp() {
  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "🚀 Emmanuel DevKit - edev"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "edev help                         Mostra ajuda"
  echo "edev version                      Mostra versao instalada"
  echo "edev update                       Atualiza o DevKit via git pull"
  echo "edev migrate                      Executa ajustes automaticos de instalacao"
  echo "edev doctor                       Verifica ambiente"
  echo ""
  echo "Atalhos:"
  echo "  atalhos                           Mostra os atalhos rápidos do terminal"
  echo ""
  echo "Setup:"
  echo "  edev setup base                 Instala pacotes base"
  echo "  edev setup node                 Instala Node/NVM"
  echo "  edev setup java-legacy          Instala ambiente Java legado"
  echo "  edev setup java-modern          Instala ambiente Java moderno"
  echo "  edev setup servers              Instala Tomcat e WildFly/JBoss"
  echo "  edev setup all                  Instala tudo"
  echo ""
  echo "Java:"
  echo "  edev java info                  Mostra Java ativo"
  echo "  edev java install temurin-17    Instala versão Java"
  echo "  edev java use temurin-17        Define Java global"
  echo ""
  echo "Servidores:"
  echo "  edev server tomcat start        Inicia Tomcat"
  echo "  edev server tomcat stop         Para Tomcat"
  echo "  edev server tomcat log          Mostra log Tomcat"
  echo "  edev server jboss start         Inicia WildFly/JBoss"
  echo "  edev server jboss stop          Para WildFly/JBoss"
  echo "  edev server jboss log           Mostra log WildFly/JBoss"
  echo "  edev server tomcat deploy       Deploy do projeto atual no Tomcat"
  echo "  edev server jboss deploy        Deploy do projeto atual no WildFly/JBoss"
  echo ""
  echo "Project:"
  echo "  edev project info               Mostra informacoes do projeto atual"
  echo ""
  echo "Config:"
  echo "  edev config list                Lista configuracoes globais"
  echo "  edev config get chave           Mostra valor de uma configuracao"
  echo "  edev config set chave valor     Define configuracao global"
  echo "  edev config unset chave         Remove configuracao"
  echo "  edev config path                Mostra caminho do arquivo config"
  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""
}

edevDoctor() {
  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "🩺 Emmanuel DevKit Doctor"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

  for commandName in git curl wget unzip zip java mvn ant docker node npm mise; do
    if hasCommand "$commandName"; then
      ok "$commandName encontrado"
    else
      warn "$commandName não encontrado"
    fi
  done

  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""
}
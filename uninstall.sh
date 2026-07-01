#!/usr/bin/env bash

set -e

if [[ "$SHELL" == *"zsh"* ]]; then
  RC_FILE="$HOME/.zshrc"
else
  RC_FILE="$HOME/.bashrc"
fi

START_MARK="# >>> Emmanuel DevKit >>>"
END_MARK="# <<< Emmanuel DevKit <<<"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🗑️  Emmanuel DevKit Uninstall"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if [[ ! -f "$RC_FILE" ]]; then
  echo "Arquivo de shell não encontrado: $RC_FILE"
  exit 0
fi

if grep -q "$START_MARK" "$RC_FILE"; then
  cp "$RC_FILE" "$RC_FILE.bkp-edev-uninstall"

  sed -i "/$START_MARK/,/$END_MARK/d" "$RC_FILE"

  echo "✅ Bloco do Emmanuel DevKit removido de: $RC_FILE"
  echo "📦 Backup criado em: $RC_FILE.bkp-edev-uninstall"
else
  echo "⚠️  Bloco do Emmanuel DevKit não encontrado em: $RC_FILE"
fi

echo ""
echo "Para aplicar no terminal atual, rode:"
echo "source $RC_FILE"
echo ""
echo "O diretório do projeto não foi apagado."
echo "Se quiser remover manualmente:"
echo "rm -rf \"${EDEV_HOME:-CAMINHO_DO_EMMANUEL_DEVKIT}\""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

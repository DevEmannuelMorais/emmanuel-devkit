#!/usr/bin/env bash

set -e

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BIN_FILE="$PROJECT_DIR/bin/edev"

chmod +x "$BIN_FILE"

if [[ "$SHELL" == *"zsh"* ]]; then
  RC_FILE="$HOME/.zshrc"
else
  RC_FILE="$HOME/.bashrc"
fi

START_MARK="# >>> Emmanuel DevKit >>>"
END_MARK="# <<< Emmanuel DevKit <<<"

if grep -q "$START_MARK" "$RC_FILE" 2>/dev/null; then
  echo "Emmanuel DevKit já está configurado em $RC_FILE"
else
  {
  echo ""
  echo "$START_MARK"
  echo "export EDEV_HOME=\"$PROJECT_DIR\""
  echo "export PATH=\"\$EDEV_HOME/bin:\$PATH\""
  echo "[[ -f \"\$EDEV_HOME/shell/edev.zsh\" ]] && source \"\$EDEV_HOME/shell/edev.zsh\""
  echo "$END_MARK"
} >> "$RC_FILE"

  echo "Emmanuel DevKit instalado em $RC_FILE"
fi

echo ""
echo "Recarregue o terminal:"
echo "source $RC_FILE"
echo ""
echo "Depois execute:"
echo "edev help"
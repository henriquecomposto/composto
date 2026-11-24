#!/bin/bash
# Hook do subagent devops: impede que ele edite o código do app (pasta src/).
# Recebe o JSON da ferramenta (Edit/Write) pela entrada padrão.
f=$(jq -r '.tool_input.file_path // empty')
raiz="${CLAUDE_PROJECT_DIR:-$(pwd)}"
case "$f" in
  "$raiz"/src/*|src/*)
    echo "O devops não edita o código do app (src/). Descreva a mudança no relatório para a sessão principal fazer." >&2
    exit 2
    ;;
esac
exit 0

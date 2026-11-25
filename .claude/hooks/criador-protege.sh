#!/bin/bash
# Hook do subagent criador: lista do que ele pode gravar; todo o resto é bloqueado.
# - Liberado: .claude/agents/, .claude/skills/ e .claude/README.md.
# - Bloqueado mesmo assim: os arquivos do próprio criador (agents/criador.md e a pasta
#   skills/criador/, onde fica a referencia.md). Eles só mudam na conversa principal.
# O criador não tem Bash, então basta cuidar de Edit e Write.
# Recebe o JSON da ferramenta pela entrada padrão. Sair com código 2 = bloquear.

entrada=$(cat)
ferramenta=$(jq -r '.tool_name // empty' <<<"$entrada")
[[ "$ferramenta" == "Edit" || "$ferramenta" == "Write" ]] || exit 0

raiz="${CLAUDE_PROJECT_DIR:-$(pwd)}"
f=$(jq -r '.tool_input.file_path // empty' <<<"$entrada")

bloquear() {
  echo "O criador só grava em .claude/agents/, .claude/skills/ e .claude/README.md: $1 Se precisar de mudança fora disso, descreva-a no relatório, em \"Para esta conversa fazer\"." >&2
  exit 2
}

[[ -n "$f" ]] || bloquear "a ferramenta não informou o arquivo."

# Caminho relativo à raiz do projeto (aceita caminho completo ou relativo)
rel=${f#"$raiz"/}
rel=${rel#./}
case "/$rel/" in
  */../*|*/./*|*//*) bloquear "caminho com \"..\", \".\" ou barra dupla ($f)." ;;
esac

# Em minúsculas: o disco do Mac não diferencia maiúsculas (CRIADOR.md = criador.md)
min=$(tr '[:upper:]' '[:lower:]' <<<"$rel")

case "$min" in
  .claude/agents/criador.md|.claude/skills/criador|.claude/skills/criador/*)
    bloquear "os arquivos do próprio criador (inclusive a referencia.md) só mudam na conversa principal." ;;
  .claude/agents/?*|.claude/skills/?*|.claude/readme.md)
    exit 0 ;;
esac

bloquear "$rel está fora da lista permitida."

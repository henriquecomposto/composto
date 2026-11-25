#!/bin/bash
# Hook do subagent devops: impede que ele altere o código do app (pasta src/).
# - Edit/Write: bloqueia arquivos dentro de src/.
# - Bash: se o comando cita src/, só passa se for de leitura (ls, cat, grep, git diff...).
#   Também bloqueia comandos que reescrevem o projeto todo sem citar src/
#   (lint --fix, prettier --write, codemods, shadcn, git restore/clean/stash...).
# Recebe o JSON da ferramenta pela entrada padrão. Sair com código 2 = bloquear.

entrada=$(cat)
ferramenta=$(jq -r '.tool_name // empty' <<<"$entrada")
raiz="${CLAUDE_PROJECT_DIR:-$(pwd)}"

bloquear() {
  echo "O devops não altera o código do app (src/): $1 Para ler src/, use Read/Grep/Glob ou um comando só de leitura (ls, cat, grep), sem gravar nada. Se precisar de mudança lá, descreva-a no relatório para a sessão principal fazer." >&2
  exit 2
}

# ---------- Edit / Write ----------
if [[ "$ferramenta" == "Edit" || "$ferramenta" == "Write" ]]; then
  f=$(jq -r '.tool_input.file_path // empty' <<<"$entrada")
  case "$f" in
    "$raiz"/src|"$raiz"/src/*|src|src/*|./src|./src/*) bloquear "edição de arquivo dentro de src/." ;;
  esac
  exit 0
fi

[[ "$ferramenta" == "Bash" ]] || exit 0
cmd=$(jq -r '.tool_input.command // empty' <<<"$entrada")

# Normaliza: tira aspas e barras invertidas; troca o caminho do projeto por "./"
c=$(printf '%s' "$cmd" | tr -d "\"'\\\\")
c=${c//\~\//$HOME/}
c=${c//"$raiz"\//./}
c=${c//\$\{CLAUDE_PROJECT_DIR\}\//./}
c=${c//\$CLAUDE_PROJECT_DIR\//./}

# ---------- Comandos que reescrevem o projeto todo (inclusive src/) ----------
re_reescreve='(^|[[:space:]])--(fix|write)([[:space:]=]|$)|prettier[^;&|]*[[:space:]]-w([[:space:]]|$)|codemod|shadcn|(^|[^[:alnum:]_-])git[[:space:]]+(restore|clean|stash)([[:space:]]|$)|(^|[^[:alnum:]_-])git[[:space:]]+checkout([[:space:]][^;&|]*)?[[:space:]](--|\.)([[:space:]]|$)'
[[ "$c" =~ $re_reescreve ]] && bloquear "este comando pode reescrever arquivos de src/ mesmo sem citar a pasta."

# ---------- Comandos que citam a pasta src ----------
re_src='(^|[[:space:]=(<>|;&])(\.\.?/)*src(/|[[:space:];&|)<>]|$)'
[[ "$c" =~ $re_src ]] || exit 0

case "$c" in
  *'$('*|*'`'*) bloquear "comando com \$(...) ou crase que cita src/." ;;
esac

# Tira redirecionamentos inofensivos (2>&1, >/dev/null); se sobrar ">", o comando grava em arquivo
s=$(sed -E 's/[0-9]*>&[0-9-]//g; s/[0-9&]*>>?[[:space:]]*\/dev\/null//g' <<<"$c")
[[ "$s" == *">"* ]] && bloquear "o comando grava em arquivo (>) e cita src/."

# O comando só lê?
re_sort_grava='[[:space:]](-o|--output)'
re_inplace='[[:space:]](-[a-zA-Z]*i|--in-place)'
re_find_age='[[:space:]]-(delete|exec|execdir|ok|okdir|fprint|fprint0|fprintf|fls)[[:space:]]'
re_git_le='^(add|diff|log|status|show|blame|ls-files|grep|rev-parse|commit)$'
so_leitura() {
  local prog=$1; shift
  local resto=" $* "
  case "$prog" in
    cd|pwd|ls|cat|head|tail|less|more|wc|file|stat|du|tree|diff|cmp|grep|egrep|fgrep|rg|cut|tr|uniq|basename|dirname|realpath|echo|printf|test|true) return 0 ;;
    sort) [[ ! "$resto" =~ $re_sort_grava ]] ;;
    sed|awk) [[ ! "$resto" =~ $re_inplace ]] ;;
    find) [[ ! "$resto" =~ $re_find_age ]] ;;
    git) [[ "$1" =~ $re_git_le ]] ;;
    *) return 1 ;;
  esac
}

# Divide o comando em partes (&&, ||, ;, |, &) e confere cada uma
s=${s//&&/$'\n'}; s=${s//||/$'\n'}; s=${s//;/$'\n'}; s=${s//|/$'\n'}; s=${s//&/$'\n'}
while IFS= read -r parte; do
  read -r -a p <<<"$parte"
  [[ ${#p[@]} -eq 0 ]] && continue
  i=0
  while [[ $i -lt ${#p[@]} && "${p[$i]}" =~ ^[A-Za-z_][A-Za-z0-9_]*= ]]; do i=$((i+1)); done
  [[ $i -ge ${#p[@]} ]] && continue
  so_leitura "${p[@]:$i}" || bloquear "o comando cita src/ e não é só de leitura (${p[$i]})."
done <<<"$s"
exit 0

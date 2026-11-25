#!/bin/bash
# Hook do projeto (vale para a conversa principal e para os subagents):
# impede que o conteúdo dos arquivos .env (segredos) entre na conversa,
# seja por leitura de arquivo (Read), busca (Grep) ou comando no terminal (Bash).
# O .env.example (modelo sem segredos) continua liberado.
# Recebe o JSON da ferramenta pela entrada padrão. Sair com código 2 = bloquear.

entrada=$(cat)
ferramenta=$(jq -r '.tool_name // empty' <<<"$entrada")
raiz="${CLAUDE_PROJECT_DIR:-$(pwd)}"
pasta=$(jq -r '.cwd // empty' <<<"$entrada")
[[ -d "$pasta" ]] || pasta=$raiz

bloquear() {
  echo "Bloqueado para proteger os segredos do .env: $1 Se precisar de um valor do .env, peça ao usuário; o .env.example (modelo sem segredos) está liberado." >&2
  exit 2
}

# O nome é de um arquivo de segredos? (.env, .env.local, .env.production...; não o .env.example)
eh_env() {
  local nome=${1##*/}
  [[ "$nome" != ".env.example" ]] && [[ "$nome" == ".env" || "$nome" == .env.* || "$nome" == .env*.local ]]
}

# Alguma destas pastas tem um arquivo .env dentro? (ignora node_modules, .git e .next)
tem_env() {
  local d
  for d in "$@"; do
    [[ -d "$d" ]] || continue
    [[ -n $(find "$d" \( -name node_modules -o -name .git -o -name .next \) -prune -o \( -name '.env' -o -name '.env.*' -o -name '.env*.local' \) ! -name '.env.example' -print -quit 2>/dev/null) ]] && return 0
  done
  return 1
}

case "$ferramenta" in
  Read)
    eh_env "$(jq -r '.tool_input.file_path // empty' <<<"$entrada")" && bloquear "leitura de arquivo .env."
    exit 0 ;;
  Grep)
    eh_env "$(jq -r '.tool_input.path // empty' <<<"$entrada")" && bloquear "busca dentro de arquivo .env."
    filtro=$(jq -r '.tool_input.glob // empty' <<<"$entrada")
    [[ "$filtro" == *.env* && "$filtro" != *.env.example* ]] && bloquear "busca com filtro que inclui arquivos .env."
    exit 0 ;;
  Bash) ;;
  *) exit 0 ;;
esac

cmd=$(jq -r '.tool_input.command // empty' <<<"$entrada")
c=$(printf '%s' "$cmd" | tr -d "\"'\\\\")   # sem aspas nem barras invertidas
re_filtros='s/--(exclude|exclude-dir|include)(=|[[:space:]]+)[^[:space:]]*//g; s/(-g|--glob)(=|[[:space:]]+)![^[:space:]]*//g'

# 1) O comando cita um arquivo .env? (filtros como --exclude=.env* não contam)
while IFS= read -r t; do
  [[ -z "$t" ]] && continue
  t=${t#[!.]}
  [[ "$t" == *[*?[{]* ]] && bloquear "curinga que pode pegar um arquivo .env ($t)."
  eh_env "$t" && bloquear "comando que cita um arquivo .env ($t)."
done < <(sed -E "$re_filtros" <<<"$c" | grep -oE '(^|[^[:alnum:]_.])\.env[^[:space:];&|<>()]*')

# 2) Curinga que pega arquivos ocultos (ex.: cat .e*), fora de trechos entre aspas
sem_aspas=$(sed -E "s/'[^']*'//g; s/\"[^\"]*\"//g; $re_filtros" <<<"$cmd")
re_curinga_oculto='(^|[[:space:]/=<>(])\.[^[:space:]/;&|<>()]*[][*?{]'
[[ "$sem_aspas" =~ $re_curinga_oculto ]] && bloquear "curinga que pega arquivos ocultos (pode incluir o .env)."

# 3) Buscas que leem arquivos ignorados pelo Git
re_rg='(^|[[:space:]/])rg([[:space:]][^;&|]*)?[[:space:]](-[a-zA-Z]*u[a-zA-Z]*|--no-ignore[^[:space:]]*|--unrestricted)([[:space:]]|$)'
re_gitgrep='git[[:space:]]+grep[[:space:]].*--(no-index|untracked)'
[[ "$c" =~ $re_rg || "$c" =~ $re_gitgrep ]] && bloquear "busca que inclui arquivos ignorados pelo Git (como o .env)."

# 4) Busca recursiva com grep que passaria por um .env.
#    O grep do Claude Code entra em arquivos ocultos e, sem pasta, busca na pasta atual.
re_grep='(^|[[:space:]/])(grep|egrep|fgrep|ugrep|ug)[[:space:]]'
re_rec='[[:space:]](-[a-zA-Z]*[rR][a-zA-Z]*|--recursive|--dereference-recursive|--directories=recurse|-d[[:space:]]*recurse)([[:space:]]|$)'
re_exclui_env='--exclude(=|[[:space:]]+)\.env\*'
re_include='--include(=|[[:space:]]+)[^[:space:]]+'
re_palavra_grep='^(.*/)?(grep|egrep|fgrep|ugrep|ug)$'
re_padrao_em_opcao='[[:space:]](-[a-zA-Z]*[ef]|--regexp|--file)([[:space:]=]|$)'   # padrão passado com -e/-f
re_opcao_com_valor='^-[a-zA-Z]*[ABCmefdD]$'                                     # opção cujo valor vem a seguir
partes=$c; partes=${partes//&&/$'\n'}; partes=${partes//||/$'\n'}; partes=${partes//;/$'\n'}; partes=${partes//|/$'\n'}
while IFS= read -r parte; do
  [[ "$parte" =~ $re_grep ]] || continue
  [[ " $parte" =~ $re_rec ]] || continue
  [[ "$parte" =~ $re_exclui_env ]] && continue
  # --include=*.js restringe a busca: seguro se nenhum filtro casa com um nome de .env
  if [[ "$parte" =~ $re_include ]]; then
    seguro=1
    while IFS= read -r g; do
      g=${g#--include}; g=${g#=}; g=${g# }
      [[ .env == $g || .env.local == $g || .env.production == $g ]] && seguro=0
    done < <(grep -oE -- "$re_include" <<<"$parte")
    [[ $seguro == 1 ]] && continue
  fi
  # Pastas citadas no comando (ou a pasta atual, se nenhuma).
  # Pula a palavra buscada: no macOS, "SUPABASE" casaria com a pasta supabase/.
  read -r -a p <<<"$parte"
  k=0; while [[ $k -lt ${#p[@]} && ! "${p[$k]}" =~ $re_palavra_grep ]]; do k=$((k+1)); done
  [[ " $parte" =~ $re_padrao_em_opcao ]] && padrao_visto=1 || padrao_visto=0
  pastas=(); pula=0
  for t in "${p[@]:$((k+1))}"; do
    if [[ $pula == 1 ]]; then pula=0; continue; fi
    if [[ "$t" == -* ]]; then
      [[ "$t" =~ $re_opcao_com_valor ]] && pula=1
      continue
    fi
    if [[ $padrao_visto == 0 ]]; then padrao_visto=1; continue; fi
    t=${t/#\~/$HOME}; t=${t//\$\{HOME\}/$HOME}; t=${t//\$HOME/$HOME}
    t=${t//\$\{CLAUDE_PROJECT_DIR\}/$raiz}; t=${t//\$CLAUDE_PROJECT_DIR/$raiz}; t=${t//\$PWD/$pasta}
    [[ "$t" == /* ]] || t="$pasta/$t"
    [[ -d "$t" ]] && pastas+=("$t")
  done
  [[ ${#pastas[@]} -eq 0 ]] && pastas=("$pasta")
  tem_env "${pastas[@]}" && bloquear "busca recursiva que passaria pelo .env. Repita com --exclude='.env*' (ou busque numa subpasta, como src/)."
done <<<"$partes"
exit 0

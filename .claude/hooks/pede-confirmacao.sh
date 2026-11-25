#!/bin/bash
# Hook do projeto (vale para a conversa principal e para os subagents):
# força a caixa de confirmação na tela antes de:
#   - git push (enviar ao GitHub), em qualquer variação (ex.: git -C . push);
#   - supabase db push (aplicar migrations no banco), em qualquer variação (ex.: npx -y supabase db push);
#   - comandos que apagam arquivos (rm, rmdir, unlink, git rm, git clean, find -delete, rsync --delete...).
# Complementa as regras "ask" do settings.json, que só pegam o começo exato do comando.
# Recebe o JSON da ferramenta pela entrada padrão.

cmd=$(jq -r '.tool_input.command // empty')
c=$(printf '%s' "$cmd" | tr -d "\"'\\\\")

re_push='(^|[^[:alnum:]_./-])git[[:space:]]([^;&|]*[[:space:]])?push([[:space:]]|$)'
re_db='supabase[^[:space:]]*[[:space:]]([^;&|]*[[:space:]])?db[[:space:]]+push([[:space:]]|$)'
re_apaga='(^|[[:space:];&|(/])(rm|rmdir|unlink|shred|srm|trash|rimraf)([[:space:]]|$)|[[:space:]]-delete([[:space:]]|$)|(^|[^[:alnum:]_-])git[[:space:]]+clean([[:space:]]|$)|[[:space:]]--delete([[:space:]]|$)'

motivo=""
[[ "$c" =~ $re_push ]] && motivo="git push (envia os commits para o GitHub)"
[[ -z "$motivo" && "$c" =~ $re_db ]] && motivo="supabase db push (aplica as migrations no banco de produção)"
[[ -z "$motivo" && "$c" =~ $re_apaga ]] && motivo="comando que apaga arquivos"
[[ -z "$motivo" ]] && exit 0

jq -n --arg m "Confirmação obrigatória: $motivo." \
  '{hookSpecificOutput: {hookEventName: "PreToolUse", permissionDecision: "ask", permissionDecisionReason: $m}}'
exit 0

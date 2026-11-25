# Referência: criar subagents e skills no Claude Code

Consultada em: **2026-11-25**. Revisar a partir de 2027-02-25 (3 meses).

Fontes:
- https://code.claude.com/docs/en/sub-agents
- https://code.claude.com/docs/en/skills
- https://code.claude.com/docs/en/hooks
- https://code.claude.com/docs/en/best-practices
- https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/claude-prompting-best-practices

Resumo só do que muda uma decisão na hora de criar um agente. Itens com "(não confirmado)" não estavam no trecho lido das páginas: se forem decisivos, anote no relatório.

## Subagent ou skill?

- **Skill:** procedimento ou conhecimento que o Claude não acha sozinho. Custa pouco: só nome e descrição ficam no contexto até ela ser usada.
- **Subagent:** tirar saída longa da conversa principal, restringir ferramentas, trabalho em paralelo ou revisão independente (quem não viu a escrita acha o que o autor não vê).
- Subagent gasta tokens próprios e precisa reunir o contexto de novo: para tarefa simples, não compensa.
- Não escreva o que o Claude descobre lendo o código.

## Subagent: `.claude/agents/<nome>.md`

- A pasta é lida inteira, inclusive subpastas. A identidade vem do campo `name`, não do nome do arquivo.
- Arquivo sem cabeçalho, sem `name`, sem `description` ou com YAML inválido é ignorado. Por isso material de apoio não fica nessa pasta.
- O corpo do arquivo vira o system prompt. O subagent não vê a conversa nem o system prompt do Claude Code.
- Campo desconhecido é ignorado sem erro: confira a grafia (camelCase).

| Campo | Para que serve | Neste projeto |
|---|---|---|
| `name` | Identificador único; sem `:` | Português, uma palavra |
| `description` | Quando o Claude deve delegar | O que faz + quando usar; curta |
| `tools` | Lista de ferramentas permitidas (`Read, Grep` ou lista YAML); omitido = herda todas | Sempre declarar, o mínimo |
| `disallowedTools` | Remove ferramentas da lista | Raramente |
| `model` | `haiku`, `sonnet`, `opus`, `fable`, `inherit` ou ID completo | `haiku` mecânico; `inherit` quando precisa julgar ou escrever |
| `permissionMode` | `default`, `acceptEdits`, `auto`, `dontAsk`, `plan`... | Não usar: valem as permissões do usuário |
| `maxTurns` | Limite de turnos | Só se houver risco de laço |
| `skills` | Pré-carrega skills inteiras no contexto | Evitar: custa contexto |
| `hooks` | Hooks enquanto o subagent roda | Travas de escrita; criadas na conversa principal |
| `memory` | Memória entre sessões (`user`, `project`, `local`) | Não usar por ora |
| `omitClaudeMd` | Não carrega o CLAUDE.md | Só se ele não precisar das regras do projeto |
| `color` | `red`, `blue`, `green`, `yellow`, `purple`, `orange`, `pink`, `cyan` | Opcional |
| `mcpServers`, `background`, `effort`, `isolation`, `initialPrompt`, `autoCompactWindow` | Casos avançados | Não usar |

- **Subagent chamando subagent:** possível se `Agent` estiver em `tools`; `Agent(nome1, nome2)` limita quais. Há limite de profundidade (número não confirmado). Neste projeto, não dar `Agent`: a conversa principal orquestra.
- Subagents em segundo plano têm um conjunto reduzido de ferramentas.

## Skill: `.claude/skills/<nome>/SKILL.md`

| Campo | Para que serve | Neste projeto |
|---|---|---|
| `name` | Nome do `/comando`; padrão: nome da pasta | Igual à pasta |
| `description` | O que faz e quando usar | Curta |
| `when_to_use` | Gatilhos extras, somados à description | Raramente |
| `argument-hint` | Dica no autocompletar, ex.: `"<pedido>"` | Sempre que receber argumento |
| `arguments` | Nomes dos argumentos (`$nome`) | Raramente |
| `disable-model-invocation` | `true`: só o usuário chama, por `/nome` | Tudo com efeito colateral e todo atalho de subagent |
| `user-invocable` | `false`: some do menu `/`; só o Claude usa | Conhecimento de fundo |
| `allowed-tools` | Libera ferramentas sem perguntar, no turno da skill | Evitar: as permissões ficam no settings.json |
| `disallowed-tools` | Remove ferramentas enquanto a skill está ativa | Raramente |
| `model`, `effort` | Modelo e esforço do turno | Raramente |
| `context: fork` + `agent` | Roda a skill dentro de um subagent (padrão `general-purpose`) | Atalho /nome de um subagent |
| `background` | Com fork: `false` espera o resultado | Não usar |
| `hooks` | Hooks registrados ao chamar a skill | Só na conversa principal |
| `paths` | Arquivos que ativam a skill | Raramente |

- **Com `context: fork`:** o texto do SKILL.md vira a tarefa do subagent, que não vê a conversa. As instruções precisam se bastar.
- **Variáveis:** `$ARGUMENTS` (tudo o que foi digitado), `$0`, `$1`... (por posição), `${CLAUDE_SKILL_DIR}` (pasta da skill), `${CLAUDE_PROJECT_DIR}` (raiz). Sem nenhuma variável, o Claude Code acrescenta `ARGUMENTS: <entrada>` ao fim.
- **Arquivos de apoio:** ficam na pasta da skill, citados com link relativo (`[referencia.md](referencia.md)`), e são lidos só quando necessário.
- **Tamanho:** a documentação pede menos de 500 linhas; neste projeto, menos de ~60. `description` + `when_to_use` são cortadas em 1.536 caracteres.

| Cabeçalho | Usuário chama | Claude chama | Descrição no contexto |
|---|---|---|---|
| padrão | sim | sim | sim |
| `disable-model-invocation: true` | sim | não | não |
| `user-invocable: false` | não | sim | sim |

## Como um agente novo passa a valer

- **Subagent** novo ou editado: detectado em poucos segundos, sem reiniciar. Se não aparecer, reinicie o Claude Code.
- **Skill**: a pasta `.claude/skills/` é observada e a mudança vale na sessão atual. Se não aparecer no `/`, rode `/reload-skills`.
- `/agents` nas versões recentes só mostra um lembrete; não é mais um assistente de criação.
- Hooks de subagents do projeto só rodam depois de o usuário confiar na pasta.

## Hooks no cabeçalho

```yaml
hooks:
  PreToolUse:
    - matcher: "Edit|Write"
      hooks:
        - type: command
          command: "bash \"$CLAUDE_PROJECT_DIR/.claude/hooks/<script>.sh\""
```

- Eventos comuns em subagent: `PreToolUse`, `PostToolUse`, `Stop`. O `matcher` filtra pelo nome da ferramenta.
- O script recebe um JSON na entrada padrão: `tool_name`, `tool_input` (em Edit/Write, `tool_input.file_path`), `cwd`, `agent_type`...
- O caminho em `file_path` vir completo ou relativo não foi confirmado: o script deve aceitar os dois (ver `.claude/hooks/devops-protege-src.sh`).
- **Código de saída:** `0` segue o fluxo normal de permissões; `2` bloqueia e o texto do stderr vai para o Claude como motivo; outros códigos são erro que não bloqueia.
- `$CLAUDE_PROJECT_DIR` aponta para a raiz do projeto.

## Escrevendo as instruções

- Clareza: um colega sem contexto entenderia? Se não, o Claude também não.
- Explique o porquê de cada regra: o Claude generaliza a partir do motivo.
- Diga o que fazer, não só o que evitar.
- Tom normal: CAIXA ALTA, "IMPORTANTE" e "NUNCA" fazem os modelos atuais exagerarem.
- Instruções condicionais ("se X, faça Y") em vez de "na dúvida, use a ferramenta", que leva ao uso excessivo.
- Limite o escopo: "faça só o que foi pedido ou é claramente necessário".
- Uma frase de papel no começo já orienta foco e tom.
- Termine com um formato de resposta fixo e curto.
- Revisor: peça para ignorar estilo; senão ele sempre acha algo e gera mudanças sem necessidade.

## Exemplos mínimos

Subagent (`.claude/agents/exemplo.md`):

```markdown
---
name: exemplo
description: Resume X e devolve só Y. Use quando o usuário pedir Z.
tools: Read, Grep, Glob
model: haiku
---

Você <papel> no Composto. Responda em português.
1. <passo, com o porquê>
## Resposta final
- <formato curto>
```

Atalho (`.claude/skills/exemplo/SKILL.md`):

```markdown
---
name: exemplo
description: Chama o subagent exemplo para <tarefa>.
disable-model-invocation: true
argument-hint: "<o que você precisa>"
context: fork
agent: exemplo
---

Pedido do usuário: $ARGUMENTS

- Se o pedido estiver vazio, responda em até 4 linhas o que você faz.
- Você não vê a conversa principal: trabalhe só com o pedido e os arquivos.
```

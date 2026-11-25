# Pasta `.claude`: configuração do Claude Code

Este guia é para pessoas: o Claude Code não carrega este arquivo sozinho. As regras do dia a dia ficam no `CLAUDE.md`, na raiz do projeto.

## O que tem aqui

```
.claude/
├── README.md              este guia
├── skills/                receitas acionadas com /nome
│   ├── versao/SKILL.md       /versao      → prepara e publica uma versão
│   ├── encerrar/SKILL.md     /encerrar    → registra "Onde paramos" no TAREFAS.md
│   ├── devops/SKILL.md       /devops      → chama o subagent devops
│   ├── verificador/SKILL.md  /verificador → chama o subagent verificador
│   └── prompt/SKILL.md       /prompt      → chama o subagent prompt
├── agents/                ajudantes (subagents) que trabalham à parte
│   ├── verificador.md     roda lint e build e devolve só o resumo (só lê)
│   ├── devops.md          cuida da infraestrutura (Supabase, deploy, dependências)
│   └── prompt.md          transforma um pedido solto num prompt completo (só lê)
├── hooks/
│   └── devops-protege-src.sh  impede o devops de editar o código do app (src/)
├── settings.json          permissões do projeto (vai para o Git)
└── settings.local.json    preferências pessoais, se existir (fora do Git)
```

## Permissões (`settings.json`)

- **Liberado sem perguntar:** comandos que só leem ou conferem (`git status/diff/log`, `npm run lint/build/dev`, criar migration).
- **Sempre pergunta:** o que publica ou altera o Git e o banco (`git commit`, `git push`, tag de versão, `supabase db push`/`link`).
- **Bloqueado:** ler o `.env` (os segredos não entram na conversa) e ações sem volta (`git push --force`, `git reset --hard`, `rm -rf`, `supabase db reset`, apagar projeto).
- Preferência só sua, para este projeto? Use `settings.local.json`, que fica fora do Git.

## Como usar

| Quando | Digite |
|---|---|
| Uma fase terminou e você quer lançar uma versão | `/versao` (ou `/versao minor`, `/versao 0.2.0`) |
| Vai fechar o Claude Code ou dar `/clear` | `/encerrar` |
| Precisa de algo de infraestrutura | `/devops <pedido>` (ex.: `/devops cria a migration da tabela de perfis`) |
| Quer conferir se o código está saudável | `/verificador` |
| Quer um prompt bem escrito para pedir algo ao Claude Code | `/prompt <pedido>` (ex.: `/prompt quero uma tela de cadastro`) |

O `/devops`, o `/verificador` e o `/prompt` rodam o subagent à parte: ele **não vê a conversa**, então escreva no pedido tudo o que ele precisa saber. Ações sem volta (ex.: aplicar migration no banco) só acontecem se o pedido trouxer o seu "ok"; senão, ele devolve o plano.

Também continua valendo pedir em texto livre ("pede para o devops…", "roda o verificador"): aí a conversa principal chama o subagent e já passa o contexto. A `/versao` usa o verificador sozinha.

### Quem faz o quê

| Quem | Faz | Não faz |
|---|---|---|
| Conversa principal | Código do app (`src/`), conversa com você, configuração do Claude Code | — |
| `verificador` | Roda lint e build e resume o resultado | Não altera nada |
| `prompt` | Escreve prompts claros para o Claude Code, com arquivos e regras do projeto | Não executa a tarefa, não altera arquivos, não decide produto (lista as dúvidas) |
| `devops` | Supabase (migrations, RLS, storage), `.env.example`, dependências, configuração, deploy | Não edita `src/` (bloqueado por hook), não decide produto, não faz ação sem volta sem o seu "ok" |

Para usar: "pede para o devops criar a migration de X".

## Skills ou commands?

A pasta `.claude/commands/` é o formato antigo. Hoje as **skills** fazem tudo o que os commands faziam (também viram `/nome`) e ainda podem ter arquivos de apoio. Por isso, aqui só usamos `skills/`.

## Convenções (para criar novas)

**Quando criar**
- **Skill:** quando um processo se repete e tem passos que não podem ser esquecidos.
- **Subagent:** quando uma tarefa gera muita saída (logs, buscas grandes) e só o resultado importa.
- Não crie antes de precisar.

**Economia de tokens**
- O `CLAUDE.md` é lido em **toda** mensagem. Só ficam nele as regras do dia a dia; passo a passo de processos raros vai para uma skill.
- Skills com `disable-model-invocation: true` não custam nada até você digitar `/nome`. Use isso em tudo que tem efeito colateral (commit, push, publicar): assim o usuário também mantém o controle.
- O `SKILL.md` deve ter menos de ~60 linhas. Material de consulta longo vai para outro arquivo na mesma pasta, que a skill manda ler só quando precisar.
- Subagents mecânicos (rodar comandos, resumir saídas) usam `model: haiku` e só as ferramentas necessárias (`tools:`).

**Nomes:** em português, curtos, uma palavra: `versao`, `encerrar`, `verificador`.

**Gestão conjunta:** toda skill que altera o Git, o banco ou algo publicado deve ter um ponto de parada explícito pedindo o "ok" do usuário.

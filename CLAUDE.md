# CLAUDE.md

Contexto e regras para o Claude Code trabalhar neste repositório.

## Regra principal: TAREFAS.md

**Sempre consulte [TAREFAS.md](TAREFAS.md) antes de começar qualquer trabalho** para checar o que já foi feito e o que vem a seguir.

- Ao iniciar uma tarefa, marque-a como em andamento (`[~]`).
- Ao concluir, marque como feita (`[x]`) e registre a data.
- Se surgir trabalho novo, adicione-o à lista antes de executá-lo.
- Não pule etapas sem combinar com o usuário.

## Sobre o projeto

- **Nome:** Composto
- **Tipo:** webapp
- **Fase:** greenfield (começando do zero)
- **Idioma de comunicação e documentação:** português (Brasil)

## Stack (decidida)

- **JavaScript** como linguagem
- **Next.js** (React no front-end, Node.js no servidor)
- **Supabase cloud** para:
  - Autenticação (Supabase Auth)
  - Banco de dados (Postgres)
  - Armazenamento de arquivos (Storage)
- **Git + GitHub**, usado pelo usuário via GitHub Desktop
  - Repositório: `github.com/henriquecomposto/composto`, branch principal `main`

## Registro de decisões

| Data | Decisão |
|---|---|
| 2026-11-19 | Histórico antigo do repositório apagado; projeto recomeçado do zero. |
| 2026-11-19 | Stack definida: JavaScript + Next.js (React/Node) + Supabase cloud (auth, banco, storage). |
| 2026-11-19 | Documentar o processo antes de codar: README.md, CLAUDE.md, .env e TAREFAS.md. |

Adicione novas decisões nesta tabela conforme forem tomadas.

## Segurança e variáveis de ambiente

- Segredos ficam **apenas** no `.env`, que **nunca** vai para o Git.
- Variáveis com prefixo `NEXT_PUBLIC_` são expostas no navegador: nunca coloque chaves secretas nelas.
- `SUPABASE_SECRET_KEY` só pode ser usada em código de servidor.
- Toda tabela no Supabase deve ter **RLS (Row Level Security)** habilitado.

## Convenções de trabalho

- Commits e pushes só quando o usuário pedir.
- Explicar os passos de forma clara: o usuário está montando o ambiente pela primeira vez.

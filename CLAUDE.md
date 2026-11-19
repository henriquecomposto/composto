# CLAUDE.md

Contexto e regras para o Claude Code trabalhar neste repositório.

@AGENTS.md

> O `AGENTS.md` é gerado pelo Next.js: antes de escrever código Next.js, consulte a documentação da versão instalada em `node_modules/next/dist/docs/`.

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
- **Projeto Supabase:** "composto", ref `rftiytwglwqltrffrjsq`, região `sa-east-1` (São Paulo)
  - Senha do banco gerada automaticamente e guardada em `SUPABASE_DB_PASSWORD` no `.env`
  - CLI do Supabase usada via `npx supabase` (login já feito no computador do usuário)
  - O login da CLI exige terminal interativo: rodar no app Terminal do Mac, não com `!` no Claude Code
- **Git + GitHub**, usado pelo usuário via GitHub Desktop
  - Repositório: `github.com/henriquecomposto/composto`, branch principal `main`

## Registro de decisões

| Data | Decisão |
|---|---|
| 2026-11-19 | Histórico antigo do repositório apagado; projeto recomeçado do zero. |
| 2026-11-19 | Stack definida: JavaScript + Next.js (React/Node) + Supabase cloud (auth, banco, storage). |
| 2026-11-19 | Documentar o processo antes de codar: README.md, CLAUDE.md, .env e TAREFAS.md. |
| 2026-11-19 | Projeto Supabase "composto" criado na região São Paulo (sa-east-1), pela menor latência para usuários no Brasil. Substitui o primeiro projeto ("o grande composto", us-east-2), que deve ser apagado. |
| 2026-11-19 | Next.js com Tailwind CSS e código dentro da pasta `src/`. |
| 2026-11-19 | Versionamento Semântico (SemVer): tag `vX.Y.Z` + release no GitHub + entrada no `CHANGELOG.md` + `version` no `package.json`, sempre juntos. Primeira versão: `v0.1.0` (fundação: Fases 0 a 2). |

Adicione novas decisões nesta tabela conforme forem tomadas.

## Código: onde fica cada coisa

- Versões instaladas: Next.js 16.4, React 19.3, Tailwind CSS 4.3, `@supabase/ssr` 0.12, `@supabase/supabase-js` 2.x
- `src/lib/supabase/client.js`: cliente para Client Components (navegador)
- `src/lib/supabase/server.js`: cliente para Server Components, Server Functions e Route Handlers; criar um novo a cada uso
- `src/lib/supabase/proxy.js` + `src/proxy.js`: renovam a sessão a cada requisição (no Next 16, `middleware` virou `proxy`)
- Para checar o usuário no servidor, use `supabase.auth.getClaims()` (valida o token); não confie em `getSession()` no servidor
- Cache Components está ativo por padrão nesta versão do Next.js

## Segurança e variáveis de ambiente

- Segredos ficam **apenas** no `.env`, que **nunca** vai para o Git.
- Variáveis com prefixo `NEXT_PUBLIC_` são expostas no navegador: nunca coloque chaves secretas nelas.
- `SUPABASE_SECRET_KEY` só pode ser usada em código de servidor.
- Toda tabela no Supabase deve ter **RLS (Row Level Security)** habilitado.

## Convenções de trabalho

- Commits e pushes só quando o usuário pedir.
- Explicar os passos de forma clara: o usuário está montando o ambiente pela primeira vez.

# CLAUDE.md

Contexto e regras para o Claude Code trabalhar neste repositório.

@AGENTS.md

> O `AGENTS.md` é gerado pelo Next.js: antes de escrever código Next.js, consulte a documentação da versão instalada em `node_modules/next/dist/docs/`.

## Regra principal: TAREFAS.md

**Sempre consulte [TAREFAS.md](TAREFAS.md) antes de começar qualquer trabalho** para checar o que já foi feito e o que vem a seguir.

- A lista tem só entregas (uma tela, uma tabela, um deploy), trabalho de mais de uma sessão ou o que depende de decisão do usuário. Ajustes pequenos não entram: ficam na mensagem do commit.
- Ao iniciar uma tarefa da lista, marque `[~]`; ao concluir, `[x]` com a data. Fase concluída vira uma linha em "Concluído".
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

## Decisões

- Histórico em [DECISOES.md](DECISOES.md) (não é carregado automaticamente; ler só quando precisar do porquê de algo).
- Registrar lá só decisões de produto ou de arquitetura, com o porquê. Regra nova em vigor também entra aqui no CLAUDE.md.

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

## Versões e releases

- Versionamento Semântico. O passo a passo completo está na skill `/versao`.
- **Ao concluir uma fase do TAREFAS.md**, sugerir ao usuário rodar `/versao`. Só publicar com o "ok" explícito dele.

## Skills e subagents

- Skills em `.claude/skills/`, subagents em `.claude/agents/`. Antes de criar ou alterar um deles, ler as convenções em `.claude/README.md`.
- Para conferir lint e build, usar o subagent `verificador` (a saída longa fica fora da conversa).
- Infraestrutura (Supabase, migrations, deploy, dependências, configuração do projeto): delegar ao subagent `devops`. Código do app (`src/`) fica na conversa principal.

## Convenções de trabalho

- Commits e pushes só quando o usuário pedir.
- Explicar os passos de forma clara: o usuário está montando o ambiente pela primeira vez.

### Gestão conjunta (usuário + Claude)

1. **Registrar onde paramos.** Ao fim de cada sessão (ou antes de um `/clear`), o usuário roda `/encerrar`, que atualiza a seção "Onde paramos" do TAREFAS.md. Se a sessão parecer estar terminando, lembrar o usuário disso. O Claude não lembra das conversas anteriores; a continuidade depende desse registro.
2. **Confirmar antes de ações sem volta.** Antes de apagar dados, alterar o banco em produção, fazer deploy ou mudar configurações no painel do Supabase, explicar o que vai acontecer e o impacto, e esperar o "ok" do usuário.
3. **Banco de dados só por migrations.** Toda mudança de estrutura no banco (tabelas, colunas, políticas RLS) vira um arquivo em `supabase/migrations/`, versionado no Git. Nada de alterar a estrutura direto pelo painel do Supabase.
4. **"Como conferir" ao fim de cada entrega.** Terminar cada tarefa explicando, em linguagem simples, como o usuário testa no navegador o que foi feito.
5. **Decisões de produto são do usuário.** Textos, fluxos e o que o usuário final vê: perguntar em vez de escolher sozinho. Decisões técnicas: o Claude decide e explica o porquê.

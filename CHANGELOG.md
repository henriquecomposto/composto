# Changelog

Todas as mudanças relevantes do Composto são registradas neste arquivo.

O formato segue o [Keep a Changelog](https://keepachangelog.com/pt-BR/1.1.0/)
e o projeto adota o [Versionamento Semântico](https://semver.org/lang/pt-BR/).

## [Não lançado]

## [0.1.0] - 2026-11-19

Primeira versão do Composto: a fundação técnica do webapp. Esta versão ainda
não tem funcionalidades para o usuário final. Ela entrega a aplicação base,
a integração com o Supabase e a documentação que guiam as próximas fases
(autenticação, banco de dados, storage e deploy).

### Adicionado

- **Aplicação web** em Next.js 16.4 (App Router) com React 19.3 e
  Tailwind CSS 4.3, código organizado em `src/`.
- **Integração com o Supabase** (projeto `composto`, região São Paulo,
  `sa-east-1`):
  - cliente para o navegador (`src/lib/supabase/client.js`);
  - cliente para o servidor, usado em Server Components, Server Functions
    e Route Handlers (`src/lib/supabase/server.js`);
  - renovação automática da sessão a cada requisição, via `proxy`
    (`src/proxy.js` e `src/lib/supabase/proxy.js`).
- **Qualidade de código:** ESLint configurado com as regras do Next.js.
- **Documentação do projeto:**
  - `README.md` com stack, pré-requisitos, configuração e comandos;
  - `CLAUDE.md` com contexto, regras de trabalho e registro de decisões;
  - `TAREFAS.md` com o roteiro do projeto por fases;
  - `CHANGELOG.md` (este arquivo).
- **Segurança:** `.gitignore` impede o envio de segredos (`.env`),
  dependências e arquivos de build para o repositório.

### Notas técnicas

- No Next.js 16, o antigo `middleware` passou a se chamar `proxy`.
- No servidor, a identidade do usuário é validada com
  `supabase.auth.getClaims()`, que confere o token. `getSession()` não é
  usado para essa checagem.
- Cache Components vem ativo por padrão nesta versão do Next.js.

[Não lançado]: https://github.com/henriquecomposto/composto/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/henriquecomposto/composto/releases/tag/v0.1.0

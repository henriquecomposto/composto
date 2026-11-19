# Tarefas — Composto

Legenda: `[ ]` a fazer · `[~]` em andamento · `[x]` feito

> Consultar este arquivo antes de cada etapa. Atualizar ao iniciar e ao concluir tarefas.

## Onde paramos

_Atualizado em 2026-11-19._

- **Última entrega:** versão `v0.1.0` publicada no GitHub (fundação: Fases 0 a 2) e regras de gestão conjunta registradas no CLAUDE.md.
- **Pela metade:** nada.
- **Próximo passo:** Fase 3, começando por definir os métodos de login (decisão do usuário).
- **Pendência paralela:** apagar o projeto antigo "o grande composto" no Supabase.

## Fase 0: Preparação

- [x] Instalar Git, Node.js e GitHub Desktop (2026-11-19)
- [x] Limpar o histórico antigo do repositório (2026-11-19)
- [x] Definir a stack: JavaScript, Next.js, Supabase cloud (2026-11-19)
- [x] Criar a documentação inicial: README.md, CLAUDE.md, .env, TAREFAS.md (2026-11-19)
- [x] Criar o `.gitignore` (proteger `.env`, `node_modules`, `.next`, `.DS_Store`) (2026-11-19)
- [x] Primeiro commit da documentação e push para o GitHub (2026-11-19)

## Fase 1: Supabase

- [x] Criar conta e projeto no Supabase cloud: "composto", região São Paulo / sa-east-1 (2026-11-19)
- [ ] Apagar o projeto antigo "o grande composto" (us-east-2)
- [x] Fazer login na CLI do Supabase no computador (2026-11-19)
- [x] Copiar URL e chaves para o `.env` e testar a conexão (2026-11-19)

## Fase 2: Projeto Next.js

- [x] Decidir as opções de criação: JavaScript, App Router, Tailwind CSS, ESLint, pasta `src/`, npm (2026-11-19)
- [x] Criar o app Next.js (`create-next-app`): Next 16.4, React 19.3, Tailwind 4.3 (2026-11-19)
- [x] Rodar localmente e conferir que abre no navegador (2026-11-19)
- [x] Instalar e configurar os clientes do Supabase (`@supabase/supabase-js`, `@supabase/ssr`) e o `proxy` de sessão; conexão testada (2026-11-19)

## Versionamento

- [x] Adotar Versionamento Semântico (SemVer) e criar o `CHANGELOG.md` (2026-11-19)
- [x] Publicar a tag `v0.1.0` no GitHub (2026-11-19)
- [x] Criar a release `v0.1.0` na página do GitHub com as notas da versão (2026-11-19)

## Fase 3: Autenticação

- [ ] Definir os métodos de login (e-mail/senha, magic link, Google…)
- [ ] Telas de cadastro, login e logout
- [ ] Proteger as rotas que exigem login

## Fase 4: Banco de dados

- [ ] Modelar as primeiras tabelas (sempre via migrations em `supabase/migrations/`)
- [ ] Habilitar RLS e criar as políticas de acesso

## Fase 5: Storage

- [ ] Criar os buckets e as políticas de acesso
- [ ] Implementar o upload e a exibição de arquivos

## Fase 6: Deploy

- [ ] Escolher a hospedagem (ex.: Vercel)
- [ ] Configurar as variáveis de ambiente de produção
- [ ] Primeiro deploy

## Backlog / ideias

- (adicione aqui)

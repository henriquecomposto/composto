# Tarefas — Composto

Legenda: `[ ]` a fazer · `[~]` em andamento · `[x]` feito

> Só entregas (uma tela, uma tabela, um deploy), trabalho de mais de uma sessão ou o que depende de decisão do usuário. Ajustes pequenos ficam só no commit.

## Onde paramos

_Atualizado em 2026-11-24._

- **Última entrega:** infraestrutura do Claude Code (skills, subagents `verificador` e `devops`, permissões em `settings.json`), `.env.example` e registro enxuto (`DECISOES.md`).
- **Pela metade:** nada.
- **Próximo passo:** Fase 3, começando por definir os métodos de login (decisão do usuário).
- **Pendência paralela:** apagar o projeto antigo "o grande composto" no Supabase.

## Concluído

- Fases 0 a 2 (preparação, Supabase, Next.js conectado ao Supabase): 2026-11-19, versão `v0.1.0`
- Infraestrutura do Claude Code: 2026-11-24

## Pendências

- [ ] Apagar o projeto antigo "o grande composto" (us-east-2) no painel do Supabase

## Fase 3: Autenticação

- [ ] Definir os métodos de login (e-mail/senha, magic link, Google…)
- [ ] Telas de cadastro, login e logout
- [ ] Proteger as rotas que exigem login

## Fase 4: Banco de dados

- [ ] Modelar as primeiras tabelas (via migrations em `supabase/migrations/`)
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

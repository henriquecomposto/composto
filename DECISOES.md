# Decisões — Composto

Histórico das decisões de produto e de arquitetura, com o porquê. As regras em vigor ficam no `CLAUDE.md`; ajustes pequenos ficam só na mensagem do commit.

| Data | Decisão | Por quê |
|---|---|---|
| 2026-11-19 | Histórico antigo do repositório apagado; projeto recomeçado do zero. | Começar limpo, com a stack e o processo definidos. |
| 2026-11-19 | Stack: JavaScript + Next.js (React/Node) + Supabase cloud (auth, banco, storage). | Uma só linguagem no front e no servidor; Supabase entrega login, banco e arquivos prontos. |
| 2026-11-19 | Projeto Supabase "composto" na região São Paulo (sa-east-1). Substitui "o grande composto" (us-east-2), que deve ser apagado. | Menor latência para usuários no Brasil. |
| 2026-11-19 | Next.js com Tailwind CSS e código dentro de `src/`. | Padrão atual do Next.js; separa o código dos arquivos de configuração. |
| 2026-11-19 | Versionamento Semântico: tag + release + `CHANGELOG.md` + `package.json`, sempre juntos. Primeira versão `v0.1.0`. | Marcar entregas de forma clara e rastreável. |
| 2026-11-19 | Gestão conjunta: Claude cuida da parte mecânica; o usuário decide publicações, ações sem volta e produto. | O usuário mantém o controle sem precisar executar o técnico. |
| 2026-11-24 | Skills em `.claude/skills/` e subagents em `.claude/agents/`; processos raros ficam em skills, não no `CLAUDE.md`. | Economizar tokens: o `CLAUDE.md` é carregado em toda conversa. |
| 2026-11-24 | Subagent `devops` para a infraestrutura, separado do código do app (`src/`, na conversa principal) e do `verificador` (só lê). | Separar quem mexe no app de quem mexe em banco e deploy; ações sem volta continuam dependendo do "ok" do usuário. |
| 2026-11-24 | Registro enxuto: `CLAUDE.md` só com regras em vigor, histórico de decisões neste arquivo e `TAREFAS.md` só com entregas. | Menos tokens e menos edições por tarefa; o detalhe já fica no Git e no CHANGELOG. |

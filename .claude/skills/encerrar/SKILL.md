---
name: encerrar
description: Registra no TAREFAS.md onde paramos, antes de fechar a sessão ou dar /clear.
disable-model-invocation: true
---

# Encerrar a sessão

Use o que aconteceu nesta conversa. Não releia arquivos de código; leia só o `TAREFAS.md`.

1. **Tarefas:** marque o que foi concluído (`[x]` + data de hoje) e o que ficou pela metade (`[~]`). Só entregas entram na lista; ajustes pequenos não. Fase concluída vira uma linha em "Concluído".
2. **"Onde paramos":** substitua a seção inteira (não acumule histórico; ele já fica no Git e no CHANGELOG). No máximo 6 linhas:
   - `_Atualizado em AAAA-MM-DD._`
   - **Última entrega**
   - **Pela metade** (ou "nada")
   - **Próximo passo** (indicando se depende de uma decisão do usuário)
   - **Pendências paralelas**, se houver
3. **Decisões:** só decisões de produto ou de arquitetura entram no `DECISOES.md` (uma linha, com o porquê). Se virou regra em vigor, atualize também o `CLAUDE.md`.
4. **Resumo ao usuário:** 3 linhas no máximo. Diga que as mudanças ainda não estão no Git e pergunte se ele quer que você faça o commit.

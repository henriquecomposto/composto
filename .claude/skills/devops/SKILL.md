---
name: devops
description: Chama o subagent devops para uma tarefa de infraestrutura (Supabase, migrations, dependências, configuração, deploy).
disable-model-invocation: true
argument-hint: "<o que você precisa>"
context: fork
agent: devops
---

Pedido do usuário: $ARGUMENTS

- Se o pedido acima estiver vazio, não faça nada: responda em até 4 linhas o que você pode fazer e peça para o usuário digitar `/devops <pedido>`.
- Você não vê a conversa principal: trabalhe só com o pedido acima e com os arquivos do projeto.
- Ações sem volta só com "ok" explícito escrito no próprio pedido. Sem ele, devolva o plano no relatório.

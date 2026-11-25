---
name: prompt
description: Chama o subagent prompt para transformar um pedido solto num prompt claro e completo para o Claude Code.
disable-model-invocation: true
argument-hint: "<o que você quer pedir>"
context: fork
agent: prompt
---

Pedido do usuário: $ARGUMENTS

- Se o pedido acima estiver vazio, não faça nada: responda em até 4 linhas o que você pode fazer e peça para o usuário digitar `/prompt <pedido>`.
- Você não vê a conversa principal: trabalhe só com o pedido acima e com os arquivos do projeto.
- Não execute a tarefa: devolva só o prompt, no formato combinado.

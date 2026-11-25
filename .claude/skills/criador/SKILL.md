---
name: criador
description: Chama o subagent criador para montar um subagent ou uma skill nova seguindo as convenções do projeto.
disable-model-invocation: true
argument-hint: "<o agente que você quer>"
context: fork
agent: criador
---

Pedido do usuário: $ARGUMENTS

- Se o pedido acima estiver vazio, não crie nada: responda em até 4 linhas o que você faz e peça para o usuário digitar `/criador <o agente que você quer>`.
- Você não vê a conversa principal: trabalhe só com o pedido acima e com os arquivos do projeto.
- Alterar um agente ou skill que já existe só com "ok" escrito no próprio pedido.

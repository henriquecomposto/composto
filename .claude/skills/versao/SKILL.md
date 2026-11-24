---
name: versao
description: Prepara e publica uma nova versão do Composto (SemVer, CHANGELOG, package.json, tag e texto da release).
disable-model-invocation: true
argument-hint: "[patch | minor | major | X.Y.Z]"
---

# Publicar versão

O usuário decide se a versão sai. Siga as etapas na ordem e **pare na etapa 3** até receber um "ok" explícito.

## 1. Levantar (sem alterar nada)

- `git status --short`: se houver mudanças não commitadas, liste-as e pergunte se entram na versão.
- `git describe --tags --abbrev=0` para a última tag; `git log <tag>..HEAD --oneline` para o que mudou.
- Se não houver commits desde a última tag, avise e encerre.
- Leia só o topo do `CHANGELOG.md` (até a última versão publicada) e as fases concluídas no `TAREFAS.md`.

## 2. Verificar

Use o subagent `verificador`. Se lint ou build falharem: pare, mostre o resumo e proponha a correção. Não se versiona com erro.

## 3. Propor e PARAR

Apresente ao usuário:

- **Número sugerido.** Se `$ARGUMENTS` trouxer um, use-o. Senão: na fase `0.x`, funcionalidade nova → `minor`; só correções → `patch`. `1.0.0` só quando o usuário decidir.
- **Motivo** em uma frase.
- **Rascunho da entrada do CHANGELOG**, no mesmo formato da `0.1.0`: parágrafo de resumo em linguagem simples, seções `Adicionado` / `Alterado` / `Corrigido` / `Removido` (só as que tiverem itens) e `Notas técnicas` se precisar.

Espere o "ok". Se ele pedir ajustes, refaça só o rascunho.

## 4. Publicar (só depois do "ok")

Tudo junto, nesta ordem:

1. `CHANGELOG.md`: a entrada vira `## [X.Y.Z] - AAAA-MM-DD`, e um `## [Não lançado]` vazio fica acima dela.
2. `npm version X.Y.Z --no-git-tag-version` (atualiza `package.json` e `package-lock.json`).
3. `TAREFAS.md`: em "Concluído", acrescente a versão na linha da fase e atualize "Onde paramos".
4. Commit: `Publica a versão X.Y.Z`.
5. Tag anotada: `git tag -a vX.Y.Z -m "Composto vX.Y.Z: <título curto>"`.
6. `git push origin main --follow-tags`.

## 5. Release no GitHub

O `gh` não está instalado; o usuário cria a release pelo site. Entregue:

- O link `https://github.com/henriquecomposto/composto/releases/new`.
- Passos: escolher a tag `vX.Y.Z`, colar o título e o texto; em versões `0.x`, marcar **Set as a pre-release**; clicar em **Publish release**.
- Título e texto prontos para copiar (o texto é a entrada do CHANGELOG).

Termine com "Como conferir": onde ver a tag e a release no GitHub.

# Composto

Webapp full stack em JavaScript, construído com Next.js (React + Node.js) e Supabase.

> Projeto em fase inicial (greenfield). O andamento está em [TAREFAS.md](TAREFAS.md).

## Stack

| Camada | Tecnologia |
|---|---|
| Linguagem | JavaScript |
| Front-end | React |
| Framework full stack | Next.js |
| Runtime | Node.js |
| Autenticação | Supabase Auth (cloud) |
| Banco de dados | Supabase Postgres (cloud) |
| Armazenamento de arquivos | Supabase Storage (cloud) |
| Versionamento | Git + GitHub (via GitHub Desktop) |

## Pré-requisitos

- [Node.js](https://nodejs.org/) instalado (ambiente atual: v26.13.1, npm 11.20.0)
- [Git](https://git-scm.com/) instalado
- [GitHub Desktop](https://desktop.github.com/) (opcional, para quem prefere interface gráfica)
- Uma conta e um projeto no [Supabase](https://supabase.com/)

## Configuração do ambiente

1. Clone o repositório.
2. Preencha o arquivo `.env` na raiz com as chaves do seu projeto Supabase
   (painel do Supabase → **Project Settings → API**).
3. Instale as dependências e rode o projeto (comandos serão adicionados quando o app Next.js for criado).

> **Nunca** envie o `.env` para o GitHub: ele contém chaves secretas.

## Documentação do projeto

- [CLAUDE.md](CLAUDE.md): contexto, decisões e regras de trabalho para o Claude Code
- [TAREFAS.md](TAREFAS.md): lista de etapas (feitas, em andamento e próximas)

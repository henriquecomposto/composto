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
2. Crie o arquivo `.env` na raiz com as chaves do projeto Supabase
   (painel do Supabase → **Project Settings → API Keys**):
   `NEXT_PUBLIC_SUPABASE_URL`, `NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY`, `SUPABASE_SECRET_KEY`.
3. Instale as dependências:
   ```bash
   npm install
   ```
4. Rode o projeto e abra http://localhost:3000 no navegador:
   ```bash
   npm run dev
   ```

> **Nunca** envie o `.env` para o GitHub: ele contém chaves secretas.

## Comandos

| Comando | O que faz |
|---|---|
| `npm run dev` | Roda o app em modo de desenvolvimento (http://localhost:3000) |
| `npm run build` | Gera a versão de produção |
| `npm run start` | Roda a versão de produção (depois do build) |
| `npm run lint` | Verifica problemas no código |

## Estrutura de pastas

```
src/
├── app/                 # Páginas e rotas (App Router)
├── lib/supabase/
│   ├── client.js        # Supabase no navegador
│   ├── server.js        # Supabase no servidor
│   └── proxy.js         # Renovação da sessão
└── proxy.js             # Roda antes de cada página (antigo "middleware")
public/                  # Imagens e arquivos estáticos
```

## Documentação do projeto

- [CLAUDE.md](CLAUDE.md): contexto, decisões e regras de trabalho para o Claude Code
- [TAREFAS.md](TAREFAS.md): lista de etapas (feitas, em andamento e próximas)

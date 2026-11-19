// Cliente Supabase para o SERVIDOR (Server Components, Server Functions, Route Handlers).
// Lê a sessão do usuário a partir dos cookies da requisição.
// Crie um cliente novo a cada uso: nunca guarde em variável global.
import { createServerClient } from "@supabase/ssr";
import { cookies } from "next/headers";

export async function createClient() {
  const cookieStore = await cookies();

  return createServerClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL,
    process.env.NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY,
    {
      cookies: {
        getAll() {
          return cookieStore.getAll();
        },
        setAll(cookiesToSet) {
          try {
            cookiesToSet.forEach(({ name, value, options }) =>
              cookieStore.set(name, value, options)
            );
          } catch {
            // Server Components não podem gravar cookies. Tudo bem:
            // o proxy (src/proxy.js) já renova a sessão a cada requisição.
          }
        },
      },
    }
  );
}

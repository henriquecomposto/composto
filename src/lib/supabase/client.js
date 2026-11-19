// Cliente Supabase para o NAVEGADOR (Client Components, com "use client").
// Usa só a chave publishable: é seguro expor no front-end.
import { createBrowserClient } from "@supabase/ssr";

export function createClient() {
  return createBrowserClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL,
    process.env.NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY
  );
}

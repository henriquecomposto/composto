// Renova a sessão do Supabase a cada requisição, antes de a página ser renderizada.
// Chamado por src/proxy.js.
import { createServerClient } from "@supabase/ssr";
import { NextResponse } from "next/server";

export async function updateSession(request) {
  let response = NextResponse.next({ request });

  const supabase = createServerClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL,
    process.env.NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY,
    {
      cookies: {
        getAll() {
          return request.cookies.getAll();
        },
        setAll(cookiesToSet, headers) {
          // Atualiza os cookies na requisição (para as páginas lerem a sessão nova)...
          cookiesToSet.forEach(({ name, value }) =>
            request.cookies.set(name, value)
          );
          response = NextResponse.next({ request });
          // ...e na resposta (para o navegador guardar a sessão nova).
          cookiesToSet.forEach(({ name, value, options }) =>
            response.cookies.set(name, value, options)
          );
          // Cabeçalhos que impedem cache de respostas com sessão.
          Object.entries(headers ?? {}).forEach(([key, value]) =>
            response.headers.set(key, value)
          );
        },
      },
    }
  );

  // Não coloque código entre createServerClient e getClaims():
  // é esta chamada que valida e renova a sessão.
  await supabase.auth.getClaims();

  // A proteção de rotas (redirecionar quem não está logado) entra na Fase 3.

  return response;
}

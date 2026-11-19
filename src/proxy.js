// Proxy do Next.js (antigo "middleware"): roda antes de cada página.
// Aqui ele mantém a sessão do Supabase sempre atualizada.
import { updateSession } from "@/lib/supabase/proxy";

export async function proxy(request) {
  return await updateSession(request);
}

export const config = {
  matcher: [
    // Roda em todas as rotas, exceto arquivos estáticos e imagens.
    "/((?!_next/static|_next/image|favicon.ico|.*\\.(?:svg|png|jpg|jpeg|gif|webp)$).*)",
  ],
};

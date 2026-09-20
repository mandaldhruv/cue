import { createAuthActions } from "@insforge/sdk/ssr";
import { NextRequest, NextResponse } from "next/server";

function safeNext(value?: string) { return value?.startsWith("/") && !value.startsWith("//") ? value : "/"; }

export async function GET(request: NextRequest) {
  const code = request.nextUrl.searchParams.get("insforge_code") || request.nextUrl.searchParams.get("code");
  const verifier = request.cookies.get("insforge_code_verifier")?.value;
  const next = safeNext(request.cookies.get("cue_auth_return")?.value);
  const response = NextResponse.redirect(new URL(next, request.url));
  if (!code || !verifier) return NextResponse.redirect(new URL(`/login?error=google&next=${encodeURIComponent(next)}`, request.url));
  const auth = createAuthActions({ requestCookies: request.cookies, responseCookies: response.cookies });
  const { data, error } = await auth.exchangeOAuthCode(code, verifier);
  if (error || !data?.user) return NextResponse.redirect(new URL(`/login?error=google&next=${encodeURIComponent(next)}`, request.url));
  response.cookies.delete("insforge_code_verifier");
  response.cookies.delete("cue_auth_return");
  return response;
}

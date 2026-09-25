export const AUTHORIZED_ADMIN_EMAILS = [
  "hersita04@gmail.com",
  "harshita301doc@gmail.com",
] as const;

export function isAuthorizedAdminEmail(email?: string | null): boolean {
  if (!email) return false;
  const normalized = email.trim().toLowerCase();
  return (AUTHORIZED_ADMIN_EMAILS as readonly string[]).includes(normalized);
}

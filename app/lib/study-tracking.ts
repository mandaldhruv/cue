/**
 * Study Time Classification Utilities
 *
 * Cue strictly separates administrative activity from student study activity.
 * Time spent inside the Admin Panel (/admin and all sub-routes) is administrative
 * activity and must NEVER contribute to Study Time.
 *
 * Student-facing website time (Home, Subjects, Syllabus, PYQs, Flashcards, etc.)
 * is genuine study activity and is tracked accurately for all users, including
 * administrators studying on the student portal.
 */

/**
 * Determines whether a route path belongs to the administrative section of Cue.
 */
export function isAdminRoute(pathname: string | null | undefined): boolean {
  if (!pathname) return false;
  const normalized = pathname.trim().toLowerCase();
  return (
    normalized === "/admin" ||
    normalized.startsWith("/admin/") ||
    normalized.startsWith("/admin?")
  );
}

/**
 * Determines whether a route path represents student-facing study activity.
 */
export function isStudyRoute(pathname: string | null | undefined): boolean {
  if (!pathname) return false;
  return !isAdminRoute(pathname);
}

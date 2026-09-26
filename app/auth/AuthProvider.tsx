"use client";

import { useCallback, useEffect, useMemo, useState } from "react";
import LoginPanel from "../login/LoginPanel";
import { AuthContext, type CueUser } from "./AuthContext";

export { useAuth } from "./AuthContext";
export type { CueUser } from "./AuthContext";

export function AuthProvider({ children }: { children: React.ReactNode }) {
  const [user, setUser] = useState<CueUser | null>(null);
  const [loading, setLoading] = useState(true);
  const [loginModalOpen, setLoginModalOpen] = useState(false);
  const [returnPath, setReturnPath] = useState("/");

  const refreshUser = useCallback(async () => {
    try {
      const response = await fetch("/api/auth/session", {
        cache: "no-store",
        credentials: "include",
        headers: { Accept: "application/json" },
      });
      const data = response.ok ? await response.json() as { user?: CueUser | null } : null;
      const nextUser = data?.user ?? null;
      setUser(nextUser);
      return nextUser;
    } catch {
      setUser(null);
      return null;
    } finally {
      setLoading(false);
    }
  }, []);

  useEffect(() => {
    const timer = window.setTimeout(() => { void refreshUser(); }, 0);
    return () => window.clearTimeout(timer);
  }, [refreshUser]);

  const requireLogin = useCallback(async (customReturnPath?: string) => {
    const currentUser = user ?? await refreshUser();
    if (currentUser) return true;
    setReturnPath(customReturnPath || `${window.location.pathname}${window.location.search}`);
    setLoginModalOpen(true);
    return false;
  }, [refreshUser, user]);

  const closeLoginModal = useCallback(() => setLoginModalOpen(false), []);

  useEffect(() => {
    if (!loginModalOpen) return;
    const previousOverflow = document.body.style.overflow;
    document.body.style.overflow = "hidden";
    const closeOnEscape = (event: KeyboardEvent) => {
      if (event.key === "Escape") setLoginModalOpen(false);
    };
    window.addEventListener("keydown", closeOnEscape);
    return () => {
      document.body.style.overflow = previousOverflow === "hidden" ? "" : previousOverflow;
      window.removeEventListener("keydown", closeOnEscape);
    };
  }, [loginModalOpen]);

  const value = useMemo(() => ({ user, loading, refreshUser, requireLogin, closeLoginModal }), [closeLoginModal, loading, refreshUser, requireLogin, user]);
  return <AuthContext.Provider value={value}>
    {children}
    {loginModalOpen && <div className="cue-auth-modal-backdrop" role="presentation" onMouseDown={closeLoginModal}>
      <div className="cue-auth-modal-dialog" role="dialog" aria-modal="true" aria-labelledby="cue-auth-modal-title" onMouseDown={(event) => event.stopPropagation()}>
        <button className="cue-auth-modal-close" type="button" onClick={closeLoginModal} aria-label="Close sign in">×</button>
        <LoginPanel next={returnPath} googleError={false} modal />
      </div>
    </div>}
  </AuthContext.Provider>;
}

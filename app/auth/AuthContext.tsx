"use client";

import { createContext, useContext } from "react";

export type CueUser = {
  id: string;
  email: string;
  profile: { name?: string; avatar_url?: string } | null;
};

export type AuthContextValue = {
  user: CueUser | null;
  loading: boolean;
  refreshUser: () => Promise<CueUser | null>;
  requireLogin: (customReturnPath?: string) => Promise<boolean>;
  closeLoginModal: () => void;
};

export const AuthContext = createContext<AuthContextValue | null>(null);

export function useAuth() {
  const value = useContext(AuthContext);
  if (!value) throw new Error("useAuth must be used inside AuthProvider.");
  return value;
}

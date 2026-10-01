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

const defaultAuthContext: AuthContextValue = {
  user: null,
  loading: false,
  refreshUser: async () => null,
  requireLogin: async () => false,
  closeLoginModal: () => {},
};

export const AuthContext = createContext<AuthContextValue>(defaultAuthContext);

export function useAuth() {
  const value = useContext(AuthContext);
  return value ?? defaultAuthContext;
}

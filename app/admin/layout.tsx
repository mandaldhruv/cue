import type { Metadata } from "next";

export const metadata: Metadata = {
  title: "Cue Admin",
  robots: { index: false, follow: false },
};

export default function AdminLayout({ children }: Readonly<{ children: React.ReactNode }>) {
  return (
    <div className="admin-app-context" data-admin-context="true" style={{ display: "contents" }}>
      {children}
    </div>
  );
}

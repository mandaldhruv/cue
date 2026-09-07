import type { Metadata } from "next";
import "./globals.css";
import "./enhancements.css";

export const metadata: Metadata = {
  metadataBase: new URL(process.env.NEXT_PUBLIC_SITE_URL || "http://localhost:5173"),
  title: "Cue — Study smarter. Stress less.",
  description: "A calmer, smarter study platform for BMS students. Find notes, PYQs, flashcards and AI-powered exam insights in one beautiful space.",
  icons: { icon: [{ url: "/cue-favicon-original.png", type: "image/png", sizes: "64x64" }], shortcut: "/cue-favicon-original.png", apple: "/cue-favicon-original.png" },
  openGraph: {
    title: "Cue — Study smarter. Stress less.",
    description: "Notes, PYQs, flashcards and exam insights in one calm space.",
    type: "website",
    images: [{ url: "/og.png", width: 1536, height: 1024, alt: "Cue — Study smarter. Stress less." }],
  },
  twitter: {
    card: "summary_large_image",
    title: "Cue — Study smarter. Stress less.",
    description: "Notes, PYQs, flashcards and exam insights in one calm space.",
    images: ["/og.png"],
  },
};

export default function RootLayout({ children }: Readonly<{ children: React.ReactNode }>) {
  return <html lang="en"><body><div className="app-shell">{children}</div></body></html>;
}

import type { ReactNode } from "react";
import { Footer, Navigation } from "../components";

export default function LegalPage({ eyebrow, title, children }: { eyebrow: string; title: string; children: ReactNode }) {
  return <><Navigation /><main className="legal-page"><section className="legal-intro"><div className="container"><span className="eyebrow">{eyebrow}</span><h1>{title}</h1></div></section><article className="container legal-content">{children}</article></main><Footer /></>;
}

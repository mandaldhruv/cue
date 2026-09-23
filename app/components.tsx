"use client";

import Link from "next/link";
import Image from "next/image";
import { usePathname } from "next/navigation";
import { navItems, Subject } from "./data";
import { useAuth } from "./auth/AuthProvider";
import { signOutAction } from "./login/actions";

export function Logo() {
  return (
    <Link className="logo" href="/" aria-label="Cue home">
      <Image className="cue-original-wordmark" src="/cue-wordmark-original-clean.png" alt="" width={685} height={266} priority />
      <strong className="sr-only">Cue</strong>
    </Link>
  );
}

export function Navigation() {
  const pathname = usePathname();
  const { user, loading, refreshUser } = useAuth();
  const isActive = (href: string) => href === "/" ? pathname === "/" : pathname.startsWith(href);
  const displayName = user?.profile?.name?.trim() || user?.email.split("@")[0] || "Cue learner";
  const initial = displayName.slice(0, 1).toUpperCase();
  async function signOut() { await signOutAction(); await refreshUser(); }
  return (
    <header className="site-header">
      <div className="container nav-inner">
        <Logo />
        <nav className="desktop-nav" aria-label="Main navigation">
          {navItems.map((item) => <Link className={isActive(item.href) ? "active" : ""} aria-current={isActive(item.href) ? "page" : undefined} href={item.href} key={item.href}><span>{item.label}</span></Link>)}
        </nav>
        {loading ? <span className="nav-account-loading" aria-label="Loading account"/> : user ? <details className="nav-account"><summary><i>{initial}</i><span><b>{displayName}</b><small>{user.email}</small></span><em>⌄</em></summary><div><span>YOUR CUE ACCOUNT</span><b>{displayName}</b><small>{user.email}</small><button onClick={signOut}>Sign out <i>→</i></button></div></details> : <Link className="nav-button nav-auth-button" href={`/login?next=${encodeURIComponent(pathname)}`} aria-label="Sign in or create a Cue account"><span className="nav-auth-icon" aria-hidden="true"><svg viewBox="0 0 24 24"><path d="M12 12a4 4 0 1 0 0-8 4 4 0 0 0 0 8Zm7 8a7 7 0 0 0-14 0"/></svg></span><span><b>Sign in</b><small>or create account</small></span></Link>}
        <details className="mobile-nav">
          <summary aria-label="Open menu"><span /><span /></summary>
          <div>{navItems.map((item) => <Link className={isActive(item.href) ? "active" : ""} aria-current={isActive(item.href) ? "page" : undefined} href={item.href} key={item.href}>{item.label}<span>→</span></Link>)}<div className="mobile-account-divider"/>{user ? <><div className="mobile-account-copy"><i>{initial}</i><span><b>{displayName}</b><small>{user.email}</small></span></div><button className="mobile-signout" onClick={signOut}>Sign out <span>→</span></button></> : <Link className="mobile-signin" href={`/login?next=${encodeURIComponent(pathname)}`}>Sign in / Sign up<span className="mobile-signin-icon" aria-hidden="true"><svg viewBox="0 0 24 24"><path d="M12 12a4 4 0 1 0 0-8 4 4 0 0 0 0 8Zm7 8a7 7 0 0 0-14 0"/></svg></span></Link>}</div>
        </details>
      </div>
    </header>
  );
}

export function Footer() {
  return (
    <footer className="site-footer">
      <div className="container footer-shell">
        <div className="footer-brand"><Logo /><p>Study <b>smarter.</b> Stress less.</p><small>One organised study space for BMS students.</small></div>
        <nav className="footer-links" aria-label="Explore Cue"><b>Explore</b><Link href="/">Home</Link><Link href="/subjects">Subjects</Link><Link href="/flashcards">Flashcards</Link><Link href="/pyqs">PYQs</Link><Link href="/about">About</Link></nav>
        <nav className="footer-links" aria-label="Support"><b>Support</b><Link href="/feedback">Feedback</Link><Link href="/help">Help &amp; FAQs</Link><Link href="/privacy">Privacy Policy</Link><Link href="/terms">Terms of Use</Link><Link href="/disclaimer">Disclaimer</Link></nav>
        <div className="footer-bottom footer-bottom-minimal"><span className="footer-credit-line"><strong>© Cue 2026</strong><span className="footer-credit">Built with <i>♥</i> by Harshita</span></span></div>
      </div>
    </footer>
  );
}

export function PageIntro({ eyebrow, title, description }: { eyebrow: string; title: string; description: string }) {
  return <section className="page-intro"><div className="container"><span className="eyebrow">{eyebrow}</span><h1>{title}</h1><p>{description}</p></div></section>;
}

export function SubjectCard({ subject, index }: { subject: Subject; index: number }) {
  return (
    <Link className={`subject-card ${subject.accent}`} href={`/subjects/${subject.slug}`}>
      <div className="subject-card-head"><span>{subject.code}</span><small>0{index + 1}</small></div>
      <div className="subject-symbol"><i /><b>{subject.code.slice(0, 2)}</b></div>
      <h3>{subject.shortName}</h3><p>{subject.description}</p>
      <div className="subject-meta"><span>Open subject workspace</span><b>→</b></div>
    </Link>
  );
}

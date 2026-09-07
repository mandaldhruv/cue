import Link from "next/link";
import { Footer, Navigation } from "../components";
import { getPublishedContent, getPublishedSubjects } from "../lib/public-content";

export const dynamic = "force-dynamic";

export default async function FlashcardsPage() {
  const [{ subjects }, { content, error }] = await Promise.all([getPublishedSubjects(), getPublishedContent(undefined, "flashcard")]);
  const decks = subjects.map((subject) => ({ subject, cards: content.filter((card) => card.subject_id === subject.id) })).filter((deck) => deck.cards.length > 0);
  return <><Navigation/><main>
    <section className="study-page-head"><div className="container"><span>ACTIVE RECALL · BMS</span><h1>Choose a subject deck.</h1><p>Every card here is published and maintained from the Cue admin workspace.</p></div></section>
    <section className="flashcard-library"><div className="container">
      {error ? <div className="study-empty error"><span>CONNECTION ISSUE</span><h3>Flashcards could not be loaded.</h3><p>Please try again in a moment.</p></div> : decks.length ? <div className="real-deck-grid">{decks.map(({ subject, cards }) => <Link href={`/flashcards/${subject.slug}`} key={subject.id} style={{ "--deck-accent": subject.accent_color } as React.CSSProperties}><div><span>{subject.short_code}</span><small>SEM {subject.semester_number}</small></div><h2>{subject.name}</h2><p>{cards.length} verified {cards.length === 1 ? "card" : "cards"}</p><strong>Open deck <i>→</i></strong></Link>)}</div> : <div className="study-empty library-empty"><span>DECK LIBRARY</span><h3>No flashcard decks are published yet.</h3><p>Flashcards remain part of Cue. New subject decks will appear here automatically when the admin publishes them.</p><Link href="/subjects">Study from subjects →</Link></div>}
    </div></section>
  </main><Footer/></>;
}

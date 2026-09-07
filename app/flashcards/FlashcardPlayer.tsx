"use client";

import { useState } from "react";

export type PublicFlashcard = { id: string; title: string; description: string; body: string };

export default function FlashcardPlayer({ cards, subjectName }: { cards: PublicFlashcard[]; subjectName: string }) {
  const [index, setIndex] = useState(0);
  const [revealed, setRevealed] = useState(false);
  if (!cards.length) return <div className="study-empty"><span>FLASHCARDS</span><h3>No cards published yet.</h3><p>The {subjectName} deck will appear here as soon as cards are published from the admin workspace.</p></div>;

  const safeIndex = index % cards.length;
  const card = cards[safeIndex];

  function move(direction: number) {
    setIndex((current) => (current + direction + cards.length) % cards.length);
    setRevealed(false);
  }

  return <div className="flashcard-player">
    <div className="flashcard-player-head"><div><span>{subjectName.toUpperCase()} DECK</span><b>{cards.length} {cards.length === 1 ? "card" : "cards"}</b></div><small>{safeIndex + 1} / {cards.length}</small></div>
    <button className={`study-flashcard ${revealed ? "revealed" : ""}`} onClick={() => setRevealed((value) => !value)} aria-label={revealed ? "Show question" : "Reveal answer"}>
      <span>{revealed ? "ANSWER" : "QUESTION"}</span>
      <h3>{revealed ? card.body : card.title}</h3>
      {!revealed && card.description && <p>{card.description}</p>}
      <small>{revealed ? "Tap to see the question" : "Tap to reveal the answer"}</small>
    </button>
    <div className="flashcard-controls"><button onClick={() => move(-1)} aria-label="Previous flashcard">← Previous</button><button className="reveal" onClick={() => setRevealed((value) => !value)}>{revealed ? "Show question" : "Reveal answer"}</button><button onClick={() => move(1)} aria-label="Next flashcard">Next →</button></div>
  </div>;
}

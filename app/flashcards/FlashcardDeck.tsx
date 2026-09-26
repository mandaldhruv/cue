"use client";

import { useEffect, useState } from "react";
import type { PublicContentRecord, PublicFlashcardTopic, PublicFlashcardUnit } from "../lib/public-content";
import { RichContent } from "./rich-content";
import { useAuth } from "../auth/AuthProvider";

export default function FlashcardDeck({
  units,
  topics,
  cards,
  subjectName,
  initialUnitId,
  initialTopicId,
  initialCardId,
  initialCardIndex,
  initialAutoOpen = false,
}: {
  units: PublicFlashcardUnit[];
  topics: PublicFlashcardTopic[];
  cards: PublicContentRecord[];
  subjectName: string;
  initialUnitId?: string;
  initialTopicId?: string;
  initialCardId?: string;
  initialCardIndex?: string;
  initialAutoOpen?: boolean;
}) {
  const { user, requireLogin } = useAuth();
  const organisedCards = cards.filter((card) => card.flashcard_unit_id && card.flashcard_topic_id);
  const unassignedCards = cards.filter((card) => !card.flashcard_unit_id || !card.flashcard_topic_id);
  const availableUnits = units.filter((unit) => organisedCards.some((card) => card.flashcard_unit_id === unit.id));

  const resolvedInitialUnit = initialUnitId && (availableUnits.some((u) => u.id === initialUnitId) || (initialUnitId === "__unassigned__" && unassignedCards.length > 0))
    ? initialUnitId
    : (availableUnits[0]?.id ?? (unassignedCards.length ? "__unassigned__" : ""));

  const [unitId, setUnitId] = useState(resolvedInitialUnit);
  const availableTopics = topics.filter((topic) => topic.unit_id === unitId && organisedCards.some((card) => card.flashcard_topic_id === topic.id));

  const resolvedInitialTopic = initialTopicId && availableTopics.some((t) => t.id === initialTopicId)
    ? initialTopicId
    : (availableTopics[0]?.id ?? "");

  const [topicId, setTopicId] = useState(resolvedInitialTopic);

  const selectedTopicId = availableTopics.some((topic) => topic.id === topicId) ? topicId : availableTopics[0]?.id ?? "";
  const visibleCards = unitId === "__unassigned__" ? unassignedCards : cards.filter((card) => card.flashcard_topic_id === selectedTopicId);
  const selectedUnit = units.find((unit) => unit.id === unitId);
  const selectedUnitIndex = availableUnits.findIndex((unit) => unit.id === unitId);
  const selectedTopic = topics.find((topic) => topic.id === selectedTopicId);
  const selectedTopicIndex = availableTopics.findIndex((topic) => topic.id === selectedTopicId);

  // Calculate target initial index from props
  let initialTargetIndex = 0;
  if (initialCardId) {
    const found = visibleCards.findIndex((c) => c.id === initialCardId);
    if (found >= 0) initialTargetIndex = found;
  } else if (initialCardIndex !== undefined) {
    const parsed = parseInt(initialCardIndex, 10);
    if (!isNaN(parsed) && parsed >= 0 && parsed < visibleCards.length) {
      initialTargetIndex = parsed;
    }
  }

  const initialMobileStep: "units" | "topics" | "cards" = (initialTopicId || initialCardId || initialCardIndex || initialAutoOpen)
    ? "cards"
    : (initialUnitId && initialUnitId !== "__unassigned__")
      ? "topics"
      : "units";

  const [viewerIndex, setViewerIndex] = useState<number | null>(null);
  const [revealed, setRevealed] = useState(false);

  // Mobile / tablet step-by-step navigation state
  const [mobileStep, setMobileStep] = useState<"units" | "topics" | "cards">(initialMobileStep);
  const [mobileCardIndex, setMobileCardIndex] = useState(initialTargetIndex);
  const [mobileRevealed, setMobileRevealed] = useState(false);
  const [isMobileFlashcardOpen, setIsMobileFlashcardOpen] = useState(false);

  // Synchronize client-side URL params on initial hydration
  useEffect(() => {
    if (typeof window === "undefined") return;
    try {
      const params = new URLSearchParams(window.location.search);
      const urlUnit = params.get("unit");
      const urlTopic = params.get("topic");
      const urlCard = params.get("card");
      const urlCardIndex = params.get("cardIndex");
      const urlOpen = params.get("open") === "1";

      if (urlUnit && urlUnit !== unitId && (availableUnits.some((u) => u.id === urlUnit) || urlUnit === "__unassigned__")) {
        setUnitId(urlUnit);
      }
      if (urlTopic && urlTopic !== topicId) {
        setTopicId(urlTopic);
      }
      if (urlTopic || urlCard || urlCardIndex || urlOpen) {
        setMobileStep("cards");
      }
    } catch {}
  }, []);

  // Handle returning authenticated users after login
  const [autoOpenHandled, setAutoOpenHandled] = useState(false);
  useEffect(() => {
    if (!initialAutoOpen || autoOpenHandled || !user) return;
    setAutoOpenHandled(true);
    const isMobile = typeof window !== "undefined" && window.innerWidth <= 1024;
    if (isMobile) {
      setMobileStep("cards");
      setMobileCardIndex(initialTargetIndex);
      setIsMobileFlashcardOpen(true);
    } else {
      setViewerIndex(initialTargetIndex);
    }
    try {
      const url = new URL(window.location.href);
      url.searchParams.delete("open");
      window.history.replaceState({}, "", url.pathname + (url.search ? url.search : ""));
    } catch {}
  }, [autoOpenHandled, initialAutoOpen, initialTargetIndex, user]);

  const viewerCard = viewerIndex === null ? null : visibleCards[viewerIndex];
  const canMovePrevious = viewerIndex !== null && (
    viewerIndex > 0 || (unitId !== "__unassigned__" && selectedTopicIndex > 0)
  );
  const canMoveNext = viewerIndex !== null && (
    viewerIndex < visibleCards.length - 1 ||
    (unitId !== "__unassigned__" && selectedTopicIndex >= 0 && selectedTopicIndex < availableTopics.length - 1)
  );

  const currentMobileCard = visibleCards[mobileCardIndex] ?? visibleCards[0] ?? null;
  const canMoveMobilePrevious = mobileCardIndex > 0;
  const canMoveMobileNext = mobileCardIndex < visibleCards.length - 1;

  function open(index: number) {
    setViewerIndex(index);
    setRevealed(false);
  }

  async function toggleSolution() {
    if (!revealed && !(await requireLogin())) return;
    setRevealed((value) => !value);
  }

  function openMobileFlashcard(index: number) {
    setMobileCardIndex(index);
    setMobileRevealed(false);
    setIsMobileFlashcardOpen(true);
  }

  function closeMobileFlashcard() {
    setIsMobileFlashcardOpen(false);
    setMobileRevealed(false);
    if (typeof window !== "undefined") {
      setTimeout(() => {
        const item = document.getElementById(`mobile-question-item-${mobileCardIndex}`);
        if (item) {
          item.scrollIntoView({ behavior: "smooth", block: "center" });
        }
      }, 50);
    }
  }

  async function toggleMobileSolution() {
    if (!mobileRevealed && !(await requireLogin())) return;
    setMobileRevealed((value) => !value);
  }

  // Question click handler with authentication gating before entering Flashcard Mode
  async function handleQuestionClick(index: number, isMobile: boolean) {
    const card = visibleCards[index];
    if (!card) return;

    // Formulate return path with exact subject, unit, topic, and card
    const search = new URLSearchParams();
    if (unitId) search.set("unit", unitId);
    if (selectedTopicId) search.set("topic", selectedTopicId);
    search.set("card", card.id);
    search.set("cardIndex", String(index));
    search.set("open", "1");
    const targetUrl = `${window.location.pathname}?${search.toString()}`;

    // Gate on login BEFORE entering Flashcard Mode
    const loggedIn = targetUrl ? await requireLogin(targetUrl) : await requireLogin();
    if (!loggedIn) {
      // User is not logged in: login modal opens, user stays on question list!
      return;
    }

    // User is logged in: enter Flashcard Mode directly
    if (isMobile) {
      openMobileFlashcard(index);
    } else {
      open(index);
    }
  }

  function move(direction: -1 | 1) {
    if (!visibleCards.length || viewerIndex === null) return;
    const nextIndex = viewerIndex + direction;
    if (nextIndex >= 0 && nextIndex < visibleCards.length) {
      setViewerIndex(nextIndex);
      setRevealed(false);
      return;
    }

    if (unitId === "__unassigned__") return;
    const adjacentTopic = availableTopics[selectedTopicIndex + direction];
    if (!adjacentTopic) return;
    const adjacentCards = cards.filter((card) => card.flashcard_topic_id === adjacentTopic.id);
    if (!adjacentCards.length) return;
    setTopicId(adjacentTopic.id);
    setViewerIndex(direction === 1 ? 0 : adjacentCards.length - 1);
    setRevealed(false);
  }

  function moveMobile(direction: -1 | 1) {
    if (!visibleCards.length) return;
    const nextIndex = mobileCardIndex + direction;
    if (nextIndex >= 0 && nextIndex < visibleCards.length) {
      setMobileCardIndex(nextIndex);
      setMobileRevealed(false);
    }
  }

  // Safe body scroll locking only while mobile fullscreen flashcard is active
  useEffect(() => {
    if (!isMobileFlashcardOpen) {
      if (typeof document !== "undefined" && document.body.style.overflow === "hidden") {
        document.body.style.overflow = "";
      }
      return;
    }
    const previousOverflow = document.body.style.overflow;
    document.body.style.overflow = "hidden";
    return () => {
      document.body.style.overflow = previousOverflow === "hidden" ? "" : previousOverflow;
    };
  }, [isMobileFlashcardOpen]);

  // Safety cleanup on unmount
  useEffect(() => {
    return () => {
      if (typeof document !== "undefined" && document.body.style.overflow === "hidden") {
        document.body.style.overflow = "";
      }
    };
  }, []);

  // Keyboard controls for mobile flashcard mode
  useEffect(() => {
    if (!isMobileFlashcardOpen) return;
    function handleKeyDown(event: KeyboardEvent) {
      if (event.key === "Escape") {
        closeMobileFlashcard();
      } else if (event.key === "ArrowLeft") {
        moveMobile(-1);
      } else if (event.key === "ArrowRight") {
        moveMobile(1);
      }
    }
    window.addEventListener("keydown", handleKeyDown);
    return () => {
      window.removeEventListener("keydown", handleKeyDown);
    };
  }, [isMobileFlashcardOpen, mobileCardIndex, visibleCards.length]);

  function handleUnitSelect(targetUnitId: string, isUnassigned = false) {
    setUnitId(targetUnitId);
    setTopicId(isUnassigned ? "__unassigned__" : "");
    setViewerIndex(null);
    setMobileCardIndex(0);
    setMobileRevealed(false);
    setIsMobileFlashcardOpen(false);
    setMobileStep(isUnassigned ? "cards" : "topics");
    if (typeof window !== "undefined") {
      window.scrollTo({ top: 0, behavior: "smooth" });
    }
  }

  function handleTopicSelect(targetTopicId: string) {
    setTopicId(targetTopicId);
    setMobileCardIndex(0);
    setMobileRevealed(false);
    setIsMobileFlashcardOpen(false);
    setMobileStep("cards");
    if (typeof window !== "undefined") {
      window.scrollTo({ top: 0, behavior: "smooth" });
    }
  }

  if (!cards.length) {
    return (
      <div className="study-empty">
        <span>FLASHCARDS</span>
        <h3>No cards published yet.</h3>
        <p>The {subjectName} deck will appear here as soon as the admin publishes its first card.</p>
      </div>
    );
  }

  return (
    <div className={`flashcard-deck-browser mobile-step-${mobileStep}`}>
      {/* Unit navigation: Left column on desktop (>1024px), Step 1 on mobile/tablet (<=1024px) */}
      <aside className="flashcard-unit-nav">
        <header>
          <span>DECK MAP</span>
          <b>Choose a unit</b>
        </header>
        <nav>
          {availableUnits.map((unit, index) => {
            const unitCards = organisedCards.filter((card) => card.flashcard_unit_id === unit.id);
            return (
              <button
                key={unit.id}
                className={unitId === unit.id ? "active" : ""}
                onClick={() => handleUnitSelect(unit.id)}
              >
                <i>{String(index + 1).padStart(2, "0")}</i>
                <span>
                  <b>{unit.title}</b>
                  <small>{unitCards.length} {unitCards.length === 1 ? "card" : "cards"}</small>
                </span>
                <strong>→</strong>
              </button>
            );
          })}
          {unassignedCards.length > 0 && (
            <button
              className={unitId === "__unassigned__" ? "active" : ""}
              onClick={() => handleUnitSelect("__unassigned__", true)}
            >
              <i>GC</i>
              <span>
                <b>General cards</b>
                <small>{unassignedCards.length} older {unassignedCards.length === 1 ? "card" : "cards"}</small>
              </span>
              <strong>→</strong>
            </button>
          )}
        </nav>
      </aside>

      {/* Desktop Workspace: Right column on desktop (>1024px). Completely hidden on mobile/tablet. */}
      <section className="flashcard-topic-workspace flashcard-desktop-workspace">
        <header>
          <div>
            <span>{selectedUnit ? "UNIT" : "DECK"}</span>
            <h2>{selectedUnit?.title ?? "General cards"}</h2>
          </div>
          <small>{availableTopics.length} {availableTopics.length === 1 ? "topic" : "topics"}</small>
        </header>
        {unitId !== "__unassigned__" && (
          <div className="flashcard-topic-tabs" role="tablist">
            {availableTopics.map((topic) => (
              <button
                key={topic.id}
                role="tab"
                aria-selected={selectedTopicId === topic.id}
                className={selectedTopicId === topic.id ? "active" : ""}
                onClick={() => {
                  setTopicId(topic.id);
                  setViewerIndex(null);
                }}
              >
                {topic.title}
                <small>{organisedCards.filter((card) => card.flashcard_topic_id === topic.id).length}</small>
              </button>
            ))}
          </div>
        )}
        <div className="flashcard-question-list">
          <div className="flashcard-question-heading">
            <span>{selectedTopic?.title ?? "Questions"}</span>
            <small>{visibleCards.length} {visibleCards.length === 1 ? "question" : "questions"}</small>
          </div>
          {visibleCards.length ? (
            visibleCards.map((card, index) => (
              <button
                key={card.id}
                type="button"
                className={viewerIndex === index ? "active-question" : ""}
                onClick={() => handleQuestionClick(index, false)}
              >
                <i>{String(index + 1).padStart(2, "0")}</i>
                <span>
                  <b>{card.title}</b>
                  {card.description && <small>{card.description}</small>}
                </span>
                <strong>View solution <em>→</em></strong>
              </button>
            ))
          ) : (
            <div className="study-empty">
              <h3>No cards in this topic yet.</h3>
              <p>Only content published by the admin appears here.</p>
            </div>
          )}
        </div>
      </section>

      {/* Mobile Step 2: Topic Selection (Only active on mobile/tablet <=1024px when mobileStep === "topics") */}
      <section className="flashcard-mobile-step-topics">
        <div className="flashcard-nav-breadcrumb-bar">
          <button
            type="button"
            className="flashcard-nav-back-button"
            onClick={() => {
              setMobileStep("units");
              if (typeof window !== "undefined") window.scrollTo({ top: 0, behavior: "smooth" });
            }}
          >
            <span className="flashcard-nav-back-icon" aria-hidden="true">←</span>
            <span>Choose unit</span>
          </button>
          <span className="flashcard-nav-context-pill">
            {selectedUnit ? `UNIT ${String(selectedUnitIndex + 1).padStart(2, "0")}` : "DECK"}
          </span>
        </div>

        <header className="flashcard-mobile-unit-header">
          <span className="flashcard-mobile-context-tag">
            {selectedUnit ? `UNIT ${String(selectedUnitIndex + 1).padStart(2, "0")}` : "DECK"}
          </span>
          <h2>{selectedUnit?.title ?? "General cards"}</h2>
          <p>{availableTopics.length} {availableTopics.length === 1 ? "topic" : "topics"} in this unit</p>
        </header>

        <div className="flashcard-mobile-topic-selector">
          <div className="flashcard-mobile-section-heading">
            <h3>Choose a topic</h3>
            <small>{availableTopics.length} {availableTopics.length === 1 ? "topic" : "topics"}</small>
          </div>
          <div className="flashcard-mobile-topic-list">
            {availableTopics.length ? (
              availableTopics.map((topic, index) => {
                const topicCardCount = organisedCards.filter((card) => card.flashcard_topic_id === topic.id).length;
                return (
                  <button
                    type="button"
                    key={topic.id}
                    className="flashcard-mobile-topic-card"
                    onClick={() => handleTopicSelect(topic.id)}
                  >
                    <i className="flashcard-mobile-topic-num">{String(index + 1).padStart(2, "0")}</i>
                    <div className="flashcard-mobile-topic-info">
                      <b>{topic.title}</b>
                      <small>{topicCardCount} {topicCardCount === 1 ? "flashcard" : "flashcards"}</small>
                    </div>
                    <strong className="flashcard-mobile-topic-arrow">→</strong>
                  </button>
                );
              })
            ) : (
              <div className="study-empty">
                <h3>No topics available in this unit yet.</h3>
              </div>
            )}
          </div>
        </div>
      </section>

      {/* Mobile Step 3: Question List (Only active on mobile/tablet <=1024px when mobileStep === "cards") */}
      <section className="flashcard-mobile-step-cards">
        <div className="flashcard-nav-breadcrumb-bar">
          <button
            type="button"
            className="flashcard-nav-back-button"
            onClick={() => {
              if (unitId === "__unassigned__") {
                setMobileStep("units");
              } else {
                setMobileStep("topics");
              }
              if (typeof window !== "undefined") window.scrollTo({ top: 0, behavior: "smooth" });
            }}
          >
            <span className="flashcard-nav-back-icon" aria-hidden="true">←</span>
            <span>{unitId === "__unassigned__" ? "Choose unit" : "Topics"}</span>
          </button>
          <span className="flashcard-nav-context-pill">
            {selectedUnit ? `UNIT ${String(selectedUnitIndex + 1).padStart(2, "0")}` : "DECK"}
          </span>
        </div>

        <header className="flashcard-mobile-topic-header">
          <span className="flashcard-mobile-context-tag">
            {selectedUnit ? `UNIT ${String(selectedUnitIndex + 1).padStart(2, "0")}` : "DECK"} · TOPIC
          </span>
          <h2>{selectedTopic?.title ?? "General cards"}</h2>
          <p>{visibleCards.length} {visibleCards.length === 1 ? "question" : "questions"}</p>
        </header>

        {/* Complete list of questions belonging to this topic */}
        {visibleCards.length > 0 ? (
          <div className="flashcard-question-list">
            {visibleCards.map((card, index) => (
              <button
                key={card.id}
                id={`mobile-question-item-${index}`}
                type="button"
                className={`flashcard-question-item ${mobileCardIndex === index ? "active-question" : ""}`}
                onClick={() => handleQuestionClick(index, true)}
              >
                <i>{String(index + 1).padStart(2, "0")}</i>
                <span>
                  <b>{card.title}</b>
                  {card.description && <small>{card.description}</small>}
                </span>
                <strong>View solution <em>→</em></strong>
              </button>
            ))}
          </div>
        ) : (
          <div className="study-empty">
            <h3>No cards in this topic yet.</h3>
            <p>Only content published by the admin appears here.</p>
          </div>
        )}
      </section>

      {/* Mobile/Tablet Dedicated Full-Screen Flashcard Mode */}
      {isMobileFlashcardOpen && currentMobileCard && (
        <div
          className="mobile-flashcard-fullscreen"
          role="dialog"
          aria-modal="true"
          aria-label="Flashcard study mode"
        >
          {/* Top Header */}
          <header className="mobile-flashcard-header">
            <div className="mobile-flashcard-header-info">
              <span className="mobile-flashcard-topic-title" title={selectedTopic?.title ?? "Topic"}>
                {selectedTopic?.title ?? "Topic"}
              </span>
            </div>
            <button
              type="button"
              className="mobile-flashcard-close-btn"
              onClick={closeMobileFlashcard}
              aria-label="Exit Flashcard Mode and return to question list"
            >
              <span className="mobile-flashcard-close-icon" aria-hidden="true">✕</span>
              <span>Close</span>
            </button>
          </header>

          {/* Main Flashcard Stage */}
          <main className="mobile-flashcard-stage-wrap">
            <div className="mobile-fs-stage">
              <div className={`mobile-fs-card ${mobileRevealed ? "is-flipped" : ""}`}>
                {/* Question Face */}
                <section className="mobile-fs-face mobile-fs-question" aria-hidden={mobileRevealed}>
                  <div className="mobile-fs-label">
                    <span className="flashcard-progress-capsule">
                      {mobileCardIndex + 1} of {visibleCards.length}
                    </span>
                    <small>Think before you reveal</small>
                  </div>
                  <div className="mobile-fs-content">
                    <RichContent document={currentMobileCard.question_document} fallback={currentMobileCard.title} />
                    {currentMobileCard.description && (
                      <aside>
                        <b>Hint</b>
                        <p>{currentMobileCard.description}</p>
                      </aside>
                    )}
                  </div>
                  <button
                    type="button"
                    className="view-solution"
                    onClick={toggleMobileSolution}
                    tabIndex={mobileRevealed ? -1 : 0}
                  >
                    View solution <span>↻</span>
                  </button>
                </section>

                {/* Answer Face */}
                <section className="mobile-fs-face mobile-fs-answer" aria-hidden={!mobileRevealed}>
                  <div className="mobile-fs-label">
                    <span className="answer-tag">ANSWER</span>
                    <small>Active recall</small>
                  </div>
                  <div className="mobile-fs-content">
                    <RichContent document={currentMobileCard.answer_document} fallback={currentMobileCard.body} />
                  </div>
                  <button
                    type="button"
                    className="show-question"
                    onClick={toggleMobileSolution}
                    tabIndex={mobileRevealed ? 0 : -1}
                  >
                    Show question <span>↻</span>
                  </button>
                </section>
              </div>
            </div>
          </main>

          {/* Bottom Navigation */}
          <footer className="mobile-flashcard-footer">
            <button
              type="button"
              className="mobile-flashcard-nav-btn"
              onClick={() => moveMobile(-1)}
              disabled={!canMoveMobilePrevious}
            >
              ← Previous
            </button>
            <span className="mobile-flashcard-footer-progress">
              {mobileCardIndex + 1} of {visibleCards.length}
            </span>
            <button
              type="button"
              className="mobile-flashcard-nav-btn"
              onClick={() => moveMobile(1)}
              disabled={!canMoveMobileNext}
            >
              Next →
            </button>
          </footer>
        </div>
      )}

      {/* Desktop Modal Flashcard Viewer: Used exclusively on desktop layout */}
      {viewerCard && (
        <div
          className="flashcard-viewer-backdrop"
          role="dialog"
          aria-modal="true"
          aria-label="Flashcard viewer"
          onMouseDown={() => setViewerIndex(null)}
        >
          <article className="flashcard-viewer" onMouseDown={(event) => event.stopPropagation()}>
            <header>
              <div>
                <span>{selectedTopic?.title ?? "Topic"}</span>
              </div>
              <button onClick={() => setViewerIndex(null)} aria-label="Close flashcard">×</button>
            </header>
            <div className="flashcard-stage">
              <div className={`flashcard-flip-card ${revealed ? "is-flipped" : ""}`}>
                <section className="flashcard-face flashcard-question-face" aria-hidden={revealed}>
                  <div className="flashcard-face-label">
                    <span className="flashcard-progress-capsule">
                      {(viewerIndex ?? 0) + 1} of {visibleCards.length}
                    </span>
                    <small>Think before you reveal</small>
                  </div>
                  <div className="flashcard-face-content">
                    <RichContent document={viewerCard.question_document} fallback={viewerCard.title} />
                    {viewerCard.description && (
                      <aside>
                        <b>Hint</b>
                        <p>{viewerCard.description}</p>
                      </aside>
                    )}
                  </div>
                  <button
                    type="button"
                    className="view-solution"
                    onClick={toggleSolution}
                    tabIndex={revealed ? -1 : 0}
                  >
                    View solution <span>↻</span>
                  </button>
                </section>
                <section className="flashcard-face flashcard-answer-face" aria-hidden={!revealed}>
                  <div className="flashcard-face-label">
                    <span>ANSWER</span>
                    <small>Active recall</small>
                  </div>
                  <div className="flashcard-face-content">
                    <RichContent document={viewerCard.answer_document} fallback={viewerCard.body} />
                  </div>
                  <button
                    type="button"
                    className="show-question"
                    onClick={toggleSolution}
                    tabIndex={revealed ? 0 : -1}
                  >
                    Show question <span>↻</span>
                  </button>
                </section>
              </div>
            </div>
            <footer>
              <button onClick={() => move(-1)} disabled={!canMovePrevious}>← Previous</button>
              <span>{(viewerIndex ?? 0) + 1} of {visibleCards.length}</span>
              <button onClick={() => move(1)} disabled={!canMoveNext}>Next →</button>
            </footer>
          </article>
        </div>
      )}
    </div>
  );
}
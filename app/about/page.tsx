import { Footer, Navigation, PageIntro } from "../components";

export default function AboutPage() {
  return <>
    <Navigation />
    <main>
      <PageIntro eyebrow="ABOUT CUE" title="A calmer way to prepare." description="Cue exists because finding study material should never take longer than studying it." />
      <section className="page-section about-page">
        <div className="container about-content">
          <div className="mission-card">
            <div>
              <span>OUR MISSION</span>
              <h2>Turn scattered resources into<br /><em>clear next steps.</em></h2>
            </div>
            <p>Students should be able to open one subject and immediately know what to learn, what to revise and what to solve next. Cue brings syllabi, notes, papers and quick revision into one thoughtful space.</p>
          </div>
          <div className="about-values" aria-label="Cue principles">
            <article>
              <span>01</span>
              <div><h3>Clarity over clutter</h3><p>Simple information architecture with no folder maze.</p></div>
            </article>
            <article>
              <span>02</span>
              <div><h3>Evidence over guessing</h3><p>Exam trends grounded in the papers actually available.</p></div>
            </article>
            <article>
              <span>03</span>
              <div><h3>Progress over pressure</h3><p>Small, visible wins that make preparation feel possible.</p></div>
            </article>
          </div>
          <div className="creator-card">
            <div className="creator-avatar">HS</div>
            <div><span>CREATED BY</span><h2>Harshita Singh</h2><p>Have suggestions or found an error? I’d love to hear your feedback.</p></div>
            <div className="creator-actions">
              <a
                className="creator-linkedin"
                href="https://www.linkedin.com/in/harshitasingh144"
                target="_blank"
                rel="noopener noreferrer"
                aria-label="Visit Harshita Singh on LinkedIn"
                title="Harshita Singh on LinkedIn"
              >
                <svg viewBox="0 0 24 24" aria-hidden="true">
                  <path fill="currentColor" d="M6.5 8.3H3.2V19h3.3V8.3ZM4.9 3A1.9 1.9 0 1 0 5 6.8 1.9 1.9 0 0 0 4.9 3ZM19.8 12.9c0-3.2-1.7-4.8-4.1-4.8a3.6 3.6 0 0 0-3.3 1.8V8.3H9.2V19h3.3v-5.3c0-1.4.3-2.8 2-2.8s2 1.6 2 2.9V19h3.3v-6.1Z" />
                </svg>
              </a>
            </div>
          </div>
        </div>
      </section>
    </main>
    <Footer />
  </>;
}

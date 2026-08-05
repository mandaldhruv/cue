const subjects = [
  { code: "ADV", title: "Advertising", meta: "5 units · 24 resources", tone: "coral", progress: 68 },
  { code: "EDM", title: "Equity & Debt Markets", meta: "5 units · 19 resources", tone: "blue", progress: 42 },
  { code: "BPEM", title: "Business Planning & Entrepreneurship", meta: "5 units · 21 resources", tone: "violet", progress: 31 },
  { code: "AMD", title: "Accounting for Managerial Decisions", meta: "5 units · 26 resources", tone: "mint", progress: 54 },
  { code: "ECO II", title: "Principles of Economics II", meta: "5 units · 18 resources", tone: "amber", progress: 22 },
  { code: "HIN I", title: "Hindi I", meta: "4 units · 16 resources", tone: "pink", progress: 76 },
];

const features = [
  { number: "01", title: "Everything, finally together.", copy: "Syllabus, notes, PYQs and resources—beautifully organised by subject, unit and year.", accent: "blue" },
  { number: "02", title: "Know what matters most.", copy: "Exam Insights turns past papers into chapter trends, repeated questions and a clear prep priority.", accent: "violet" },
  { number: "03", title: "Progress you can feel.", copy: "Tick off chapters, solve PYQs and continue exactly where you stopped—on any device.", accent: "coral" },
];

export default function Home() {
  return (
    <main>
      <section className="hero" id="home">
        <nav className="nav shell" aria-label="Main navigation">
          <a className="brand" href="#home" aria-label="Cue home">
            <span className="brand-mark"><i /></span>
            <span>Cue</span>
          </a>
          <div className="nav-links">
            <a className="active" href="#home">Home</a>
            <a href="#subjects">Subjects</a>
            <a href="#insights">Exam insights</a>
            <a href="#features">Why Cue?</a>
          </div>
          <a className="nav-cta" href="#subjects">Start studying <span>↗</span></a>
          <details className="mobile-menu">
            <summary aria-label="Open navigation"><span /><span /></summary>
            <div>
              <a href="#subjects">Subjects</a>
              <a href="#insights">Exam insights</a>
              <a href="#features">Why Cue?</a>
              <a href="#subjects">Start studying</a>
            </div>
          </details>
        </nav>

        <div className="hero-glow hero-glow-one" />
        <div className="hero-glow hero-glow-two" />
        <div className="hero-content shell">
          <div className="hero-copy">
            <div className="eyebrow"><span>✦</span> Made for BMS students</div>
            <h1>Study smarter.<br /><em>Stress less.</em></h1>
            <p>One calm, beautifully organised space for every note, PYQ, flashcard and exam insight you need.</p>
            <div className="hero-actions">
              <a className="button button-light" href="#subjects">Explore subjects <span>→</span></a>
              <a className="text-link" href="#insights"><span className="play">▶</span> See how it works</a>
            </div>
            <div className="trust-row">
              <div className="avatar-stack"><b>HS</b><b>AM</b><b>RK</b><b>+</b></div>
              <div><strong>Built with students</strong><span>For calmer exam seasons</span></div>
            </div>
          </div>

          <div className="hero-art" aria-label="A visual preview of Cue study tools">
            <div className="art-halo" />
            <img src="/cue-hero.png" alt="Floating glass study dashboard with flashcards and exam notes" />
            <div className="float-card progress-float">
              <span className="mini-icon">✓</span>
              <div><small>Today&apos;s progress</small><strong>4 tasks complete</strong></div>
            </div>
            <div className="float-card insight-float">
              <span className="spark">✦</span>
              <div><small>Exam insight</small><strong>Unit 3 is high priority</strong></div>
            </div>
          </div>
        </div>
        <div className="hero-bottom shell">
          <span>Scroll to discover</span><i />
          <div><b>06</b><span>Subjects</span><b>100%</b><span>Focused</span><b>01</b><span>Calm space</span></div>
        </div>
      </section>

      <section className="search-strip">
        <div className="shell search-wrap">
          <span className="search-icon">⌕</span>
          <div><small>WHAT ARE YOU STUDYING?</small><strong>Search subjects, notes, topics or PYQs...</strong></div>
          <kbd>⌘ K</kbd>
        </div>
      </section>

      <section className="section subjects-section" id="subjects">
        <div className="shell">
          <div className="section-head">
            <div><span className="kicker">YOUR SEMESTER, SORTED</span><h2>Six subjects.<br /><em>Zero chaos.</em></h2></div>
            <p>Everything for BMS Semester 3, structured so you spend less time searching and more time actually learning.</p>
          </div>
          <div className="subject-grid">
            {subjects.map((subject, index) => (
              <a className={`subject-card ${subject.tone}`} href="#" key={subject.code}>
                <div className="subject-top"><span>{subject.code}</span><b>0{index + 1}</b></div>
                <div className="subject-orbit"><i /><span>{subject.code.slice(0, 2)}</span></div>
                <h3>{subject.title}</h3>
                <p>{subject.meta}</p>
                <div className="subject-progress"><span style={{ width: `${subject.progress}%` }} /></div>
                <div className="subject-foot"><small>{subject.progress}% explored</small><span>→</span></div>
              </a>
            ))}
          </div>
          <div className="center-action"><a className="button button-dark" href="#">View all study material <span>→</span></a></div>
        </div>
      </section>

      <section className="section features-section" id="features">
        <div className="shell">
          <div className="feature-intro">
            <span className="kicker light">WHY CUE FEELS DIFFERENT</span>
            <h2>Less hunting.<br />More <em>aha.</em></h2>
            <p>Designed around the way students actually prepare—not around folders, filenames or fifty open tabs.</p>
          </div>
          <div className="feature-list">
            {features.map((feature) => (
              <article className={`feature-row ${feature.accent}`} key={feature.number}>
                <span>{feature.number}</span><h3>{feature.title}</h3><p>{feature.copy}</p><b>↗</b>
              </article>
            ))}
          </div>
        </div>
      </section>

      <section className="section insights-section" id="insights">
        <div className="shell insights-grid">
          <div className="insights-copy">
            <span className="kicker">AI-POWERED EXAM INSIGHTS</span>
            <h2>Past papers,<br /><em>decoded.</em></h2>
            <p>Cue reads years of PYQs and turns the noise into a clear, evidence-backed plan for your next exam.</p>
            <ul>
              <li><span>✓</span> Repeated topics and definitions</li>
              <li><span>✓</span> Chapter-wise marks distribution</li>
              <li><span>✓</span> Short vs long answer trends</li>
            </ul>
            <a className="button button-dark" href="#">Explore Exam Insights <span>↗</span></a>
            <small className="disclaimer">AI predictions are based on available papers and are not guarantees.</small>
          </div>
          <div className="insights-dashboard">
            <div className="dash-head"><div><span className="spark-box">✦</span><div><strong>Exam Insights</strong><small>Advertising · Semester 3</small></div></div><button>Last 5 years⌄</button></div>
            <div className="dash-stat-row">
              <div><small>PAPERS ANALYSED</small><strong>12</strong><span>↑ 2 new</span></div>
              <div><small>TOPIC CONFIDENCE</small><strong>92%</strong><span>High signal</span></div>
              <div><small>TIME TO REVISE</small><strong>4.5h</strong><span>Est. focus time</span></div>
            </div>
            <div className="dash-main">
              <div className="chart-card">
                <div className="card-label"><strong>Chapter frequency</strong><small>Appearances in PYQs</small></div>
                <div className="bars">
                  {[88, 66, 54, 41, 29].map((height, i) => <div key={i}><span style={{ height: `${height}%` }} /><small>U{i + 1}</small></div>)}
                </div>
              </div>
              <div className="priority-card">
                <div className="card-label"><strong>Prep priority</strong><small>Based on trends</small></div>
                <div className="priority-item high"><b>01</b><div><strong>Media planning</strong><small>8 appearances · 10 marks</small></div><span>HIGH</span></div>
                <div className="priority-item medium"><b>02</b><div><strong>Agency structure</strong><small>6 appearances · 5 marks</small></div><span>MED</span></div>
                <div className="priority-item low"><b>03</b><div><strong>Ad regulations</strong><small>3 appearances · short note</small></div><span>LOW</span></div>
              </div>
            </div>
          </div>
        </div>
      </section>

      <section className="section progress-section">
        <div className="shell progress-grid">
          <div className="phone-wrap">
            <div className="phone">
              <div className="phone-top"><span>9:41</span><i /><i /></div>
              <div className="phone-brand"><span className="brand-mark small"><i /></span><strong>Good evening, Harshita</strong><b>HS</b></div>
              <p>Your semester progress</p>
              <div className="big-progress"><div><strong>54%</strong><span>complete</span></div><i style={{ "--p": "54%" } as React.CSSProperties} /></div>
              <div className="continue-card"><small>CONTINUE WHERE YOU LEFT</small><strong>Equity & Debt Markets</strong><span>Unit 3 · Debt instruments</span><button>Continue learning →</button></div>
              <div className="week"><strong>This week</strong><div>{["M", "T", "W", "T", "F"].map((d, i) => <span className={i < 4 ? "done" : ""} key={i}>{i < 4 ? "✓" : d}</span>)}</div></div>
            </div>
          </div>
          <div className="progress-copy">
            <span className="kicker">YOUR PROGRESS, YOUR PACE</span>
            <h2>Pick up right<br />where you <em>paused.</em></h2>
            <p>Cue remembers what you completed, what you bookmarked and what deserves your attention next.</p>
            <div className="metric-row"><div><strong>54%</strong><span>Semester complete</span></div><div><strong>12</strong><span>Day study streak</span></div><div><strong>28</strong><span>Topics mastered</span></div></div>
            <a className="text-arrow" href="#">See your study dashboard <span>→</span></a>
          </div>
        </div>
      </section>

      <section className="quote-section">
        <div className="shell quote-inner">
          <span className="quote-mark">“</span>
          <blockquote>I stopped wasting half my study time just looking for the right PDF. Cue makes exam prep feel <em>possible</em> again.</blockquote>
          <div className="student"><b>AS</b><div><strong>Aarav Shah</strong><span>BMS · Semester 3</span></div></div>
        </div>
      </section>

      <section className="cta-section">
        <div className="cta-glow" />
        <div className="shell cta-inner">
          <span className="kicker light">YOUR CALMER SEMESTER STARTS HERE</span>
          <h2>Ready to study<br /><em>with a cue?</em></h2>
          <p>Open a subject. Find what matters. Make real progress.</p>
          <a className="button button-light" href="#subjects">Start studying now <span>→</span></a>
        </div>
      </section>

      <footer>
        <div className="shell footer-grid">
          <div className="footer-brand"><a className="brand" href="#home"><span className="brand-mark"><i /></span><span>Cue</span></a><p>Your calm corner for smarter study and less stressful exam prep.</p><small>Created with care by Harshita Singh.</small></div>
          <div><strong>Explore</strong><a href="#subjects">Subjects</a><a href="#">Flashcards</a><a href="#">PYQs</a><a href="#insights">Exam Insights</a></div>
          <div><strong>Cue</strong><a href="#features">Why Cue?</a><a href="#">About</a><a href="#">Feedback</a><a href="#">Contact</a></div>
          <div className="footer-note"><strong>Found something wrong?</strong><p>Tell us and help make Cue better for everyone.</p><a href="#">Share feedback ↗</a></div>
        </div>
        <div className="shell footer-bottom"><span>© 2026 Cue. Study smarter, stress less.</span><div><a href="#">Privacy</a><a href="#">Terms</a><a href="#home">Back to top ↑</a></div></div>
      </footer>
    </main>
  );
}

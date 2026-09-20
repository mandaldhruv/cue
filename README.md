# Cue

> Study smarter. Stress less.

Cue is a premium study platform designed for BMS students. It brings subject-wise syllabus, notes, important topics, PYQs, flashcards, resources and feedback into one calm, organised study space.

Instead of searching through WhatsApp groups, Telegram channels, folders and random links, students can open a subject and start studying.

---

## What Cue Solves

Study material is often scattered across multiple places, especially before exams.

Cue helps students find the right material quickly by organising it semester-wise and subject-wise in one place.

- Syllabus and units
- Notes and revision material
- Important / exam-focus topics
- Recommended resources
- Previous-year question papers
- Flashcards for active recall
- Private student feedback

---

## Key Features

### Student Experience

- BMS-focused, mobile-first study platform
- Semester and subject-wise organisation
- Dedicated subject workspaces
- Published syllabus, notes, important topics and resources
- Previous-year paper library with PDF preview and download
- Subject-based flashcard decks for active recall
- Student accounts with Google and email/password sign-in
- Email verification for newly created student accounts
- Login required only for protected outputs: PDF downloads and flashcard solutions
- Persistent student sessions, with the signed-in learner shown in the navigation
- Clear empty and coming-soon states when content is not available
- Private feedback form for student suggestions and issue reporting
- Educator testimonials managed by the admin
- Responsive experience across mobile, tablet and desktop

### Admin Dashboard

Cue includes a private admin workspace for managing all study material without editing code.

| Area | Admin capabilities |
| --- | --- |
| Dashboard | View live subjects, content status, semesters and feedback summary |
| Semesters | Create, reorder and publish semesters |
| Subjects | Add, edit, publish and reorder subjects |
| Study Content | Manage syllabus, notes, important topics and resources |
| Flashcards | Organise units/topics, create rich cards, reorder topics/cards and control publishing |
| PYQs & PDFs | Upload, replace, publish and manage question-paper PDFs |
| Feedback | Review private student feedback and update review status |
| Testimonials | Add approved educator testimonials with optional headshots |

---

## Flashcards: A Core Cue Feature

Cue flashcards are designed around the same study material available inside Cue. Decks follow a clear **Subject → Unit → Topic → Card** hierarchy, and questions or answers can contain structured text, lists, tables and images.

This makes revision more focused:

1. Study the notes and resources.
2. Open the related flashcards.
3. Recall important concepts through active revision.
4. Continue naturally from the last card in one topic to the first card in the next.

In the admin workspace, topics appear as a compact accordion. Admins can expand one topic at a time, reorder topics, and independently edit, reorder, publish or unpublish every card.

The goal is not just to store content, but to help students revise it properly.

---

## Student Accounts and Protected Actions

Students can browse Cue freely: subjects, published study material, PYQ listings, PDF previews and flashcard questions remain available without an account.

Cue asks a student to sign in only when they request a protected output:

- downloading a PYQ PDF; or
- revealing a flashcard solution.

The protected-action flow opens a compact Cue login modal over the current page. Students can continue with Google, sign in with an existing email/password account, or create an account and verify their email using a one-time code. The normal navigation **Sign in** control opens the complete `/login` page.

After a successful Google, email/password or email-verification flow, the student returns to the original page with a persistent server-verified session. Their name or email-based initial appears in the navigation, where they can also sign out.

---

## Tech Stack

- **Framework:** Next.js
- **Language:** TypeScript
- **Styling:** Custom CSS
- **Backend:** InsForge
- **Database:** PostgreSQL via InsForge
- **Authentication:** InsForge Auth
- **Storage:** InsForge Storage for PDF papers and testimonial images
- **Deployment:** InsForge Deployments

---

## Project Structure

```text
app/
├── admin/                 # Private admin dashboard
├── about/                 # About Cue page
├── api/auth/              # OAuth callback, refresh and current-session routes
├── auth/                  # Client auth context, session state and protected-action modal
├── feedback/              # Feedback form and testimonials
├── flashcards/            # Flashcard library and card player
├── login/                 # Student sign-in, account creation and email verification
├── pyqs/                  # Previous-year paper library
├── subjects/              # Semester, subject and study workspace pages
├── components.tsx         # Shared navigation, footer and UI components
├── data.ts                # Public navigation and display data
├── enhancements.css       # Premium UI and responsive styling
└── lib/                   # InsForge and public-content utilities

migrations/                # Database schema and access-control migrations
public/                    # Logo, favicon and visual assets
scripts/                   # Maintainer-only content import utilities
tests/                     # Build and security regression checks
PRD.md                     # Product requirements document
```

---

## Getting Started

### Prerequisites

- Node.js `22+`
- npm
- An InsForge project

### Installation

```bash
git clone https://github.com/mandaldhruv/cue.git
cd cue
npm install
```

### Environment Variables

Create a `.env.local` file in the project root.

```env
NEXT_PUBLIC_INSFORGE_URL=your_insforge_project_url
NEXT_PUBLIC_INSFORGE_ANON_KEY=your_insforge_anon_key
NEXT_PUBLIC_SITE_URL=http://localhost:3000
```

> Never commit `.env.local`, API keys or `.insforge/project.json`.

### Run Locally

```bash
npm run dev
```

Open:

```text
http://localhost:3000
```

### Production Build

```bash
npm run build
npm run start
```

### Run Tests

```bash
npm run lint
npm test
```

---

## Content Publishing Workflow

Cue follows a simple publishing model:

- **Draft** content is visible only to the admin.
- **Published** content becomes visible to students.
- Empty sections never show fake material.
- If a semester or subject is not ready, students see a clear coming-soon state.

This allows the admin to prepare and review material before making it public.

---

## Admin Access

The admin dashboard is available at:

```text
/admin/login
```

Only authorised InsForge users can access the dashboard.

The first-time setup option is intentionally not part of the public workflow. Admin access is controlled through authorised login credentials.

---

## InsForge Deployment

This project is deployed with InsForge.

```bash
npx -y @insforge/cli deployments deploy .
```

Make sure the project is linked before deployment:

```bash
npx -y @insforge/cli link --project-id YOUR_PROJECT_ID
```

---

## Important Notes

- Public browsing stays open, while downloads and flashcard answers require a student account.
- Authentication cookies are managed through InsForge SSR helpers. Never create, rename or clear auth cookies manually.
- The app verifies the current student session through `/api/auth/session`; this avoids clearing a newly established session during browser hydration.
- Student feedback is private and is never shown publicly.
- Public testimonials are managed only through the admin dashboard.
- Educator testimonials should be published only with permission.
- PDFs, notes and resources should be reviewed before publishing.
- Cue is currently focused on BMS students, with Semester 3 as the primary content-ready semester.

---

## Product Vision

Cue is more than a material library.

It is a calmer, cleaner and more focused way for BMS students to study: one place to find what matters, revise better and prepare with confidence.

---

## License

This project is private and intended for Cue.

---

Built with care for BMS students.

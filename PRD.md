# Cue: Product Requirements Document

**Product:** Cue  
**Tagline:** Study smarter. Stress less.  
**Primary audience:** BMS students  
**Document purpose:** A plain-English overview of what Cue is, what it offers students, and what the admin can manage.

---

## 1. Product overview

Cue is a central study platform for BMS students. It brings the material students usually search for across class groups, Telegram channels, folders and multiple links into one organised website.

Instead of spending time looking for the correct note, syllabus unit, past paper or revision question, a student can open their subject and start studying from the relevant material immediately.

Cue is designed to feel calm, premium and easy to use on phones, tablets and laptops. It is a study workspace, not a cluttered content library.

## 2. Problem being solved

BMS students often face these problems:

- Study material is scattered across several group chats and storage links.
- Important files are difficult to find again before an exam.
- Previous-year question papers are not consistently organised by subject and year.
- Students do not know which topics deserve more attention.
- A website can become outdated if every content change needs a developer.

Cue solves this by giving students one organised place for their subjects and giving the content owner a private admin area to update the platform independently.

## 3. Product goals

1. Help a student reach useful study material in as few steps as possible.
2. Keep all BMS subject content structured, current and easy to scan.
3. Make revision easier through flashcards and important-topic highlights.
4. Allow the admin to publish, edit, reorder or remove content without changing website code.
5. Keep the public experience focused, mobile-friendly and free from unnecessary information.

## 4. Who Cue is for

### Primary users: BMS students

Students use Cue to:

- choose their semester and subject;
- read syllabus units and important topics;
- access notes and recommended learning resources;
- preview previous-year question papers and download them after signing in;
- revise with flashcards and reveal solutions after signing in; and
- share private feedback or feature suggestions.

### Content admin

The content admin maintains the platform through a secure private dashboard. The admin controls what students can see and when it becomes visible.

### Educators and academic leaders

Educator testimonials can be displayed on the public Feedback page. These are managed by the admin and should only be published with permission.

## 5. Public website experience

### Main navigation

The public navigation includes:

- **Home:** the BMS-focused introduction to Cue and a direct route to subjects.
- **Subjects:** the main entry point for organised study material.
- **Flashcards:** active-recall revision decks grouped by subject.
- **PYQs:** previous-year question papers organised for quick access.
- **Feedback:** student feedback form and educator testimonials.
- **About:** Cue’s purpose and approach.

### Home page

The home page introduces Cue as a study platform built for BMS students. It directs students toward the subject area rather than making them read long marketing copy.

After authentication, the Home page alone shows a compact personalized greeting immediately below the navigation. The greeting uses the learner's verified profile name and must not appear on Subjects, Flashcards, PYQs, Feedback, About or legal pages. Unauthenticated visitors do not see it.

### Subjects page

Students can select a semester. Semester 3 is currently the primary BMS semester.

For an available semester, students see the published subjects. If a semester has not been prepared yet, Cue shows a clear **Coming soon** state instead of placeholder material.

### Subject workspace

When a student opens a subject, they see only material that has been published by the admin. The subject workspace can include:

- **Syllabus:** units and detailed topic coverage.
- **Important topics / Exam focus:** high-priority topics for revision.
- **Notes:** explanations, revision notes and useful links.
- **Recommended resources:** books, videos or external learning links.
- **PYQs:** previous-year papers, grouped by academic year.
- **Flashcards:** question-and-answer revision cards for that subject.

If material has not yet been uploaded, Cue does not invent dummy content. It shows an honest empty or coming-soon state.

### PYQs and PDFs

The PYQ area helps students find actual exam papers by subject and year. A student can preview a published paper in the browser without an account. Downloading a published PDF requires a Cue student account.

### Flashcards

Flashcards are Cue’s primary active-recall feature. They are created from the same structured study material available on Cue and organised as **subject → unit → topic → card**. Each card has a question or prompt followed by a detailed answer. When a student finishes the final card in one topic, they can continue directly to the first card in the next topic.

Students can browse flashcard questions freely. Revealing an answer requires a Cue student account.

### Student accounts

Cue supports student accounts through Google or email/password sign-in. A new email/password account is verified through a one-time email code before it can be used.

Students do not have to sign in immediately on entering Cue. The site remains browsable, and authentication is requested only for protected outputs such as PDF downloads and flashcard solutions. When a protected action is selected, Cue opens a compact sign-in modal over the current page. The normal navigation sign-in control opens the complete login page.

After successful sign-in, Google OAuth or email verification, Cue restores the original page and displays the signed-in learner’s name or initial in the navigation. The session is server-verified so it remains available after a page refresh.

### Greeting sequence

Cue maintains separate Admin and Student greeting collections. Each collection contains 100 messages for each of eight three-hour IST (`Asia/Kolkata`) blocks. Messages advance sequentially, never randomly.

The authoritative position is stored per authenticated user, audience and time block in InsForge. It continues across devices, browsers and days, and rolls from 100 to 1. A single display-event identifier is idempotent so hydration, retries or React Strict Mode cannot consume two messages for one page entry. Concurrent devices reserve different messages atomically. The Admin greeting enhances the main dashboard heading; Student greetings remain restricted to the public Home page. An authorised Admin can use both surfaces, but the two audience counters and message collections remain independent.

### Feedback page

The Feedback page is intentionally compact and student-friendly:

1. Admin-approved educator testimonials appear first, where available.
2. The feedback form asks for:
   - a 1–5 star rating;
   - an optional email address; and
   - a written suggestion, issue or idea.

Submissions are private. They are stored for the admin to review and are not displayed publicly as student comments.

## 6. Admin dashboard

The admin dashboard is private. Only authorised users who sign in with an approved email address and password can access it.

The dashboard is divided into practical sections:

| Admin area | What the admin can do |
| --- | --- |
| **Dashboard** | See a quick summary of live subjects, published material, available semesters, new feedback and content needing attention. |
| **Semesters** | Create and manage semesters, set their order and control whether they are published, draft or coming soon. |
| **Subjects** | Add, edit, reorder, publish or unpublish subjects within a semester. |
| **Study Content** | Choose a semester and subject, then manage syllabus units, notes, exam-focus topics and recommended resources. |
| **Flashcards** | Organise decks by unit and topic; create rich question-and-answer cards; reorder topics/cards; and control whether each item is live or draft. |
| **PYQs & PDFs** | Upload PDF papers, attach a title, year, exam type and description, then publish, replace or remove them. |
| **Feedback & Testimonials** | Review student feedback, set its review status, add private notes and manage public educator testimonials. |

### Content publishing rules

Every major item can be saved as either:

- **Draft:** visible only in the admin dashboard; or
- **Published / Live:** visible to students on the public website.

This allows content to be prepared in advance and checked before students can access it.

### Educator testimonials

The admin can add a testimonial from a principal, HOD, teacher or academic leader. Each testimonial can include:

- person’s name;
- designation and institution;
- quote;
- optional professional headshot;
- image description for accessibility;
- star rating;
- display order;
- featured status; and
- a private permission/consent record.

Only published testimonials appear on the public website.

## 7. Key user journeys

### Student: start studying

1. Open Cue.
2. Select **BMS Subjects** or **Subjects**.
3. Choose a semester.
4. Select a subject.
5. Open the required section: syllabus, notes, important topics, resources, PYQs or flashcards.
6. Study or preview a paper without signing in.
7. Sign in only when downloading a paper or revealing a flashcard solution.

### Student: submit feedback

1. Open **Feedback**.
2. Choose a rating.
3. Optionally add an email address for follow-up.
4. Write the feedback or suggestion.
5. Submit it privately.

### Admin: publish new subject content

1. Sign in to the private admin dashboard.
2. Open **Study Content**.
3. Select a semester, then select a subject.
4. Choose the content type: syllabus, notes, exam focus or resources.
5. Add the content, choose its order and save it as draft or published.
6. Preview the student-facing subject page when needed.

### Admin: upload a previous-year paper

1. Open **PYQs & PDFs**.
2. Select semester and subject.
3. Upload a PDF and add its title, academic year, exam type and description.
4. Save it as draft or publish it.
5. Students can then access it in the relevant public PYQ area.

## 8. Design and usability requirements

- The experience must work well on mobile phones, tablets and laptops.
- Login, account creation, email verification and signed-in navigation must work consistently across mobile phones, tablets and laptops.
- Navigation should always make it clear which page the student is on.
- Text, controls and touch targets must remain comfortable to read and tap.
- Public subject pages should prioritise actual study material over long introductory text.
- Empty areas should show a clear, honest status rather than dummy material.
- The admin dashboard should be efficient and uncluttered, with semester and subject selection available before content editing.
- Visual style should remain premium, calm and BMS-focused.

## 9. Content requirements

For every subject, the admin should aim to prepare:

- syllabus units;
- important/exam-focus topics;
- notes;
- recommended resources;
- previous-year question papers, where available; and
- flashcards for quick revision.

Content should be accurate, clearly titled and placed in the appropriate subject. PDFs should be readable and named clearly before publication.

## 10. Current scope

The current Cue product includes the public website, student accounts, protected downloads and flashcard solutions, subject discovery, subject workspaces, PYQs, flashcards, private student feedback, public educator testimonials and the admin management dashboard.

The platform is currently focused on BMS content, with Semester 3 as the primary prepared semester. Additional semesters can be added and managed through the admin dashboard as their content becomes available.

## 11. Future opportunities

These are possible future improvements, not requirements for the current release:

- saved study progress for student accounts;
- bookmarks or favourites;
- search across subjects and study material;
- study reminders or revision plans;
- analytics on the most-used content;
- richer PDF annotations; and
- expansion to additional courses or colleges.

## 12. Success criteria

Cue is successful when:

- a BMS student can find the right subject material quickly;
- students spend less time searching through chats and folders;
- the admin can maintain content without developer support;
- only accurate, published material is visible publicly;
- the site remains polished and easy to use across devices; and
- student feedback creates a practical loop for improving the platform.

---

**Product positioning:** Cue is the organised study space for BMS students, one calm place for the material they need to learn, revise and prepare with confidence.

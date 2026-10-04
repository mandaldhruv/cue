import test from "node:test";
import assert from "node:assert/strict";
import fs from "node:fs/promises";
import path from "node:path";

async function source(relPath) {
  return fs.readFile(path.join(process.cwd(), relPath), "utf8");
}

test("Issue 1: Members & Users Mobile Layout — Zero excess blank space, attached search icon, and 2-row filters", async () => {
  const [enhancements, membersManager] = await Promise.all([
    source("app/enhancements.css"),
    source("app/admin/members/MembersManager.tsx"),
  ]);

  // 1. MembersManager semantic structure
  assert.match(membersManager, /<div className="members-toolbar">/);
  assert.match(membersManager, /<div className="members-search-wrap">/);
  assert.match(membersManager, /<span className="members-search-icon"/);
  assert.match(membersManager, /<input[\s\S]*type="search"/);
  assert.match(membersManager, /<div className="members-filters">/);

  // 2. Mobile Toolbar: flex-direction column with clean gap & margin
  assert.match(
    enhancements,
    /\.members-toolbar\s*\{[^}]*display:\s*flex;[^}]*flex-direction:\s*column;[^}]*gap:\s*20px;[^}]*margin-bottom:\s*20px;/
  );

  // 3. Search Wrap: flex-basis reset (flex: 0 0 auto !important) to prevent 300px column stretch bug
  assert.match(
    enhancements,
    /\.members-search-wrap\s*\{[^}]*flex:\s*0 0 auto\s*!important;[^}]*max-width:\s*100%\s*!important;[^}]*width:\s*100%\s*!important;[^}]*height:\s*auto\s*!important;/
  );

  // 4. Search Input: 42px touch target with proper padding
  assert.match(
    enhancements,
    /\.members-search-wrap input\s*\{[^}]*width:\s*100%\s*!important;[^}]*height:\s*42px\s*!important;[^}]*min-height:\s*42px\s*!important;/
  );

  // 5. Search Icon: stays inside input, vertically centered, never detached
  assert.match(
    enhancements,
    /\.members-search-icon\s*\{[^}]*position:\s*absolute\s*!important;[^}]*left:\s*12px\s*!important;[^}]*top:\s*50%\s*!important;[^}]*transform:\s*translateY\(-50%\)\s*!important;/
  );

  // 6. Mobile Filter Grid: Row 1 has Role & Activity (50/50), Row 2 has Sort (full width)
  assert.match(
    enhancements,
    /\.members-filters\s*\{[^}]*display:\s*grid\s*!important;[^}]*grid-template-columns:\s*1fr 1fr\s*!important;[^}]*gap:\s*16px 12px\s*!important;/
  );
  assert.match(
    enhancements,
    /\.members-filters label:nth-child\(1\),\s*\.members-filters label:nth-child\(2\)\s*\{[^}]*grid-column:\s*span 1\s*!important;/
  );
  assert.match(
    enhancements,
    /\.members-filters label:nth-child\(3\)\s*\{[^}]*grid-column:\s*1\s*\/\s*-1\s*!important;/
  );

  // 7. Filter labels & selects: touch friendly height, no vertical gaps
  assert.match(
    enhancements,
    /\.members-filters label\s*\{[^}]*display:\s*flex\s*!important;[^}]*flex-direction:\s*column\s*!important;[^}]*gap:\s*5px\s*!important;/
  );
  assert.match(
    enhancements,
    /\.members-filters select\s*\{[^}]*width:\s*100%\s*!important;[^}]*height:\s*42px\s*!important;/
  );
});

test("Issue 2: Admin Dashboard Greeting — Server-side initial reservation eliminates placeholder flash", async () => {
  const [dashboardPage, greetingDisplay] = await Promise.all([
    source("app/admin/page.tsx"),
    source("app/greetings/GreetingDisplay.tsx"),
  ]);

  // 1. Dashboard page reserves greeting on the server during SSR
  assert.match(dashboardPage, /client\.database\.rpc\("reserve_cue_greeting"/);
  assert.match(dashboardPage, /p_audience:\s*"admin"/);
  assert.match(dashboardPage, /initialGreetingTimeBlock/);

  // 2. Resilient fallback to IST time block if reservation unavailable
  assert.match(dashboardPage, /timeZone:\s*"Asia\/Kolkata"/);
  assert.match(dashboardPage, /greetingMessages\.admin/);

  // 3. AdminGreeting receives server-resolved initial greeting props
  assert.match(dashboardPage, /<AdminGreeting[\s\S]*initialUserId=\{user\.id\}/);
  assert.match(dashboardPage, /initialMessage=\{initialGreeting\}/);
  assert.match(dashboardPage, /initialTimeBlock=\{initialGreetingTimeBlock\}/);

  // 4. GreetingDisplay initializes state with initialGreeting so SSR & client hydrate identical content
  assert.match(greetingDisplay, /initialMessage/);
  assert.match(greetingDisplay, /initialGreeting/);
  assert.match(
    greetingDisplay,
    /const message = greeting\?\.message \?\? initialGreeting\?\.message \?\? null;/
  );

  // 5. AdminGreeting renders activeMessage directly without showing 'Your publishing dashboard'
  assert.match(
    greetingDisplay,
    /const activeMessage = message \|\| initialMessage;/
  );
  assert.match(
    greetingDisplay,
    /<strong>\{activeMessage \|\| fallback\}<\/strong>/
  );
});

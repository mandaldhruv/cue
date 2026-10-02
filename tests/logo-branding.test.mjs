import test from "node:test";
import assert from "node:assert/strict";
import fs from "node:fs/promises";
import path from "node:path";

async function source(relPath) {
  return fs.readFile(path.join(process.cwd(), relPath), "utf8");
}

test("Logo Branding: transparent PNG with loop-arrow is used across all website surfaces", async () => {
  const [components, globals, enhancements] = await Promise.all([
    source("app/components.tsx"),
    source("app/globals.css"),
    source("app/enhancements.css"),
  ]);

  // 1. Components Logo component references cue-logo-transparent.png and cue-logo-white.png
  assert.match(components, /src="\/cue-logo-transparent\.png"/);
  assert.match(components, /src="\/cue-logo-white\.png"/);
  assert.match(components, /className="cue-original-wordmark cue-logo-dark"/);
  assert.match(components, /className="cue-original-wordmark cue-logo-light"/);

  // 2. CSS handles light surfaces (default dark logo) and dark surfaces (white logo with blue arrow)
  assert.match(globals, /\.cue-logo-light\{display:none!important\}/);
  assert.match(globals, /\.cue-logo-dark\{display:block\}/);
  assert.match(globals, /\.site-footer \.cue-logo-light,\.admin-sidebar \.cue-logo-light/);
  assert.match(globals, /\.site-footer \.cue-logo-dark,\.admin-sidebar \.cue-logo-dark/);

  // 3. Verify files exist on disk and are valid RGBA PNGs (colorType 6)
  const darkBuffer = await fs.readFile(path.join(process.cwd(), "public/cue-logo-transparent.png"));
  const whiteBuffer = await fs.readFile(path.join(process.cwd(), "public/cue-logo-white.png"));

  assert.equal(darkBuffer.readUInt32BE(0), 0x89504E47); // PNG signature
  assert.equal(darkBuffer[25], 6); // RGBA color type (true alpha channel)
  assert.equal(whiteBuffer.readUInt32BE(0), 0x89504E47);
  assert.equal(whiteBuffer[25], 6); // RGBA color type (true alpha channel)

  // 4. Ensure no muddy CSS inversion filters are applied to the new logo
  assert.doesNotMatch(enhancements, /\.admin-mobile-header \.cue-original-wordmark\s*\{[^}]*filter:\s*invert/);
  assert.doesNotMatch(enhancements, /\.footer-brand \.cue-original-wordmark\s*\{[^}]*filter:\s*brightness\(0\)\s*invert/);
});

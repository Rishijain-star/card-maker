/**
 * Reorders <section class="screen"> blocks inside .screen-stack for a logical user-journey order.
 * Run: node prototype/scripts/reorder-screen-stack.mjs
 */
import fs from "fs";
import path from "path";
import { fileURLToPath } from "url";

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const htmlPath = path.join(__dirname, "..", "index.html");

const ORDER = [
  "screen-launch-white",
  "screen-onboard-1",
  "screen-onboard-2",
  "screen-onboard-3",
  "screen-welcome",
  "screen-login",
  "screen-register",
  "screen-forgot-password",
  "screen-flow-guide",
  "screen-home",
  "screen-search",
  "screen-results",
  "screen-ride-detail",
  "screen-booking",
  "screen-live-trip",
  "screen-review",
  "screen-new-ride",
  "screen-datetime",
  "screen-preferences",
  "screen-my-rides",
  "screen-my-rides-passenger",
  "screen-garage",
  "screen-account",
  "screen-settings",
  "screen-edit-profile",
  "screen-trip-history",
  "screen-payment-history",
  "screen-profile-setup",
];

/** Insert comment line immediately before this screen id */
const COMMENT_BEFORE = {
  "screen-launch-white": "        <!-- ═══ Launch & onboarding ═══ -->\n",
  "screen-login": "        <!-- ═══ Authentication ═══ -->\n",
  "screen-flow-guide":
    "        <!-- ═══ Journey map · prototype overview (optional entry point) ═══ -->\n",
  "screen-home": "        <!-- ═══ Home hub ═══ -->\n",
  "screen-search": "        <!-- ═══ Passenger · search & book ═══ -->\n",
  "screen-new-ride": "        <!-- ═══ Driver · publish & manage ═══ -->\n",
  "screen-my-rides": "        <!-- ═══ My rides & vehicle ═══ -->\n",
  "screen-my-rides-passenger":
    "        <!-- ═══ My rides · passenger tab (static frame) ═══ -->\n",
  "screen-account": "        <!-- ═══ Account · profile & billing ═══ -->\n",
};

let html = fs.readFileSync(htmlPath, "utf8");

const stackOpen = '<div class="screen-stack">';
const navComment = "\n      <!-- Bottom navigation -->";
const startIdx = html.indexOf(stackOpen);
const endIdx = html.indexOf(navComment);
if (startIdx === -1 || endIdx === -1) {
  console.error("Could not find screen-stack or bottom nav marker.");
  process.exit(1);
}

const openEnd = startIdx + stackOpen.length;
const inner = html.slice(openEnd, endIdx);

const sectionRe = /<section\b[^>]*class="screen[\s\S]*?<\/section>/g;
const blocks = [...inner.matchAll(sectionRe)].map((m) => m[0]);
const ids = blocks.map((b) => {
  const idm = b.match(/\bid="([^"]+)"/);
  if (!idm) throw new Error("Section without id");
  return idm[1];
});

const seen = new Set();
const byId = {};
for (let i = 0; i < ids.length; i++) {
  if (seen.has(ids[i])) console.warn("Duplicate section id:", ids[i]);
  seen.add(ids[i]);
  byId[ids[i]] = blocks[i];
}

for (const id of ORDER) {
  if (!byId[id]) {
    console.error("Missing section in HTML:", id);
    process.exit(1);
  }
}

function normalizeIndent(sectionHtml) {
  const trimmed = sectionHtml.trimEnd();
  const lines = trimmed.split("\n");
  const body = lines.map((line) => line.trimEnd()).join("\n");
  return "        " + body.replace(/\n/g, "\n        ");
}

let out = "\n";
for (const id of ORDER) {
  if (COMMENT_BEFORE[id]) out += COMMENT_BEFORE[id];
  out += normalizeIndent(byId[id]) + "\n\n";
}

const newHtml =
  html.slice(0, openEnd) + out + "      </div>\n\n" + html.slice(endIdx);

fs.writeFileSync(htmlPath, newHtml, "utf8");
console.log("Reordered", ORDER.length, "screens.");

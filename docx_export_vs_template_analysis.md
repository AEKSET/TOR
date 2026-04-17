# DOCX Export vs Template Analysis

> Updated: 2026-04-16
> Compared against both templates (Turnkey + Outsource)

## Files compared

| Role | File |
|---|---|
| Export | `Test Export/โครงการพัฒนาระบบบริหารจัดการสัญญาและการจัดซื้อจัดจ้าง (Contract & Procurement Management System)_20260409_1356.docx` |
| Template 1 (Turnkey) | `templates/tor/05. Terms of Reference (ToR) SET_PRO_05_v.2_20250509_แก้ไขแจ้ง Password.docx` |
| Template 2 (Outsource) | `templates/tor/5. Template_TOR Outsource v.1_20250509_สำหรับ Biding.docx` |

---

## Summary

The two templates share **identical file structure** (34 files each). The export is significantly smaller (368 KB vs 1.3–1.5 MB) and is missing 20 files present in both templates. The export also has 5 extra `word/_rels/*.xml.rels` files that templates do not need (Word generates these automatically).

---

## File Count

| | Export | Template1 (Turnkey) | Template2 (Outsource) |
|---|---|---|---|
| Total files | 20 | 34 | 34 |
| Structure identical | — | ✅ same as T2 | ✅ same as T1 |

---

## Files Missing from Export (present in both templates)

| Missing File | Importance |
|---|---|
| `customXml/_rels/item1–4.xml.rels` | SharePoint/content-type metadata links |
| `customXml/item1–4.xml` | SharePoint metadata (bibliography, FormTemplates, properties, contentTypeSchema) |
| `customXml/itemProps1–4.xml` | CustomXml part properties |
| `word/commentsExtended.xml` | Extended comment data (Word 2013+) |
| `word/commentsExtensible.xml` | Extensible comment data (Word 2016+) |
| `word/commentsIds.xml` | Comment IDs mapping |
| `word/endnotes.xml` | Endnotes (even if empty, required by template) |
| `word/media/image1.png` | **SET logo / header image** — critical for branding |
| `word/people.xml` | Author/reviewer people metadata |
| `word/theme/theme1.xml` | **Document theme (fonts, colors)** — critical for correct rendering |
| `word/webSettings.xml` | Web view settings |

---

## Files Present in Both — Size Comparison

| File | Export | Template1 (Turnkey) | Template2 (Outsource) | Status |
|---|---|---|---|---|
| `[Content_Types].xml` | 2,229 | 3,361 | 3,361 | ⚠️ Export too small |
| `_rels/.rels` | 718 | 737 | 737 | ✅ Similar |
| `docProps/app.xml` | 230 | 996 | 995 | ⚠️ Missing metadata |
| `docProps/core.xml` | 643 | 813 | 813 | ⚠️ Missing properties |
| `docProps/custom.xml` | 228 | 592 | 402 | ⚠️ Missing custom props |
| `word/_rels/document.xml.rels` | 1,182 | 3,192 | 3,192 | ❌ Missing 14 relationships |
| `word/comments.xml` | 2,246 | 79,077 | 79,531 | ❌ ~3% of template size |
| `word/document.xml` | 311,075 | 843,021 | 1,042,208 | ❌ ~37%/30% of template — body content differs significantly |
| `word/fontTable.xml` | 835 | 5,897 | 5,897 | ❌ Only ~14% — missing fonts |
| `word/footer1.xml` | 2,393 | 5,834 | 6,319 | ⚠️ Footer content incomplete |
| `word/footnotes.xml` | 1,692 | 16,288 | 16,231 | ❌ Missing footnotes |
| `word/header1.xml` | 2,677 | 3,568 | 2,998 | ⚠️ Slightly different |
| `word/numbering.xml` | 3,172 | 93,969 | 98,520 | ❌ ~3% of template — list styles nearly absent |
| `word/settings.xml` | 1,395 | 40,407 | 40,817 | ❌ ~3% — missing document settings |
| `word/styles.xml` | 4,840 | 54,962 | 55,266 | ❌ ~9% — most paragraph/character styles missing |

---

## Files in Export NOT in Templates

These are auto-generated relationship files — Word creates them on open. Not a problem.

- `word/_rels/comments.xml.rels`
- `word/_rels/fontTable.xml.rels`
- `word/_rels/footer1.xml.rels`
- `word/_rels/footnotes.xml.rels`
- `word/_rels/header1.xml.rels`

---

## customXml Contents Differ Between Templates

The customXml items serve the same purpose in both templates but are stored in different order/numbering:

| item | Template1 (Turnkey) | Template2 (Outsource) |
|---|---|---|
| item1 | Bibliography (APA) | FormTemplates (SharePoint) |
| item2 | FormTemplates (SharePoint) | contentTypeSchema (SharePoint CT ID: `0x010100349ECA3B...`) |
| item3 | properties (documentManagement, empty) | properties + PublishingExpirationDate metadata |
| item4 | contentTypeSchema (SharePoint CT ID: `0x01010083B6AE8F...`) | Bibliography (APA) |

**Content Type IDs differ** — these are SharePoint library-specific and should not be blindly copied.

---

## Critical Gaps for Export Quality

### 1. `word/styles.xml` — 9% of template size
The export has almost no styles defined. This means:
- Heading styles (หัวข้อ 1–4), body text, table styles are all missing
- Document will render with default Word styles, not SET template styles

### 2. `word/numbering.xml` — 3% of template size
- All list/numbering formats (numbered lists, bullet lists with Thai style) are absent
- Numbered clauses (ข้อ 1. ข้อ 1.1) will not render correctly

### 3. `word/settings.xml` — 3% of template size
- Missing: compatibility settings, revision tracking settings, document protection, Thai language settings

### 4. `word/media/image1.png` — completely absent
- SET logo or header image is not embedded in the export
- Header will be text-only or broken

### 5. `word/theme/theme1.xml` — completely absent
- Theme fonts and colors not defined
- Word falls back to default theme, affecting color of headings and accents

### 6. `word/document.xml` — 37% of Turnkey template
- Most of the TOR body content is present but the template likely has styles/formatting references that are not replicated
- Should be the largest file — currently 311KB vs 843KB (template1) suggests ~55% of content is missing or condensed without proper markup

---

## Recommended Fix Strategy

### Priority 1 — Carry-over from template (copy as-is)
These files do not contain user data and should be copied from the appropriate template before injecting document content:

- `word/styles.xml` — preserve all SET styles
- `word/numbering.xml` — preserve all list formats
- `word/settings.xml` — preserve document settings
- `word/theme/theme1.xml` — preserve theme
- `word/fontTable.xml` — preserve font table
- `word/media/image1.png` — preserve SET logo
- `word/endnotes.xml` — required (even if empty)
- `word/webSettings.xml` — required for compatibility

### Priority 2 — Merge/inject document body
- `word/document.xml` — inject generated content using template's paragraph styles and structure
- `word/header1.xml` / `word/footer1.xml` — use template versions (SET branding + page numbers)
- `word/footnotes.xml` — use template base + append generated footnotes

### Priority 3 — Carry-over or omit (low impact)
- `customXml/` — can copy from template; content is SharePoint metadata (not user data)
- `word/comments.xml` — strip all comments from template (set to empty), keep structure
- `word/commentsExtended.xml`, `commentsExtensible.xml`, `commentsIds.xml`, `people.xml` — empty stubs are fine

### Priority 4 — Update relationship files
- `word/_rels/document.xml.rels` — must reference all carried-over parts (theme, image, customXml, endnotes, webSettings, commentsExtended, people)
- `[Content_Types].xml` — must declare all new part types
- `_rels/.rels` — may need update if customXml is included

---

## Implementation Approach

The current export is built by **docx.js** (inlined in `index.html`) which generates a minimal DOCX from scratch. To align with the template:

**Option A — Template Merge (recommended)**
1. Fetch the appropriate template (`template1` for Turnkey, `template2` for Outsource) as binary
2. Unzip it in memory (JSZip, which docx.js already bundles)
3. Replace `word/document.xml` with the generated content
4. Update `word/header1.xml` and `word/footer1.xml` with dynamic values (project name, date)
5. Re-zip and offer as download

**Option B — Style Import**
1. Extract `styles.xml`, `numbering.xml`, `theme/theme1.xml`, `settings.xml` from template at build time
2. Embed them as base64 constants in `index.html`
3. Inject them into every docx.js export

Option A produces output closest to the original template and is the most maintainable.

---

## Usage

This file serves as a reference for `index.html` export logic improvements and future Claude Code sessions working on the DOCX generation feature.

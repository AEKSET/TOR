# SET TOR Generator — Project Memory & Design Guide

> Last updated: 2026-04-08
> Reference system: SET Procurement Portal (internal, observed via screenshot)

---

## 1. Project Overview

The **SET TOR Generator** (`index.html`) is a single-page HTML application that helps SET procurement staff generate Terms of Reference (TOR) documents for Turnkey / Outsource projects. It produces a `.docx` output and optionally passes data to a Contract Generator.

Key files:
- `index.html` — main TOR generator (self-contained, all CSS/JS inline)
- `contract.html` — contract generator that receives data from TOR
- `sow.html` — Scope of Work document generator
- `test_outsource.html` — outsource variant test build
- `index_backup.html` — previous version backup

---

## 2. Procurement Portal — Design Reference

The SET **Procurement Portal** is the internal system through which all purchase requisitions flow. Its UI sets the visual standard that internal SET tools should align to.

### 2.1 Layout Architecture

| Zone | Description |
|---|---|
| Top header | Full-width dark navy bar; portal title + icon left, user badge right |
| Decorative banner strip | Colorful Thai flag bunting pattern just below header |
| Left sidebar | Vertical step navigator (fixed width ~220px); steps shown with icons |
| Main content | White card-based content area; scrollable |
| Bottom action bar | Fixed, light gray, left=navigation buttons, right=action buttons |

The TOR Generator currently uses a **horizontal top tab nav** + fixed bottom bar. The Portal uses a **vertical left sidebar** — this is the primary layout divergence.

### 2.2 Procurement Portal — Step Sidebar Pattern

- Each step item has: icon (left) + label text
- States:
  - **Completed** — green checkmark circle icon
  - **Active** — blue text + yellow/gold right-border indicator bar (3-4px solid on right edge)
  - **Pending** — gray text, no icon or unfilled circle
- Sidebar background: white or very light gray
- Active step has a vertical yellow bar on the **right** side of the sidebar item (not left)
- Steps are: Pre-PR Request → PR Draft → PR Flow Setup → PR Approval

### 2.3 Procurement Portal — Color Palette

| Token | Hex | Usage |
|---|---|---|
| `--portal-navy` | `#1a2c4e` | Header background, primary actions fill |
| `--portal-gold` | `#f0a500` | Accent, active step indicator, highlights |
| `--portal-blue-active` | `#1d4ed8` (approx) | Active step text, link color |
| `--portal-green` | `#16a34a` | Completed steps, Approve button |
| `--portal-red-soft` | `#f87171` / `#f48` salmon | Send Back / destructive action button |
| `--portal-orange-badge` | `#f97316` | User welcome pill badge |
| `--portal-input-readonly` | `#f0f0f0` | Read-only form field background |
| `--portal-card-bg` | `#ffffff` | Card/panel background |
| `--portal-page-bg` | `#f3f4f6` | Page background |
| `--portal-link` | `#2563eb` | Attachment links, inline links |
| `--portal-table-header` | `#ffffff` | Table header row background |
| `--portal-border` | `#e5e7eb` | Card borders, table dividers |
| `--portal-status-pending` | amber/yellow text | Status badge "Pending Approve" |

### 2.4 Procurement Portal — Typography

- Font: likely **Sarabun** (Thai) + system sans-serif (matches TOR Generator — already correct)
- Label alignment: **right-aligned** (in form rows, labels sit to the right, value field to the left)
- Field values: left-aligned inside inputs
- Card titles: medium-large, bold, dark navy
- Section sub-labels: smaller, gray/muted
- Mixed Thai + English throughout

### 2.5 Procurement Portal — Component Patterns

#### Header
```
[monitor icon] Procurement Portal          [Welcome, Name] (orange pill)
─────────────────── bunting decoration ────────────────────
```
- Dark navy (`#1a2c4e`) background
- Title in white, bold
- User name in orange pill badge (rounded, filled)
- Bunting/decoration strip is decorative only (not interactive)

#### Sidebar Step Navigator
```
[ ✅ ] Pre-PR Request
[ ✅ ] PR Draft
[ ✅ ] PR Flow Setup
[ 🔵 ] PR Approval          |  ← yellow right border
```
- `border-right: 3px solid #f0a500` on active item
- Completed: `color: #16a34a` + check SVG icon
- Active: `color: #1d4ed8` + blue dot or filled circle icon
- Pending: `color: #9ca3af`

#### Cards
- White background, `border: 1px solid #e5e7eb`, `border-radius: 8px`
- Card header: title left, status/action right (flex row)
- Status badge inline with title (e.g. "Status: Pending Approve" in amber/orange badge)
- Padding: `1.25rem 1.5rem`

#### Form Fields (Read-only Approval View)
- Label: right-aligned, `font-size: 0.8rem`, `color: #6b7280`, `font-weight: 600`
- Input: `background: #f0f0f0`, `border: 1px solid #d1d5db`, `border-radius: 6px`, read-only cursor
- Grid layout: label col (~30% width) + field col (~70%)

#### Data Table
- White background, column headers white with sort arrow icons
- Row dividers: `border-bottom: 1px solid #f3f4f6`
- Columns: No. | รายละเอียด | Account | Project | Qty | Unit Price | จำนวนเงิน | Actions
- Action icons: eye (view) + kebab menu (more options)
- Alternating rows: very subtle (or none)

#### Attachment Card
- Links displayed as blue text with external-link icon (`↗`)
- Each file on its own line, clickable
- Card label: "เอกสารแนบ" as section header

#### Bottom Action Bar (Portal version)
- Background: `#f9fafb` (light gray, NOT dark navy like TOR Generator)
- `border-top: 1px solid #e5e7eb`
- Left group: "PR List" (dark filled) + "Previous" (outline)
- Right group: "Recall" (outline + icon) | "Send Back" (pink/salmon) | "Approve" (green)
- Padding: `0.75rem 1.5rem`

---

## 3. TOR Generator — Current Design System

### 3.1 CSS Custom Properties (as of 2026-04-08)

```css
:root {
  --bg: #f5f4f0;
  --surface: #ffffff;
  --card: #fafaf8;
  --border: #ddd9d0;
  --border-light: #ede9e0;
  --accent: #1a3a5c;       /* dark navy — primary */
  --accent2: #c8972a;      /* warm gold — secondary/highlight */
  --accent3: #4a7c59;      /* forest green — success/done */
  --text: #1a1a1a;
  --muted: #6b6560;
  --success: #2d6a4f;
  --danger: #9b2335;
  --warning: #c8721a;
  --input-bg: #fff;
}
```

### 3.2 Current Layout

- **Header**: full-width dark navy (`--accent`) bar; `border-bottom: 4px solid var(--accent2)` (gold)
- **Navigation**: horizontal tab bar below header; tabs have `step-num` badge + label
- **Active tab**: `border-bottom: 3px solid var(--accent2)` + gold step-num badge
- **Done tab**: green step-num badge (`--accent3`)
- **Content**: `max-width: 1100px` centered, `--bg` page background
- **Cards**: white surface, `border-radius: 8px`, `border: 1px solid var(--border)`
- **Bottom bar**: dark navy (`#1a3a5c`), `border-top: 2px solid var(--accent2)`, fixed position

### 3.3 Bottom Bar — Current Buttons

| Button | Class | Description |
|---|---|---|
| Previous | `bb-btn--dark` | Semi-transparent white on navy |
| Save Draft | `bb-btn--save` | Semi-transparent white on navy |
| บันทึกเข้า Contract | `bb-btn--outline` | Orange-tinted, warm |
| ถัดไป / Submit | `bb-btn--primary` | Gold fill (`--accent2`), navy text |

---

## 4. Design Alignment Recommendations

### 4.1 Elements to Adopt from Procurement Portal

#### HIGH PRIORITY
1. **Left sidebar step navigation** — Replace horizontal tabs with a vertical left sidebar. This matches the Portal pattern and improves usability for 7-step wizard.
   - Width: 220–240px, sticky/fixed
   - States: completed (green check), active (blue + yellow right-border), pending (gray)
   - Step labels in Thai match existing `nav-step` labels

2. **User/context badge in header** — Add a user context indicator (e.g., "TOR Generator" + project name pill) to the top-right of the header in the Portal's orange/amber pill style.

3. **Breadcrumb** — Add a small breadcrumb line below the header ("TOR Generator / [Current Step Name]") matching Portal's pattern.

4. **Card header layout** — Card titles should have a right-aligned status/action element (e.g., completeness %, TOR type badge).

#### MEDIUM PRIORITY
5. **Input field readonly state** — Use `background: #f0f0f0` (Portal pattern) for display-only fields in review panels, not just white.

6. **Bottom bar background** — Consider lightening the TOR Generator's bottom bar from dark navy to light gray (`#f9fafb`) to match Portal, and use dark navy buttons (filled) instead of transparent-on-dark pattern. However, the current dark navy approach is acceptable as it provides good contrast.

7. **Link styling for attachments** — If adding an attachments section, use blue links with `↗` icon per Portal pattern.

8. **Table action icons** — For the line items / deliverables table, add eye (view) + menu action column per Portal pattern.

#### LOW PRIORITY / OPTIONAL
9. **Bunting decoration strip** — A subtle Thai-inspired decorative strip below the header could reinforce SET branding. This is purely aesthetic.

10. **Status badge on card header** — "Status: Draft / In Review / Complete" badge mirroring the "Status: Pending Approve" pattern.

### 4.2 Color Tokens — Recommended Additions

Add these to `:root` for Portal alignment:

```css
/* Portal-aligned additions */
--portal-readonly-bg: #f0f0f0;   /* read-only input fields */
--portal-link: #2563eb;           /* attachment/inline links */
--portal-badge-orange: #f97316;  /* user/status pill badge */
--portal-sidebar-active-border: #f0a500;  /* yellow right-border on active step */
--sidebar-completed: #16a34a;    /* green for completed steps (maps to --accent3) */
--sidebar-width: 220px;           /* sidebar width when switching to vertical layout */
```

Note: `--accent` (`#1a3a5c`) maps closely to `--portal-navy` (`#1a2c4e`) — slightly different but compatible.
Note: `--accent2` (`#c8972a`) and `--portal-gold` (`#f0a500`) serve the same role — highlight/active accent.

### 4.3 Component Patterns to Replicate

#### Vertical Sidebar (to replace horizontal nav):
```html
<aside class="sidebar">
  <div class="sidebar-step done">
    <div class="step-icon">✓</div>
    <span>ข้อมูลโครงการ</span>
  </div>
  <div class="sidebar-step active">
    <div class="step-icon">●</div>
    <span>ขอบเขตของงาน</span>
  </div>
  <div class="sidebar-step pending">
    <div class="step-icon">○</div>
    <span>คุณสมบัติผู้เสนองาน</span>
  </div>
</aside>
```

```css
.sidebar { width: var(--sidebar-width); flex-shrink: 0; background: white;
           border-right: 1px solid var(--border); padding: 1rem 0; }
.sidebar-step { display: flex; align-items: center; gap: 12px;
                padding: 0.85rem 1.25rem; cursor: pointer; font-size: 0.82rem;
                font-weight: 600; color: #9ca3af; border-right: 3px solid transparent; }
.sidebar-step.active { color: #1d4ed8; border-right-color: var(--portal-sidebar-active-border); background: #eff6ff; }
.sidebar-step.done { color: var(--sidebar-completed); }
.sidebar-step.done .step-icon { color: #16a34a; }
```

#### Status Badge (card header right):
```html
<div class="card-header">
  <h3>ข้อมูลโครงการ</h3>
  <span class="status-badge status-draft">Draft</span>
</div>
```
```css
.status-badge { font-size: 0.72rem; font-weight: 700; padding: 3px 10px;
                border-radius: 20px; letter-spacing: 0.04em; }
.status-draft  { background: #fef3c7; color: #92400e; }
.status-done   { background: #d1fae5; color: #065f46; }
.status-review { background: #dbeafe; color: #1e40af; }
```

#### Readonly Input:
```css
input[readonly], select[disabled], textarea[readonly] {
  background: var(--portal-readonly-bg, #f0f0f0);
  color: #6b7280;
  cursor: not-allowed;
}
```

### 4.4 UX Improvements Based on Portal Reference

1. **Sidebar navigation is more scalable** — 7 steps in a horizontal tab bar wraps on mobile and small screens; vertical sidebar handles this gracefully and matches Portal UX.

2. **Step completion indicators** — Portal shows explicit green checkmark when a step is fully complete. TOR Generator should implement this: check required fields and toggle `.done` class on the nav step.

3. **Prominent status display** — Add a "TOR Status" indicator (Draft / In Progress / Ready to Export) in the header or card header, visible at a glance, matching the Portal's "Status: Pending Approve" pattern.

4. **Breadcrumb context** — The Portal's breadcrumb ("Purchase Requisition / PR Approval") helps users orient. The TOR Generator's bottom bar already shows a mini-breadcrumb, but adding one below the header (like the Portal) would improve orientation.

5. **Fixed bottom bar on Portal is light, not dark** — The Portal uses a light gray bottom bar. The current TOR Generator dark navy bar is bold but may feel heavier than necessary. This is a judgment call — the dark bar gives strong visual separation which is appropriate for a creation tool.

6. **Print button placement** — Portal shows a Print button in the top-right of the main card. The TOR Generator's export/download should similarly be accessible from the card header of the review step, not only from the bottom bar.

---

## 5. Font & Language Notes

- Font family: `'Sarabun', sans-serif` — already used in TOR Generator, correct for Thai/English
- Weights used: 300 (light), 400 (regular), 500 (medium), 600 (semibold), 700 (bold)
- IBM Plex Mono used for code/technical values — keep for contract clause text
- All UI labels should support Thai primary with English secondary (or bilingual)
- Thai numerals vs Arabic: use Arabic numerals for form fields (ระบบ), Thai context labels are fine in Thai

---

## 6. Implementation Notes for Future Agents

When modifying `index.html`:
- The file is large (~28,000+ lines) because docx.js library is inlined at the top
- CSS starts around line 22,600 (search for `:root {`)
- HTML structure starts around line 23,225 (search for `<body>`)
- The nav steps are at lines 23,285–23,292
- Bottom bar is at lines 28,341–28,362
- JavaScript `goTo()` function handles step navigation and updates `.active`/`.done` classes
- To add sidebar: wrap body content in a flex layout `<div class="app-layout">`, add `<aside class="sidebar">`, place `<main class="main-content">` for panels

When adopting Portal design patterns:
1. Do NOT change the CSS variable names (backward compatible with existing code)
2. ADD new variables alongside existing ones
3. The gold accent (`--accent2: #c8972a`) is the bridge between TOR Generator and Portal gold (`#f0a500`) — they are intentionally different shades; keep TOR's warmer gold
4. The dark navy (`--accent: #1a3a5c`) closely matches Portal navy (`#1a2c4e`) — these are compatible

---

## 7. Quick Reference — Visual Comparison

| Element | TOR Generator (current) | Procurement Portal (target alignment) |
|---|---|---|
| Navigation | Horizontal tabs, top | Vertical sidebar, left |
| Active step indicator | Bottom border gold | Right border gold/yellow |
| Completed step | Green badge number | Green checkmark icon |
| Header bg | `#1a3a5c` navy | `#1a2c4e` navy (very similar) |
| Header accent strip | `4px solid #c8972a` bottom | Bunting decoration (decorative) |
| Bottom bar bg | Dark navy | Light gray `#f9fafb` |
| Primary button | Gold fill, navy text | Dark navy fill, white text |
| Card background | `#ffffff` | `#ffffff` |
| Page background | `#f5f4f0` (warm off-white) | `#f3f4f6` (cool light gray) |
| Readonly inputs | White (same as editable) | `#f0f0f0` light gray |
| Font | Sarabun | Sarabun (inferred match) |
| User badge | Not shown | Orange pill, top-right |
| Breadcrumb | In bottom bar | Below header |

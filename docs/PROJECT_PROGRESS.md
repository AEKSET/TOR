# SET TOR Generator — Project Progress Tracker

**Status:** 🟡 **IN PROGRESS — DOCX Export Validation Phase**  
**Last Updated:** 2026-04-09  
**Next Review:** 2026-04-10

---

## 📊 Project Overview

| Field | Details |
|---|---|
| **Project Name** | SET TOR Generator |
| **Objective** | Generate Terms of Reference (TOR) documents in `.docx` format for Turnkey/Outsource projects |
| **Scope** | TOR form + Contract generator + SOW integration |
| **Stakeholders** | SET Procurement Team |
| **Primary Deliverable** | Single-page HTML form application (`index.html`) |

---

## ✅ Completed Phases

### Phase 1: Code Quality Review (✅ Complete)
- **Date Completed:** 2026-04-08
- **Deliverables:**
  - Code architecture assessment of `index.html`
  - Identified monolithic single-file design (26,000+ lines)
  - Documented technical debt and maintainability concerns
- **Key Findings:**
  - Functional MVP but not production-grade
  - All HTML/CSS/JS/libraries bundled inline
  - Missing modularization (recommends future refactoring)
- **Artifacts:** Assessment documented in conversation notes

### Phase 2: Agent Infrastructure Setup (✅ Complete)
- **Date Completed:** 2026-04-09
- **Deliverables:**
  - Created `dispatcher.agent.md` — automatic task routing agent
  - Initialized 11 specialized agent role mappings:
    - `project-manager`, `ba-roll`, `ui-ux-designer`, `full-stack-dev`
    - `contract-reviewer`, `procurement-officer`, `content-writer`
    - `localization-reviewer`, `qa-automation`, `tester`, `docx-specialist`
- **Artifacts:** `.github/agents/dispatcher.agent.md` created
- **Status:** Ready to use; dispatcher routes requests to appropriate agents

### Phase 3: DOCX Export Structural Analysis (✅ Complete)
- **Date Completed:** 2026-04-09
- **Deliverables:**
  - Created `dev/compare_docx_ascii.ps1` — ZIP structure comparison tool
  - Executed full DOCX comparison (export vs template)
  - Generated comprehensive analysis report
- **Key Findings:**
  - **Export file is structurally incomplete** compared to template
  - **Missing Components (20+ files):**
    - `customXml/*` (12 files) — document metadata
    - `word/commentsExtended.xml`, `word/commentsExtensible.xml`, `word/commentsIds.xml`
    - `word/endnotes.xml`, `word/media/`, `word/people.xml`, `word/theme/theme1.xml`, `word/webSettings.xml`
  - **Size Discrepancies (Export vs Template):**
    - `word/document.xml`: 311 KB vs 843 KB **(63% of template)**
    - `word/styles.xml`: 4.8 KB vs 55 KB **(9% of template)**
    - `word/numbering.xml`: 3.2 KB vs 94 KB **(3% of template)**
    - 15 total files with size gaps
  - Export is stripped-down generated version lacking template fidelity
- **Tools Used:**
  - PowerShell 5.1 with `System.IO.Compression.ZipFile` API
  - Workaround: ASCII-only variable names to bypass Thai character encoding issues
- **Artifacts:** 
  - `dev/compare_docx_ascii.ps1` (PowerShell comparison script)
  - `docs/docx_export_vs_template_analysis.md` (detailed analysis report)

---

## 🟡 Current Phase: DOCX Export Improvement (IN PROGRESS)

### Objectives
- [ ] Modify `startExport()` and `exportDocx()` functions in `index.html`
- [ ] Implement template preservation strategy to include missing components
- [ ] Validate export matches template structure after modifications

### Analysis-Based Recommendations
1. **Strategy Option A (Recommended):** Use template as base, overlay user-entered data
   - Load reference template, insert TOR form data into appropriate sections
   - Preserves all template metadata, styling, theme files
   - Cleaner implementation

2. **Strategy Option B:** Generate from scratch, manually add missing components
   - More complex; requires rebuilding all XML structures
   - Higher maintenance burden

### Recommended Approach
- Use `docx.js` library's template-loading capabilities (if available)
- Fallback: Implement ZIP post-processing to add missing files from template during export
- Include all 20+ previously missing components
- Verify with `compare_docx_ascii.ps1` script after each modification

### Assigned Agent: `docx-specialist`
- Reference document: `docs/docx_export_vs_template_analysis.md`
- Key contact: Full-stack dev team for implementation support

---

## 📋 Pending Tasks (Ready to Execute)

### Task 1: Modify Export Logic (HIGH PRIORITY)
- **Owner:** `docx-specialist` agent + `full-stack-dev` team
- **Description:** Update `index.html` export functions to preserve template components
- **Dependencies:** Analysis complete (`docx_export_vs_template_analysis.md`)
- **Effort:** 2-4 hours estimated
- **Success Criteria:**
  - Exported DOCX includes all 20+ template files
  - XML file sizes within ±10% of template values
  - Comparison script shows <5 structural differences
- **Rollback Plan:** Use `index.html.bak_20260409_1109` if issues arise

### Task 2: Validate Export After Updates (MEDIUM PRIORITY)
- **Owner:** `tester` + `qa-automation` agents
- **Description:** Re-run comparison script to verify export quality improvements
- **Tool:** `dev/compare_docx_ascii.ps1`
- **Acceptance Criteria:** Export structure matches template ≥95%
- **Timeline:** Execute immediately after Task 1 completion

### Task 3: Template Compliance Check (MEDIUM PRIORITY)
- **Owner:** `docx-specialist` agent
- **Description:** Validate exported content aligns with `TEMPLATE_COMPLIANCE_GAPS.md` requirements
- **Artifact:** Update or confirm compliance checklist
- **Blockers:** Task 1 must complete first

### Task 4: UI/UX Alignment to Portal Design (LOW PRIORITY)
- **Owner:** `ui-ux-designer` agent
- **Description:** Optional: Implement Procurement Portal design patterns
  - Replace horizontal tabs with vertical sidebar navigation
  - Update color scheme and component styles (per `CLAUDE.md` design guide)
  - Add user context badge in header
- **Reference:** `CLAUDE.md` section 4 (Design Alignment Recommendations)
- **Timeline:** Post-export-export quality fixes; not blocking
- **Impact:** Improved user experience, better Portal integration

---

## 🎯 Project Milestones

| Milestone | Target Date | Status | Notes |
|---|---|---|---|
| Code audit complete | 2026-04-08 | ✅ Done | Monolithic design documented |
| Agent infrastructure | 2026-04-09 | ✅ Done | 11 agents + dispatcher created |
| DOCX analysis complete | 2026-04-09 | ✅ Done | 20+ gaps identified |
| **Export logic updated** | 2026-04-11 | 🟡 Pending | High priority barrier |
| Export validation | 2026-04-12 | 🔲 Blocked | Awaits Task 1 |
| Template compliance verified | 2026-04-13 | 🔲 Blocked | Awaits Task 1 |
| UI/Portal alignment (optional) | 2026-04-15 | 🔲 On-hold | Low priority |

---

## ⚠️ Known Issues & Risks

### CRITICAL
| Issue | Impact | Owner | Status |
|---|---|---|---|
| **Export missing 20+ template files** | Export quality degraded; non-compliant with template | `docx-specialist` | 🟡 Identified, in analysis |
| **XML files 60-70% smaller than template** | Loss of document data/formatting | `docx-specialist` | 🟡 Under investigation |
| **Theme and media files missing** | Export lacks styling/branding consistency | `docx-specialist` | 🟡 Documented |

### MEDIUM
| Issue | Impact | Owner | Status |
|---|---|---|---|
| Monolithic `index.html` code structure | High maintenance cost; difficult refactoring | `project-manager` | 📋 Future phase |
| Thai character encoding in PowerShell | Tooling/scripting limitations | `full-stack-dev` | ✅ Workaround applied |
| No UI/Portal design alignment (yet) | Divergent from SET Procurement Portal UX | `ui-ux-designer` | 📋 Optional/future |

### Workarounds in Place
- ✅ PowerShell encoding issue: ASCII-only script variables + wildcard path resolution
- ✅ DOCX comparison: `dev/compare_docx_ascii.ps1` successfully compares structures

---

## 📁 Key Artifacts

### Code & Scripts
- `index.html` — Main TOR form generator (26,000+ lines)
- `dev/compare_docx_ascii.ps1` — ZIP structure comparison tool (28 lines)
- `.github/agents/dispatcher.agent.md` — Task routing agent (YAML frontmatter)

### Documentation
- `docs/PROJECT_PROGRESS.md` — **THIS FILE** — Progress tracking
- `docs/docx_export_vs_template_analysis.md` — Detailed DOCX comparison analysis
- `docs/REGRESSION_CHECKLIST.md` — Existing compliance checklist
- `CLAUDE.md` — Design system and Portal alignment guide

### Backups
- `index.html.bak_20260409_1109` — Backup before export modifications

### Reference Templates
- `reference/tor/05. Terms of Reference (ToR) SET_PRO_05_v.2_20250509_...docx` — Template DOCX
- `reference/contract/` — Contract templates (8 templates)
- `reference/sow/` — SOW templates

### Test Export
- `Test Export/[TOR filename]_20260409_1356.docx` — Export used for comparison analysis

---

## 🚀 Quick Action Guide

### For Developers (Implementing Task 1: Export Logic Update)
1. **Reference:** `docs/docx_export_vs_template_analysis.md` (component list)
2. **Target File:** `index.html` lines ~23,000-26,000 (export functions)
3. **Functions to Modify:**
   - `startExport()` — Main export workflow
   - `exportDocx()` — DOCX generation logic
4. **Validation Tool:** Run `dev/compare_docx_ascii.ps1` after changes

### For QA/Testers (Implementing Task 2: Validation)
1. **Tool:** `dev/compare_docx_ascii.ps1`
2. **Baseline:** Compare to `reference/tor/05. Terms...docx`
3. **Acceptance:** Export file has <5 structural differences from template
4. **Report:** Update `docs/REGRESSION_CHECKLIST.md` after validation

### For Project Manager (Status Updates)
1. **Update Frequency:** Daily during active development, weekly otherwise
2. **Status Indicators:** 
   - ✅ Complete
   - 🟡 In Progress
   - 🔲 Blocked/Pending
   - 📋 Future/On-Hold
3. **Escalation:** Flag any milestone slippage >1 day

---

## 📞 Contact & Escalation

| Role | Agent | Status | Notes |
|---|---|---|---|
| Project Lead | `project-manager` | Active | 🟢 Available |
| DOCX Specialist | `docx-specialist` | On Deck | 🟡 Ready for Task 1 |
| Full-Stack Dev | `full-stack-dev` | On Deck | 🟡 Support role |
| QA/Tester | `tester`, `qa-automation` | On Deck | 🟡 Ready for Task 2 |
| UI/UX Designer | `ui-ux-designer` | Reserved | 📋 Task 4 only |

---

## 📝 Change Log

| Date | Change | Owner |
|---|---|---|
| 2026-04-08 | Created initial Code Quality Review | project-manager |
| 2026-04-08 | Set up Agent Infrastructure (dispatcher + 11 agents) | project-manager |
| 2026-04-09 | Completed DOCX Export Analysis; documented gaps | docx-specialist + project-manager |
| 2026-04-09 | **Created Project Progress Tracker** | project-manager |

---

**Next Meeting:** 2026-04-10 — Review Task 1 (Export Logic Modification) progress

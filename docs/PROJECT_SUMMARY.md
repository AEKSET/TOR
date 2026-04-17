# Project Summary - SET TOR/SoW Generator

## Overview

This workspace contains document generators and reference templates for:

- TOR (Terms of Reference)
- SoW (Scope of Works)
- Contract templates and supporting reference documents

The main implementation currently lives in two HTML applications:

- `index.html`
- `sow.html`

## Current Status

### TOR Generator

`index.html` is the primary TOR generator and currently supports:

- TOR types: `turnkey`, `maintenance`, `software`, `outsource`, and `sow` mode in the type selector
- DOCX export
- type-based Annex 1 generation
- field completeness and hard-required validation
- AI Suggest and Suggest All flows
- local draft save/restore via `localStorage`

Reference templates used by the TOR flow:

- `Template TOR and SOW/05. Terms of Reference (ToR) SET_PRO_05_v.2_20250509_แก้ไขแจ้ง Password.docx`
- `Template TOR and SOW/5. Template_TOR Outsource v.1_20250509_สำหรับ Biding.docx`

### SoW Generator

SoW is no longer just a planned item. There are now two active SoW directions in the repo:

1. `sow.html`
2. `index.html` with `sow` included in the type system

`sow.html` already provides a working SoW generator prototype with:

- project information form
- SoW sections 2.1-2.4
- duration and payment mode
- installment support
- vendor qualification/contact fields
- validation and completeness progress
- draft save/restore
- AI Suggest for selected SoW fields
- DOCX export

Reference templates used by the SoW flow:

- `Template TOR and SOW/04. Scope of Works (SoW) [SET_PRO_04_v.1_20220816].DOC`
- `Template TOR and SOW/6. Template_SOW_Outsource [SET_SOW_v.1_20220816].docx`

## Repo Structure

### Application files

- `index.html` - main single-file app for TOR generation, with embedded `docx.js`
- `sow.html` - standalone SoW generator prototype using CDN `docx`
- `contract.html` - contract-related HTML output/reference
- `test_outsource.html` - smaller test page for outsource-related behavior

### Reference/template folders

- `Template TOR and SOW/` - TOR and SoW reference templates
- `Contract Template/` - contract templates, annexes, DPA, general conditions
- `Template สัญญาสำหรับ Digital Signature/` - digital-signature contract variants
- `Template สัญญาสำหรับ Docusign/` - DocuSign contract variants

### Unpacked DOCX/XML folders

- `unpacked_efintech/`
- `unpacked_test/`
- `unpacked_test_contract/`
- `unpacked_sow_outsource/`
- `unpacked_tor_outsource/`

These folders appear to be extracted DOCX structures used for inspection and comparison.

## Architecture Notes

### `index.html`

`index.html` is a large single-file application that combines:

- embedded `docx.js`
- HTML form UI
- type switching logic
- validation/completeness logic
- AI integration
- draft persistence
- DOCX export generation

Important logic areas:

- `exportDocx()`
- `_TOR_TYPE_META`
- `setTorType(type)`
- `_REQUIRED_COMMON`
- `_REQUIRED_BY_TYPE`
- `_HARD_BY_TYPE`
- `updateCompleteness()`
- `validateBeforeExport()`
- `aiSuggest()`
- `aiSuggestAll()`
- `saveDraft()`
- `restoreDraft()`

### `sow.html`

`sow.html` is a smaller standalone generator with its own copies of:

- validation
- draft persistence
- payment/installment state
- AI helper calls
- DOCX export

This means the repo currently has duplicated generator responsibilities between `index.html` and `sow.html`.

## Known Gaps

### SoW gaps

The current `sow.html` implementation is useful, but still incomplete relative to a production-ready template-driven workflow:

- UI groups sections 5-8 together instead of matching the final document structure exactly
- section 6 is still mostly generated from a short boilerplate pattern
- sections 7-8 contain hardcoded NDA/PDPA/IP/penalty text
- installment validation does not yet enforce total percentage = `100`
- the output still needs careful comparison against the real SoW template wording and formatting

### Cross-app gaps

- SoW exists in both `index.html` and `sow.html`, so ownership is unclear
- the current project summary was previously out of date regarding SoW status
- regression coverage is informal and should be documented explicitly

## Main Risks

1. `index.html` is very large and mixes UI, business rules, and export code in one file.
2. Type-specific rules are spread across multiple configs and switches.
3. `sow.html` duplicates logic that also exists in `index.html`.
4. Output correctness depends on matching real SET templates, not just generating valid DOCX files.

## Recommended Next Steps

1. Decide whether SoW should live in `sow.html`, `index.html`, or both temporarily with clear ownership.
2. Add a formal regression checklist for TOR and SoW flows.
3. Refactor `sow.html` so sections 5-8 map more directly to the actual document structure.
4. Replace hardcoded SoW clauses with editable fields where template variation is expected.
5. Compare exported files directly against the real SET templates before further feature expansion.

## Suggested Agent Roles

- `Repo Mapper` - maps logic and ownership in `index.html` and `sow.html`
- `Template Compliance Agent` - compares generated output against real templates
- `DOCX Export Agent` - focuses on document generation and formatting
- `SoW Builder Agent` - improves `sow.html` fields, validation, and template fidelity
- `Regression Agent` - maintains smoke tests and release checklists

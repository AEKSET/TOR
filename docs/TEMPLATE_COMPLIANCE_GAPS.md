# Template Compliance Gaps

## Purpose

This note records the current gap analysis between:

- the live generators in `index.html` and `sow.html`
- the reference templates in `Template TOR and SOW/`
- related contract reference material in `Contract Template/`

This is a working compliance/backlog document, not a final sign-off.

## Reference Templates Reviewed

Primary reference set:

- `Template TOR and SOW/05. Terms of Reference (ToR) SET_PRO_05_v.2_20250509_แก้ไขแจ้ง Password.docx`
- `Template TOR and SOW/5. Template_TOR Outsource v.1_20250509_สำหรับ Biding.docx`
- `Template TOR and SOW/04. Scope of Works (SoW) [SET_PRO_04_v.1_20220816].DOC`
- `Template TOR and SOW/6. Template_SOW_Outsource [SET_SOW_v.1_20220816].docx`

Supporting reference set:

- `Contract Template/11 Template_ข้อตกลงและเงื่อนไขทั่วไป [SET_GEN_CON_v.1_20220816].docx`
- `Contract Template/12 Template_ข้อตกลงเกี่ยวกับการประมวลผลข้อมูลส่วนบุคคล (DPA) [SET_DPA_CON_v.1_20220816].docx`
- related contract templates under `Contract Template/`

## Source Logic Reviewed

- `index.html`
- `sow.html`

Key export areas:

- `index.html` Annex builders at `annex1_turnkey`, `annex1_maintenance`, `annex1_software`, `annex1_sow`, `annex1_outsource`
- `sow.html` export block around `heading("1. วัตถุประสงค์")` through contact output

## High-Level Findings

1. TOR coverage in `index.html` is materially ahead of SoW coverage.
2. SoW exists in two places: `sow.html` and `index.html` `annex1_sow`, which creates compliance drift risk.
3. `sow.html` is structurally usable, but still closer to a prototype than a template-faithful implementation.
4. Outsource coverage in `index.html` is much richer than the standalone SoW flow.

## Compliance Gaps

### 1. SoW ownership is split across two implementations

Relevant code:

- `index.html#L25518`
- `sow.html#L423`

Gap:

- There are two active SoW outputs:
  - `index.html` `annex1_sow`
  - standalone `sow.html`
- They do not use the same field model or wording strategy.

Risk:

- one SoW flow can become compliant while the other drifts
- bug fixes and wording fixes must be duplicated

Recommended action:

- choose one SoW owner
- treat the other path as temporary or deprecated

### 2. `sow.html` groups sections 5-8 too loosely compared with the target document

Relevant code:

- `sow.html#L230`
- `sow.html#L462`
- `sow.html#L467`
- `sow.html#L470`
- `sow.html#L473`

Gap:

- The UI combines sections 5-8 into one card.
- The export later emits sections 5, 6, 7, and 8 as if they were separately authored.

Risk:

- users cannot easily see which input maps to which formal section
- template-specific clause editing becomes difficult

Recommended action:

- split the UI into dedicated cards for sections 5, 6, 7, and 8

### 3. `sow.html` hardcodes critical boilerplate instead of exposing it as data

Relevant code:

- `sow.html#L468`
- `sow.html#L471`
- `sow.html#L474`
- `sow.html#L475`

Gap:

- section 6 is mostly one generated sentence using only `submitDept`
- sections 7 and 8 hardcode NDA, PDPA, IP, and penalty text

Risk:

- cannot adapt wording for project-specific exceptions
- cannot align clause text with revised legal templates without editing code

Recommended action:

- add editable fields for:
  - evaluation/reservation wording
  - NDA/PDPA notes
  - IP clause wording
  - penalty/other contract conditions

### 4. `index.html` SoW flow is more template-aware than `sow.html`, but the two models do not match

Relevant code:

- `index.html#L25520`
- `index.html#L25544`
- `index.html#L25547`
- `index.html#L24127`
- `index.html#L24132`

Gap:

- `index.html` SoW has fields such as `sowStart` and `sowPayment`.
- `sow.html` uses `sowPayMode`, `sowPayOnce`, and `_installments`.
- The generated wording therefore differs between the two SoW paths.

Risk:

- users will get different document structures depending on entry point
- testing and compliance review become ambiguous

Recommended action:

- normalize the SoW field model before more feature work

### 5. Installment validation in `sow.html` is incomplete

Relevant code:

- `sow.html#L303`
- `sow.html#L371`
- `sow.html#L375`
- `sow.html#L376`

Gap:

- the standalone SoW checks that installment rows exist and are filled
- it does not enforce that the total percentage equals `100`

Risk:

- a formally invalid payment schedule can still be exported

Recommended action:

- add business validation that installment totals equal `100`

### 6. Outsource output in `index.html` is substantially richer than general SoW output

Relevant code:

- `index.html#L25558`
- `index.html#L25569`
- `index.html#L25613`
- `index.html#L25619`

Gap:

- outsource export includes:
  - role table
  - overtime handling
  - employer obligations
  - equipment obligations
  - replacement policy
- general SoW in `sow.html` has a much thinner clause model

Risk:

- users may expect the same depth of document control across SoW-like workflows and not get it

Recommended action:

- identify which clause depth should be baseline for non-outsource SoW

### 7. TOR output structure appears strong, but still needs exact template wording review

Relevant code:

- `index.html#L25377`
- `index.html#L25430`
- `index.html#L25479`
- `index.html#L25518`
- `index.html#L25558`

Gap:

- the generators clearly mirror template sections and annex structure
- however, this review was based on code structure and available references in the repo, not a full line-by-line legal wording verification

Risk:

- headings can be right while legal phrasing or spacing is still off

Recommended action:

- perform a manual side-by-side review of exported files against each official template

### 8. Legacy `.DOC` references limit automated comparison

Relevant files:

- `Template TOR and SOW/04. Scope of Works (SoW) [SET_PRO_04_v.1_20220816].DOC`
- multiple `.DOC` files under `Contract Template/`

Gap:

- several important reference templates are legacy `.DOC` files
- this pass focused on repo structure and generator logic, not binary `.DOC` content extraction

Risk:

- some formatting and clause gaps may still be invisible until manual Word review

Recommended action:

- export real sample files and compare them in Word against the `.DOC` originals

## Priority Backlog

### Priority 1

- decide the canonical SoW implementation
- split `sow.html` sections 5-8 into separate editable sections
- remove hardcoded section 6-8 boilerplate from `sow.html`
- add installment sum validation

### Priority 2

- align `sow.html` field model with `index.html` SoW field model
- define one wording source for SoW payment clauses
- confirm whether `sowStart` and richer payment wording are required in the standalone SoW flow

### Priority 3

- run side-by-side manual document review against all four primary templates
- capture exact wording/spacing mismatches
- decide whether contract annex references should surface directly in generator UX

## Manual Review Checklist

- section titles match the official template
- section order matches the official template
- annex behavior matches the official template
- payment wording matches the official template
- NDA/PDPA wording matches the official template
- IP and penalty wording matches the official template
- contact/sign-off placement matches the official template
- tables and paragraph spacing match the official template closely enough for business use

## Recommended Next Task

Refactor `sow.html` first, because it currently has the clearest compliance debt:

1. split sections 5-8
2. add editable fields for sections 6-8
3. enforce installment total validation
4. align wording with the chosen SoW source of truth

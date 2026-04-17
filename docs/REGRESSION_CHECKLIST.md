# Regression Checklist

## Scope

Use this checklist before major changes to:

- `index.html`
- `sow.html`
- export logic
- validation logic
- AI prompt/output handling
- draft persistence

## Smoke Tests

- TOR `turnkey`: complete required fields and export successfully
- TOR `maintenance`: complete required fields and export successfully
- TOR `software`: complete required fields and export successfully
- TOR `outsource`: complete required fields and export successfully
- SoW: complete required fields and export successfully

## Validation Tests

- TOR `turnkey`: missing required field blocks export
- TOR `maintenance`: missing SLA or duration blocks export
- TOR `software`: missing license count or requirements blocks export
- TOR `outsource`: missing main scope, work location, duration, or role data blocks export
- SoW `once` payment mode: installments are not required
- SoW `installment` payment mode: at least one installment is required
- SoW `installment` payment mode: each row must contain both percent and condition

## Type Switch Tests

- switch `turnkey -> maintenance -> software -> outsource` and confirm the visible scope panel changes correctly
- switch across TOR types and confirm completeness/progress updates correctly
- switch across TOR types and confirm required fields are recalculated correctly
- switch back to the original type and confirm entered values are still handled safely
- if `sow` is used inside `index.html`, confirm it does not break TOR-specific validation or export

## Draft Restore Tests

- save a TOR draft and reload the page
- restore a TOR draft and confirm `_torType` restores before dependent fields
- save an outsource draft with dynamic role rows and confirm all rows restore
- save a SoW draft with installment rows and confirm all rows restore
- clear or overwrite draft data and confirm old state does not leak back in

## AI Tests

- no API key: UI must fail safely without crashing
- API error: existing field values must not be lost
- single-field suggest updates only the target field
- suggest-all updates the expected fields for the selected section/type
- malformed AI output must fail safely

## Export Tests

- exported filename is sanitized for invalid filesystem characters
- exported DOCX opens in Word successfully
- TOR export uses the correct Annex 1 for the selected type
- multi-line textarea content becomes multiple paragraphs as expected
- dynamic rows are preserved in the exported document
- long Thai text does not break export

## Output Review Against Templates

- compare TOR general export against `Template TOR and SOW/05. Terms of Reference (ToR) SET_PRO_05_v.2_20250509_แก้ไขแจ้ง Password.docx`
- compare TOR outsource export against `Template TOR and SOW/5. Template_TOR Outsource v.1_20250509_สำหรับ Biding.docx`
- compare SoW export against `Template TOR and SOW/04. Scope of Works (SoW) [SET_PRO_04_v.1_20220816].DOC`
- compare SoW outsource output against `Template TOR and SOW/6. Template_SOW_Outsource [SET_SOW_v.1_20220816].docx`
- verify headings, section order, wording, spacing, and signature/contact placement

## Release Gate

Before merging or shipping a meaningful change:

- complete all smoke tests
- complete at least one negative validation test for the touched flow
- complete draft restore for the touched flow
- complete one real DOCX export review against the closest template

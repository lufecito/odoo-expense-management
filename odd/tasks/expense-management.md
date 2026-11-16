# Feature: Expense management on Odoo 18

Objective: replace Rindegastos with the existing Odoo 18 instance.
Branch: `main`. Delivery: work-unit commits.
Test runner: Odoo 18 test suite (`--test-tags`), pending staging availability.

## Specs

- **S1** — The replacement runs on Odoo 18.0+e, on the existing instance. No
  version upgrade is part of this feature. *User statement: "no, mantendremos
  18".*
- **S2** — Expense, report, employee and journal models are inherited from
  `hr_expense`, never duplicated. Parallel models for the same concepts are
  rejected.
- **S3** — Pilot covers P1 capture, P2 approval, P3 accounting, P4
  reimbursement, P5 advances, P6 petty cash, plus X1 company isolation, X2
  traceability, X3 role separation. Full criteria in `docs/00-scope-pilot.md`.
- **S4** — Corporate cards, automated payments, WhatsApp, AI scoring, multi-country
  and historical migration are out of pilot scope.
- **S5** — Nothing is installed in production until a non-production database
  and a documented rollback exist.
- **S6** — The MCP connection stays read-only for this project. It is not a
  deployment channel.
- **S7** — Assumption to validate, not a requirement: the OCA 18.0 modules for
  tier validation, advances and petty cash are usable. They are Beta; the pilot
  decides.

## Tasks

| ID | Task | Specs | Route | Status | Evidence |
| --- | --- | --- | --- | --- | --- |
| T1 | Verified baseline of the instance | S1 | inline | done | `docs/02-verified-baseline.md` |
| T2 | Architecture decision: extend versus duplicate | S2 | inline | done | `docs/01-architecture.md` |
| T3 | Pilot scope and acceptance criteria | S3, S4 | inline | done | `docs/00-scope-pilot.md` |
| T4 | Open decisions register | S5 | inline | done | `docs/03-open-decisions.md` |
| T5 | Resolve D1/D2: staging and deployment procedure | S5 | blocked | pending | owner: host administrator |
| T6 | Evaluate `hr_expense_tier_validation` on 18.0 | S7 | — | pending | blocked by T5 |
| T7 | Evaluate `hr_expense_advance_clearing` (three clearing scenarios) | S7 | — | pending | blocked by T5 |
| T8 | Evaluate `hr_expense_petty_cash` | S7 | — | pending | blocked by T5 |
| T9 | Configure pilot policy with Finance | S3 | — | pending | blocked by D3 |
| T10 | Scaffold `ipam_expense` addon for the remaining gaps | S2 | — | pending | blocked by T5, T9 |
| T11 | Run the pilot with real users and record per-criterion evidence | S3 | — | pending | blocked by T5, T9 |

## Log

- **L1** — Original request, verbatim: *"mi objetivo es reemplazar rindegastos
  por odoo."* Then: *"Dale, trabajemos sobre un proyecto en Github, créalo."*
- **L2** — 2026-11-16: baseline verified read-only. `hr_expense` installed with
  zero records; 15 companies; OCR module installed; OCA tier validation already
  installed but expense adapter absent.
- **L3** — 2026-11-16: `hr_expense_sheet` 19.0 reviewed and discarded. It restores
  expense reports in Odoo 19, where `hr.expense.sheet` was removed. On 18 the
  model is native, so the module adds nothing here.
- **L4** — 2026-11-16: earlier analysis corrected — 15 companies, not 10; the
  "70% covered" figure retracted; AI/reconciliation/payments are implementable,
  not impossible.
- **L5** — 2026-11-16: repository created. Documentation baseline committed.
  Nothing installed, nothing configured.

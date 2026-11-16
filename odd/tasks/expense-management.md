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
- **S3** — Pilot covers P1 registration and weekly report, P2a first confirmation,
  P2b final approval, P3 accounting, P4 payment closure, P7 reporting, P8 exit,
  plus X1 company isolation, X2 traceability and X3 role separation. Full criteria
  in `docs/00-scope-pilot.md`. P5 and P6 were retired on 2026-11-16 (C2).
- **S4** — Corporate cards, automated payments, WhatsApp, AI scoring, multi-country
  and historical migration are out of pilot scope.
- **S5** — Nothing is installed in production until a non-production database
  and a documented rollback exist.
- **S6** — The MCP connection stays read-only for this project. It is not a
  deployment channel.
- **S7** — Assumption to validate, not a requirement: the OCA 18.0 modules for
  tier validation, advances and petty cash are usable. They are Beta; the pilot
  decides.
- **S8** — Every Rindegastos function in use has a written disposition: replaced,
  deferred with a named alternative, or accepted as a loss. Recorded in
  `docs/05-substitution-matrix.md` and decided in D13.
- **S9** — No notice is given to Rindegastos until P8 passes: history, open items,
  approval records and paid amounts secured, and verified by someone other than
  the exporter.
- **S10** — Payment closure is defined by Treasury (D11). Registered, executed and
  reconciled are distinct facts and are never treated as synonyms.
- **S11** — Renderer effort is measured against the current tool. A cheaper cycle
  that takes three times longer to submit is not a replacement.
- **S12** — `docs/06-business-spec.md` is authoritative for process, roles, states,
  validations and the test plan. Where the pilot scope contradicts it, the conflict
  is recorded in §7 of `docs/00-scope-pilot.md` and resolved by a named decision,
  never silently.
- **S13** — The pilot is **technical**, run by two participants. Its maximum
  conclusion is "technically viable"; it cannot certify operational readiness nor
  justify cancellation. The operational pilot with the five-role chain is a
  separate, mandatory phase.
- **S14** — The two-stage operational approval is implemented as custom states and
  server-enforced transitions in `ipam_expense`, not with a generic tier engine.
  A correction after final approval restarts the first stage.

## Tasks

| ID | Task | Specs | Route | Status | Evidence |
| --- | --- | --- | --- | --- | --- |
| T1 | Verified baseline of the instance | S1 | inline | done | `docs/02-verified-baseline.md` |
| T2 | Architecture decision: extend versus duplicate | S2 | inline | done | `docs/01-architecture.md` |
| T3 | Pilot scope and acceptance criteria | S3, S4 | inline | done | `docs/00-scope-pilot.md` |
| T4 | Open decisions register | S5 | inline | done | `docs/03-open-decisions.md` |
| T5 | Resolve D1/D2: staging and deployment procedure | S5 | blocked | request prepared | `docs/04-staging-request.md`, to be sent by owner |
| T6 | Evaluate `hr_expense_tier_validation` on 18.0 | S7 | — | pending | blocked by T5 |
| T7 | Evaluate `hr_expense_advance_clearing` (three clearing scenarios) | S7 | — | pending | blocked by T5 |
| T8 | Evaluate `hr_expense_petty_cash` | S7 | — | pending | blocked by T5 |
| T9 | Configure pilot policy with Finance | S3 | — | pending | blocked by D3 |
| T10 | Scaffold `ipam_expense` addon for the remaining gaps | S2 | — | pending | blocked by T5, T9 |
| T11 | Run the pilot with real users and record per-criterion evidence | S3 | — | pending | blocked by T5, T9 |
| T12 | Configure approver routing for pilot employees (department or `expense_manager_id`) | S3 | — | pending | Benjamín's employee record has neither |
| T13 | Decide coverage of X1/X3 | S3 | inline | done | reduced coverage accepted; gaps recorded as pre-cancellation gates |
| T14 | Substitution matrix against the Rindegastos catalogue | S8 | inline | done | `docs/05-substitution-matrix.md` |
| T15 | Rewrite P4 with registered/executed/reconciled levels | S10 | inline | done | `docs/00-scope-pilot.md` §4 |
| T16 | Add P7 reporting and P8 exit/cutover to scope | S9 | inline | done | `docs/00-scope-pilot.md` §4 |
| T17 | Add duplicate, OCR correction, refusal loop and effort criteria | S11 | inline | done | `docs/00-scope-pilot.md` §4 P1–P2 |
| T18 | Correct the admin-bypass claim: verify instead of assert | S3 | inline | done | `docs/00-scope-pilot.md` §4 X, §8 |
| T19 | Confirm which Rindegastos functions are actually used (D13) | S8 | — | pending | owner: Management, Finance |
| T20 | Obtain and verify the Rindegastos export (D12, D14) | S9 | — | pending | blocked by D12/D14 |
| T21 | Execute X1 and negative X3 with real non-admin users | S3 | — | pending | needs third user; gate before multi-company |
| T22 | Import the existing business specification as the authoritative source | S12 | inline | done | `docs/06-business-spec.md` |
| T23 | Record conflicts between pilot scope and business spec | S12 | inline | done | `docs/00-scope-pilot.md` §7 |
| T24 | Resolve C1: who really participates in the pilot | S12 | inline | done | technical pilot, two participants |
| T25 | Resolve C2: advances and petty cash in or out of the first delivery | S12 | inline | done | deferred; P5/P6 retired |
| T26 | Resolve C5 and add the two-level approval flow to the pilot | S12 | inline | done | P2a/P2b, two-stage custom states |
| T27 | Resolve C3, C4, C6 in scope and acceptance criteria | S12 | inline | done | `docs/00-scope-pilot.md` §7 |
| T28 | Confirm whether funds por rendir are used today | S12 | — | pending | if yes, cancellation is blocked |

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
- **L6** — 2026-11-16: pilot users confirmed as Luis Fontecilla (`admin`, id 2)
  and Benjamín Abarzua (`benjamin.abarzua@airlife.com`, id 10). Rindegastos notice
  period is 30 days. Readiness check found: both users in company 1; Benjamín's
  employee record (id 71) has no department, expense manager or parent; 72 of 73
  employees have no department and only one has an expense manager. Consequence:
  P2 cannot run until routing is configured, and X1/X3 cannot be validated with
  these two users alone.
- **L7** — 2026-11-16: sequencing recorded — pilot passes first, notice second,
  30 days of parallel operation third. The notice period is not a deadline to
  migrate faster.
- **L8** — 2026-11-16: reduced pilot coverage accepted by the user. X1, the
  negative X3 path and the P2 self-approval rule are recorded as untested, each
  with its consequence. They become explicit gates before multi-company rollout
  and before notice is given to Rindegastos. Exit criteria rewritten so a
  success cannot be declared for the group on single-company evidence.
- **L9** — 2026-11-16: local staging ruled out for now. The machine has no
  Docker, no Podman and no PostgreSQL, and ships Python 3.14, which Odoo 18 does
  not support. A local Odoo would require installing a system stack with root
  privileges and would still not reproduce the Chilean localization, SII modules
  or 15-company setup. Formal staging request written instead:
  `docs/04-staging-request.md`.
- **L11** — 2026-11-16: gaps against Rindegastos closed in scope, not in code.
  Corrected: history is no longer assumed absent (P8 added); P4 now distinguishes
  registered, executed and reconciled; P1 adds duplicate tolerance, OCR correction,
  mobile capture, refusal loop and measured effort; P2 adds amount-based routing;
  P3 adds multiple taxes and rate source; P7 and P8 are new; the admin-bypass claim
  is now a verification step instead of an asserted fact; every deferred function
  requires a written disposition. Substitution matrix added at
  `docs/05-substitution-matrix.md`.
- **L12** — 2026-11-16: found an existing business specification and flow diagrams at
  `Escritorio/Airlife/Reemplazo Rindegastos/`. It describes the real process — Teresa
  as digitizer, Jefatura SAT as first confirmation, Gabriela as final approval,
  Contabilidad for posting and payment, weekly consolidation per technician/company/
  payment mode — and contradicts this project's assumptions. Imported as
  `docs/06-business-spec.md` and made authoritative. Six conflicts recorded (C1–C6);
  C1, C2 and C5 block execution. The `exportar_flujo_contable.ps1` in that folder
  only draws the diagram: no Rindegastos→Odoo export tooling exists yet.
- **L13** — 2026-11-16: advance made without touching Odoo or the workstation. The
  D13 question is now partially answered by evidence: WhatsApp intake is manual by a
  digitizer, there are two operational approval levels, and advances are excluded
  from the first phase by the business owner of the process.
- **L14** — 2026-11-16: the six conflicts are resolved. C1 technical pilot with two
  participants; C2 advances and petty cash deferred and their process IDs retired;
  C3 manual WhatsApp intake in scope; C4 archive instead of migration; C5 replaced
  single-level approval with P2a/P2b custom states; C6 weekly grouping in scope.
  Consequences recorded: the pilot cannot claim operational readiness, cancellation
  stays blocked while funds or history are uncovered, and the two-stage approval is
  now the largest technical risk. Rejected `hr_expense_tier_validation` for the
  chain because it cannot express two business stages with restart semantics.
- **L10** — 2026-11-16: local sandbox rejected by the user — the workstation system
  is not to be modified. No Docker, no PostgreSQL, no package installation. Staging
  from the host administrator is the only path to a testable environment. No further
  technical work is possible until T5 closes.

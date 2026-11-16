# Outstanding items

State at 2026-11-16, end of session. Nothing is installed and nothing is deployed.
This file is the single list of what is still open, who owns it, and what it blocks.

## 1. Blocking everything

| ID | Item | Owner | Notes |
| --- | --- | --- | --- |
| D1 | A non-production database | Host administrator | Request ready in `docs/04-staging-request.md`, not sent |
| D2 | Addon install and rollback procedure | Host administrator | Undocumented today |

No test can run until both are closed. This is infrastructure, not expense design.

## 2. Decisions that can change the size of the project

| ID | Decision | Owner | Why it matters |
| --- | --- | --- | --- |
| D8 / D20 | Funds por rendir and petty cash | Finance, Accounting | **Already answered by evidence: they are in use** (`100.01.110.07`, `100.01.110.06`). Out of pilot scope, so **cancellation is blocked** |
| D9 | Rindegastos contract: per-user price and end date | Management | Notice period is 30 days; the date is unknown |
| D13 | Which Rindegastos functions are actually used | Management, Finance | Funds and WhatsApp confirmed; cards, mileage, travel and AI unknown |
| D21 | Which company hosts the pilot: 1 (Luis, Benjamín) or 5 (the verifiers) | Management | The verifiers cannot see company-1 reports |
| D23 | Technical area: digitizer model or own accounts | Management | Digitizer model costs no licences; self-service costs one per technician |

## 3. Decisions needed before configuring the flow

| ID | Decision | Owner |
| --- | --- | --- |
| D3 | Categories, taxes, accounts, analytic dimensions and limits | Finance |
| D22 | Which verifier holds the first stage and which the final approval | Management |
| D24 | Who are the Transport executives and which technicians participate | Management |
| D10 | Retention for receipts and expense evidence | Legal, Finance |
| D12 | Retention period and archive format for Rindegastos history | Legal, Finance |

Proposed defaults already recorded, pending confirmation: closure at *reconciled*
(D11), duplicate warning rule (D15), effort target relative to Rindegastos (D16),
read-only archive instead of migration (D12).

## 4. Configuration gaps found in the instance

| # | Gap | Fix |
| --- | --- | --- |
| G1 | Katherine Catalán (user 148) has **no employee record**, so she cannot approve | Create the employee record in the pilot company |
| G2 | Verifiers are in company 5; pilot users are in company 1 | D21, then multi-company access or change of pilot company |
| G3 | **One department exists in the whole database** ("Administration", no manager) | Build Transport and technical departments, or route by `expense_manager_id` |
| G4 | Technical area has no Odoo users | Digitizer model: executives register on their behalf |
| G5 | No expense categories configured; only Odoo demo products | Map the business specification categories onto existing accounts |
| G6 | No OCR credits visible on the digitization account | Buy credits or run the pilot with manual entry |
| G7 | Benjamín's employee record (id 71) has no department, manager or parent | Configure before P2 can run |

## 5. Work not started

| ID | Task |
| --- | --- |
| T5 | Obtain staging and the deployment procedure |
| T9 | Configure the policy with Finance |
| T10 | Build `ipam_expense`: two-stage approval, weekly grouping, fields, validations |
| T11 | Run the technical pilot and record evidence per criterion |
| T12 | Configure approver routing |
| T21 | Execute X1 and the negative X3 path with non-administrator accounts |
| T31 | Create Katherine's employee record |
| T32 | Align the pilot company |
| T33 | Build department or expense-manager routing |
| T20 | Obtain and verify the Rindegastos history export |

## 6. Scheduled automation

| When | What | Where |
| --- | --- | --- |
| 2026-11-17 09:00 (America/Santiago) | Attempt to invite `benjamin.abarzua@airlife.com` to this repository and log the result | systemd user timer `odoo-expense-invite.timer` |

Two accounts match the person on GitHub: `benjabarzua` (full name Benjamín Abraham
Abarzua Ehijo) and `Tabarnakle` (Benjamin Abarzua, Santiago). The email handle
matches the first one, which is the configured default. If it is wrong, change
`ops/invitee.txt` before 09:00 or revoke the invitation afterwards.

## 7. Corrected objective for the current phase

Make the core cycle technically viable, and decide with evidence what happens to
funds and to history. **Cancelling Rindegastos is not on the table** while funds
and history remain uncovered.

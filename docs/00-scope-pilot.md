# Pilot scope — replace Rindegastos with Odoo 18

Status: **draft for approval by Finance and HR.** Scope is not agreed until
those owners sign off on sections 3 and 4.

## 1. Objective

Run the company expense cycle inside Odoo 18, end to end, without Rindegastos:

capture receipt → assemble report → approve → post accounting entry →
reimburse employee.

Secondary objective: decide with evidence whether Rindegastos can be cancelled,
reduced, or must stay for the processes Odoo does not cover.

## 2. In scope for the pilot

| ID | Process |
| --- | --- |
| P1 | Employee captures a receipt and submits a report |
| P2 | Approver approves or refuses a report |
| P3 | Approved report posts to accounting in the correct company, account, tax and analytic dimension |
| P4 | Employee is reimbursed and the report reaches a final paid state |
| P5 | Advance and clearing (employee receives money before spending it) |
| P6 | Petty cash with controlled balance and replenishment |

Cross-cutting, verified inside every process above:

| ID | Requirement |
| --- | --- |
| X1 | Company isolation: a user of company A cannot see or approve company B data |
| X2 | Traceability: who created, submitted, approved, refused and posted, with timestamps |
| X3 | Role separation: employee, approver, finance manager |

## 3. Out of scope for the pilot

Explicitly excluded, to be decided afterwards:

- Corporate card reconciliation and bank statement matching.
- Automated payment execution or bank transfers.
- WhatsApp ingestion.
- AI risk scoring, anomaly agents and financial forecasting.
- Tax-authority document validation beyond what `l10n_cl` already does.
- Digitization accuracy benchmarking (evaluated as a separate, costed decision).
- Countries other than Chile.
- Historical data migration (there is none: `hr_expense` holds zero records).

## 4. Acceptance criteria

A process passes only when every criterion below is reproduced with realistic
data on a non-production database, by a human other than the developer.

### P1 — Capture and submit

- An employee creates an expense with date, supplier, net, tax, total, currency,
  category and an attached receipt.
- The expense can be attached to a report, and the report can hold several
  expenses of the same employee.
- A report cannot be submitted with no expenses.
- A report cannot be submitted with a missing required field defined by policy.
- The employee cannot edit a report after submission.

### P2 — Approve and refuse

- A user without the approver role cannot approve.
- The designated approver sees the report in a work queue.
- Approving moves the report to approved and records the approver and timestamp.
- Refusing requires a reason and returns the report to the employee.
- An approver cannot approve their own report.

### P3 — Accounting

- Posting creates a balanced journal entry in the company's currency.
- Account, tax and analytic dimension come from the configured policy, not from
  free text.
- A foreign-currency expense posts with the correct exchange rate and the
  original currency preserved.
- Posting twice is impossible; a posted report cannot be edited.
- Report, expenses, journal entry and payment are navigable in both directions.

### P4 — Reimbursement

- Only posted reports can be paid.
- Payment records the employee, bank account, date and amount.
- The report reaches a final paid state only when the payment is registered.
- A partial payment leaves the report in an in-payment state, not paid.

### P5 — Advance and clearing

Three scenarios, each with accounting evidence:

1. Expenses equal the advance: no further payment, advance fully cleared.
2. Expenses below the advance: the employee returns the difference, advance
   balance reaches zero.
3. Expenses above the advance: the company pays the difference, advance cleared
   and the extra reimbursed.

In all three: the advance never appears as revenue or expense, and the balance
is reconcilable against the accounting entries.

### P6 — Petty cash

- A holder is created with an assigned balance.
- Replenishment is recorded through a documented accounting path.
- An expense paid from petty cash reduces the holder balance.
- The holder cannot submit an expense above the available balance, or the
  system blocks it with a clear message.
- Balance reconciles against the general ledger at period close.

### X — Cross-cutting

- A user of company A cannot read, write or approve company B records, verified
  with a real second-company user, not by reading ACL XML.
- The chatter shows the full lifecycle with actor and timestamp.
- Removing an approver role revokes pending approvals.

## 5. Exit criteria

| Outcome | Condition |
| --- | --- |
| **Proceed, single company** | P1–P6 pass; X2 passes; X3 passes on the positive path |
| **Blocked for multi-company** | X1 and the X3 negative path are untested. Both must pass before a second company adopts the flow and before Rindegastos notice is given |
| **Partial replacement** | P1–P4 pass; P5/P6 fail; Rindegastos retained only for funds, or replaced by a different tool |
| **No-go** | P3 fails, deployment or rollback cannot be demonstrated, or a later X1 test fails |

Reduced coverage was accepted on 2026-11-16. It does not lower the bar: it moves
X1 and the negative X3 checks to a named gate before cancellation.

## 6. Preconditions

The pilot cannot start until:

1. A non-production database exists (copy of production or local Odoo 18).
2. The addon deployment and rollback procedure is documented by whoever
   administers the host.
3. Finance confirms the expense policy: categories, taxes, accounts, analytic
   dimensions, approval limits and who approves what.
4. The list of real pilot users is agreed (employees, approvers, finance).
5. Licensing implications for those users are confirmed by the Odoo contact.

## 7. Pilot participants

Two users, one company (`Ipam Technology S.A.`), one approval level, 4 weeks.

| User | Odoo user | Role in pilot | Verified state |
| --- | --- | --- | --- |
| Luis Fontecilla | id 2, login `admin` | Renderer and configuration | Administrator on production |
| Benjamín Abarzua | id 10, `benjamin.abarzua@airlife.com` | Renderer and approver | Active, internal, no department, no expense manager, no parent |

### Readiness gaps found

1. **The pilot includes the production administrator.** Login `admin` bypasses
   record rules and ACLs. Testing with it proves nothing about X1 or X3. A
   third, non-administrator user is required to validate either.
2. **Approval routing is unconfigured.** Benjamín's employee record (id 71) has
   no department, no `expense_manager_id` and no parent. 72 of 73 employees have
   no department, and only one employee has an expense manager. Until that is
   set, P2 cannot be executed at all.
3. **Company isolation cannot be tested with these two users.** Both belong to
   company 1. X1 needs a user from another company.

### Coverage decision (accepted 2026-11-16)

Reduced coverage accepted. The pilot validates P1–P6 and X2, plus the positive
path of X3 (an approver who is not the renderer approves and refuses). It does
**not** validate:

| Untested | Why | Consequence |
| --- | --- | --- |
| X1 company isolation | Both pilot users belong to company 1 | Must pass before a second company adopts the flow, and before Rindegastos is cancelled |
| X3 negative path | `admin` bypasses record rules | A non-administrator must attempt forbidden reads and approvals before multi-company use |
| P2 self-approval rule | Only one approver exists | Verified by code review and ACL inspection by a second person, not by execution |

These are **deferred gates, not waived requirements**. The pilot may conclude
"ready for one company"; it may not conclude "ready for the group".

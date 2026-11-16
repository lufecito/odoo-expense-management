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
| **Proceed to rollout** | All of P1–P4 and X1–X3 pass; P5 and P6 pass or have an approved workaround with a dated plan |
| **Partial replacement** | P1–P4 pass; P5/P6 fail; Rindegastos retained only for funds, or replaced by a different tool |
| **No-go** | P3 or X1 fails, or deployment/rollback cannot be demonstrated |

## 6. Preconditions

The pilot cannot start until:

1. A non-production database exists (copy of production or local Odoo 18).
2. The addon deployment and rollback procedure is documented by whoever
   administers the host.
3. Finance confirms the expense policy: categories, taxes, accounts, analytic
   dimensions, approval limits and who approves what.
4. The list of real pilot users is agreed (employees, approvers, finance).
5. Licensing implications for those users are confirmed by the Odoo contact.

## 7. Pilot size

One company, one department, one approval level, 5–10 employees, 4 weeks. No
other company participates until X1 passes.

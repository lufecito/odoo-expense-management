# Pilot scope — replace Rindegastos with Odoo 18

Status: **draft for approval by Finance, HR and Treasury.** Scope is not agreed
until those owners sign off sections 3, 4 and 5.

## 1. Objective

Run the company expense cycle inside Odoo 18, end to end, without Rindegastos:

capture receipt → assemble report → approve → post accounting entry →
reimburse employee → report and audit.

Secondary objective: decide with evidence whether Rindegastos can be cancelled,
reduced, or must stay for the processes Odoo does not cover.

## 2. In scope for the pilot

| ID | Process |
| --- | --- |
| P1 | Employee captures a receipt and submits a report |
| P2 | Approver approves or refuses a report |
| P3 | Approved report posts to accounting in the correct company, account, tax and analytic dimension |
| P4 | Employee is reimbursed and the payment is closed under the agreed definition |
| P5 | Advance and clearing (employee receives money before spending it) |
| P6 | Petty cash with controlled balance and replenishment |
| P7 | Finance reports and pending queue |
| P8 | Exit from Rindegastos: archive, open items and cutover |

Cross-cutting, verified inside every process above:

| ID | Requirement |
| --- | --- |
| X1 | Company isolation: a user of company A cannot see or approve company B data |
| X2 | Traceability: who created, submitted, approved, refused and posted, with timestamps |
| X3 | Role separation: employee, approver, finance manager |

## 3. Out of scope for the pilot

Excluded from the pilot, each with a required disposition in
`docs/03-open-decisions.md` (D13). None may be silently dropped:

- Corporate card reconciliation and bank statement matching.
- Automated payment execution or bank transfers.
- WhatsApp ingestion.
- Mileage, per-diem travel and digital signature.
- AI risk scoring, anomaly agents and financial forecasting.
- Digitization accuracy benchmarking (separate, costed decision).
- Countries other than Chile.

Historical data is **not** out of scope. See P8. The absence of expense records
in Odoo says nothing about the history held in Rindegastos.

## 4. Acceptance criteria

A process passes only when every criterion is reproduced with realistic data on a
non-production database, by a human other than the developer.

### P1 — Capture and submit

- An employee creates an expense with date, supplier, net, tax, total, currency,
  category and an attached receipt.
- Receipt capture works from a phone, not only from a desktop browser.
- After OCR extraction, the employee can correct any extracted field without
  re-uploading the receipt.
- The expense can be attached to a report, and the report can hold several
  expenses of the same employee.
- A report cannot be submitted with no expenses, or missing a field the policy
  marks as required.
- The employee cannot edit a report after submission.
- **Duplicate detection:** an expense matching an existing one on supplier,
  amount and date is flagged; the same receipt image submitted twice is flagged.
  The tolerance that defines "duplicate" is agreed before the test (D15).
- **Capture effort is measured, not assumed:** time from "start" to "submitted"
  for a typical expense is recorded for each pilot user and compared against the
  same task in Rindegastos. A target is agreed before the pilot starts.

### P2 — Approve and refuse

- A user without the approver role cannot approve.
- The designated approver sees the report in a work queue with its age.
- Approving moves the report to approved and records the approver and timestamp.
- Refusing requires a reason and returns the report to the employee.
- **Refusal loop closes:** the employee is notified, can correct the report and
  resubmit it, and the history of both attempts is preserved.
- An approver cannot approve their own report.
- Approval routing by amount threshold and by category is configured and tested,
  not only single-level approval.

### P3 — Accounting

- Posting creates a balanced journal entry in the company's currency.
- Account, tax and analytic dimension come from the configured policy, not from
  free text; a missing mandatory dimension blocks submission.
- **Multiple taxes on one receipt** are supported and land on separate tax lines.
- A foreign-currency expense posts with the correct rate and preserves the
  original currency. The rate source and date are identified and reproducible.
- Posting twice is impossible; a posted report cannot be edited.
- Report, expenses, journal entry and payment are navigable in both directions.

### P4 — Reimbursement and payment closure

Three distinct facts, which must not be conflated:

| Level | Meaning | Evidence |
| --- | --- | --- |
| Registered | Odoo created the payment record | Payment record, journal entry |
| Executed | Money left the company account | Bank transfer evidence |
| Reconciled | The bank statement line is matched | Reconciled statement line |

The pilot must state which level closes the report (D11). Default proposal:
**reconciled**, with registered-only accepted solely with a documented manual
control owned by Treasury.

- Only posted reports can be paid.
- Payment records the employee, bank account, date and amount.
- A partial payment leaves the report in an in-payment state, not paid.
- The report reaches its final state only at the agreed closure level.

### P5 — Advance and clearing

Three scenarios, each with accounting evidence:

1. Expenses equal the advance: no further payment, advance fully cleared.
2. Expenses below the advance: the employee returns the difference, advance
   balance reaches zero.
3. Expenses above the advance: the company pays the difference, advance cleared
   and the extra reimbursed.

In all three: the advance never appears as revenue or expense, and the balance is
reconcilable against the accounting entries.

Also required: the **request and authorization** of the advance, not only its
delivery. Rindegastos separates fund request from fund assignment; delivering
money without an approved request is not the same process.

### P6 — Petty cash

- A holder is created with an assigned balance.
- Replenishment is recorded through a documented accounting path.
- An expense paid from petty cash reduces the holder balance.
- The holder cannot submit an expense above the available balance, or the system
  blocks it with a clear message.
- Balance reconciles against the general ledger at period close.

### P7 — Reporting and pending queue

- Finance can list every report pending approval, with approver and age in days.
- Totals by category, company and period match a manual calculation performed
  independently for the same data.
- Custom statuses, where used, filter correctly and appear in the queue.
- An export to spreadsheet is produced and opened successfully.
- A report of expenses charged to a given analytic dimension is obtainable without
  developer intervention.

### P8 — Exit from Rindegastos

- Every historical report is retrievable with its receipts, amounts, dates,
  approvers and payment evidence, for the retention period defined by Legal
  (D12).
- A list of reports in progress at cutover exists, and each one is either closed
  in Rindegastos or re-entered in Odoo exactly once.
- No expense can be paid twice across the cutover: paid amounts in the overlap
  window are reconciled between both systems.
- Approval history needed for audit is preserved, not only final amounts.
- The export is verified for completeness by someone other than the person who
  produced it (D14).

### X — Cross-cutting

- **Denied actions are executed, not inferred.** A non-administrator account
  attempts to read and approve another company's records; the denial is observed.
  Reading ACL XML is not evidence.
- The belief that the `admin` login bypasses record rules is **verified during the
  pilot**, not assumed. If it does not bypass them, coverage is wider than
  declared and the limitation is lifted with evidence.
- The chatter shows the full lifecycle with actor and timestamp.
- Removing an approver role revokes pending approvals.
- Report of who accessed a given report is obtainable for audit.

## 5. Exit criteria

| Outcome | Condition |
| --- | --- |
| **Proceed, single company** | P1–P4, P7 and X2 pass; P5–P6 pass or have an approved workaround with a dated plan; X3 passes on the positive path |
| **Blocked for multi-company** | X1 and the X3 negative path have not been executed. Both must pass before a second company adopts the flow and before Rindegastos notice is given |
| **Blocked for cancellation** | P8 has not passed. No notice may be given while history and open items are unsecured |
| **Partial replacement** | P1–P4 pass; P5/P6 fail; Rindegastos retained only for funds, or replaced by a different tool |
| **No-go** | P3 fails, deployment or rollback cannot be demonstrated, or an executed X1 test fails |

Reduced coverage was accepted on 2026-11-16. It does not lower the bar: it moves
X1 and the negative X3 checks to a named gate before cancellation, and P8 adds a
second gate that no previous version of this document had.

## 6. Preconditions

The pilot cannot start until:

1. A non-production database exists (copy of production).
2. The addon deployment and rollback procedure is documented by whoever
   administers the host.
3. Finance confirms the expense policy: categories, taxes, accounts, analytic
   dimensions, approval limits and who approves what.
4. Treasury confirms the payment closure definition (D11) and the bank accounts
   used for reimbursement.
5. The list of real pilot users is agreed, including one non-administrator and,
   for X1, one user from another company.
6. Licensing implications for those users are confirmed by the Odoo contact.
7. Rindegastos grants an export of history and open items, or the export is
   produced before notice is given (D14).

## 7. Conflicts with the business specification

`docs/06-business-spec.md` describes the real process: Teresa as digitizer,
Jefatura SAT as first confirmation, Gabriela as final approval, Contabilidad for
posting, payment and reconciliation, and 3–5 technicians. This section records
where the pilot scope disagrees with it, so neither document silently wins.

| # | Conflict | Business spec | This document | Decision |
| --- | --- | --- | --- | --- |
| C1 | Who participates in the pilot | Teresa, Jefatura SAT, Gabriela, Contabilidad, 3–5 technicians | Luis and Benjamín | **Open — D17** |
| C2 | Advances and petty cash | Explicitly out of the first phase until Accounting approves the treatment | P5 and P6 are in the pilot | **Open — D20** |
| C3 | WhatsApp | Manual intake by Teresa in phase 1; automation later | Excluded from pilot | Compatible, but C3 confirms manual intake is **in** scope |
| C4 | History | Closed reports not migrated; open ones only if approved | P8 requires archive and open-item control | P8 governs; the archive does not require re-posting |
| C5 | Approval model | Two operational levels plus accounting, with custom states | P2 tests one level | **Open — D18** |
| C6 | Weekly consolidation | One report per technician, company and payment mode, weekly | Not modelled | Must be added to P1/P7 before the pilot |

Until C1, C2 and C5 are resolved, the pilot as described here cannot be executed:
the roles it assumes are not the roles the process has.

## 8. Pilot participants

Two users, one company (`Ipam Technology S.A.`), one approval level, 4 weeks.

| User | Odoo user | Role in pilot | Verified state |
| --- | --- | --- | --- |
| Luis Fontecilla | id 2, login `admin` | Renderer and configuration | Administrator on production |
| Benjamín Abarzua | id 10, `benjamin.abarzua@airlife.com` | Renderer and approver | Active, internal, no department, no expense manager, no parent |

### Readiness gaps found

1. **Approval routing is unconfigured.** Benjamín's employee record (id 71) has no
   department, no `expense_manager_id` and no parent. 72 of 73 employees have no
   department, and only one employee has an expense manager. Until that is set,
   P2 cannot be executed at all.
2. **Both pilot users belong to company 1**, so X1 cannot be executed with them.
3. **A third, non-administrator user is required** to execute the negative X3
   checks. Whether `admin` actually bypasses record rules is verified in the
   pilot, not assumed.

### Coverage decision (accepted 2026-11-16, revised)

The pilot validates P1–P6, P7 and X2, plus the positive path of X3. It does not
validate, until the gates below are closed:

| Untested | Why | Gate |
| --- | --- | --- |
| X1 company isolation | No second-company user among participants | Before a second company adopts the flow, and before notice |
| X3 negative path | Needs a non-administrator account | Before multi-company use |
| P2 self-approval rule | Only one approver exists | Before a second approver is configured |
| P8 exit readiness | Depends on the Rindegastos export | Before notice is given |

These are **deferred gates, not waived requirements**. The pilot may conclude
"ready for one company"; it may not conclude "ready for the group", and it may
never conclude "ready to cancel" without P8.

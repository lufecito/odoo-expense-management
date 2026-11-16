# Pilot scope — replace Rindegastos with Odoo 18

Status: **technical pilot, approved 2026-11-16.** Scope agreed as a feasibility
proof carried out by two technical participants. It is **not** an operational
pilot: it does not validate the business chain of digitizer, SAT, final approval
and accounting.

## 1. Objective

Prove, on Odoo 18, that the expense cycle can run end to end:

digitizer registers expense → weekly report per technician → first confirmation →
final approval → accounting post → payment → reconcile.

The technical pilot answers one question: **is the configuration and the custom
module viable?** It deliberately does not answer whether Teresa, Jefatura SAT,
Gabriela and Contabilidad can operate it. That is the next phase.

## 2. In scope for the pilot

| ID | Process |
| --- | --- |
| P1 | Digitizer registers a receipt against a technician and builds the weekly report |
| P2a | First confirmation (SAT stage): confirm or return |
| P2b | Final approval: approve, return or refuse, including restart of P2a after a correction |
| P3 | Approved report posts to accounting in the correct company, account, tax and analytic dimension |
| P4 | Payment is registered and reconciled under the agreed definition |
| P7 | Finance reports and pending queue |
| P8 | Exit from Rindegastos: archive, open items and cutover |

Cross-cutting:

| ID | Requirement |
| --- | --- |
| X1 | Company isolation: a user of company A cannot see or approve company B data |
| X2 | Traceability: who created, confirmed, approved, refused and posted, with timestamps |
| X3 | Role separation: digitizer, first confirmer, final approver, accounting |

**P5 (advances) and P6 (petty cash) were removed from the pilot on 2026-11-16.**
Their IDs are retired, not reused. See C2.

## 3. Out of scope

| Excluded | Reason |
| --- | --- |
| Advances and clearing | Business specification excludes them from the first phase; Accounting must approve the accounting treatment (C2) |
| Petty cash and funds | Same as advances |
| Corporate card reconciliation | Different mechanism from Concil-IA; no equivalence claimed |
| Automated payment execution | Requires bank integration, not an addon |
| WhatsApp automation | Phase 1 is manual intake by the digitizer (C3) |
| Mileage, per-diem travel, digital signature | Usage not confirmed |
| AI scoring and agents | No equivalence claimed |
| Countries other than Chile | Pilot is single-company |
| Re-posting of historical reports | P8 archives; it does not migrate and re-account |

## 4. Acceptance criteria

Executed on a non-production database, with realistic data, by a person other than
the developer where possible.

### P1 — Registration and weekly report

- A digitizer registers an expense on behalf of a technician: date, supplier,
  category, net, tax, total, currency, payment mode (employee or company),
  analytic distribution.
- The receipt travels by WhatsApp manually: the digitizer saves the image and
  attaches it. No automated ingestion is expected or tested.
- After OCR, the digitizer can correct any extracted field without re-uploading.
- The expense cannot be saved without a receipt, with a zero or negative amount,
  with a future date, or with an incomplete analytic distribution.
- **Weekly grouping:** one report per technician, per company and per payment
  mode. A report cannot mix technicians, companies or payment modes.
- Naming convention: `Rendición semanal – <técnico> – AAAA-SNN`.
- Duplicate warning triggers on supplier + date + amount, and on a repeated file
  checksum. Warning only, not blocking, during the pilot.
- **Effort is measured:** time for the digitizer to register one expense with OCR,
  compared with the same task in Rindegastos.

### P2a — First confirmation (SAT stage)

- Only a user in the first-confirmer group sees the pending queue.
- Confirming records confirmer, timestamp and comment, closes the previous
  activity and opens the final approver's activity.
- Returning requires a reason, records it, and returns the report to the digitizer.
- The first confirmer cannot execute the standard final approval.

### P2b — Final approval

- The final approver cannot approve while the first confirmation is not valid.
- Approving records approver, timestamp and comment, and invokes the standard
  approval logic.
- Returning requires a reason and sends the report back to the digitizer.
- Refusing requires a reason and blocks the flow permanently.
- **A correction after final approval restarts P2a**, because the content the
  first confirmer approved may have changed.
- The final approver cannot approve their own report.
- A user without the approver role cannot approve; the denial is observed.

### P3 — Accounting

- Posting creates a balanced journal entry in the company currency.
- Account, tax and analytic dimension come from configured masters, not free text.
- Multiple taxes on one receipt land on separate tax lines.
- A foreign-currency expense posts with the correct rate and preserves the
  original currency; the rate source and date are documented.
- Posting twice is impossible; a posted report cannot be edited without an
  authorised reversal.
- Report, expenses, journal entry and payment are navigable in both directions.

### P4 — Payment closure

| Level | Meaning | Evidence |
| --- | --- | --- |
| Registered | Odoo created the payment record | Payment record, journal entry |
| Executed | Money left the company account | Bank transfer evidence |
| Reconciled | Statement line matched | Reconciled statement line |

Closure level is defined by Treasury (D11). Default proposal: **reconciled**.

- Only posted reports can be paid.
- Payment records employee, bank account, date and amount.
- A partial payment leaves the report in payment, not paid.
- Individual and grouped payments both work.

### P7 — Reporting and pending queue

- Pending queue per stage, with responsible user and age in days.
- Saved filters: current week, previous week, by technician, by company, pending
  by stage, pending posting, pending payment, returned, missing receipt.
- Totals by category, company and period match an independent manual calculation.
- Spreadsheet export produced and opened successfully.
- Expenses charged to a given analytic dimension are obtainable without a
  developer.

### P8 — Exit from Rindegastos

- Historical reports retrievable with receipts, amounts, dates, approvers and
  payment evidence, for the retention period set by Legal (D12).
- Reports in progress at cutover listed; each closed in Rindegastos or re-entered
  in Odoo exactly once.
- No expense paid twice across the cutover; paid amounts in the overlap window
  reconciled between both systems.
- Approval history needed for audit preserved, not only final amounts.
- Export verified for completeness by someone other than its producer (D14).
- No Rindegastos→Odoo export tooling exists today; it must be built or the data
  archived read-only.

### X — Cross-cutting

- A non-administrator account attempts to read and approve another company's
  records; the denial is observed, not inferred from ACL XML.
- Whether the `admin` login bypasses record rules is verified, not assumed.
- Chatter shows the full lifecycle with actor and timestamp.
- Structured fields allow querying responsible user and date without parsing text.
- Removing a role revokes pending actions.

## 5. Exit criteria

| Outcome | Condition |
| --- | --- |
| **Technically viable** | P1, P2a, P2b, P3, P4, P7 pass; X2 passes; X3 passes on role assignment |
| **Not viable** | P3 fails, deployment or rollback cannot be demonstrated, or the double approval cannot be enforced server-side |
| **Blocked for operational pilot** | Always, until the five-role chain is exercised by its real owners (C1) |
| **Blocked for cancellation** | P8 has not passed. No notice while history and open items are unsecured |
| **Blocked for multi-company** | X1 not executed. Required before a second company adopts the flow |

The technical pilot **cannot** declare readiness to operate or to cancel. Its
maximum conclusion is "technically viable; schedule the operational pilot".

## 6. Preconditions

1. Non-production database (copy of production).
2. Documented addon deployment and rollback procedure.
3. Finance defines categories, taxes, accounts, analytic dimensions and limits
   for at least one company.
4. Treasury defines payment closure (D11).
5. Rindegastos history and open items secured (D12, D14) before any notice.
6. Licensing implication of the two technical users confirmed.

## 7. Conflicts with the business specification — resolved

`docs/06-business-spec.md` remains authoritative for process, roles, states,
validations and its test plan. Resolution of the six conflicts:

### C1 — Who participates → **technical pilot with two participants**

Luis Fontecilla and Benjamín Abarzua run the pilot as a feasibility proof.

**Consequence:** the business chain is not validated. Nothing in this pilot
demonstrates that Teresa, Jefatura SAT, Gabriela or Contabilidad can operate the
flow, accept the workload, or meet an SLA. The operational pilot is a separate,
mandatory phase.

**Role simulation:** the two participants carry the four roles by group
assignment on stage accounts only. To observe denials, one stage account must be a
non-administrator. If no non-administrator account is used, X1 and the negative
X3 path stay uncovered and the gate remains open.

### C2 — Advances and petty cash → **deferred**

Removed from the pilot, matching the business specification. Accounting must
approve the treatment before they are built.

**Consequence:** if the company uses fundos por rendir today, **Rindegastos cannot
be cancelled** until that process has a replacement. This must be confirmed with
Finance (D20) before any notice is given.

### C3 — WhatsApp → **manual intake is in scope**

The digitizer receives the photo by WhatsApp, saves it and attaches it. This is
the business specification's phase 1 and is tested as part of P1.

**Consequence:** the pilot measures digitizer effort, not technician self-service.
A technician submitting directly is not tested. Automation remains a later phase.

### C4 — History → **archive, not migration**

P8 governs: export or archive read-only, verify completeness, control open items,
prevent double payment. Closed reports are not re-entered in Odoo.

**Consequence:** there is no Rindegastos→Odoo export tool today, and its
availability is not confirmed. P8 is the gate that keeps cancellation honest.

### C5 — Approval model → **two operational levels, custom states**

Replaced the single-level P2 with P2a and P2b, matching the specification's state
machine and transition matrix. Implemented as structured states and
server-enforced transitions, not as view-level buttons.

**Consequence:** this is the largest piece of custom work and the main technical
risk of the project. Studio alone is insufficient.

### C6 — Weekly consolidation → **in scope**

Grouping rules, naming convention and the weekly view with saved filters are
part of P1 and P7. Automatic weekly generation is optional and not required by the
pilot; manual creation is enough to validate the grouping rules.

## 8. Pilot participants

| User | Odoo user | Role during the pilot |
| --- | --- | --- |
| Luis Fontecilla | id 2, login `admin` | Configuration, digitizer, final approver |
| Benjamín Abarzua | id 10, `benjamin.abarzua@airlife.com` | Digitizer, first confirmer, accounting |

### Known limitations

1. Both belong to company 1, so X1 needs a stage account from another company.
2. Benjamín's employee record (id 71) has no department, no `expense_manager_id`
   and no parent; 72 of 73 employees have no department. Approval routing needs
   configuration before P2 can run.
3. One of the two accounts is the production administrator. Every denial test must
   run on a non-administrator stage account.

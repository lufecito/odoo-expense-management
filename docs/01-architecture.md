# Architecture decision

## Decision

Extend `hr_expense` and `hr.expense.sheet`. Do not build a parallel expense
application.

Rejected alternative: a standalone addon with its own expense, person and
approval models, following the pattern of `it_informatica_inventory`.

## Why

`hr_expense` already provides, without custom code:

- Expense and report models with states, currency, taxes, attachments and
  analytic distribution.
- Duplicate detection (`duplicate_expense_ids`, `same_receipt_expense_ids`).
- Posting to the chart of accounts, and payment to the employee.
- Multi-company rules, chatter, activities and access groups.

A parallel model would have to rebuild all of it, and would break the one thing
that makes this replacement worthwhile: the expense becomes an accounting entry
without an integration step.

The asset-custody module is isolated on purpose because it represents physical
objects that never post to accounting. Expenses are the opposite case.

## Module set

| Layer | Component | Origin | Status |
| --- | --- | --- | --- |
| Base | `hr_expense` | Odoo core, already installed | Pilot |
| Double operational approval | `ipam_expense` (to build) | this repository | Pilot — main risk |
| Policy rules | `ipam_expense` (to build) | this repository | Pilot, minimal |
| Reporting and weekly view | `ipam_expense` + native views | this repository | Pilot |
| Multi-level approval via OCA tiers | `hr_expense_tier_validation` | OCA 18.0, Beta | **Not selected** |
| Advances and clearing | `hr_expense_advance_clearing` | OCA 18.0, Beta | Deferred (C2) |
| Petty cash | `hr_expense_petty_cash` | OCA 18.0, Beta | Deferred (C2) |

### Why not `hr_expense_tier_validation`

The business process needs two **operational stages** with their own structured
audit fields (first confirmer, final approver, comments, return reason) and a rule
that a correction after final approval restarts the first stage. A generic tier
engine can validate that N approvals exist; it does not model two business stages
with distinct meaning and restart semantics.

Tier validation remains a candidate for simpler approval policies inside a stage,
not for the two-stage chain.

## Proposed addon boundary

`ipam_expense` should only contain what the layers above do not provide:

- The two-stage operational approval: states, transitions, structured audit fields,
  restart rule after a correction.
- Weekly report grouping rules, naming sequence and the weekly view with saved
  filters.
- Company-scoped policy rules: limits by category, required fields, submission
  windows, duplicate warnings.
- Custom expense fields from the specification: receipt number, issuer VAT, source
  channel, source message id, operating week.
- Any SII or document validation not covered by the installed localization.

It must not:

- Define a second expense or report model.
- Create a parallel employee or person table.
- Replace the accounting entry with an export file.
- Implement advances or petty cash (deferred, C2).

## Naming and structure

```
ipam_expense/
├── models/        # _inherit hr.expense, hr.expense.sheet only
├── security/      # groups and ACLs scoped to new models and fields
├── views/         # inherited views, no duplicated forms
├── data/          # policy defaults, sequences
├── report/        # only if the standard report is insufficient
└── tests/         # one test per acceptance criterion
```

## Licensing note

The OCA modules are AGPL-3. Internal use carries no distribution obligation. If a
modified version is ever offered as a network service to third parties, the
source must be published.

## Deployment constraint

No production install until a staging database and a documented rollback exist.
The MCP connection is read-only in this project; it is not a deployment channel.

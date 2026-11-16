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

| Layer | Component | Origin |
| --- | --- | --- |
| Base | `hr_expense` | Odoo core, already installed |
| Multi-level approval | `hr_expense_tier_validation` | OCA 18.0, Beta |
| Advances and clearing | `hr_expense_advance_clearing` | OCA 18.0, Beta |
| Petty cash | `hr_expense_petty_cash` | OCA 18.0, Beta |
| Policy gaps | `ipam_expense` (to build) | this repository |

All three OCA modules are published for 18.0 and marked Beta. They are candidates
for testing, not proven dependencies.

## Proposed addon boundary

`ipam_expense` should only contain what the layers above do not provide:

- Company-scoped policy rules: limits by category, required fields, submission
  windows.
- Custom report statuses for finance tracking, if the standard state machine
  proves insufficient.
- Any SII or document validation not covered by the installed localization.
- Integration glue, only if a specific system is in scope.

It must not:

- Define a second expense or report model.
- Create a parallel employee or person table.
- Store approvals outside `base_tier_validation`.
- Replace the accounting entry with an export file.

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

# Odoo Expense Management (18.0)

Feasibility, pilot scope and implementation for replacing Rindegastos with the
existing Odoo 18 Enterprise instance (`ipam-master`).

**Status:** pilot scoping. Nothing is installed. No production writes.

## Scope of this repository

| Path | Purpose |
| --- | --- |
| `docs/00-scope-pilot.md` | Pilot scope, processes and acceptance criteria |
| `docs/01-architecture.md` | Design decision and module boundary |
| `docs/02-verified-baseline.md` | Facts read from the live instance |
| `docs/03-open-decisions.md` | Decisions blocked on owners outside engineering |
| `docs/04-staging-request.md` | Formal staging request to the host administrator |
| `docs/05-substitution-matrix.md` | Rindegastos function by function, with disposition |
| `odd/tasks/expense-management.md` | Working feature document and log |

## Ground rules

1. **Read-only against production** until a staging database exists and a
   deployment procedure is confirmed. The MCP connection uses an administrator
   account on production; it is an inspection tool, not a deployment mechanism.
2. **No secrets in this repository.** No API keys, no bank credentials, no
   database dumps.
3. **Extend, do not duplicate.** Expense, sheet, employee and journal models are
   inherited from Odoo. Parallel models for the same concepts are rejected by
   design (see `docs/01-architecture.md`).
4. **Documentation is in English.** Business conversation and stakeholder
   reviews happen in Spanish; identifiers, code comments and commit messages are
   English.

## Current baseline

Odoo 18.0+e, 15 companies (CLP), `hr_expense` installed with no usage, OCA
`base_tier_validation` installed, `hr_expense_extract` installed. Details and
evidence in `docs/02-verified-baseline.md`.

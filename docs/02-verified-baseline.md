# Verified baseline

Read on 2026-11-16 through the local `odoo` MCP server (read-only calls only).
Production database: `ipam-master`. No record was created, changed or deleted.

## Platform

| Fact | Value |
| --- | --- |
| Version | Odoo 18.0+e |
| Companies | 15 (CLP) |
| Active employees | 73 |
| Internal active users | 87 |
| Endpoint | `https://ipam.server72c8e.oerpondemand.net` |

## Expense-related modules

| Module | Version | State |
| --- | --- | --- |
| `hr_expense` | 18.0.2.0 | installed |
| `hr_expense_extract` | 18.0.1.0 | installed (OCR, IAP credits) |
| `hr_expense_predict_product` | 18.0.1.0 | installed |
| `documents_hr_expense` | 18.0.1.0 | installed |
| `project_hr_expense` | 18.0.1.0 | installed |
| `sale_expense` | 18.0.1.0 | installed |
| `account_disallowed_expenses` | 18.0.1.0 | installed |

## Supporting modules

| Module | Version | Notes |
| --- | --- | --- |
| `base_tier_validation` | 18.0.3.0.0 | multi-level validation engine (OCA) |
| `base_tier_validation_formula` | 18.0.1.0.0 | condition support |
| `purchase_tier_validation` | 18.0.1.0.0 | precedent: tiers already used in purchase |
| `web_studio` | 18.0.1.0 | installed |
| `documents` | 18.0.1.4 | installed |
| `l10n_cl` | installed | official Chilean localization |
| `l10n_cl_edi` | not installed | third-party SII modules present instead |
| `l10n_cl_account_sii_*` | several | third-party SII localization, installed |
| `approvals` | 18.0.1.0 | **not installed** (Enterprise) |

## Usage evidence

| Fact | Value |
| --- | --- |
| `hr.expense` records | **0** |
| `hr.expense.sheet` records | **0** |

The Expenses app has never been used. There is no historical process to migrate,
and no existing configuration to preserve. The expense policy must be defined
with Finance, not inferred from data.

## Custom addon precedent

`it_informatica_inventory` 18.0.1.2.0 is installed and operational. It declares
models `x_it_asset`, `x_it_assignment`, `x_it_event`, `x_it_document`,
`x_it_document_link`, `x_it_entity`, `x_it_line`, `x_it_person`,
`x_it_personal_usage`, `x_it_conflict`, plus ACLs, window actions, a client
dashboard action and JS assets.

Two conclusions:

1. Custom addons are technically deployable on this host, so the deployment
   mechanism exists even if its procedure is undocumented.
2. That module deliberately avoids inheriting business models and keeps its own
   person/entity tables. That isolation is appropriate for asset custody and
   **not** appropriate for expenses, which must post to the existing chart of
   accounts.

## Open uncertainty

No staging database and no documented addon deployment procedure were found in
the previous handoff (2026-11-10). That was not re-verified against the host now.
Treat it as unknown, not as absent.

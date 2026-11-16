# Substitution matrix

Function-by-function comparison between Rindegastos (official plans page, Chile,
consulted 2026-11-16) and the pilot scope.

Status values:

| Status | Meaning |
| --- | --- |
| **Pilot** | Has an acceptance criterion in `docs/00-scope-pilot.md` |
| **Assumed** | Believed to exist in Odoo 18; not yet executed |
| **Build** | Requires `ipam_expense` or configuration work |
| **Deferred** | Out of pilot, with a required disposition (D13) |
| **No plan** | Not covered anywhere; must be accepted explicitly or scoped |

## Core expense cycle

| Rindegastos function | Odoo 18 candidate | Status | Evidence / gap |
| --- | --- | --- | --- |
| Create expenses and reports, unlimited | `hr.expense`, `hr.expense.sheet` | Pilot P1 | Zero records today; unproven |
| Custom approval flows, unlimited | `ipam_expense` two-stage approval (not OCA tiers) | Pilot P2a/P2b | Custom logic; largest risk |
| Automatic duplicate detection | `duplicate_expense_ids`, `same_receipt_expense_ids` | Pilot P1 | Native fields exist; tolerance undefined (D15) |
| Custom fields | `ir.model.fields`, Studio | Assumed | Not tested |
| Multi-currency | `hr.expense.currency_id` + rates | Pilot P3 | Rate source must be documented |
| Multiple taxes per receipt | `tax_ids` | Pilot P3 | Common Chilean case; explicit test |
| Custom statuses | `hr.expense.sheet.state` + Studio field | Pilot P7 | Filters and queue must work |
| Attachment of receipts | `ir.attachment` | Pilot P1 | Volume and mobile upload untested |
| Report and pending tracking | List views, activities | Pilot P7 | Aging and queue untested |
| Spreadsheet export | Native export | Pilot P7 | Verify totals against manual count |

## Capture channels

| Rindegastos | Odoo 18 candidate | Status | Note |
| --- | --- | --- | --- |
| Mobile app | Odoo mobile web / app | Pilot P1 | Capture effort measured, not assumed |
| Scanit 2.0 OCR | `hr_expense_extract` (IAP credits) | Deferred | Cost per document; accuracy not benchmarked |
| Email ingestion | Mail alias to expenses | Deferred | Must be scoped with volume |
| WhatsApp ingestion | None native | Deferred | Third-party integration required |
| Custom approval notifications | Activities + mail | Pilot P2 | Delivery and refusal loop tested |

## Money flows

| Rindegastos | Odoo 18 candidate | Status | Note |
| --- | --- | --- | --- |
| Petty cash and funds | OCA `hr_expense_petty_cash` | Deferred | Removed from pilot (C2); blocks cancellation if funds are in use |
| Funds to be accounted | OCA `hr_expense_advance_clearing` | Deferred | Removed from pilot (C2); Accounting must approve the treatment |
| Fund requests and authorization | None selected | Deferred | Depends on the advances decision |
| Reimbursement | `account.payment` from sheet | Pilot P4 | Closure level defined by Treasury (D11) |
| Rindepay (payment execution) | None native | Deferred | Requires bank integration, not an addon |
| Card reconciliation (Concil-IA) | Bank sync + reconciliation models | Deferred | Different mechanism; must not be claimed as equivalent |
| Mileage and per-diem travel | `hr_expense` mileage app (Enterprise) | Deferred | Confirm actual usage first |

## Reporting, control and platform

| Rindegastos | Odoo 18 candidate | Status | Note |
| --- | --- | --- | --- |
| Advanced reporting | Pivot/list/Graph + spreadsheet | Pilot P7 | Verified against independent calculation |
| Full action audit log | `mail.thread`, `mail.tracking.value` | Assumed | Enterprise audit log not verified |
| SSO | Odoo SSO | No plan | Out of pilot; note for group rollout |
| 2FA | Odoo 2FA | Assumed | Not in pilot scope |
| Multi-company | Record rules | Pilot X1 | Gate, not validated in pilot |
| API for integrations | JSON-RPC / XML-RPC | No plan | Not needed for the pilot |
| AI agents (Rendidor, Revisor, Auditor, Financiero) | None | Deferred | No equivalence claimed |

## What this means

The pilot covers the **core cycle plus money flows and reporting**. It does not
cover capture channels, card reconciliation, payment execution or AI. Those are
not small omissions: they are where Rindegastos adds value beyond a form and an
approval.

Every `Deferred` row requires a written disposition (D13) before cancellation:
retain Rindegastos for it, replace it with another tool, accept the loss, or
commit to a dated build.

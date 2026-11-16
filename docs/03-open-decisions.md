# Open decisions

Each item blocks something concrete. Owner and answer are recorded when known.

| ID | Decision | Owner | Blocks | Status |
| --- | --- | --- | --- | --- |
| D1 | Where the pilot is tested: second database on the same host, separate instance, or local Odoo 18 | Host administrator | Everything | Open |
| D2 | Addon deployment and rollback procedure | Host administrator | Any custom module | Open |
| D3 | Expense policy: categories, taxes, accounts, analytic dimensions, approval limits | Finance | P1, P2, P3 | Open |
| D4 | Who approves what, and whether one level is enough for the pilot | Finance, HR | P2 | Open |
| D5 | Pilot user list and licensing impact under the current Odoo contract | Odoo contact, Management | P1, cost model | Open |
| D6 | Digitization: Odoo IAP credits versus an external provider, and expected volume | Finance | Cost model | Open |
| D7 | Banks and card issuers actually in use | Finance, Treasury | Out-of-pilot card reconciliation | Open |
| D8 | Whether petty cash is currently used at all, and by how many holders | Finance | P6 | Open |
| D9 | Rindegastos contract end date, notice period and per-user pricing | Management | Timing of any cancellation | Open |
| D10 | Retention requirements for receipts and expense evidence | Legal, Finance | Data model, attachments | Open |

## Notes

- D1 and D2 were already blockers for the asset-custody project. They are
  infrastructure decisions, not expense decisions, and they block this project
  for the same reason.
- D9 must be known before any rollout date is promised. Cancelling a SaaS without
  knowing the notice period is how a migration becomes an emergency.
- D6 has a cost consequence that is easy to underestimate: digitization is
  charged per document, and volume grows with every receipt, not with every user.

# Open decisions

Each item blocks something concrete. Owner and answer are recorded when known.

| ID | Decision | Owner | Blocks | Status |
| --- | --- | --- | --- | --- |
| D1 | Where the pilot is tested: second database on the same host, separate instance, or local Odoo 18. **Local sandbox declined 2026-11-16: the system is not to be modified** | Host administrator | Everything | Staging only |
| D2 | Addon deployment and rollback procedure | Host administrator | Any custom module | Open |
| D3 | Expense policy: categories, taxes, accounts, analytic dimensions, approval limits | Finance | P1, P2, P3 | Open |
| D4 | Who approves what, and whether one level is enough for the pilot | Finance, HR | P2 | Open |
| D5 | Licensing impact of the confirmed pilot users under the current Odoo contract | Odoo contact, Management | Cost model | Partially resolved |
| D6 | Digitization: Odoo IAP credits versus an external provider, and expected volume | Finance | Cost model | Open |
| D7 | Banks and card issuers actually in use | Finance, Treasury | Out-of-pilot card reconciliation | Open |
| D8 | Whether petty cash is currently used at all, and by how many holders | Finance | P6 | Open |
| D9 | Rindegastos end date and per-user pricing. **Notice period confirmed: 30 days** | Management | Timing of any cancellation | Partially resolved |
| D10 | Retention requirements for receipts and expense evidence | Legal, Finance | Data model, attachments | Open |

## Notes

- D1 and D2 were already blockers for the asset-custody project. They are
  infrastructure decisions, not expense decisions, and they block this project
  for the same reason.
- D9 must be known before any rollout date is promised. Cancelling a SaaS without
  knowing the notice period is how a migration becomes an emergency.
  **30 days confirmed on 2026-11-16.** The period starts when notice is given, so
  the correct sequence is: pilot passes, then notice, then 30 days of parallel
  operation. Not the reverse.
- The pilot user list is confirmed (Luis Fontecilla, Benjamín Abarzua) but its
  coverage is not sufficient for X1 and X3. See `docs/00-scope-pilot.md` §7.
- D6 has a cost consequence that is easy to underestimate: digitization is
  charged per document, and volume grows with every receipt, not with every user.

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
| D11 | Which payment level closes a report: registered, executed or reconciled | Treasury | P4 | Open |
| D12 | Retention period and archive format for Rindegastos history | Legal, Finance | P8 | Open |
| D13 | Disposition of each deferred function: cards, WhatsApp, mileage, travel, signature, AI | Management, Finance | Cancellation scope | Open |
| D14 | Who verifies the Rindegastos export for completeness, and when | Management | P8, notice date | Open |
| D15 | Tolerance that defines a duplicate expense | Finance | P1 | Open |
| D16 | Capture-effort target, measured against the current Rindegastos flow | Finance, pilot users | P1 | Open |
| D17 | Who actually participates: Luis and Benjamín, or Teresa, Jefatura SAT, Gabriela, Contabilidad and 3–5 technicians | Management | P1, P2, everything | Open |
| D18 | Who integrates Jefatura SAT, who replaces them, and whether the pilot tests both approval levels | Management, SAT | P2, C5 | Open |
| D19 | Weekly close: day, time, and who consolidates | Finance, SAT | P1, P7, C6 | Open |
| D20 | Advances and petty cash: in the first delivery or deferred as the business spec states | Finance, Accounting | P5, P6, C2 | Open |

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
  coverage is not sufficient for X1 and X3. See `docs/00-scope-pilot.md` §8.
- D11 matters more than it looks. "Paid" in Odoo can mean three different things.
  If Treasury closes reports at *registered* while the bank transfer never
  happens, the pilot will look green and employees will not be paid.
- D13 is the decision that prevents a surprise: every function we defer is either
  retained in Rindegastos, replaced elsewhere, or accepted as a loss. Silence is
  not a disposition.
- D12 and D14 are the exit gate. Notice cannot be given while history and open
  items are unsecured, regardless of how well the pilot performs.
- D17 is the most consequential open decision. The scope assumed two technical
  participants; the business specification assumes a five-role operational chain.
  Both cannot be true. Reporting "pilot passed" against the wrong users would be
  the worst possible outcome.
- D20 is a scope reduction, not a technical question. The business specification
  already excludes advances from the first phase; this project's P5/P6 contradict
  it. Deferring them lowers risk and shortens the pilot.
- D6 has a cost consequence that is easy to underestimate: digitization is
  charged per document, and volume grows with every receipt, not with every user.

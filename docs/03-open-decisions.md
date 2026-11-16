# Open decisions

Each item blocks something concrete. Owner and answer are recorded when known.

| ID | Decision | Owner | Blocks | Status |
| --- | --- | --- | --- | --- |
| D1 | Where the pilot is tested: second database on the same host, separate instance, or local Odoo 18. **Local sandbox declined 2026-11-16: the system is not to be modified** | Host administrator | Everything | Staging only |
| D2 | Addon deployment and rollback procedure | Host administrator | Any custom module | Open |
| D3 | Expense policy: categories, taxes, accounts, analytic dimensions, approval limits | Finance | P1, P2, P3 | **Narrowed:** no categories configured; draft mapping required |
| D4 | Who approves what | Finance, HR | P2a, P2b | **Resolved: Hecdaly Corzo and Katherine Catalán verify**; stage split pending (D22) |
| D5 | Licensing impact of the confirmed pilot users under the current Odoo contract | Odoo contact, Management | Cost model | **Resolved for the pilot: both users already active, no incremental licence** |
| D6 | Digitization: Odoo IAP credits versus an external provider, and expected volume | Finance | Cost model | **Resolved for the pilot: OCR excluded until credits are confirmed** |
| D7 | Banks and card issuers actually in use | Finance, Treasury | Out-of-pilot card reconciliation | **Partly resolved:** bank journals inventoried; cards still unknown |
| D8 | Whether petty cash is currently used at all, and by how many holders | Finance | Cancellation scope (C2) | **Resolved: yes, accounts exist including Fondo Fijo SAT** |
| D9 | Rindegastos end date and per-user pricing. **Notice period confirmed: 30 days** | Management | Timing of any cancellation | Partially resolved |
| D10 | Retention requirements for receipts and expense evidence | Legal, Finance | Data model, attachments | Proposal: no purge, Legal sets the number |
| D11 | Which payment level closes a report: registered, executed or reconciled | Treasury | P4 | **Resolved: reconciled**, per business spec §14 |
| D12 | Retention period and archive format for Rindegastos history | Legal, Finance | P8 | Proposal: read-only archive, period set by Legal |
| D13 | Disposition of each deferred function: cards, WhatsApp, mileage, travel, signature, AI | Management, Finance | Cancellation scope | Open |
| D14 | Who verifies the Rindegastos export for completeness, and when | Management | P8, notice date | **Candidates named: Hecdaly Corzo, Katherine Catalán**; confirm scope of their verification |
| D15 | Tolerance that defines a duplicate expense | Finance | P1 | **Resolved: supplier+date+amount and repeated checksum, warn only** |
| D16 | Capture-effort target, measured against the current Rindegastos flow | Finance, pilot users | P1 | **Resolved: not slower than the current step** |
| D17 | Who participates in the pilot | Management | Everything | **Resolved 2026-11-16: technical pilot with Luis and Benjamín.** Operational chain validated in a later phase |
| D18 | First confirmer role and whether the pilot tests both approval levels | Management, SAT | P2a, P2b | **Resolved: both levels tested by role assignment on stage accounts.** Real SAT owner still undefined for the operational phase |
| D19 | Weekly close: day, time and consolidator | Finance, SAT | P1, P7 | **Resolved for the pilot: grouping validated, no real close.** Operational cadence pending |
| D24 | Who are the Transport executives and which technical staff participate | Management | P1, G4 | Open |
| D21 | Which company hosts the pilot: 1 (Luis, Benjamín) or 5 (the two verifiers) | Management | P2a, P2b, X1 | Open |
| D22 | Which verifier holds the first stage and which the final approval | Management | P2a, P2b | Open |
| D23 | Technical area: digitizer model or self-service with own accounts | Management | P1, licensing | Open — default is digitizer model |
| D20 | Advances and petty cash in the first delivery | Finance, Accounting | P5, P6 | **Resolved: deferred.** Must confirm whether funds are in use today, because that blocks cancellation |

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
- D17 is resolved as a technical pilot, and that changes what can be claimed. Its
  maximum conclusion is "technically viable". It cannot certify that the operational
  chain works, and it cannot justify cancellation on its own.
- D20 is resolved by deferral, but the underlying question remains: if funds por
  rendir are used today, Rindegastos stays until they are covered.
- C5 is now the largest technical risk. The two-stage approval with restart
  semantics is custom logic, not configuration, and Studio cannot enforce it.
- D6 has a cost consequence that is easy to underestimate: digitization is
  charged per document, and volume grows with every receipt, not with every user.

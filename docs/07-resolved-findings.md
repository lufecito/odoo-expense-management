# Autonomously resolved findings

Read-only against `ipam-master` on 2026-11-16. No record was created, changed or
deleted.

## 1. Funds por rendir and petty cash are in use — D8 resolved

The chart of accounts already carries dedicated accounts:

| Code | Name |
| --- | --- |
| `100.01.110.04` | Fondo Fijo Administración |
| `100.01.110.05` | Fondo Fijo Producción |
| `100.01.110.06` | **Fondo Fijo SAT** |
| `100.01.110.07` | **Fondos por Rendir** |
| `100.01.110.01` | Anticipos Remuneraciones |

**Conclusion: funds and petty cash exist as accounting vehicles, including one
specific to SAT, the same area the expense process serves.**

Consequence, per conflict C2: **Rindegastos cannot be cancelled with the current
scope.** The pilot deliberately excludes advances and petty cash, so the process
they cover today would be left without a replacement. Either the scope grows to
include funds, or Rindegastos (or another tool) stays for that function.

This is the single most consequential finding of the project so far, and it was
treated as an open question until now.

## 2. OCR has no visible credits — D6 partly resolved

`iap.account` "Document Digitization" exists (id 12) but its `balance` returns no
value. `hr_expense_extract` is installed and configured in automatic mode, yet no
credit balance is visible.

**Conclusion: digitization cannot be assumed to work today.** Either credits are
purchased, or the pilot runs with manual data entry and OCR is evaluated
separately. Do not promise OCR in the pilot plan.

## 3. Expense categories are not configured — D3 narrowed

Only the Odoo demo products carry `can_be_expensed`: Expenses, Meals, Gifts,
Mileage, Travel & Accommodation. There are no company-specific expense categories.

The chart does contain plausible target accounts, for example:

| Account | Name |
| --- | --- |
| `600.01.610.04` | Almuerzos |
| `600.01.604.01` | Otros Gastos de Viaje |
| `500.02.504.02` | Costo Colación por Viaje |
| `500.02.506.02` | Costo Elementos de Protección Personal |

**Conclusion:** the policy cannot be inferred; it must be built. The work is to map
the business specification's categories (fuel, tolls, meals, lodging, transport,
minor materials, tools) onto existing accounts. That is a review of a draft, not a
blank page.

## 4. The SAT analytic dimension exists — C6 unblocked

Analytic account `SAT` (id 19) under plan `OPERACIONES`.

**Conclusion:** the business specification's requirement for a SAT cost centre can
be met with existing data. No new analytic structure is required.

## 5. Real banks per company — D7 partly resolved

Bank journals exist for: Banco Security / Bice, Banco de Chile, Santander, BCI,
Banco Estado, Itaú, Scotiabank, Consorcio (Chile); BCP (Perú); generic Bank
(México), plus USD variants.

**Conclusion:** reimbursement and reconciliation can use existing journals. Card
reconciliation remains excluded and is not resolved by this.

## 6. Licensing — D5 resolved for the pilot

Both pilot users are already active internal users of company 1:
Luis Fontecilla (`admin`, id 2) and Benjamín Abarzua (id 10, not a portal user).

**Conclusion: no incremental licence is required for the technical pilot.** This
says nothing about the operational rollout, where technicians and approvers may or
may not become paying users.

## 7. Resolutions adopted

| ID | Resolution | Basis |
| --- | --- | --- |
| D5 | No incremental licence for the technical pilot | Both users already active |
| D6 | OCR is out of the pilot until credits are confirmed | No visible balance |
| D7 | Use existing bank journals; card reconciliation stays deferred | Journals exist |
| D8 | **Funds and petty cash are in use; cancellation blocked while uncovered** | Dedicated accounts exist |
| D11 | A report is closed at **reconciled**, not registered | Business spec §14 requires bank reconciliation |
| D12 | Propose: keep receipts and reports for the tax retention period, no purge; Legal confirms the number | Engineering default, pending Legal |
| D14 | Accounting verifies the export against document count and totals, independent of the exporter | Separation of duties |
| D15 | Warn on supplier + date + amount and on repeated checksum; warning only during the pilot | Business spec §13 |
| D16 | Target: not slower than the current Rindegastos step for the same expense | Relative, no invented number |

## 8. What remains genuinely unresolvable without a human

| ID | Why |
| --- | --- |
| D1, D2 | Need host administrator access |
| D3 | Requires Finance to choose categories and limits |
| D4 | Requires Finance and HR to name approvers |
| D9 | Requires the Rindegastos contract |
| D10, D12 | Requires Legal |
| D13 | Requires knowing actual usage beyond what evidence shows |
| D14 | Requires naming the verifier |

## 9. Impact on the project objective

The objective was "replace Rindegastos with Odoo". With evidence:

- The core cycle is feasible on Odoo.
- **Funds and petty cash are used and are out of scope**, so a full replacement is
  not achievable with the current plan.
- History export has no tooling; until P8 passes, cancellation is unsafe.

Corrected objective for the current phase: **make the core cycle technically
viable and decide, with evidence, what happens to funds and history.** Cancellation
is not on the table yet.

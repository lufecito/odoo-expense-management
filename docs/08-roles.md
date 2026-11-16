# Roles and owners

Named on 2026-11-16 by the project owner. Verified read-only against `ipam-master`.

## 1. Who does what

| Role | Who | State in Odoo |
| --- | --- | --- |
| Data entry | Ejecutivos de Transport | No user identified yet |
| Data entry / expense subject | Área técnica | **No Odoo user** (stated by owner) |
| Verification | Hecdaly Corzo | User id 40, active, internal, **company 5 (Ipam S.A.)**; employee id 11 |
| Verification | Katherine Catalán | User id 148, active, internal, **company 5 (Ipam S.A.)**; **no employee record** |

## 2. Gaps that block execution

### G1 — Katherine Catalán has no employee record

`res.users` 148 exists but `hr.employee` has no matching record. Odoo routes expense
approval through the employee model (`expense_manager_id`, department manager,
parent). Without an employee record she cannot be an approver in the standard flow.

**Fix:** create her employee record in the pilot company. Configuration, not code.

### G2 — Verifiers belong to a different company than the pilot

Hecdaly (40) and Katherine (148) are in **company 5, Ipam S.A.**
Luis (2) and Benjamín (10) are in **company 1, Ipam Technology S.A.**

Expense record rules are company-scoped. As they stand, the verifiers cannot see
company-1 reports.

**Fix:** either run the pilot in company 5, or grant both verifiers multi-company
access in staging. Both are configuration; neither is free of consequence — the
choice decides which company the pilot represents.

### G3 — The organisational structure the process needs does not exist

Only one department exists in the whole database: `Administration` (company 1, no
manager). There is no Transport department and no technical department. 71 of 73
employees have a user; 2 do not.

Consequence: approval routing by department cannot work. Routing must use
`expense_manager_id` explicitly until the structure is built.

### G4 — The technical area cannot enter data without accounts

"El área técnica aún no tiene usuario en Odoo." Two models are possible:

| Model | How it works | Cost | Fits today |
| --- | --- | --- | --- |
| **A. Digitizer model** (default) | Transport executives register expenses *on behalf of* technical staff, who exist as employees without users | No licence | Yes — this is what the business specification already describes for Teresa and the technicians |
| **B. Self-service model** | Technical staff get Odoo accounts and register their own expenses | A user per technician | Blocked: they have no users today |

**Default adopted: A**, because it matches `docs/06-business-spec.md` and requires
no accounts. Model B is a later decision, and it changes licensing.

## 3. What this resolves

| ID | Resolution |
| --- | --- |
| D4 | Verification chain named: Hecdaly Corzo and Katherine Catalán |
| D18 | Verifiers identified; still undefined who is first stage and who is final |
| D14 | Candidates for export verification named; confirm whether both also verify the export |

## 4. What this opens

| ID | Question |
| --- | --- |
| D21 | Which company hosts the pilot: 1 (current technical users) or 5 (verifiers) |
| D22 | First stage versus final approver: which of the two verifiers holds which role |
| D23 | Technical area: digitizer model A or self-service model B |

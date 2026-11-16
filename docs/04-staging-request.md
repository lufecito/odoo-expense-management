# Staging request

**Status:** to be sent to whoever administers `ipam-master` (host
`ipam.server72c8e.oerpondemand.net`).
**Owner:** host administrator / Odoo partner.
**Blocks:** every task from T5 onward.

## Why a copy and not an empty database

The pilot validates accounting in Chile, not just screens. An empty Odoo would
lack the chart of accounts, taxes, `l10n_cl`, the installed third-party SII
modules, the 15 companies and the custom addons. Acceptance criterion P3 cannot
be evaluated there.

A staging copy also lets us test that adding a module does not break what already
runs in production.

## What is required

| # | Requirement | Why |
| --- | --- | --- |
| 1 | A separate database, restored from a recent `ipam-master` backup | Reproduces localization, companies, chart of accounts, custom addons |
| 2 | Same Odoo version (`18.0+e`) and same module set | Otherwise the test proves nothing about production |
| 3 | A database name that is clearly not production (e.g. `ipam-staging`) | Prevents wrong-target deployment |
| 4 | The addons path used in production, and permission to place a module there | We need to know where `it_informatica_inventory` lives |
| 5 | Written procedure: install, restart, verify, roll back | An undocumented deploy is not a deploy |
| 6 | Confirmation that a backup is taken before any install | Recovery path |
| 7 | Access for one administrator and two non-administrator users | X1 and X3 cannot be tested with `admin` alone |
| 8 | Explicit statement of who to contact when staging breaks | Avoids discovery by incident |

## What is explicitly not requested

- Access to production for any write operation.
- A different Odoo version.
- Real bank or card credentials in the staging copy.

## Data handling

`hr.expense` and `hr.expense.sheet` are empty, so the copy introduces no expense
history. Other modules do contain personal and financial data. If a full copy is
not acceptable, the minimum viable alternative is a copy with partner, employee
and payroll data anonymized, keeping chart of accounts, taxes and companies
intact.

## Acceptance of the request

The request is satisfied when, in staging and without touching production, we can:

1. Install a test addon and see it listed as installed.
2. Run the Odoo test suite for that addon.
3. Uninstall it and confirm the database returns to its previous state.

## Draft message

> Necesitamos un ambiente de staging para evaluar la implementación de gestión de
> gastos sobre Odoo 18, sin tocar producción.
>
> Requerimos una base separada restaurada desde un respaldo reciente de
> `ipam-master`, con la misma versión y módulos, más la ruta de addons que usan en
> producción y el procedimiento documentado para instalar un módulo, reiniciar y
> revertir.
>
> También necesitamos saber quién es el contacto responsable de ese ambiente.
>
> No solicitamos acceso de escritura a producción.

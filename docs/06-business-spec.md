# Implementación del proceso de rendiciones en Odoo 18

> **Imported business specification.** Verbatim copy of
> `Escritorio/Airlife/Reemplazo Rindegastos/Implementacion.md`, imported on
> 2026-11-16 so the project has a single reviewable source. This document is
> authoritative for process, roles, states, validations and the test plan.
> `docs/00-scope-pilot.md` governs pilot acceptance and must not contradict it.
> Known conflicts are listed in `docs/00-scope-pilot.md` §7.
>
> Kept in Spanish because it is a business document reviewed by Finance, HR and
> SAT operations. Engineering documents remain in English.

## 1. Objetivo

Reemplazar Rindegastos mediante los módulos de Gastos, Contabilidad, Pagos, Documentos y Analítica de Odoo 18 Enterprise, manteniendo trazabilidad desde la recepción del comprobante hasta el reembolso y la conciliación bancaria.

La solución debe permitir que Teresa registre y valide los gastos enviados por los técnicos, que Jefatura SAT realice una primera confirmación y que Gabriela ejecute la aprobación final antes de que Contabilidad publique, pague y concilie el movimiento.

![Flujo objetivo](./flujo_gestion_gastos_actualizado.png)

## 2. Base técnica confirmada

La consulta realizada sobre la instancia de Odoo informó la siguiente base:

- Odoo 18 Enterprise.
- Gastos mediante `hr.expense`.
- Informes de gastos mediante `hr.expense.sheet`.
- Asientos contables mediante `account.move`.
- Pagos mediante `account.payment`.
- Comprobantes mediante `ir.attachment`.
- Trazabilidad en el chatter mediante `mail.message`.
- Tareas de revisión mediante `mail.activity`.
- OCR instalado y configurado en modo automático.

Antes de desarrollar se deberán reconfirmar en una base de pruebas los nombres técnicos de campos y métodos que serán heredados. En particular, debe verificarse la firma y disponibilidad del método estándar de aprobación `action_approve_expense_sheets` en la versión exacta desplegada.

## 3. Alcance

### Incluido en la primera fase

- Alta o normalización de técnicos como empleados.
- Registro de gastos por Teresa a nombre de cada técnico.
- Carga del comprobante recibido por WhatsApp.
- Validación documental y detección de posibles duplicados.
- Consolidación semanal por técnico.
- Confirmación de Jefatura SAT.
- Aprobación final de Gabriela.
- Devolución para corrección y rechazo definitivo.
- Registro del usuario, fecha y comentario de cada decisión.
- Creación y publicación de los movimientos contables.
- Reembolso al técnico cuando corresponda.
- Conciliación bancaria.
- Reportes y filtros de seguimiento.
- Seguridad por rol y compañía.

### Fuera del alcance inicial

- Creación automática de gastos desde WhatsApp.
- Migración de rendiciones históricas ya cerradas.
- Reembolso mediante nómina.
- Aprobación de gastos fuera del área SAT.
- Automatización de anticipos o fondos por rendir hasta validar el tratamiento contable.

## 4. Flujo funcional objetivo

1. El técnico envía a Teresa por WhatsApp una foto legible del comprobante y la información mínima requerida.
2. Teresa crea un `hr.expense` a nombre del técnico.
3. Teresa registra fecha, proveedor, categoría, importe, moneda, impuestos, modalidad de pago, distribución analítica y observación.
4. Teresa adjunta el comprobante y revisa advertencias de duplicidad.
5. Al cierre semanal, Teresa crea un `hr.expense.sheet` por técnico, compañía y modalidad de pago.
6. Teresa envía el informe a Jefatura SAT.
7. Jefatura SAT confirma o devuelve el informe para corrección.
8. Si SAT confirma, Odoo registra la decisión y asigna una actividad a Gabriela.
9. Gabriela aprueba, devuelve para corrección o rechaza definitivamente.
10. La aprobación de Gabriela ejecuta la lógica estándar de aprobación de gastos y permite generar los movimientos contables.
11. Contabilidad revisa y publica los movimientos.
12. Contabilidad registra el reembolso o relaciona el gasto con el medio de pago de la empresa.
13. El pago se concilia con la cartola bancaria.
14. El informe queda finalizado y conserva toda su auditoría.

## 5. Roles y responsabilidades

| Rol | Responsabilidades | Restricciones |
| --- | --- | --- |
| Técnico | Enviar comprobante e información requerida; responder solicitudes de corrección. | No necesita usuario de Odoo en la primera fase. |
| Teresa | Crear y modificar gastos; adjuntar comprobantes; validar datos; crear informes semanales; corregir devoluciones. | No puede confirmar por SAT, aprobar, contabilizar ni pagar. |
| Jefatura SAT | Revisar informes SAT; confirmar la primera etapa; devolver para corrección; dejar comentario. | No puede ejecutar la aprobación nativa, contabilizar ni pagar. |
| Gabriela | Revisar informes confirmados por SAT; aprobar; devolver o rechazar; dejar comentario. | No puede aprobar antes de SAT; no publica ni paga salvo autorización expresa. |
| Contabilidad | Revisar y publicar asientos; registrar pagos; gestionar anticipos; conciliar movimientos. | No reemplaza las aprobaciones operativas. |
| Administrador funcional | Mantener categorías, permisos, reglas y parámetros del flujo. | No debe operar rendiciones salvo contingencia autorizada. |

### Grupos requeridos

- Digitador de gastos SAT.
- Aprobador Jefatura SAT.
- Aprobador final de gastos SAT.
- Contabilidad de gastos.
- Administrador funcional del proceso.

Las reglas deben respetar las compañías habilitadas para cada usuario y aplicar el principio de mínimo privilegio.

## 6. Datos maestros y configuración

### 6.1 Empleados

Cada técnico debe existir en Empleados, aunque no tenga usuario ni licencia de acceso.

Datos mínimos:

- Nombre completo.
- Compañía.
- Departamento o equipo técnico.
- Jefatura.
- Responsable de gastos.
- Correo laboral, si se usará recepción por correo.
- Cuenta bancaria, si Odoo realizará el reembolso por transferencia.
- Estado activo.

Teresa debe poder crear gastos para los técnicos autorizados, sin obtener acceso general a empleados fuera del alcance SAT.

### 6.2 Categorías de gasto

Categorías iniciales sugeridas:

- Combustible.
- Peajes y estacionamiento.
- Alimentación.
- Alojamiento.
- Transporte.
- Materiales menores.
- Herramientas.
- Otros gastos de terreno.

Cada categoría debe definir:

- Cuenta contable de gasto.
- Impuesto de compra permitido.
- Código o referencia interna.
- Distribución analítica predeterminada, cuando corresponda.
- Compañías en las que puede utilizarse.
- Reglas documentales o límites establecidos por la política de gastos.

Teresa no debería seleccionar manualmente cuentas contables salvo una excepción autorizada.

### 6.3 Contabilidad

- Diario de gastos por compañía.
- Cuenta por pagar a empleados.
- Diarios bancarios.
- Métodos de pago.
- Cuenta pendiente para gastos pagados por la empresa.
- Configuración de impuestos.
- Fechas de bloqueo contable.
- Cuentas de anticipos por empleado, si se utilizan fondos por rendir.

### 6.4 Analítica

- Plan analítico obligatorio.
- Centro de costo SAT.
- Proyecto, obra u orden de trabajo cuando corresponda.
- Distribución analítica que sume 100 %.

## 7. Modelo de datos

### 7.1 Gasto: `hr.expense`

Campos estándar informados por la consulta a Odoo:

- `name`
- `date`
- `employee_id`
- `company_id`
- `currency_id`
- `vendor_id`
- `product_id`
- `quantity`
- `total_amount_currency`
- `tax_ids`
- `account_id`
- `analytic_distribution`
- `payment_mode`
- `description`
- `attachment_ids`
- `duplicate_expense_ids`
- `same_receipt_expense_ids`
- `sheet_id`
- `state`

Campos personalizados propuestos:

| Campo | Tipo sugerido | Uso |
| --- | --- | --- |
| `x_receipt_number` | Texto | Folio del comprobante. |
| `x_receipt_vat` | Texto | RUT u otro identificador tributario del emisor. |
| `x_source_channel` | Selección | `whatsapp_manual`, `email`, `api` u otro canal. |
| `x_source_message_id` | Texto indexado | Identificador externo para idempotencia en una integración futura. |
| `x_expense_week` | Texto o fecha | Semana operativa usada para consolidación. |

### 7.2 Informe: `hr.expense.sheet`

Campos estándar informados por la consulta a Odoo:

- `name`
- `employee_id`
- `company_id`
- `expense_line_ids`
- `user_id`
- `approval_state`
- `approval_date`
- `state`
- `journal_id`
- `account_move_ids`
- `payment_state`
- `payment_method_line_id`
- `accounting_date`
- `total_amount`

Campos personalizados propuestos:

| Campo | Tipo sugerido | Uso |
| --- | --- | --- |
| `x_approval_stage` | Selección | Etapa funcional vigente. |
| `x_sat_status` | Selección | Estado de la revisión SAT. |
| `x_sat_approved_by` | Usuario | Responsable de la confirmación SAT. |
| `x_sat_approved_at` | Fecha y hora | Momento de la confirmación SAT. |
| `x_sat_comment` | Texto largo | Comentario de Jefatura SAT. |
| `x_final_status` | Selección | Estado de la revisión de Gabriela. |
| `x_final_approved_by` | Usuario | Responsable de la aprobación final. |
| `x_final_approved_at` | Fecha y hora | Momento de la aprobación final. |
| `x_final_comment` | Texto largo | Comentario de Gabriela. |
| `x_return_reason` | Texto largo | Motivo de la devolución o rechazo. |
| `x_returned_by` | Usuario | Usuario que devolvió o rechazó. |
| `x_returned_at` | Fecha y hora | Momento de la devolución o rechazo. |

Los tipos exactos, selecciones, índices y restricciones deben implementarse en un módulo y validarse en la base de pruebas.

## 8. Estados y transiciones

### 8.1 Estados estándar informados

- `draft`
- `submit`
- `approve`
- `post`
- `done`
- `cancel`

### 8.2 Etapas funcionales personalizadas

- `draft`: preparación por Teresa.
- `submitted_sat`: enviado a Jefatura SAT.
- `returned_sat`: devuelto por Jefatura SAT.
- `submitted_final`: confirmado por SAT y enviado a Gabriela.
- `returned_final`: devuelto por Gabriela para corrección.
- `approved`: aprobado finalmente.
- `refused`: rechazado de forma definitiva.

### 8.3 Matriz de transición

| Actor | Acción | Estado inicial | Estado final | Efectos obligatorios |
| --- | --- | --- | --- | --- |
| Teresa | Enviar a SAT | `draft` | `submitted_sat` | Validar datos y comprobantes; crear actividad SAT. |
| Jefatura SAT | Confirmar | `submitted_sat` | `submitted_final` | Registrar usuario, fecha y comentario; cerrar actividad SAT; crear actividad para Gabriela. |
| Jefatura SAT | Devolver | `submitted_sat` | `returned_sat` | Exigir motivo; registrar auditoría; notificar a Teresa. |
| Teresa | Corregir y reenviar | `returned_sat` | `submitted_sat` | Registrar cambios y nueva actividad SAT. |
| Gabriela | Aprobar | `submitted_final` | `approved` | Registrar auditoría; ejecutar la aprobación estándar. |
| Gabriela | Devolver | `submitted_final` | `returned_final` | Exigir motivo; notificar a Teresa. |
| Teresa | Corregir y reenviar | `returned_final` | `submitted_sat` | Reiniciar ambas revisiones para que SAT confirme los cambios. |
| Gabriela | Rechazar | `submitted_final` | `refused` | Exigir motivo y bloquear la continuación. |

Un informe devuelto por Gabriela debe regresar a SAT después de la corrección, porque el contenido que SAT confirmó pudo haber cambiado.

## 9. Diseño de la doble aprobación

La aprobación estándar de Odoo contempla una aprobación gerencial principal. La primera confirmación de Jefatura SAT se implementará como una etapa adicional previa y no como la aprobación contable estándar.

### Acciones requeridas

- `Enviar a Jefatura SAT`, visible para Teresa en borrador o después de una devolución.
- `Confirmar SAT`, visible únicamente para el grupo Jefatura SAT.
- `Devolver a Teresa`, disponible para SAT y Gabriela con motivo obligatorio.
- `Aprobar gasto`, visible únicamente para Gabriela después de la confirmación SAT.
- `Rechazar definitivamente`, visible únicamente para Gabriela con motivo obligatorio.

### Reglas técnicas

- Gabriela no puede aprobar si `x_sat_status` no está confirmado.
- Jefatura SAT no puede invocar el método de aprobación estándar.
- Teresa no puede modificar un informe mientras esté en revisión, salvo que sea devuelto.
- La aprobación final debe invocar la lógica estándar de Odoo, informada como `action_approve_expense_sheets`.
- Cada acción debe registrar usuario, fecha, comentario y transición en campos estructurados y en el chatter.
- Las actividades anteriores deben cerrarse antes de crear la siguiente.
- Los botones y restricciones críticas deben implementarse en servidor, no solamente ocultarse en las vistas.

Studio puede utilizarse para prototipar campos, vistas y filtros. Para seguridad, transiciones y validaciones críticas se recomienda un módulo personalizado versionado.

## 10. Operación diaria de Teresa

### Información solicitada al técnico

- Foto o PDF legible.
- Fecha.
- Monto.
- Motivo.
- Obra, cliente, OT o proyecto.
- Indicación de quién pagó.
- Folio y proveedor cuando sean identificables.

### Registro del gasto

Teresa debe completar o verificar:

- Técnico en `employee_id`.
- Fecha del gasto.
- Proveedor.
- Categoría.
- Importe y moneda.
- Impuestos.
- Pagado por empleado o por empresa.
- Compañía.
- Distribución analítica.
- Proyecto, cliente, obra u orden de trabajo.
- Folio del comprobante.
- Foto o PDF.
- Observación.

El OCR puede proponer datos, pero Teresa sigue siendo responsable de verificarlos antes del envío.

## 11. Rendición semanal por técnico

Cada informe debe agrupar gastos de un solo técnico, una sola compañía y una sola modalidad de pago.

Convención recomendada:

`Rendición semanal – Nombre del técnico – AAAA-SNN`

Ejemplo:

`Rendición semanal – Juan Pérez – 2026-S34`

La vista `Gastos → Rendiciones semanales` debe mostrar:

- Semana.
- Técnico.
- Compañía.
- Cantidad de comprobantes.
- Total rendido.
- Total pagado por el empleado.
- Total pagado por la empresa.
- Etapa de aprobación.
- Responsable actual.
- Pendiente de pago.
- Fecha de pago.

Filtros guardados:

- Semana actual.
- Semana anterior.
- Por técnico.
- Por compañía.
- Pendiente de Teresa.
- Pendiente de Jefatura SAT.
- Pendiente de Gabriela.
- Pendiente de contabilizar.
- Pendiente de pagar.
- Devuelto para corrección.
- Sin comprobante.

La generación automática semanal es opcional. El piloto puede comenzar con creación manual para validar reglas de agrupación y cierre.

## 12. Comprobantes, WhatsApp y OCR

### Primera fase: operación manual

- El técnico envía la foto por WhatsApp.
- Teresa descarga el archivo.
- Teresa crea o abre el gasto.
- Teresa adjunta el archivo al registro.
- Odoo conserva el comprobante como `ir.attachment`.

WhatsApp será solamente el canal de recepción. El registro oficial y la auditoría estarán en Odoo.

### Segunda fase opcional: WhatsApp Business API

Una integración automática necesitaría:

- Webhook externo.
- Validación de firma.
- Descarga segura del archivo.
- Relación teléfono–empleado.
- Creación del gasto mediante la API soportada por la instalación.
- Creación de `ir.attachment`.
- Idempotencia mediante el ID del mensaje.
- Registro y reintento de errores.
- Manejo seguro de credenciales y datos personales.

### Correo

El alias de gastos puede evaluarse cuando el remitente coincida con el correo laboral autenticado del empleado. No debe asumirse como reemplazo de WhatsApp sin probar la experiencia del usuario.

### OCR

El OCR figura instalado y configurado en modo automático. Antes de producción se deben validar:

- Créditos disponibles.
- Precisión con boletas y facturas chilenas.
- Lectura de RUT, fecha, folio, moneda, neto, IVA y total.
- Comportamiento con imágenes borrosas o duplicadas.
- Necesidad de corrección manual.

## 13. Validaciones de negocio

- El gasto debe tener al menos un comprobante.
- El monto debe ser mayor que cero.
- La fecha no puede ser futura.
- Empleado y compañía deben ser coherentes.
- La categoría debe estar autorizada para la compañía.
- El impuesto debe estar permitido para la compañía y categoría.
- La distribución analítica debe estar completa y sumar 100 %.
- La modalidad de pago debe estar informada.
- Debe registrarse folio cuando el documento lo incluya.
- Debe advertirse una coincidencia por empleado, categoría, fecha y monto.
- Debe advertirse la reutilización del checksum del archivo.
- Un informe no puede mezclar empleados.
- Un informe no puede mezclar compañías.
- Un informe no puede mezclar modalidades de pago.
- Gabriela no puede aprobar sin confirmación SAT vigente.
- Teresa no puede aprobar, contabilizar ni pagar.
- SAT no puede ejecutar la aprobación estándar.
- Un informe publicado no puede modificarse sin una reversa autorizada.
- Toda devolución o rechazo requiere motivo.

La detección de duplicados debe comenzar como advertencia durante el piloto. Su eventual conversión en bloqueo dependerá de la tasa de falsos positivos.

## 14. Contabilización, reembolso y conciliación

### Pagó el técnico

- Registrar como pagado por el empleado.
- Después de la aprobación y contabilización, reconocer el monto por reembolsar.
- Contabilidad registra el pago individual o agrupado.
- El pago se concilia con la cartola bancaria.

### Pagó la empresa

- Registrar como pagado por la empresa.
- Relacionar el gasto con banco, caja, tarjeta o cuenta pendiente correspondiente.
- Conciliarlo contra el movimiento real del medio de pago.

### Anticipo o fondo por rendir

- Diseñar una cuenta de anticipos por empleado.
- Registrar la entrega del anticipo.
- Compensar la rendición contra el anticipo.
- Pagar o cobrar la diferencia, según corresponda.
- Conciliar ambos movimientos.

El tratamiento de anticipos debe ser aprobado por Contabilidad antes de desarrollarse, porque puede requerir configuración o personalización adicional.

## 15. Seguridad y auditoría

- Aplicar reglas multiempresa a gastos, informes, adjuntos, actividades y asientos relacionados.
- Impedir que Teresa acceda a informes fuera de los técnicos autorizados cuando la política lo requiera.
- Separar aprobación operativa, contabilización y pago.
- Registrar cada transición en el chatter.
- Conservar campos estructurados para consultar responsable y fecha sin depender del texto del chatter.
- Restringir el acceso a comprobantes por contener información tributaria o personal.
- No almacenar tokens ni credenciales de WhatsApp en campos visibles.
- Definir una política de conservación de comprobantes.

## 16. Personalizaciones requeridas

1. Grupos y reglas de acceso para Teresa, SAT, Gabriela y Contabilidad.
2. Campos adicionales del gasto y del informe.
3. Etapas y botones de doble aprobación.
4. Restricciones de transición ejecutadas en servidor.
5. Actividades automáticas para el responsable de cada etapa.
6. Vista y filtros de rendiciones semanales.
7. Registro estructurado de devoluciones y rechazos.
8. Validación de comprobante, distribución analítica y duplicidad.
9. Reglas multiempresa.
10. Generación semanal automática, solo si el piloto la justifica.
11. Integración con WhatsApp Business API, únicamente como fase posterior.

## 17. Plan de implementación

### Fase 0: decisiones y descubrimiento

- Resolver preguntas abiertas.
- Confirmar compañías, técnicos, categorías, impuestos y centros de costo.
- Validar modelos, campos y métodos en una copia de pruebas.
- Aprobar la política de gastos y de comprobantes.

### Fase 1: configuración base

- Normalizar empleados.
- Configurar categorías, cuentas, impuestos y analítica.
- Configurar diarios y métodos de pago.
- Crear grupos y permisos iniciales.

### Fase 2: prototipo

- Incorporar campos de control.
- Construir la doble aprobación.
- Crear la vista semanal y sus filtros.
- Configurar actividades y auditoría.
- Probar con una compañía, Teresa, Jefatura SAT, Gabriela y entre tres y cinco técnicos.

### Fase 3: pruebas

- Ejecutar pruebas funcionales, de seguridad y contables.
- Validar OCR con comprobantes chilenos.
- Probar reembolsos y conciliación.
- Corregir reglas y permisos.

### Fase 4: piloto en paralelo

- Operar durante al menos dos cierres semanales en paralelo con Rindegastos.
- Comparar cantidad de gastos, totales, rechazos, tiempos y pagos.
- Documentar diferencias y ajustar el proceso.

### Fase 5: puesta en producción

- Capacitar a Teresa, SAT, Gabriela y Contabilidad.
- Definir fecha de corte.
- Migrar solamente rendiciones abiertas si se aprueba.
- Monitorear el primer cierre y la primera conciliación.

### Fase 6: optimización

- Evaluar generación semanal automática.
- Evaluar WhatsApp Business API según volumen y ahorro esperado.
- Ajustar OCR, tableros y SLA.

## 18. Plan mínimo de pruebas

- Gasto válido pagado por el técnico.
- Gasto válido pagado por la empresa.
- Gasto con anticipo.
- Comprobante faltante.
- Fecha futura.
- Monto cero o negativo.
- Impuesto no autorizado.
- Distribución analítica incompleta.
- Gasto duplicado por datos.
- Comprobante duplicado por checksum.
- Informe con gastos de dos técnicos.
- Informe con dos compañías.
- Informe con dos modalidades de pago.
- Devolución de SAT y reenvío.
- Devolución de Gabriela y nueva revisión de SAT.
- Rechazo definitivo de Gabriela.
- Intento de aprobación de Gabriela sin confirmación SAT.
- Intento de aprobación por Teresa o SAT.
- Publicación contable y reversa autorizada.
- Pago individual y pago agrupado.
- Conciliación completa y parcial.
- Acceso de un usuario a una compañía no autorizada.
- Auditoría completa de usuario, fecha y comentario.

## 19. Criterios de aceptación

- Teresa puede registrar gastos únicamente para técnicos autorizados.
- Cada gasto conserva su comprobante.
- El sistema advierte posibles duplicados.
- Puede generarse un informe semanal por técnico.
- Jefatura SAT puede confirmar o devolver.
- Gabriela no puede aprobar antes de la confirmación SAT.
- SAT no puede ejecutar la aprobación final.
- Cada decisión conserva usuario, fecha y comentario.
- Una corrección posterior a Gabriela reinicia la revisión de SAT.
- La aprobación final ejecuta la lógica estándar de Odoo.
- Contabilidad puede revisar y publicar el asiento.
- Puede registrarse el reembolso al técnico.
- El pago puede conciliarse con una cartola.
- Los usuarios no acceden a compañías no autorizadas.
- El flujo completo puede auditarse mediante chatter y campos estructurados.
- El resultado del piloto coincide con Rindegastos en cantidad de documentos y totales, salvo diferencias justificadas.

## 20. Preguntas abiertas

- ¿Qué personas integran Jefatura SAT y quién las reemplaza durante ausencias?
- ¿Cuál es el día y la hora de cierre semanal?
- ¿Qué diferencia operativa tendrá una devolución respecto de un rechazo definitivo?
- ¿Qué compañías y técnicos participarán inicialmente?
- ¿Qué categorías y límites están autorizados?
- ¿Qué impuestos puede seleccionar Teresa?
- ¿Qué centro de costo, proyecto u OT corresponde a cada gasto?
- ¿Los pagos se realizarán individualmente o agrupados?
- ¿Existen anticipos o fondos por rendir y cómo se contabilizan actualmente?
- ¿Se migrarán rendiciones abiertas desde Rindegastos?
- ¿Cuántos créditos OCR existen y cuál es su costo operativo?
- ¿WhatsApp seguirá siendo manual o existe una fecha objetivo para automatizarlo?
- ¿Cuál es el plazo legal e interno de conservación de comprobantes?
- ¿Qué SLA tendrá Jefatura SAT, Gabriela y Contabilidad?
- ¿Quién autoriza reversas de informes ya publicados?
- ¿Qué indicadores se usarán para aprobar el abandono definitivo de Rindegastos?

## 21. Decisión recomendada

El reemplazo es viable con Odoo 18 Enterprise. La primera entrega debe concentrarse en el registro manual por Teresa, la consolidación semanal, la doble aprobación y el ciclo contable completo. La integración automática con WhatsApp debe evaluarse después de estabilizar el proceso y medir el volumen real.

La doble aprobación y las reglas de seguridad no deben depender exclusivamente de Studio. Se recomienda un módulo personalizado para las transiciones y restricciones críticas, utilizando Studio únicamente para prototipos o ajustes visuales de bajo riesgo.

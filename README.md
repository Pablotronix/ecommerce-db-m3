# ecommerce-db-m3

**Implementación de la base de datos relacional para un e‑commerce**  
Incluye diagrama ER, `schema.sql`, `seed.sql`, `queries.sql` y una transacción demostrativa. Orientado a **PostgreSQL**.

---

## Descripción
Proyecto del **Módulo 3** del bootcamp: diseño y construcción de la base de datos relacional para una tienda online. El repositorio contiene el modelo conceptual (ER), el DDL para crear las tablas con sus restricciones, datos de prueba para validar consultas y ejemplos de consultas y transacciones que responden KPIs típicos de e‑commerce.

---

## Estructura del repositorio
**Archivos y carpetas principales**

| Ruta | Contenido |
|---|---|
| **/sql/schema.sql** | DDL: creación de tablas, PK, FK, CHECK, índices. |
| **/sql/seed.sql** | Datos de prueba coherentes para ejecutar consultas. |
| **/sql/queries.sql** | Consultas SQL (búsquedas, agregaciones, top N, transacción). |
| **/docs/er.png** | Diagrama ER exportado (Crow’s Foot). |
| **/evidence/** | CSVs y capturas que evidencian resultados de consultas. |
| **README.md** | Documentación y pasos para reproducir el proyecto. |

---

## Requisitos técnicos y ejecución
**Requisitos**  
- PostgreSQL 12+  
- `psql` cliente (opcional)  
- Herramienta para ERD (Draw.io, Lucidchart)

**Pasos rápidos**
1. Crear la base de datos:
   ```bash
   createdb ecommerce_m3

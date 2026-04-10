# Ejemplo base de datos contactos desde cero
Este repositorio contiene el diseño lógico y físico de una base de datos relacional para la gestión de contactos, optimizada para aplicaciones móviles y sistemas empresariales, enfocándose en las mejores prácticas de normalización y estándares de la industria.

---

## Naming Conventions

Para asegurar la consistencia y profesionalismo del código, se han aplicado las siguientes reglas de nomenclatura:

1.  **Tablas:** Uso de `Pascal_Snake_Case` (Primera letra de cada palabra en mayúscula) y en singular. Ejemplo: `Label_Type`.
2.  **Columnas:** Uso de `snake_case` en minúsculas. Ejemplo: `phone_number`.
3.  **Idioma:** Inglés técnico para la estructura de objetos (Tablas y Columnas).
4.  **Primary Keys (PK):** Nombradas simplemente como `id`.
5.  **Foreign Keys (FK):** Nombradas como `tabla_relacionada_id` (ejemplo: `contact_id`).

## Diagrama ER
![preview](/Support-Files/MyContacs.png)



## Estructura de la Base de Datos (DDL)
[Script DDL](/Support-Files/MyContacts.sql)

## Inserción de Datos de Prueba (DML)
[Script DML](/Support-Files/MyContacts.sql)

## Notas de Arquitectura

* **Idempotencia:** El uso de `IF NOT EXISTS` permite ejecutar el script múltiples veces garantizando la integridad de la estructura sin generar errores por duplicidad.
* **Normalización:** El diseño utiliza tablas maestras (`Label_Type`, `Country_Code`) para asegurar la consistencia lógica y facilitar el mantenimiento global de los datos.
* **Contextualización:** Se incluyen configuraciones específicas para el entorno local, como el prefijo telefónico internacional y dominios de correo institucionales de Guatemala.
* **Integridad:** Se definen restricciones de llave foránea con políticas de eliminación (`ON DELETE CASCADE`) para prevenir la existencia de registros huérfanos.


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

## Análisis del Modelo Relacional

### Label_Type
Es para los tipos de etiquetas. Sirve para categorizar si una descripción pertenece a un teléfono, a un correo o a ambos.
*Justificación:* Implementar esto evita errores de lógica en la interfaz (como que un usuario intente asignar la etiqueta "WhatsApp" a un correo electrónico).

### Country_Code
Centraliza los prefijos telefónicos internacionales (ej. +502, +52).
*Justificación:* Evita que el programador tenga que validar manualmente cada código de país y permite estandarizar las búsquedas internacionales sin repetir el nombre del país en cada teléfono.

### Label
Guarda las descripciones de uso, como "Personal", "Trabajo" o "Educational".
*Justificación:* Al ser una tabla independiente, el sistema es escalable. Si el usuario necesita una nueva categoría, solo se inserta una fila en la tabla sin tocar el código de la aplicación.

### Contact
Es el corazón del sistema. Almacena los datos biográficos de la persona.
*Justificación:* Dividimos los nombres y apellidos en columnas separadas (atomicidad) para que el sistema pueda ordenar y filtrar de forma eficiente (por ejemplo, buscar a todos los que tengan el apellido "Pérez").

### Phone
Gestiona la relación **Uno a Muchos (1:N)** entre el contacto y sus números.
*Justificación:* Permite que una persona tenga varios números (casa, móvil, oficina) sin crear columnas vacías en la tabla principal, optimizando el espacio en disco.

### Email
Funciona igual que la tabla de teléfonos, pero para direcciones de correo electrónico.
*Justificación:* Mantiene el diseño modular. Al separar los correos, se facilita la validación de formatos (ej. que contengan un `@`) sin interferir con el resto de la información del contacto.


## Estructura de la Base de Datos (DDL)
[Script DDL](/Support-Files/MyContacts.sql)

## Inserción de Datos de Prueba (DML)
[Script DML](/Support-Files/MyContacts.sql)

## Notas de Arquitectura

* **Idempotencia:** El uso de `IF NOT EXISTS` permite ejecutar el script múltiples veces garantizando la integridad de la estructura sin generar errores por duplicidad.
* **Normalización:** El diseño utiliza tablas maestras (`Label_Type`, `Country_Code`) para asegurar la consistencia lógica y facilitar el mantenimiento global de los datos.
* **Contextualización:** Se incluyen configuraciones específicas para el entorno local, como el prefijo telefónico internacional y dominios de correo institucionales de Guatemala.
* **Integridad:** Se definen restricciones de llave foránea con políticas de eliminación (`ON DELETE CASCADE`) para prevenir la existencia de registros huérfanos.


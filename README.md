# Ejemplo base de datos contactos desde cero

En esta guía se detallan los pasos a seguir para crear el diseño lógico y físico de una base de datos relacional para la gestión de contactos, enfocándose en las mejores prácticas de normalización y estándares de la industria.

## Naming Conventions

Para asegurar la consistencia y profesionalismo del código, se han aplicado las siguientes reglas de nomenclatura:

1.  **Schemas:** Uso de PascalCase con sufijo opcional _Db. Ejemplo: `MyContacts_Db`.
2.  **Tablas:** Uso de `Pascal_Snake_Case` (Primera letra de cada palabra en mayúscula) y en singular. Ejemplo: `Label_Type`.
3.  **Columnas:** Uso de `snake_case` en minúsculas. Ejemplo: `phone_number`.
4.  **Idioma:** Inglés técnico para la estructura de objetos (Tablas y Columnas).
5.  **Primary Keys (PK):** Nombradas simplemente como `id`.
6.  **Foreign Keys (FK):** Nombradas como `tabla_relacionada_id` (ejemplo: `contact_id`).

## Diagrama ER
![preview](/Support-Files/MyContacs.png)

## Análisis del Modelo Relacional

### Label_Type
Es para los tipos de etiquetas. Sirve para categorizar si una descripción pertenece a un teléfono, a un correo o a ambos.

**Justificación:** Implementar esto evita errores de lógica en la interfaz (como que un usuario intente asignar la etiqueta "WhatsApp" a un correo electrónico).

### Country_Code
Centraliza los prefijos telefónicos internacionales (ej. +502, +52).

**Justificación:** Evita que el programador tenga que validar manualmente cada código de país y permite estandarizar las búsquedas internacionales sin repetir el nombre del país en cada teléfono.

### Label
Guarda las descripciones de uso, como "Personal", "Trabajo" o "Educational".

**Justificación:** Al ser una tabla independiente, el sistema es escalable. Si el usuario necesita una nueva categoría, solo se inserta una fila en la tabla sin tocar el código de la aplicación.

### Contact
Es el corazón del sistema. Almacena los datos biográficos de la persona.

**Justificación:** Dividimos los nombres y apellidos en columnas separadas (atomicidad) para que el sistema pueda ordenar y filtrar de forma eficiente (por ejemplo, buscar a todos los que tengan el apellido "Pérez").

### Phone
Gestiona la relación **Uno a Muchos (1:N)** entre el contacto y sus números.

**Justificación:** Permite que una persona tenga varios números (casa, móvil, oficina) sin crear columnas vacías en la tabla principal, optimizando el espacio en disco.

### Email
Funciona igual que la tabla de teléfonos, pero para direcciones de correo electrónico.

**Justificación:** Mantiene el diseño modular. Al separar los correos, se facilita la validación de formatos (ej. que contengan un `@`) sin interferir con el resto de la información del contacto.

## Estructura de la Base de Datos (DDL)
``` sql
/**** Script de Estructura (DDL) *****/

DROP SCHEMA IF EXISTS MyContacts_Db;

/**** Script de Estructura (DDL) *****/

-- Crea el esquema si no existe
CREATE SCHEMA IF NOT EXISTS MyContacts_Db;
USE MyContacts_Db;

-- Tabla de códigos de área para Países (Catálogo)
CREATE TABLE IF NOT EXISTS Country_Code (
    id INT AUTO_INCREMENT PRIMARY KEY,
    prefix VARCHAR(10) NOT NULL,
    country_name VARCHAR(100) NOT NULL
);

-- Tabla de Tipo de Etiqueta (Maestro)
CREATE TABLE IF NOT EXISTS Label_Type (
    id INT AUTO_INCREMENT PRIMARY KEY,
    type_name VARCHAR(20) NOT NULL -- 'PHONE', 'EMAIL', 'BOTH'
);

-- Tabla para guardar las Etiquetas (Catálogo)
CREATE TABLE IF NOT EXISTS Label (
    id INT AUTO_INCREMENT PRIMARY KEY,
    label_name VARCHAR(45) NOT NULL,
    label_type_id INT NOT NULL,
    CONSTRAINT fk_label_type FOREIGN KEY (label_type_id) REFERENCES Label_Type(id)
);

-- Tabla de Contactos
CREATE TABLE IF NOT EXISTS Contact (
    id INT AUTO_INCREMENT PRIMARY KEY,
    picture_url VARCHAR(45),
    first_name VARCHAR(45) NOT NULL,
    middle_name VARCHAR(45),
    last_name VARCHAR(45),
    maternal_last_name VARCHAR(45),
    nickname VARCHAR(45),
    company_name VARCHAR(100),
    birth_date DATE,
    notes MEDIUMTEXT
);

-- Tabla de Teléfonos
CREATE TABLE IF NOT EXISTS phone (
    id INT AUTO_INCREMENT PRIMARY KEY,
    phone_number VARCHAR(45) NOT NULL,
    contact_id INT NOT NULL,
    label_id INT NOT NULL, 
    country_code_id INT NOT NULL,
    CONSTRAINT fk_phone_contact FOREIGN KEY (contact_id) REFERENCES Contact(id) ON DELETE CASCADE,
    CONSTRAINT fk_phone_label FOREIGN KEY (label_id) REFERENCES Label(id),
    CONSTRAINT fk_phone_country FOREIGN KEY (country_code_id) REFERENCES Country_Code(id)
);

-- Tabla de Correos
CREATE TABLE IF NOT EXISTS email (
    id INT AUTO_INCREMENT PRIMARY KEY,
    email_address VARCHAR(255) NOT NULL,
    contact_id INT NOT NULL,
    label_id INT NOT NULL,
    CONSTRAINT fk_email_contact FOREIGN KEY (contact_id) REFERENCES Contact(id) ON DELETE CASCADE,
    CONSTRAINT fk_email_label FOREIGN KEY (label_id) REFERENCES Label(id)
);

```

## Inserción de Datos de Prueba (DML)
``` sql
/**** Script de Datos (DML) *****/

USE MyContacts_Db;

-- Inserts para Country_Code (Catálogo)
INSERT INTO Country_Code (prefix, country_name) VALUES ('+502', 'Guatemala');
INSERT INTO Country_Code (prefix, country_name) VALUES ('+503', 'El Salvador');
INSERT INTO Country_Code (prefix, country_name) VALUES ('+1', 'USA');
INSERT INTO Country_Code (prefix, country_name) VALUES ('+52', 'Mexico');
INSERT INTO Country_Code (prefix, country_name) VALUES ('+34', 'España'); 

-- Inserts para los tipos
INSERT INTO Label_Type (type_name) VALUES ('PHONE');
INSERT INTO Label_Type (type_name) VALUES ('EMAIL');
INSERT INTO Label_Type (type_name) VALUES ('BOTH');

-- Inserts para Label (Catálogo)
INSERT INTO Label (label_name, label_type_id) VALUES ('Mobile', 1);     -- PHONE
INSERT INTO Label (label_name, label_type_id) VALUES ('WhatsApp', 1);   -- PHONE
INSERT INTO Label (label_name, label_type_id) VALUES ('Work', 3);       -- BOTH
INSERT INTO Label (label_name, label_type_id) VALUES ('Personal', 3);   -- BOTH
INSERT INTO Label (label_name, label_type_id) VALUES ('Educational', 2);      -- EMAIL

-- Inserts para Contact
INSERT INTO Contact (first_name, last_name, maternal_last_name, nickname, company_name, birth_date) 
VALUES ('Mario', 'Pérez', 'García', 'Mayito', 'EEGSA', '1990-05-15');

INSERT INTO Contact (first_name, middle_name, last_name, nickname, company_name, birth_date) 
VALUES ('Ana', 'Lucía', 'Gonzalez', 'Analú', 'Banco Industrial', '1995-08-22');

INSERT INTO Contact (first_name, last_name, maternal_last_name, nickname) 
VALUES ('Carlos', 'Mendoza', 'Ruiz', 'Charly');

INSERT INTO Contact (first_name, middle_name, last_name, company_name) 
VALUES ('Sofía', 'Isabel', 'Ramírez', 'Universidad Mariano Galvez'); 

INSERT INTO Contact (first_name, last_name, company_name) 
VALUES ('Roberto', 'Gómez', 'Universidad Mariano Galvez'); 

-- Inserts para phone
INSERT INTO phone (phone_number, contact_id, label_id, country_code_id) VALUES ('55551234', 1, 1, 1);
INSERT INTO phone (phone_number, contact_id, label_id, country_code_id) VALUES ('22334455', 1, 2, 1);
INSERT INTO phone (phone_number, contact_id, label_id, country_code_id) VALUES ('78904567', 2, 5, 1);
INSERT INTO phone (phone_number, contact_id, label_id, country_code_id) VALUES ('3015550101', 3, 1, 3);
INSERT INTO phone (phone_number, contact_id, label_id, country_code_id) VALUES ('912345678', 4, 3, 5);

-- Inserts para email 
INSERT INTO email (email_address, contact_id, label_id) VALUES ('mario.perez@eegsa.com', 1, 2);
INSERT INTO email (email_address, contact_id, label_id) VALUES ('mayito90@gmail.com', 1, 4);
INSERT INTO email (email_address, contact_id, label_id) VALUES ('analucia@bi.com.gt', 2, 2);
INSERT INTO email (email_address, contact_id, label_id) VALUES ('carlos_mendoza@outlook.com', 3, 4);
INSERT INTO email (email_address, contact_id, label_id) VALUES ('sofia.ramirez@miumg.edu.gt', 4, 4); 
```

## Notas de Arquitectura

* **Idempotencia:** El uso de `IF NOT EXISTS` permite ejecutar el script múltiples veces garantizando la integridad de la estructura sin generar errores por duplicidad.
* **Normalización:** El diseño utiliza tablas maestras (`Label_Type`, `Country_Code`) para asegurar la consistencia lógica y facilitar el mantenimiento global de los datos.
* **Contextualización:** Se incluyen configuraciones específicas para el entorno local, como el prefijo telefónico internacional y dominios de correo institucionales de Guatemala.
* **Integridad:** Se definen restricciones de llave foránea con políticas de eliminación (`ON DELETE CASCADE`) para prevenir la existencia de registros huérfanos.

## Ejemplos de Consultas

Aquí tenemos varias consultas SQL de ejemplo para interactuar con la base de datos de contactos. A continuación, se explica cada una con su código correspondiente:

### 1. Obtener el nombre completo y el apodo de todos los contactos
Esta consulta concatena todos los componentes del nombre (primer nombre, segundo nombre, apellido paterno y materno) de cada contacto, manejando valores NULL para evitar resultados vacíos.
```sql
SELECT 
    CONCAT_WS(' ', first_name, middle_name, last_name, maternal_last_name) AS full_name, 
    nickname 
FROM Contact;
```

### 2. Obtener contactos que trabajan en la 'Universidad Mariano Gálvez'
Filtra los contactos por empresa una específica, en este caso la UMG
```sql
SELECT first_name, last_name, company_name 
FROM Contact 
WHERE company_name = 'Universidad Mariano Gálvez';
```

### 3. Obtener nombres, correos y etiquetas de correos
Une las tablas Contact, Email y Label para mostrar información completa de correos electrónicos. Los JOINs permiten combinar datos de múltiples tablas basándose en una condición de relación, y aquí se usan INNER JOINs para obtener solo los registros con correspondencia.
```sql
SELECT 
    C.first_name, 
    E.email_address, 
    L.label_name
FROM Contact C
INNER JOIN Email E ON C.id = E.contact_id
INNER JOIN Label L ON E.label_id = L.id;
```

### 4. Obtener nombres, prefijos, teléfonos y etiquetas para Guatemala
Filtra teléfonos de Guatemala uniendo varias tablas.
```sql
SELECT 
    C.first_name, 
    CC.prefix, 
    P.phone_number, 
    L.label_name
FROM Contact C
JOIN Phone P ON C.id = P.contact_id
JOIN Country_Code CC ON P.country_code_id = CC.id
JOIN Label L ON P.label_id = L.id
WHERE CC.country_name = 'Guatemala';
```

### 5. Contar contactos por empresa
Agrupa y cuenta contactos por empresa, excluyendo NULL.
```sql
SELECT company_name, COUNT(*) AS total_contacts
FROM Contact
GROUP BY company_name
HAVING company_name IS NOT NULL;
```

### 6. Listar empresas únicas
Muestra empresas distintas donde trabajan los contactos.
```sql
SELECT DISTINCT company_name 
FROM Contact 
WHERE company_name IS NOT NULL;
```

### 7. Buscar contactos por iniciales del nombre
Filtra nombres que empiecen con 'M' o 'Ca'.
```sql
SELECT first_name, last_name 
FROM Contact 
WHERE first_name LIKE 'M%' or first_name LIKE 'Ca%';
```

### 8. Buscar correos institucionales de la UMG
Filtra correos que contengan el dominio de la universidad.
```sql
SELECT email_address 
FROM Email 
WHERE email_address LIKE '%@miumg.edu.gt';
```

### 9. Contactos sin fecha de cumpleaños
Muestra contactos que no tienen fecha de nacimiento registrada.
```sql
SELECT first_name, last_name 
FROM Contact 
WHERE birth_date IS NULL;
```

### 10. Los 3 contactos más jóvenes
Ordena por fecha de nacimiento descendente y limita a 3.
```sql
SELECT first_name, last_name, birth_date
FROM Contact
WHERE birth_date IS NOT NULL
ORDER BY birth_date DESC
LIMIT 3;
```

### 11. Contactos nacidos en los 90s
Filtra fechas de nacimiento entre 1990 y 1999.
```sql
SELECT first_name, last_name, birth_date 
FROM Contact 
WHERE birth_date BETWEEN '1990-01-01' AND '1999-12-31'
ORDER BY birth_date ASC;
```

### 12. Actualizar empresa y apodo de un contacto
Modifica datos de un contacto específico por ID.
```sql
UPDATE Contact 
SET company_name = 'EEGSA - Departamento Técnico', 
    nickname = 'Ing. Pérez'
WHERE id = 1;
```

### 13. Actualizar nombre oficial de empresa
Cambia variantes de 'UMG' al nombre completo.
```sql
UPDATE Contact 
SET company_name = 'Universidad Mariano Gálvez de Guatemala' 
WHERE company_name LIKE '%Mariano%' OR company_name = 'UMG';
```

### 14. Eliminar un contacto
Borra el contacto con ID 5.
```sql
DELETE FROM Contact 
WHERE id = 5;
```

### 15. Actualizar fecha de nacimiento
Modifica la fecha de nacimiento de un contacto específico.
```sql
UPDATE Contact 
SET birth_date = '1985-03-10' 
WHERE id = 2;
```

### 16. Actualizar notas de un contacto
Cambia las notas de un contacto.
```sql
UPDATE Contact 
SET notes = 'Contacto preferido para asuntos técnicos' 
WHERE id = 1;
```

### 17. Actualizar número de teléfono
Modifica un número de teléfono específico.
```sql
UPDATE phone 
SET phone_number = '55559876' 
WHERE contact_id = 1 AND label_id = 1;
```

### 18. Actualizar dirección de correo
Cambia la dirección de correo electrónico de un contacto.
```sql
UPDATE email 
SET email_address = 'nuevo.correo@empresa.com' 
WHERE contact_id = 3 AND label_id = 4;
```

### 19. Eliminar un teléfono específico
Borra un número de teléfono concreto.
```sql
DELETE FROM phone 
WHERE contact_id = 1 AND phone_number = '22334455';
```

### 20. Eliminar un correo específico
Borra una dirección de correo específica.
```sql
DELETE FROM email 
WHERE contact_id = 2 AND email_address = 'analucia@bi.com.gt';
```

### 21. Eliminar contactos sin empresa
Borra contactos que no tienen empresa registrada.
```sql
DELETE FROM Contact 
WHERE company_name IS NULL;
```

### 22. Eliminar teléfonos de un país
Borra todos los teléfonos de un país específico, como USA.
```sql
DELETE FROM phone 
WHERE country_code_id = (SELECT id FROM Country_Code WHERE country_name = 'USA');
```

### 23. Eliminar etiquetas no utilizadas
Borra etiquetas que no están siendo usadas en teléfonos ni correos.
```sql
DELETE FROM Label 
WHERE id NOT IN (SELECT DISTINCT label_id FROM phone) 
  AND id NOT IN (SELECT DISTINCT label_id FROM email);
```


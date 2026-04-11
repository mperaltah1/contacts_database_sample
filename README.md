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

-- Crea el esquema si no existe
CREATE SCHEMA IF NOT EXISTS MyContacts_sample;
USE MyContacts_sample;

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
USE MyContacts_sample;

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


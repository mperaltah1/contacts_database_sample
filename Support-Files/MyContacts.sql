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
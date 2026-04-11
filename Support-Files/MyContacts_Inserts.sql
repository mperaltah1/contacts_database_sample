/**** Script de Datos (DML) *****/

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

INSERT INTO Contact (first_name, second_name, last_name, nickname, company_name, birth_date) 
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
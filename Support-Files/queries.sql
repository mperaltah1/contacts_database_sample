-- Obtener el nombre completo y el apodo de todos los contactos
SELECT 
    CONCAT_WS(' ', first_name, middle_name, last_name, maternal_last_name) AS full_name, 
    nickname 
FROM Contact;

-- Obtener contactos que trabajan en 'Universidad Mariano Gálvez'
SELECT first_name, last_name, company_name 
FROM Contact 
WHERE company_name = 'Universidad Mariano Gálvez';

-- Los JOINs permiten combinar datos de múltiples tablas basándose en una condición de relación.
-- En este caso, usamos INNER JOIN para obtener solo los registros que tienen correspondencia en ambas tablas.
-- Obtener nombres, correos y etiquetas de correos
SELECT 
    C.first_name, 
    E.email_address, 
    L.label_name
FROM Contact C
INNER JOIN Email E ON C.id = E.contact_id
INNER JOIN Label L ON E.label_id = L.id;

-- Obtener nombres, prefijos, teléfonos y etiquetas para Guatemala
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

-- ¿Cuántos contactos hay por empresa?
SELECT company_name, COUNT(*) AS total_contacts
FROM Contact
GROUP BY company_name
HAVING company_name IS NOT NULL;

-- Listar todas las empresas únicas donde trabajan nuestros contactos
SELECT DISTINCT company_name 
FROM Contact 
WHERE company_name IS NOT NULL;

-- Buscar contactos cuyo primer nombre empiece con 'M' o 'Ca'
SELECT first_name, last_name 
FROM Contact 
WHERE first_name LIKE 'M%' or first_name LIKE 'Ca%'; -- Otro ejemplo seria Like '%A%' = Contiene la A en cualquier posición.

-- Buscar a todos los que usan el correo institucional de la UMG
SELECT email_address 
FROM Email 
WHERE email_address LIKE '%@miumg.edu.gt';

-- Listar contactos que NO tienen una fecha de cumpleaños registrada
SELECT first_name, last_name 
FROM Contact 
WHERE birth_date IS NULL;

-- Obtener los 3 contactos más jóvenes (ordenados por fecha de nacimiento)
SELECT first_name, last_name, birth_date
FROM Contact
WHERE birth_date IS NOT NULL
ORDER BY birth_date DESC
LIMIT 3;

/*
IS NULL / IS NOT NULL: Recordar que NULL no es igual a "vacío" o "cero", 
es la ausencia de valor. No se puede usar = con NULL.
*/

-- Obtener contactos nacidos entre el 1 de enero de 1990 y el 31 de diciembre de 1999
SELECT first_name, last_name, birth_date 
FROM Contact 
WHERE birth_date BETWEEN '1990-01-01' AND '1999-12-31'
ORDER BY birth_date ASC;

-- Cambiar el nombre de la empresa para un contacto específico usando su ID
UPDATE Contact 
SET company_name = 'EEGSA - Departamento Técnico', 
    nickname = 'Ing. Pérez'
WHERE id = 1;

-- Actualizar todos los registros que digan 'UMG' o variantes a su nombre oficial
UPDATE Contact 
SET company_name = 'Universidad Mariano Gálvez de Guatemala' 
WHERE company_name LIKE '%Mariano%' OR company_name = 'UMG';

-- Eliminar al contacto con ID 5
DELETE FROM Contact 
WHERE id = 5;

-- Actualizar la fecha de nacimiento de un contacto
UPDATE Contact 
SET birth_date = '1985-03-10' 
WHERE id = 2;

-- Actualizar las notas de un contacto
UPDATE Contact 
SET notes = 'Contacto preferido para asuntos técnicos' 
WHERE id = 1;

-- Actualizar el número de teléfono de un contacto
UPDATE phone 
SET phone_number = '55559876' 
WHERE contact_id = 1 AND label_id = 1;

-- Actualizar la dirección de correo electrónico
UPDATE email 
SET email_address = 'nuevo.correo@empresa.com' 
WHERE contact_id = 3 AND label_id = 4;

-- Eliminar un teléfono específico
DELETE FROM phone 
WHERE contact_id = 1 AND phone_number = '22334455';

-- Eliminar un correo electrónico específico
DELETE FROM email 
WHERE contact_id = 2 AND email_address = 'analucia@bi.com.gt';

-- Eliminar contactos sin empresa registrada
DELETE FROM Contact 
WHERE company_name IS NULL;

-- Eliminar teléfonos de un país específico (ej. USA)
DELETE FROM phone 
WHERE country_code_id = (SELECT id FROM Country_Code WHERE country_name = 'USA');

-- Eliminar etiquetas no utilizadas
DELETE FROM Label 
WHERE id NOT IN (SELECT DISTINCT label_id FROM phone) 
  AND id NOT IN (SELECT DISTINCT label_id FROM email);




USE barbershop;

# 1
INSERT INTO client 
VALUES 
	(1, 'Vasy', 'Pupkinov', '+79346543432', '2024-01-01'),
    (2, 'Vasy', 'Pupkin', '+79346543432', '2019-01-01'),
    (3, 'Vasy2', 'Pupkin2', '+79346549876', '2020-01-01'),
    (4, 'Cool', 'Men', '+79346543432', '2017-01-01'),
	(5, 'Maxim', 'Surname', '+79346532432', '2023-11-21'),
	(6, 'NewVasy', 'NewPupkinov', '+79536432860', '2022-10-11');

INSERT INTO service_type
	(name, description, gender)
VALUES 
	("Haircut", "Cut your hair to a certain length", 2),
    ("Hair coloring", "Let's dye your hair the color you want", 2),
    ("Manicure", "Manicure for women", 1),
    ("Shaving", "Shaving the beard to a certain length", 0);
    
INSERT INTO service
	(service_start, service_end, price, service_type_id)
VALUES
	("2024-06-10", "2024-09-10", 500, 1),
    ("2024-09-10", "2025-10-20", 800, 4),
	("2024-12-20", "2025-01-20", 400, 2),
    ("2024-01-20", "2024-05-20", 500, 3),
    ("2024-02-10", "2024-03-20", 1000, 4),
    ("2024-10-15", "2024-12-10", 700, 3),
	("2025-01-20", "2025-05-20", 450, 1);
    
INSERT INTO barber
	(name, surname, phone, started_work)
SELECT
	name, surname, phone, birth_date
FROM client;

# 2
DELETE FROM client;

DELETE FROM service WHERE service_type_id = 3;

INSERT INTO client
	(name, surname, phone, birth_date)
VALUES 
	('n', 's', '+79346543432', '1990-11-01'),
    ('Me', 'NotMe', '+79346543432', '1989-01-01'),
    ('Vasy2', 'Pupkin2', '+79346549876', '1999-01-01'),
    ('Cool', 'Men', '+79346543432', '1987-01-01'),
	('M', 'Sss', '+79346532432', '2000-11-21'),
	('NewVasy', 'NewPupkinov', '+79536432860', '1995-10-11');

INSERT INTO complited_work
	(barber_id, client_id, service_id, work_start, work_end, is_paid)
VALUES 
	(1, 7, 1, "2024-06-15 14:30:00", "2024-06-15 15:00:00", 1),
	(1, 8, 3, "2024-08-30 9:15:00", "2024-08-30 9:30:00", 0),
	(2, 12, 5, "2024-02-26 15:30:00", "2024-02-26 16:20:00", 0),
	(5, 10, 2, "2024-09-30 10:15:00", "2024-09-30 10:30:00", 0),
	(4, 7, 7, "2024-02-27 15:30:00", "2024-02-27 16:00:00", 1),
	(1, 11, 2, "2024-05-30 9:15:00", "2024-05-30 9:30:00", 0),
	(6, 8, 5, "2024-11-30 12:30:00", "2024-11-30 13:10:00", 1);

# 3
UPDATE complited_work 
SET is_paid = 1;

UPDATE barber
SET phone = "+79346548766"
WHERE id = 1;

UPDATE service_type
SET name = "New name",
	description = "New very new description"
WHERE gender = 2;

UPDATE service_type
SET name = "Haircut",
	description = "Cut your hair to a certain length"
WHERE id = 1;

# 4
SELECT work_start, work_end FROM complited_work;

SELECT * FROM service_type;

SELECT * FROM service WHERE service_type_id = 1;

# 5
SELECT * FROM barber ORDER BY name ASC LIMIT 5;

SELECT * FROM service_type ORDER BY name DESC;

SELECT * FROM barber ORDER BY name, surname LIMIT 5;

SELECT * FROM barber ORDER BY 1 DESC;

# 6
SELECT * FROM complited_work WHERE work_start = "2024-06-15 14:30:00";

SELECT * FROM service WHERE service_end BETWEEN "2024-01-01 00:00:00" AND "2025-01-01 00:00:00";

SELECT name, surname, YEAR(started_work) FROM barber;

# 7
SELECT COUNT(*) FROM service_type;

SELECT COUNT(DISTINCT name) FROM service_type;

SELECT DISTINCT name FROM service_type;

SELECT MAX(price) FROM service;

SELECT MIN(price) FROM service;

SELECT service_id, COUNT(id) FROM complited_work GROUP BY service_id;

#8
SELECT service_type_id, COUNT(id) FROM service 
GROUP BY service_type_id HAVING COUNT(id) > 1;

SELECT barber_id, COUNT(id) 
FROM complited_work
GROUP BY barber_id 
HAVING COUNT(id) > 1;

SELECT service_id, COUNT(id) 
FROM complited_work
GROUP BY service_id 
HAVING COUNT(id) > 1;

# 9
SELECT * FROM service 
LEFT JOIN service_type ON service.service_type_id = service_type.id WHERE gender = 0;

SELECT * FROM service_type 
RIGHT JOIN service ON service.service_type_id = service_type.id WHERE gender = 0;

SELECT * FROM barber
LEFT JOIN complited_work ON barber.id = complited_work.barber_id
LEFT JOIN client ON complited_work.client_id = client.id
WHERE YEAR(started_work) > 2020 AND work_start 
BETWEEN "2024-01-01" AND "2025-01-01" AND YEAR(birth_date) < 1990;

SELECT * FROM complited_work
INNER JOIN service ON complited_work.service_id = service.id;

# 10
SELECT * FROM service WHERE service_type_id
IN (SELECT id FROM service_type WHERE name = "Haircut" OR name = "Shaving");

SELECT service_start, service_end, (SELECT name FROM service_type WHERE service_type.id = service_type_id) FROM service;

SELECT * FROM (SELECT * FROM service_type) AS type;

SELECT * FROM complited_work
JOIN (SELECT id, name, surname FROM client WHERE YEAR(birth_date) > 1990) AS young
ON complited_work.client_id = young.id;

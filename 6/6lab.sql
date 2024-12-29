USE hotel;

/* 1. Добавить внешние ключи.
*/

ALTER TABLE room
ADD CONSTRAINT FK_room_hotel_id_hotel
FOREIGN KEY (id_hotel) REFERENCES hotel(id_hotel);

ALTER TABLE room
ADD CONSTRAINT FK_room_hotel_id_room_category
FOREIGN KEY (id_room_category) REFERENCES room_category(id_room_category);

ALTER TABLE booking
ADD CONSTRAINT FK_booking_client_id_client
FOREIGN KEY (id_client) REFERENCES client(id_client);

ALTER TABLE room_in_booking
ADD CONSTRAINT FK_room_in_booking_booking_id_booking
FOREIGN KEY (id_booking) REFERENCES booking(id_booking);

ALTER TABLE room_in_booking
ADD CONSTRAINT FK_room_in_booking_room_id_room
FOREIGN KEY (id_room) REFERENCES room(id_room);

/* 2. Выдать информацию о клиентах гостиницы “Космос”, проживающих в номерах
		категории “Люкс” на 1 апреля 2019г.
*/

SELECT c.name, c.phone 
FROM client c 
WHERE c.id_client IN
	(
		SELECT b.id_client
		FROM
			booking b
			INNER JOIN room_in_booking rb USING(id_booking)
            INNER JOIN room r USING(id_room)
			INNER JOIN room_category rc USING(id_room_category)
            INNER JOIN hotel h USING(id_hotel)
		WHERE h.name = "Космос"
		AND
			rc.name = "Люкс"
		AND
			rb.checkin_date <= "2019-04-01"
        AND
			rb.checkout_date > "2019-04-01"
    );

/* 3. Дать список свободных номеров всех гостиниц на 22 апреля
*/

SELECT h.name, r.number
FROM 
	room r
    INNER JOIN hotel h USING(id_hotel)
WHERE r.id_room NOT IN
	(SELECT rb.id_room
    FROM room_in_booking rb
    WHERE
		rb.checkin_date < "2019-04-22"
	AND
		rb.checkout_date >= "2019-04-22");

# id_room 22 25.04-26.04
# id_room 22 21.03-23.04
# есть комнаты вообще без бронирований


/* 4. Дать количество проживающих в гостинице “Космос” на 23 марта
	по каждой категории номеров.
*/

SELECT rc.name, COUNT(rb.id_room_in_booking)
FROM 
	room_in_booking rb
    INNER JOIN room r USING(id_room)
    INNER JOIN room_category rc USING(id_room_category)
WHERE r.id_hotel IN
	(SELECT hotel.id_hotel FROM hotel WHERE hotel.name = "Космос")
AND	rb.checkin_date <= "2019-03-23"
AND rb.checkout_date > "2019-03-23"
GROUP BY rc.id_room_category;

/*5. Дать список последних проживавших клиентов по всем комнатам гостиницы
	“Космос”, выехавшим в апреле с указанием даты выезда.
*/

SELECT MAX(checkout_date)
FROM room_in_booking rb
WHERE MONTH(checkout_date) = 4;

SELECT c.name, rb.checkout_date, rb.id_room
FROM 
	room_in_booking rb
	INNER JOIN booking b USING(id_booking)
    INNER JOIN `client` c USING(id_client)
WHERE rb.id_room IN 
	(SELECT id_room FROM room
    WHERE id_hotel IN (
		SELECT id_hotel FROM hotel WHERE hotel.name = "Космос")
AND MONTH(rb.checkout_date) = 4)
ORDER BY rb.checkout_date DESC;
# Последний проживающий в каждой комнате

/*6. Продлить на 2 дня дату проживания в гостинице “Космос” всем клиентам
	комнат категории “Бизнес”, которые заселились 10 мая.*/

UPDATE room_in_booking rb
SET rb.checkout_date = DATE_ADD(rb.checkout_date, INTERVAL 2 DAY)
WHERE rb.id_room IN (
	SELECT id_room FROM room
    WHERE room.id_hotel IN (
		SELECT id_hotel FROM hotel WHERE hotel.name = "Космос")
	AND room.id_room_category IN (
    SELECT id_room_category FROM room_category WHERE name = "Бизнес"))
AND rb.checkin_date = "2019-05-10";

/* 7.Найти все "пересекающиеся" варианты проживания. Правильное состояние:
	не может быть забронирован один номер на одну дату несколько раз, т.к. нельзя
	заселиться нескольким клиентам в один номер. Записи в таблице room_in_booking
	с id_room_in_booking = 5 и 2154 являются примером неправильного состояния, которые необходимо найти.
	Результирующий кортеж выборки должен содержать информацию о двух конфликтующих номерах.
*/

SELECT *
FROM
	room_in_booking rb1
    INNER JOIN room_in_booking rb2 ON rb1.id_room = rb2.id_room
WHERE (rb1.checkin_date <= rb2.checkin_date AND rb1.checkout_date > rb2.checkin_date)
AND rb1.id_room_in_booking <> rb2.id_room_in_booking
AND (rb1.id_room_in_booking = 2154 and rb2.id_room_in_booking = 5 OR rb1.id_room_in_booking = 5 AND rb2.id_room_in_booking = 2154 )
;


/* 8. Создать бронирование в транзакции.
*/

START TRANSACTION;
INSERT INTO client
	(name, phone)
VALUES
	("Кузнецов Павел Евгеньевич", +79021112233);

SET @last_index_client = LAST_INSERT_ID();

INSERT INTO booking
	(id_client, booking_date)
VALUES
	(@last_index_client, CURDATE());

SET @last_index_booking = LAST_INSERT_ID();

INSERT INTO room_in_booking
	(id_booking, id_room, checkin_date, checkin_out)
VALUES
	(@last_index_booking, 12, "2024-05-25", "2025-05-25");

COMMIT;
ROLLBACK;
# room_in_booking


/* 9. Добавить необходимые индексы для всех таблиц.
*/

# Creating
CREATE INDEX IX_hotel_name ON hotel(name);

CREATE INDEX IX_client_name ON client(name);

CREATE INDEX IX_room_category_name ON room_category(name);

CREATE INDEX IX_room_in_booking_checkin_date ON room_in_booking(checkin_date);
CREATE INDEX IX_room_in_booking_checkout_date ON room_in_booking(checkout_date);

# Deleting

DROP INDEX IX_room_in_booking_checkin_date ON room_in_booking;
DROP INDEX IX_room_in_booking_checkout_date ON room_in_booking;

DROP INDEX IX_room_category_name ON room_category;

DROP INDEX IX_client_name ON client;

DROP INDEX IX_hotel_name ON hotel;

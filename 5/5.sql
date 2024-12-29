USE medicines2;

/*1. Добавить внешние ключи.
*/

ALTER TABLE dealer
ADD CONSTRAINT dealer_company_company_id_fk
FOREIGN KEY (id_company) REFERENCES company(id_company);

ALTER TABLE production
ADD CONSTRAINT production_company_company_id_fk
FOREIGN KEY (id_company) REFERENCES company(id_company);

ALTER TABLE production
ADD CONSTRAINT production_medicine_medicine_id_fk
FOREIGN KEY (id_medicine) REFERENCES medicine(id_medicine);

ALTER TABLE `order`
ADD CONSTRAINT order_production_production_id_fk
FOREIGN KEY (id_production) REFERENCES production(id_production);

ALTER TABLE `order`
ADD CONSTRAINT order_dealer_dealer_id_fk
FOREIGN KEY (id_dealer) REFERENCES dealer(id_dealer);

ALTER TABLE `order`
ADD CONSTRAINT order_pharmacy_pharmacy_id_fk
FOREIGN KEY (id_pharmacy) REFERENCES pharmacy(id_pharmacy);

/* 2. Выдать информацию по всем заказам лекарствам “Кордерон” компании “Аргус”
		с указанием названий аптек, дат, объема заказов.
*/

SELECT
	ph.name, o.date, o.quantity
FROM
	`order` o
    INNER JOIN production pr USING(id_production)
    INNER JOIN company c USING(id_company)
    INNER JOIN medicine m USING(id_medicine)
    INNER JOIN pharmacy ph USING(id_pharmacy)
WHERE c.name = "Аргус" AND m.name = "Кордерон";

/* 3. Дать список лекарств компании “Фарма”, на которые не были сделаны заказы до 25 января.
*/

SELECT m.name
FROM
	medicine m
	INNER JOIN production pr USING(id_medicine)
	INNER JOIN company c USING(id_company)
WHERE c.name = "Фарма" AND 
	pr.id_production IN (
		SELECT o.id_production FROM `order` o WHERE (o.date >= "2019-01-25" OR ISNULL(o.date))
    );

/* 4.Дать минимальный и максимальный баллы лекарств каждой фирмы, которая
		оформила не менее 120 заказов
*/

SELECT c.name, MAX(pr.rating), MIN(pr.rating)
FROM 
	company c
    INNER JOIN production pr USING(id_company)
    INNER JOIN `order` o USING(id_production)
GROUP BY c.id_company HAVING COUNT(o.id_order) >= 120;

/* 5. Дать списки сделавших заказы аптек по всем дилерам компании “AstraZeneca”.
		Если у дилера нет заказов, в названии аптеки проставить NULL.
*/

SELECT ph.name, d.name
FROM
	pharmacy ph
    INNER JOIN `order` o USING(id_pharmacy)
    RIGHT JOIN dealer d USING(id_dealer)
    INNER JOIN company c USING(id_company)
WHERE c.name = "AstraZeneca";

/* 6. Уменьшить на 20% стоимость всех лекарств, если она превышает 3000, а
		длительность лечения не более 7 дней.
*/

UPDATE production
SET production.price = 0.8 * production.price
WHERE production.price > 3000
AND production.id_medicine IN
	(SELECT medicine.id_medicine 
    FROM medicine 
    WHERE medicine.cure_duration <= 7);

/* 7. Добавить необходимые индексы.
*/

CREATE INDEX IX_company_name ON company(name(100));

CREATE INDEX IX_medicine_name ON medicine(name(100));
CREATE INDEX IX_medicine_cure_duration ON medicine(cure_duration);

CREATE INDEX IX_prodution_id_medicine ON production(id_medicine);

CREATE INDEX IX_order_date ON `order`(date(6));

# Droping
DROP INDEX IX_company_name ON company;

DROP INDEX IX_medicine_name ON medicine;
DROP INDEX IX_medicine_cure_duration ON medicine;

DROP INDEX IX_prodution_id_medicine ON production;

DROP INDEX IX_order_date ON `order`;

USE barbershop;

CREATE TABLE IF NOT EXISTS service_type
(
	`id` INT AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(20),
    `description` VARCHAR(255),
    `gender` TINYINT(2)
)  ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS barber
(
	`id` INT AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(20),
    `surname` VARCHAR(20),
    `phone` VARCHAR(20),
    `started_work` DATE
)  ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS service
(
	`id` INT AUTO_INCREMENT PRIMARY KEY,
    `service_start` DATE,
    `service_end` DATE,
    `price` DECIMAL(7, 2) UNSIGNED,
    `service_type_id` INT,
    FOREIGN KEY (`service_type_id`) REFERENCES service_type(`id`)
)  ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS client
(
	`id` INT AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(20),
    `surname` VARCHAR(20),
    `phone` VARCHAR(20),
    `birth_date` DATE
)  ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS complited_work
(
	`id` INT AUTO_INCREMENT PRIMARY KEY,
    `barber_id` INT,
    `client_id` INT,
    `service_id` INT,
    `work_start` DATETIME,
    `work_end` DATETIME,
    `is_paid` TINYINT(1),
    FOREIGN KEY (`barber_id`) REFERENCES barber(`id`),
    FOREIGN KEY (`client_id`) REFERENCES client(`id`),
    FOREIGN KEY (`service_id`) REFERENCES service(`id`)
)  ENGINE = InnoDB;
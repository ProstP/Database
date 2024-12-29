USE food;

CREATE TABLE IF NOT EXISTS dish_type
(
	`id` INT AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS product_type
(
	`id` INT AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS dish
(
	`id` INT AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(20),
    `description` VARCHAR(255),
    `type` VARCHAR(20),
    `calorie` DECIMAL(6, 2) UNSIGNED,
    FOREIGN KEY (`type`) REFERENCES dish_type(`id`)
);

CREATE TABLE IF NOT EXISTS chef
(
	`id` INT AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(20),
    `surname` VARCHAR(20),
    `phone` VARCHAR(20),
	`birth_date` DATE
);

CREATE TABLE IF NOT EXISTS product
(
	`id` INT AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(255),
    `type` VARCHAR(255),
    `calorie` SMALLINT UNSIGNED,
    `protein` DECIMAL(5, 2) UNSIGNED,
    `fat` DECIMAL(5, 2) UNSIGNED,
    `carbohydrate` DECIMAL(5, 2) UNSIGNED,
    FOREIGN KEY (`type`) REFERENCES product_type(`id`)
);

CREATE TABLE IF NOT EXISTS restaurant
(
	`id` INT AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(50),
    `rating` DECIMAL(3, 2) UNSIGNED,
    `opening_time` TIME,
    `cloded_time` TIME
);

CREATE TABLE IF NOT EXISTS recipe
(
	`id` INT AUTO_INCREMENT PRIMARY KEY,
    `dish_id` INT,
    `chef_id` INT,
    `time_to_cook` TIME,
    `num_of_portion` TINYINT UNSIGNED,
    FOREIGN KEY (`dish_id`) REFERENCES dish(`id`),
    FOREIGN KEY (`chef_id`) REFERENCES chef(`id`)
);

CREATE TABLE IF NOT EXISTS recipe_has_product
(
	`id` INT AUTO_INCREMENT PRIMARY KEY,
    `recipe_id` INT,
    `product_id` INT,
    FOREIGN KEY (`recipe_id`) REFERENCES recipe(`id`),
    FOREIGN KEY (`product_id`) REFERENCES product(`id`)
);

CREATE TABLE IF NOT EXISTS restaurant_has_dish
(
	`id` INT AUTO_INCREMENT PRIMARY KEY,
    `restaurant_id` INT,
    `dish_id` INT,
    FOREIGN KEY (`restaurant_id`) REFERENCES restaurant(`id`),
    FOREIGN KEY (`dish_id`) REFERENCES dish(`id`)
);
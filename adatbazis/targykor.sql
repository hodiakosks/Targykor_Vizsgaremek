
-- adatbázis létrehozása
CREATE DATABASE IF NOT EXISTS `targykor`
CHARACTER SET utf8mb4 
COLLATE utf8mb4_unicode_ci;

-- adatbázisba belépés

USE targykor;

-- táblák kódja:
SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `username` varchar(100) NOT NULL,
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `avatar_url` varchar(255) NULL DEFAULT NULL,
  `email` varchar(255) NOT NULL,
  `phone_number` varchar(50),
  `password` varchar(255) NOT NULL,
  `role` ENUM('USER', 'ADMIN') NOT NULL DEFAULT 'USER',
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `last_login` timestamp NULL DEFAULT NULL,
  `failed_login_attempts` int NOT NULL DEFAULT 0,
  `locked_until` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `is_deleted` tinyint NULL DEFAULT 0,
  UNIQUE KEY `uq_user_email` (`email`),
  UNIQUE KEY `uq_user_username` (`username`)
);

DROP TABLE IF EXISTS `sessions`;
CREATE TABLE `sessions` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `token` varchar(255) NOT NULL,
  `expires_at` timestamp NOT NULL, -- meddig marad bejelentkezve
  `revoked` tinyint NOT NULL DEFAULT 0, -- kijelentkezés
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY `uq_sessions_token` (`token`),
  FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE CASCADE
);


DROP TABLE IF EXISTS `user_twofa`;
CREATE TABLE `user_twofa` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `is_enabled` tinyint NOT NULL DEFAULT 0,
  `secret_key` varchar(255) NULL DEFAULT NULL,
  `backup_codes` varchar(1024) NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `is_deleted` tinyint NULL DEFAULT 0,
  UNIQUE KEY `uq_twofa_user` (`user_id`),
  FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE CASCADE
);

DROP TABLE IF EXISTS `email_verifications`;
CREATE TABLE `email_verifications` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `token` varchar(255) NOT NULL,
  `sent_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `expires_at` timestamp NOT NULL,
  `verified_at` timestamp NULL DEFAULT NULL,
  UNIQUE KEY `uq_email_verif_token` (`token`),
  FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE CASCADE
);

DROP TABLE IF EXISTS `password_resets`;
CREATE TABLE `password_resets` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `token` varchar(255) NOT NULL,
  `expires_at` timestamp NOT NULL,
  `used_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY `uq_pw_reset_token` (`token`),
  FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE CASCADE
);

DROP TABLE IF EXISTS `login_logs`;
CREATE TABLE `login_logs` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `user_id` int NULL,
  `user_agent` varchar(255) NULL,
  `logged_in_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE SET NULL
);

DROP TABLE IF EXISTS `categories`;
CREATE TABLE `categories` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `is_deleted` tinyint NULL DEFAULT 0,
  UNIQUE KEY `uq_categories_name` (`name`)
);

DROP TABLE IF EXISTS `counties`;
CREATE TABLE `counties` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  UNIQUE KEY `uq_counties_name` (`name`)
);

INSERT INTO `counties` (`name`) VALUES
  ('Bács-Kiskun'), ('Baranya'), ('Békés'), ('Borsod-Abaúj-Zemplén'),
  ('Csongrád-Csanád'), ('Fejér'), ('Győr-Moson-Sopron'), ('Hajdú-Bihar'),
  ('Heves'), ('Jász-Nagykun-Szolnok'), ('Komárom-Esztergom'), ('Nógrád'),
  ('Pest'), ('Somogy'), ('Szabolcs-Szatmár-Bereg'), ('Tolna'),
  ('Vas'), ('Veszprém'), ('Zala'), ('Budapest');


DROP TABLE IF EXISTS `products`;
CREATE TABLE `products` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `category_id` int NOT NULL,
  `county_id` int NOT NULL,
  `name` varchar(100) NOT NULL,
  `price_per_day` int NOT NULL,
  `deposit` int NOT NULL DEFAULT 0,
  `description` text NOT NULL,
  `city` varchar(100) NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `is_deleted` tinyint NULL DEFAULT 0,
  CONSTRAINT `chk_products_price` CHECK (`price_per_day` > 0),
  CONSTRAINT `chk_products_deposit` CHECK (`deposit` >= 0),
  FOREIGN KEY (`user_id`) REFERENCES `users`(`id`),
  FOREIGN KEY (`category_id`) REFERENCES `categories`(`id`),
  FOREIGN KEY (`county_id`) REFERENCES `counties`(`id`)
);

DROP TABLE IF EXISTS `product_images`;
CREATE TABLE `product_images` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `product_id` int NOT NULL,
  `url` varchar(255) NOT NULL,
  `sort_order` int NOT NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY (`product_id`, `sort_order`),
  FOREIGN KEY (`product_id`) REFERENCES `products`(`id`) ON DELETE CASCADE
  
);

DROP TABLE IF EXISTS `rentals`;
CREATE TABLE `rentals` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `product_id` int NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,   
  `price` int NOT NULL,
  `total_price` int NOT NULL,
  `status` ENUM('pending', 'approved', 'active', 'completed', 'cancelled') NOT NULL DEFAULT 'pending',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT `chk_rentals_dates` CHECK (`end_date` >= `start_date`),
  CONSTRAINT `chk_rentals_price` CHECK (`price` > 0 AND `total_price` > 0),
  FOREIGN KEY (`user_id`) REFERENCES `users`(`id`),
  FOREIGN KEY (`product_id`) REFERENCES `products`(`id`)
);

DROP TABLE IF EXISTS `rental_status_history`;
CREATE TABLE `rental_status_history` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `rental_id` int NOT NULL,
  `old_status` ENUM('pending', 'approved', 'active', 'completed', 'cancelled') NULL,
  `new_status` ENUM('pending', 'approved', 'active', 'completed', 'cancelled') NOT NULL,
  `changed_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP, 
  FOREIGN KEY (`rental_id`) REFERENCES `rentals`(`id`) ON DELETE CASCADE
);

DROP TABLE IF EXISTS `complaints`;
CREATE TABLE `complaints` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `rental_id` int NOT NULL,
  `user_id` int NOT NULL,
  `description` text NOT NULL,
  `status` ENUM('open', 'in_review', 'resolved', 'rejected') NOT NULL DEFAULT 'open',
  `admin_response` text NULL,
  `resolved_by` int NULL,
  `resolved_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT `chk_complaints_desc` CHECK (CHAR_LENGTH(TRIM(`description`)) > 0),
  FOREIGN KEY (`rental_id`) REFERENCES `rentals`(`id`),
  FOREIGN KEY (`user_id`) REFERENCES `users`(`id`),
  FOREIGN KEY (`resolved_by`) REFERENCES `users`(`id`) ON DELETE SET NULL
);


DROP TABLE IF EXISTS `notifications`;
CREATE TABLE `notifications` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `content` varchar(255) NOT NULL,
  `rental_id` int NULL,
  `is_read` tinyint NOT NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE CASCADE,
  FOREIGN KEY (`rental_id`) REFERENCES `rentals`(`id`) ON DELETE SET NULL
);

DROP TABLE IF EXISTS `favourites`;
CREATE TABLE `favourites` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `product_id` int NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY `unique_favourite` (`user_id`, `product_id`),
  FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE CASCADE,
  FOREIGN KEY (`product_id`) REFERENCES `products`(`id`) ON DELETE CASCADE
);

DROP TABLE IF EXISTS `reviews`;
CREATE TABLE `reviews` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `product_id` int NOT NULL,
  `rental_id` int NOT NULL,
  `rating` tinyint NOT NULL,
  `comment` text,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `is_deleted` tinyint NULL DEFAULT 0,
  UNIQUE KEY `unique_review_rental` (`rental_id`),
  CONSTRAINT `chk_reviews_rating` CHECK (`rating` BETWEEN 1 AND 5),
  FOREIGN KEY (`rental_id`) REFERENCES `rentals`(`id`),
  FOREIGN KEY (`user_id`) REFERENCES `users`(`id`),
  FOREIGN KEY (`product_id`) REFERENCES `products`(`id`) ON DELETE CASCADE
);
SET FOREIGN_KEY_CHECKS = 1;

-- eljárások:
DELIMITER $$


-- ||||||||| users |||||||||

-- új user létrehozása
DROP PROCEDURE IF EXISTS createUser$$ 
CREATE PROCEDURE createUser(
  IN usernameIN VARCHAR(100),
  IN first_nameIN VARCHAR(50),
  IN last_nameIN VARCHAR(50),
  IN emailIN VARCHAR(255),
  IN phone_numberIN VARCHAR(50),
  IN passwordIN VARCHAR(255)
)
BEGIN
  INSERT INTO users (username, first_name, last_name, email, phone_number, password)
  VALUES (usernameIN, first_nameIN, last_nameIN, emailIN, phone_numberIN, passwordIN);

  SELECT LAST_INSERT_ID() AS new_user_id;
END$$


-- az összes felhasználó listája (password nincs benne)
DROP PROCEDURE IF EXISTS getAllUser$$
CREATE PROCEDURE getAllUser()
BEGIN
  SELECT id, username, first_name, last_name, email, phone_number, role, last_login, created_at
  FROM users
  WHERE is_deleted = 0
  ORDER BY created_at DESC;
END$$

-- user adatai id alapján
DROP PROCEDURE IF EXISTS getUserById$$
CREATE PROCEDURE getUserById(IN idIN INT)
BEGIN
  SELECT id, username, first_name, last_name, email, phone_number, role, email_verified_at, last_login, created_at
  FROM users
  WHERE id = idIN AND is_deleted = 0;
END$$

-- user lekérése email alapján a belépéshez
DROP PROCEDURE IF EXISTS getUserByEmail$$
CREATE PROCEDURE getUserByEmail(IN emailIN VARCHAR(255))
BEGIN
  SELECT id, username, email, password, role, failed_login_attempts, locked_until, email_verified_at
  FROM users
  WHERE email = emailIN AND is_deleted = 0;
END$$

-- profil módosítása
DROP PROCEDURE IF EXISTS updateUser$$
CREATE PROCEDURE updateUser(
  IN idIN INT,
  IN usernameIN VARCHAR(100),
  IN first_nameIN VARCHAR(50),
  IN last_nameIN VARCHAR(50),
  IN emailIN VARCHAR(255),
  IN phone_numberIN VARCHAR(50)
)
BEGIN
  UPDATE users
  SET email_verified_at = IF(email <> emailIN, NULL, email_verified_at),
      username     = usernameIN,
      first_name   = first_nameIN,
      last_name    = last_nameIN,
      email        = emailIN,
      phone_number = phone_numberIN
  WHERE id = idIN AND is_deleted = 0;

  SELECT ROW_COUNT() AS affected_rows;
END$$


-- profilképnek a módosítása
DROP PROCEDURE IF EXISTS updateUserAvatar$$
CREATE PROCEDURE updateUserAvatar(IN idIN INT, IN avatar_urlIN VARCHAR(255))
BEGIN
  UPDATE users
  SET avatar_url = avatar_urlIN
  WHERE id = idIN AND is_deleted = 0;

  SELECT ROW_COUNT() AS affected_rows;
END$$

-- fiók törlése (0 -> 1)
DROP PROCEDURE IF EXISTS softDeleteUser$$
CREATE PROCEDURE softDeleteUser(IN idIN INT)
BEGIN
  UPDATE users
  SET is_deleted = 1,
      deleted_at = NOW()
  WHERE id = idIN AND is_deleted = 0;
END$$

-- hibás jelszó, 5. próbálkozásnál zárol
DROP PROCEDURE IF EXISTS loginFailed$$
CREATE PROCEDURE loginFailed(IN emailIN VARCHAR(255))
BEGIN
  UPDATE users
  SET locked_until = IF(failed_login_attempts + 1 >= 5,
    NOW() + INTERVAL 15 MINUTE, locked_until),
    failed_login_attempts = failed_login_attempts + 1
  WHERE email = emailIN AND is_deleted = 0;
END$$


-- sikeres belépés
DROP PROCEDURE IF EXISTS loginSuccess$$
CREATE PROCEDURE loginSuccess(IN idIN INT)
BEGIN
  UPDATE users
  SET last_login = NOW(),
      failed_login_attempts = 0,
      locked_until = NULL
  WHERE id = idIN AND is_deleted = 0;
END$$


-- ||||||||| sessions |||||||||

-- új munkamenet mentése belépéskor
DROP PROCEDURE IF EXISTS createSession$$
CREATE PROCEDURE createSession(
  IN user_idIN INT,
  IN tokenIN VARCHAR(255),
  IN expires_atIN TIMESTAMP
)
BEGIN
  INSERT INTO sessions (user_id, token, expires_at)
  VALUES (user_idIN, tokenIN, expires_atIN);

  SELECT LAST_INSERT_ID() AS new_session_id;
END$$

-- érvényes munkamenetet ad vissza
DROP PROCEDURE IF EXISTS getSessionByToken$$
CREATE PROCEDURE getSessionByToken(IN tokenIN VARCHAR(255))
BEGIN
  SELECT sessions.id, sessions.user_id, sessions.expires_at, users.role
  FROM sessions
  JOIN users ON users.id = sessions.user_id
  WHERE sessions.token = tokenIN
    AND sessions.revoked = 0
    AND sessions.expires_at > NOW()
    AND users.is_deleted = 0;
END$$

-- kijelentkezés
DROP PROCEDURE IF EXISTS revokeSession$$
CREATE PROCEDURE revokeSession(IN tokenIN VARCHAR(255))
BEGIN
  UPDATE sessions
  SET revoked = 1
  WHERE token = tokenIN AND revoked = 0;

  SELECT ROW_COUNT() AS affected_rows;
END$$

-- kijelentkezés minden eszközről
DROP PROCEDURE IF EXISTS revokeAllSessionByUser$$
CREATE PROCEDURE revokeAllSessionByUser(IN user_idIN INT)
BEGIN
  UPDATE sessions
  SET revoked = 1
  WHERE user_id = user_idIN AND revoked = 0;

  SELECT ROW_COUNT() AS affected_rows;
END$$

-- lejárt munkamenetek törlése
DROP PROCEDURE IF EXISTS deleteExpiredSession$$
CREATE PROCEDURE deleteExpiredSession()
BEGIN
  DELETE FROM sessions
  WHERE expires_at < NOW();

  SELECT ROW_COUNT() AS affected_rows;
END$$




-- ||||||||| products |||||||||

-- új termék létrehozása
DROP PROCEDURE IF EXISTS createProduct$$
CREATE PROCEDURE createProduct(
  IN user_idIN INT,
  IN category_idIN INT,
  IN county_idIN INT,
  IN nameIN VARCHAR(100),
  IN price_per_dayIN INT,
  IN depositIN INT,
  IN descriptionIN TEXT,
  IN cityIN VARCHAR(100)
)
BEGIN
  INSERT INTO products (user_id, category_id, county_id, name, price_per_day, deposit, description, city)
  VALUES (user_idIN, category_idIN, county_idIN, nameIN, price_per_dayIN, depositIN, descriptionIN, cityIN);

  SELECT LAST_INSERT_ID() AS new_product_id;
END$$




-- ||||||||| rentals |||||||||

-- a usernek hány folyamatban lévő bérlése van
DROP PROCEDURE IF EXISTS countActiveRentalByUser$$
CREATE PROCEDURE countActiveRentalByUser(IN idIN INT)
BEGIN
  SELECT COUNT(*) AS active_count
  FROM rentals
  JOIN products ON products.id = rentals.product_id
  WHERE (rentals.user_id = idIN OR products.user_id = idIN)
    AND rentals.status IN ('pending', 'approved', 'active');
END$$

-- trigger, a rental_status_history táblába írják be automatikusan 
DROP TRIGGER IF EXISTS rentalsAfterInsert$$
CREATE TRIGGER rentalsAfterInsert AFTER INSERT ON rentals
FOR EACH ROW
BEGIN
  INSERT INTO rental_status_history (rental_id, old_status, new_status)
  VALUES (NEW.id, NULL, NEW.status);
END$$

-- ha változik akkor az old és a new status változik
DROP TRIGGER IF EXISTS rentalsAfterUpdate$$
CREATE TRIGGER rentalsAfterUpdate AFTER UPDATE ON rentals
FOR EACH ROW
BEGIN
  IF OLD.status <> NEW.status THEN
    INSERT INTO rental_status_history (rental_id, old_status, new_status)
    VALUES (NEW.id, OLD.status, NEW.status);
  END IF;
END$$

-- ||||||||| user_twofa |||||||||

-- twofa mentése, ha már volt akkor felülírja és kikapcsolja
DROP PROCEDURE IF EXISTS createUserTwoFa$$
CREATE PROCEDURE createUserTwoFa(
  IN user_idIN INT,
  IN secret_keyIN VARCHAR(255),
  IN backup_codesIN VARCHAR(1024)
)
BEGIN
  INSERT INTO user_twofa (user_id, secret_key, backup_codes)
  VALUES (user_idIN, secret_keyIN, backup_codesIN)
  ON DUPLICATE KEY UPDATE
    secret_key = secret_keyIN,
    backup_codes = backup_codesIN,
    is_enabled = 0;

  SELECT ROW_COUNT() AS affected_rows;
END$$


-- belépéskor és a kód ellenőrzésekor
DROP PROCEDURE IF EXISTS getUserTwoFaByUser$$
CREATE PROCEDURE getUserTwoFaByUser(IN user_idIN INT)
BEGIN
  SELECT is_enabled, secret_key, backup_codes
  FROM user_twofa
  WHERE user_id = user_idIN;
END$$


-- a helyes kód beírása után kapcsol be a backend által (majd)
DROP PROCEDURE IF EXISTS enableUserTwoFa$$
CREATE PROCEDURE enableUserTwoFa(IN user_idIN INT)
BEGIN
  UPDATE user_twofa
  SET is_enabled = 1
  WHERE user_id = user_idIN;

  SELECT ROW_COUNT() AS affected_rows;
END$$

DROP PROCEDURE IF EXISTS updateBackupCode$$
CREATE PROCEDURE updateBackupCode(
  IN user_idIN INT,
  IN backup_codesIN VARCHAR(1024)
)
BEGIN
  UPDATE user_twofa
  SET backup_codes = backup_codesIN
  WHERE user_id = user_idIN;

  SELECT ROW_COUNT() AS affected_rows;
END$$


-- twofa kikapcsolása
DROP PROCEDURE IF EXISTS deleteUserTwoFa$$
CREATE PROCEDURE deleteUserTwoFa(IN user_idIN INT)
BEGIN
  DELETE FROM user_twofa
  WHERE user_id = user_idIN;

  SELECT ROW_COUNT() AS affected_rows;
END$$

DELIMITER ;

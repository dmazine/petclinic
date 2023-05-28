CREATE TABLE IF NOT EXISTS persons
(
    id         BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(30),
    last_name  VARCHAR(30),
    INDEX (last_name)
);

CREATE TABLE IF NOT EXISTS vets
(
    first_name VARCHAR(30),
    last_name  VARCHAR(30),
    INDEX (last_name)
);

CREATE TABLE IF NOT EXISTS owners
(
    first_name VARCHAR(30),
    last_name  VARCHAR(30),
    INDEX (last_name)
);

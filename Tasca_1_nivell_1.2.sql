CREATE DATABASE Pizzeria;
USE Pizzeria;

CREATE TABLE province
(
    id   INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(30) NOT NULL
);

CREATE TABLE locality
(
    id       INT PRIMARY KEY AUTO_INCREMENT,
    name     VARCHAR(30) NOT NULL,
    province INT         NOT NULL,
    CONSTRAINT fk_locality_province FOREIGN KEY (province) REFERENCES province (id)
);

-- phone_number és charchar perquè pot tenir guions, parèntesis, etc.
-- A partir d'aquí poso sempre not null a no ser que s'especifiqui el contrari.
-- Dubte: Cal posar FK a província? no es podria fer un walk des de localitat?
CREATE TABLE client
(
    id           INT PRIMARY KEY AUTO_INCREMENT,
    name         VARCHAR(30) NOT NULL,
    surname      VARCHAR(50) NOT NULL,
    address      VARCHAR(50) NOT NULL,
    postal_code  INT(5)      NOT NULL,
    locality     INT         NOT NULL,
    province     INT         NOT NULL,
    phone_number VARCHAR(20) NOT NULL,
    CONSTRAINT fk_client_locality FOREIGN KEY (locality) REFERENCES locality (id),
    CONSTRAINT fk_client_province FOREIGN KEY (province) REFERENCES province (id)
);

CREATE TABLE store
(
    id          INT PRIMARY KEY AUTO_INCREMENT,
    address     VARCHAR(50) NOT NULL,
    postal_code INT(5)      NOT NULL,
    locality    INT         NOT NULL,
    province    INT         NOT NULL,
    CONSTRAINT fk_store_locality FOREIGN KEY (locality) REFERENCES locality (id),
    CONSTRAINT fk_store_province FOREIGN KEY (province) REFERENCES province (id)
);

CREATE TABLE employee
(
    id              INT PRIMARY KEY AUTO_INCREMENT,
    store           INT         NOT NULL,
    name            VARCHAR(30) NOT NULL,
    surname         VARCHAR(50) NOT NULL,
    nif             VARCHAR(9)  NOT NULL,
    phone_number    VARCHAR(20) NOT NULL,
    job_description ENUM ('cooker', 'delivery_man'),
    CONSTRAINT fk_employee_store FOREIGN KEY (store) REFERENCES store (id)
);

-- TODO faltaria comprovar que employee té job_description = 'delivery_man'
CREATE TABLE home_delivery
(
    id       INT PRIMARY KEY AUTO_INCREMENT,
    employee INT      NOT NULL,
    dt       DATETIME NOT NULL,
    CONSTRAINT fk_home_delivery_employee FOREIGN KEY (employee) REFERENCES employee (id)
    -- CONSTRAINT home_delivery_check_employee CHECK ( ...? )
);

-- "order" (comanda en anglès) és sql reserved word, faig servir "sale".
-- "price" és decimal perquè float pot donar problemes d'exactitut en decimals quan es treballa en moneda. Li he posat 3 dígits de part entera i 2 de decimal.
-- TODO No se com fer que tingui com a mínim una línia de producte (== mínim un sale_line fk apuntant cada sale perquè pugui existir)
CREATE TABLE sale
(
    id            INT PRIMARY KEY AUTO_INCREMENT,
    dt            DATETIME      NOT NULL,
    client        INT           NOT NULL,
    delivery      ENUM ('home_address', 'store_pickup'),
    total_price   DECIMAL(5, 2) NOT NULL,
    store         INT           NOT NULL,
    home_delivery INT,
    CONSTRAINT fk_sale_client FOREIGN KEY (CLIENT) REFERENCES CLIENT (id),
    -- CONSTRAINT check_sale_min_1_product CHECK ( ...? ),
    CONSTRAINT fk_sale_store FOREIGN KEY (store) REFERENCES store (id),
    CONSTRAINT fk_sale_home_delivery FOREIGN KEY (home_delivery) REFERENCES home_delivery (id),
    CONSTRAINT check_sale_home_delivery CHECK (
            (NOT (delivery = 'home_address') AND home_delivery IS NULL) OR
            (delivery = 'home_address' AND home_delivery IS NOT NULL))
);

CREATE TABLE pizza_category
(
    id   INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(30) NOT NULL
);
CREATE TABLE product
(
    id             INT PRIMARY KEY AUTO_INCREMENT,
    type           ENUM ('pizza', 'burger', 'beverage'),
    name           VARCHAR(30)   NOT NULL,
    description    VARCHAR(100)  NOT NULL,
    image          BLOB          NOT NULL,
    price          DECIMAL(5, 2) NOT NULL,
    pizza_category INT,
    CONSTRAINT fk_product_pizza_category FOREIGN KEY (pizza_category) REFERENCES pizza_category (id),
    CONSTRAINT product_pizza_category_notnull CHECK (
            (NOT (type = 'pizza') AND pizza_category IS NULL) OR
            (type = 'pizza' AND pizza_category IS NOT NULL))
);

CREATE TABLE sale_line
(
    id          INT PRIMARY KEY AUTO_INCREMENT,
    sale        INT           NOT NULL,
    product     INT           NOT NULL,
    quantity    INT           NOT NULL,
    total_price DECIMAL(5, 2) NOT NULL,
    CONSTRAINT fk_sale_line_sale FOREIGN KEY (sale) REFERENCES sale (id),
    CONSTRAINT fk_sale_line_product FOREIGN KEY (product) REFERENCES product (id)
);

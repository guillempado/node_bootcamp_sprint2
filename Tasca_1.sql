-- NIVELL 1.1 - Òptica

CREATE DATABASE Optica;
USE Optica;

/*
Observacions:
    - num és varchar perquè podria ser per exemple num "130 (bis)"
    - flat és varchar perquè podria ser entresòl o baixos
    - door és varchar perquè hi ha comunitats amb diferents escales que numeren les portes des d'1 altre cop per cada pis i escala -per exemple, num 103 3r 2A seria diferent a num 103 3r 2B.
    - flat i door poden ser null, per exemple si l'adreça és d'una nau industrial
*/

CREATE TABLE address
(
    id          INT PRIMARY KEY AUTO_INCREMENT,
    street      VARCHAR(50) NOT NULL,
    num         VARCHAR(10) NOT NULL,
    flat        VARCHAR(10),
    door        VARCHAR(6),
    city        VARCHAR(30) NOT NULL,
    postal_code VARCHAR(10) NOT NULL,
    country     VARCHAR(30) NOT NULL
);

/*
Observacions:
    - Format del NIF: http://www.juntadeandalucia.es/servicios/madeja/contenido/recurso/677
    - Deixo fax com a possible null -hi ha empreses que avui dia ja no en tenen.
    - Poso e NIF de primary key perquè ja és un identificador únic.
*/

CREATE TABLE provider
(
    nif          VARCHAR(9) PRIMARY KEY,
    name         VARCHAR(30) NOT NULL,
    address      INT         NOT NULL,
    phone_number VARCHAR(20) NOT NULL,
    fax_number   VARCHAR(20),
    CONSTRAINT fk_provider_address FOREIGN KEY (address) REFERENCES address (id)
);

CREATE TABLE brand
(
    id       INT PRIMARY KEY AUTO_INCREMENT,
    name     VARCHAR(30) NOT NULL,
    provider VARCHAR(9),
    CONSTRAINT fk_brand_provider FOREIGN KEY (provider) REFERENCES provider (nif)
);


/*
Observacions:
    - La marca la resolc amb FK a una altra taula per fer FK a provider de manera que brand <-> provider sigui many-to-one.
*/
CREATE TABLE glasses
(
    id               INT PRIMARY KEY AUTO_INCREMENT,
    brand            INT                                 NOT NULL,
    correction_right FLOAT                               NOT NULL,
    correction_left  FLOAT                               NOT NULL,
    mount_type       ENUM ('floating', 'paste', 'metal') NOT NULL,
    mount_color      VARCHAR(30)                         NOT NULL,
    glass_color      VARCHAR(30)                         NOT NULL,
    price            FLOAT                               NOT NULL,
    CONSTRAINT fk_glasses_brand FOREIGN KEY (brand) REFERENCES brand (id)
);


/*
Observacions:
    - Hi ha molts camps sense "not null" perquè no té sentit que s'obligui als clients a donar dades, ja que si un client no les vol donar, no té sentit perdre la venda.
    - El nom sí que el poso obligatori perquè és la info mínima que donarà un client sobre si mateix. Sense aquesta, el que hauríem de fer seria no entrar registre del client concret. L'altre seria un mètode de contacte, sigui el telèfon o el correu.
*/
CREATE TABLE client
(
    id           INT PRIMARY KEY AUTO_INCREMENT,
    email        VARCHAR(50) UNIQUE,
    name         VARCHAR(30) NOT NULL,
    address      INT,
    phone_number VARCHAR(20) UNIQUE,
    registration DATE        NOT NULL,
    referred_by  INT,
    CONSTRAINT fk_client_address FOREIGN KEY (address) REFERENCES address (id),
    CONSTRAINT fk_client_referred_by FOREIGN KEY (referred_by) REFERENCES client (id),
    CONSTRAINT client_phone_or_email_not_null CHECK (phone_number OR email IS NOT NULL)
);

/*
 Observacions:
    - l'enunciat no especifica els camps
*/
CREATE TABLE employee
(
    id   INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(30) NOT NULL
);

/*
 Observacions:
    - Pot passar que es doni una venta a un client no registrat, perquè davant del fet que un client no vulgui donar les dades no té sentit perdre la venda.
 */
CREATE TABLE sale
(
    id        INT PRIMARY KEY AUTO_INCREMENT,
    glasses   INT  NOT NULL,
    employee  INT  NOT NULL,
    client    INT,
    sale_date DATE NOT NULL,
    CONSTRAINT fk_sale_glasses FOREIGN KEY (glasses) REFERENCES glasses (id),
    CONSTRAINT fk_sale_employee FOREIGN KEY (employee) REFERENCES employee (id),
    CONSTRAINT fk_sale_client FOREIGN KEY (client) REFERENCES client (id)
);



CREATE DATABASE Spotify;
USE Spotify;

CREATE TABLE user
(
    id         INT PRIMARY KEY AUTO_INCREMENT,
    type       ENUM ('free', 'premium')            NOT NULL,
    email      VARCHAR(50)                         NOT NULL,
    username   VARCHAR(30)                         NOT NULL,
    birthdate  DATE                                NOT NULL,
    gender     ENUM ('male','female','non-binary') NOT NULL,
    country    VARCHAR(50)                         NOT NULL,
    postalcode VARCHAR(10)                         NOT NULL
);

CREATE TABLE credit_card
(
    id               INT PRIMARY KEY AUTO_INCREMENT,
    card_number      INT NOT NULL,
    expiration_month INT NOT NULL,
    expiration_year  INT NOT NULL,
    security_code    INT NOT NULL,
    user             INT NOT NULL,
    CONSTRAINT fk_credit_card_user FOREIGN KEY (user) REFERENCES user (id)
);

CREATE TABLE paypal
(
    id       INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL,
    user     INT         NOT NULL,
    CONSTRAINT fk_paypal_user FOREIGN KEY (user) REFERENCES user (id)
);

CREATE TABLE subscription
(
    id           INT PRIMARY KEY AUTO_INCREMENT,
    user         INT                            NOT NULL,
    start_date   DATE                           NOT NULL,
    renewal_date DATE                           NOT NULL,
    credit_card  INT,
    paypal       INT,
    payment      ENUM ('credit_card', 'paypal') NOT NULL,

    CONSTRAINT fk_subscription_user FOREIGN KEY (user) REFERENCES user (id),
    CONSTRAINT fk_subscription_credit_card FOREIGN KEY (credit_card) REFERENCES credit_card (id),
    CONSTRAINT fk_subscription_paypal FOREIGN KEY (paypal) REFERENCES paypal (id),
    CONSTRAINT check_subscription_has_one_payment CHECK (credit_card IS NOT NULL XOR paypal IS NOT NULL)
);

CREATE TABLE payment
(
    invoice_number INT PRIMARY KEY,
    charge_date    DATE          NOT NULL,
    total_amount   DECIMAL(5, 2) NOT NULL,
    subscription   INT           NOT NULL,
    CONSTRAINT fk_payment_subscription FOREIGN KEY (subscription) REFERENCES subscription (id)
);

-- Si date deleted és null, llista no ha estat eliminada, en cas contrari sabrem que ho ha estat i la data
CREATE TABLE playlist
(
    id              INT PRIMARY KEY AUTO_INCREMENT,
    title           VARCHAR(30) NOT NULL,
    number_of_songs INT         NOT NULL,
    creation_date   DATE        NOT NULL,
    date_deleted    DATE,
    user            INT         NOT NULL,
    CONSTRAINT fk_playlist_user FOREIGN KEY (user) REFERENCES user (id)
);


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
    shared          BOOLEAN     NOT NULL,
    author          INT         NOT NULL,
    CONSTRAINT fk_playlist_author FOREIGN KEY (author) REFERENCES user (id),
    CONSTRAINT check_playlist_against_deleted_and_shared CHECK (
        NOT (shared = TRUE AND date_deleted IS NOT NULL)
        )
);


CREATE TABLE artist
(
    id    INT PRIMARY KEY AUTO_INCREMENT,
    name  VARCHAR(50) NOT NULL,
    image BLOB        NOT NULL
);

CREATE TABLE album
(
    id                  INT PRIMARY KEY AUTO_INCREMENT,
    title               VARCHAR(200) NOT NULL,
    year_of_publication INT(4)       NOT NULL,
    cover               BLOB         NOT NULL,
    artist              INT          NOT NULL,
    CONSTRAINT fk_album_artist FOREIGN KEY (artist) REFERENCES artist (id)

);

CREATE TABLE song
(
    id           INT PRIMARY KEY AUTO_INCREMENT,
    title        VARCHAR(200) NOT NULL,
    duration     TIME         NOT NULL,
    times_played INT          NOT NULL,
    album        INT          NOT NULL,
    CONSTRAINT fk_song_album FOREIGN KEY (album) REFERENCES album (id)

);

-- cada cançó només pot ser afegida un cop a una playlist, per això playlist + song == clau primària composta
-- added_by és un usuari qualsevol que ha afegit la cançó a una playlist creada i compartida per ell mateix o un altre usuari
CREATE TABLE playlist_item
(
    playlist INT,
    song     INT,
    added_by INT  NOT NULL,
    added_on DATE NOT NULL,
    CONSTRAINT pk_playlist_item PRIMARY KEY (playlist, song),
    CONSTRAINT fk_playlist_item_playlist FOREIGN KEY (playlist) REFERENCES playlist (id),
    CONSTRAINT fk_playlist_item_song FOREIGN KEY (song) REFERENCES song (id),
    CONSTRAINT fk_playlist_item_added_by FOREIGN KEY (added_by) REFERENCES user (id)
);

CREATE TABLE user_followed_artist
(
    user   INT,
    artist INT,
    CONSTRAINT pk_user_followed_artist PRIMARY KEY (user, artist),
    CONSTRAINT fk_user_followed_artist_user FOREIGN KEY (user) REFERENCES user (id),
    CONSTRAINT fk_user_followed_artist_artist FOREIGN KEY (artist) REFERENCES artist (id)
);

CREATE TABLE similar_artist
(
    artist         INT,
    similar_artist INT,
    CONSTRAINT pk_similar_artist PRIMARY KEY (artist, similar_artist),
    CONSTRAINT fk_similar_artist_artist FOREIGN KEY (artist) REFERENCES artist (id),
    CONSTRAINT fk_similar_artist_similar_artist FOREIGN KEY (similar_artist) REFERENCES artist (id)
);

CREATE TABLE user_favorite_song
(
    user INT,
    song INT,
    CONSTRAINT pk_user_favorite_song PRIMARY KEY (user, song),
    CONSTRAINT fk_user_favorite_song_user FOREIGN KEY (user) REFERENCES user (id),
    CONSTRAINT fk_user_favorite_song_song FOREIGN KEY (song) REFERENCES song (id)
);

CREATE TABLE user_favorite_album
(
    user  INT,
    album INT,
    CONSTRAINT pk_user_favorite_album PRIMARY KEY (user, album),
    CONSTRAINT fk_user_favorite_album_user FOREIGN KEY (user) REFERENCES user (id),
    CONSTRAINT fk_user_favorite_album_album FOREIGN KEY (album) REFERENCES album (id)
);
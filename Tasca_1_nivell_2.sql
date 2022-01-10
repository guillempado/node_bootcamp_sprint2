CREATE DATABASE Youtube;
USE Youtube;

CREATE TABLE user
(
    id          INT PRIMARY KEY AUTO_INCREMENT,
    email       VARCHAR(50)                           NOT NULL,
    password    VARCHAR(30)                           NOT NULL,
    name        VARCHAR(30)                           NOT NULL,
    birth       DATE                                  NOT NULL,
    gender      ENUM ('male', 'female', 'non-binary') NOT NULL,
    country     VARCHAR(30)                           NOT NULL,
    postal_code VARCHAR(10)                           NOT NULL
);
CREATE TABLE video
(
    id                  INT PRIMARY KEY AUTO_INCREMENT,
    title               VARCHAR(100)                         NOT NULL,
    description         TEXT                                 NOT NULL,
    size_in_bytes       INT                                  NOT NULL,
    filename            VARCHAR(100)                         NOT NULL,
    duration_in_seconds INT                                  NOT NULL,
    thumbnail           BLOB                                 NOT NULL,
    views               INT                                  NOT NULL,
    likes               INT                                  NOT NULL,
    dislikes            INT                                  NOT NULL,
    author              INT                                  NOT NULL,
    publication_dt      DATETIME                             NOT NULL,
    state               ENUM ('public', 'hidden', 'private') NOT NULL,

    CONSTRAINT fk_video_author FOREIGN KEY (author) REFERENCES user (id)
);

CREATE TABLE video_tag
(
    id    INT PRIMARY KEY AUTO_INCREMENT,
    name  VARCHAR(30) NOT NULL,
    video INT         NOT NULL,
    CONSTRAINT fk_video_tag_video FOREIGN KEY (video) REFERENCES video (id)
);

CREATE TABLE channel
(
    id            INT PRIMARY KEY AUTO_INCREMENT,
    name          VARCHAR(30) NOT NULL,
    description   TEXT        NOT NULL,
    creation_date DATE        NOT NULL,
    author        INT         NOT NULL,
    CONSTRAINT fk_channel_author FOREIGN KEY (author) REFERENCES user (id)

);

-- user + channel son pk composta (per això no cal posar not null)
CREATE TABLE user_subscribed_channels
(
    user    INT,
    channel INT,
    CONSTRAINT pk_user_subscribed_channels PRIMARY KEY (user, channel),
    CONSTRAINT fk_user_subscribed_channels_user FOREIGN KEY (user) REFERENCES user (id),
    CONSTRAINT fk_user_subscribed_channels_channel FOREIGN KEY (channel) REFERENCES channel (id)
);

-- Com que user + video és pk composta, cada combinació user + vídeo serà única i per tant cada usuari només podrà donar like/dislike un cop a cada vídeo i de manera excloent
CREATE TABLE video_like
(
    author INT,
    video  INT,
    state  ENUM ('like', 'dislike') NOT NULL,
    dt     DATETIME                 NOT NULL,
    CONSTRAINT pk_video_like PRIMARY KEY (author, video),
    CONSTRAINT fk_video_like_user FOREIGN KEY (author) REFERENCES user (id),
    CONSTRAINT fk_video_like_video FOREIGN KEY (video) REFERENCES video (id)
);

CREATE TABLE playlist
(
    id            INT PRIMARY KEY AUTO_INCREMENT,
    name          VARCHAR(50) NOT NULL,
    creation_date DATE        NOT NULL,
    state         ENUM ('public', 'private'),
    author        INT,
    CONSTRAINT fk_playlist_author FOREIGN KEY (author) REFERENCES user (id)
);

-- Posant una id de primary key m'asseguro que un mateix usuari pugui afegir tants comentaris com vulgui a un mateix vídeo
CREATE TABLE comment
(
    id          INT PRIMARY KEY AUTO_INCREMENT,
    author      INT      NOT NULL,
    video       INT      NOT NULL,
    content     TEXT     NOT NULL,
    creation_dt DATETIME NOT NULL,
    CONSTRAINT fk_comment_author FOREIGN KEY (author) REFERENCES user (id),
    CONSTRAINT fk_comment_video FOREIGN KEY (video) REFERENCES video (id)
);

CREATE TABLE comment_like
(
    author  INT,
    comment INT,
    state   ENUM ('like', 'dislike') NOT NULL,
    dt      DATETIME                 NOT NULL,
    CONSTRAINT pk_comment_like PRIMARY KEY (author, comment),
    CONSTRAINT fk_comment_like_author FOREIGN KEY (author) REFERENCES user (id),
    CONSTRAINT fk_comment_like_comment FOREIGN KEY (comment) REFERENCES comment (id)
);
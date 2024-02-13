CREATE TABLE users (
    user_id             INTEGER         NOT NULL,
    username            TEXT            NOT NULL,
    password            TEXT            NOT NULL,
    approved            TEXT            CHECK (approved IN ('Pending', 'Approved', 'Rejected')) DEFAULT 'Pending',
    first_name          TEXT,
    last_name           TEXT,
    age                 INTEGER,
    email               TEXT,
    phone               TEXT,
    gender              TEXT,
    -------------------------------------------------
    PRIMARY KEY (user_id),
    FOREIGN KEY (username) REFERENCES login(username)
);



CREATE TABLE login (
    username            TEXT            NOT NULL,
    password            TEXT            NOT NULL,
    -------------------------------------------------
    FOREIGN KEY (username) REFERENCES users(username)
);


CREATE TABLE coordinators (
    coordinator_id      INTEGER         NOT NULL,
    ------------------------------------------------
    PRIMARY KEY (coordinator_id)
    FOREIGN KEY (user_id) REFERENCES users (user_id)
);

CREATE TABLE admin (
    user_id             INTEGER         NOT NULL,
    ------------------------------------------------
    FOREIGN KEY (user_id) REFERENCES users (user_id)
);


CREATE TABLE clubs(
    club_id             INTEGER
    club_name           TEXT,
    club_description    TEXT,
    coordinator_id      INTEGER,
    validity            TEXT            CHECK (validity IN ('Pending', 'Approved', 'Rejected')) DEFAULT 'Pending',
    created             DATETIME        DEFAULT CURRENT_TIMESTAMP,
    updated             DATETIME        DEFAULT CURRENT_TIMESTAMP,
    --------------------------------------------------------------------
    PRIMARY KEY (club_id),
    FOREIGN KEY (coordinator_id) REFERENCES coordinators(coordinator_id)
);

CREATE TABLE club_memberships(
    club_id             INTEGER,
    user_id             INTEGER,
    validity            TEXT            CHECK (validity IN ('Pending', 'Approved', 'Rejected')),
    created             DATETIME        DEFAULT CURRENT_TIMESTAMP,
    updated             DATETIME        DEFAULT CURRENT_TIMESTAMP,
    -----------------------------------------------
    PRIMARY KEY (club_id, user_id),
    FOREIGN KEY (club_id) REFERENCES clubs(club_id)
);


CREATE TABLE events(
    event_id            INTEGER,
    club_id             INTEGER,
    event_name          TEXT,
    event_description   TEXT,
    date_and_time       DATETIME,
    venue               TEXT,
    created             DATETIME        DEFAULT CURRENT_TIMESTAMP,
    updated             DATETIME        DEFAULT CURRENT_TIMESTAMP,
    -----------------------------------------------
    PRIMARY KEY (event_id),
    FOREIGN KEY (club_id) REFERENCES clubs(club_id)
);

CREATE TABLE if event_participants(
    event_id            INTEGER,
    user_id             INTEGER,
    validity            TEXT            CHECK (validity IN ('Pending', 'Approved', 'Rejected')),
    created             DATETIME        DEFAULT CURRENT_TIMESTAMP,
    updated             DATETIME        DEFAULT CURRENT_TIMESTAMP,
    --------------------------------------------------
    PRIMARY KEY (event_id, user_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
    FOREIGN KEY (event_id) REFERENCES events(event_id)
);



CREATE TRIGGER check_max_clubs
BEFORE INSERT ON club_memberships
BEGIN
    SELECT CASE
        WHEN (SELECT COUNT(*) FROM club_memberships WHERE user_id = NEW.user_id) >= 3
        THEN
            RAISE(ABORT, 'Cannot add more than 3 clubs for a user');
    END;
END;



CREATE DATABASE training_db;




CREATE TABLE users (
    id         SERIAL PRIMARY KEY,
    name       VARCHAR(100) NOT NULL,
    email      VARCHAR(150) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE addresses (
    id      SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL,
    city    VARCHAR(100) NOT NULL,
    street  VARCHAR(200),
    zip     VARCHAR(20)
);


ALTER TABLE addresses
ADD CONSTRAINT fk_addresses_user
FOREIGN KEY (user_id) REFERENCES users(id)
ON DELETE CASCADE;

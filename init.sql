-- init.sql

-- Create a new database
CREATE DATABASE movies;

-- Connect to the newly created database
\c movies

-- Create a new user with a password
CREATE USER username WITH ENCRYPTED PASSWORD 'password';

-- Grant all privileges on the database to the new user
GRANT ALL PRIVILEGES ON DATABASE movies TO username;

-- Create a new table
CREATE TABLE movies (
    id SERIAL PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    description VARCHAR(255)
);
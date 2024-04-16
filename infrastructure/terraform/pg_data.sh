#!/bin/bash
sudo apt-get update
sudo apt-get install -y postgresql

sudo -u postgres psql << EOF
CREATE DATABASE todo_db;
CREATE USER todo WITH PASSWORD 'password';
GRANT ALL PRIVILEGES ON DATABASE todo_db TO todo;
CREATE TABLE IF NOT EXISTS todo (
    id SERIAL PRIMARY KEY,
    title VARCHAR(100),
    complete BOOLEAN
);
EOF

sudo echo "listen_addresses = '*'" >> /etc/postgresql/14/main/postgresql.conf
sudo echo "host    all             all             0.0.0.0/0            md5" >> /etc/postgresql/14/main/pg_hba.conf
sudo service postgresql restart
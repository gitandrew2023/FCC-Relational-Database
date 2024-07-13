#!/bin/bash
echo -e "\n~~Create database&table for Salon~~\n"

# create variable PSQL to allow us to query database
PSQL="psql --username=freecodecamp --dbname=postgres --no-align --tuples-only -c"

# Investigating the data 
# to run script: ./salon_create.sh


echo -e "\n~~Drop database salon~~\n"
echo "$($PSQL "DROP DATABASE IF EXISTS salon;")"

echo -e "\n~~Create database salon~~\n"
echo "$($PSQL "CREATE DATABASE salon;")"

PSQL="psql --username=freecodecamp --dbname=salon --no-align --tuples-only -c"
# Connect database
echo "$($PSQL "\c salon;")"

# Drop tables
echo "$($PSQL "DROP TABLE IF EXISTS customers CASCADE;")"

echo "$($PSQL "DROP TABLE IF EXISTS appointments CASCADE;")"

echo "$($PSQL "DROP TABLE IF EXISTS services CASCADE;")"

# Create table customers
echo "$($PSQL "CREATE TABLE customers(customer_id SERIAL NOT NULL,
  phone VARCHAR UNIQUE,
  name VARCHAR NOT NULL);")"

# Create table appointments
echo "$($PSQL "CREATE TABLE appointments(appointment_id SERIAL NOT NULL, time VARCHAR NOT NULL, customer_id INT NOT NULL, service_id INT NOT NULL);")"
# Create tabble services
echo "$($PSQL "CREATE TABLE services(service_id SERIAL NOT NULL, name VARCHAR NOT NULL);")"

# Create PRIMARY KEY
echo "$($PSQL "ALTER TABLE customers ADD PRIMARY KEY(customer_id);")"

echo "$($PSQL "ALTER TABLE appointments ADD PRIMARY KEY(appointment_id);")"

echo "$($PSQL "ALTER TABLE services ADD PRIMARY KEY(service_id);")"

# Create FOREIGN KEY
echo "$($PSQL "ALTER TABLE appointments ADD FOREIGN KEY(customer_id) REFERENCES customers(customer_id);")"

echo "$($PSQL "ALTER TABLE appointments ADD FOREIGN KEY(service_id) REFERENCES services(service_id);")"

# Insert data into services
echo "$($PSQL "INSERT INTO services(name) VALUES('cut'),('color'),('perm'),('style'),('trim');")"






-- Creación de la Base de Datos
CREATE DATABASE DIDI
USE DIDI

-- Tabla date_info:
CREATE TABLE date_info (
calendar_date date,
day_of_week varchar(10), -- El valor mas grande es de 9 caracteres y promedio de 7
holiday_flg int,
PRIMARY KEY(calendar_date))

-- Tabla store_info:
CREATE TABLE store_info (
store_id char(16), -- Todos los valores son de 16 caracteres
genre_name varchar(50), -- El valor mas grande es de 28 caracteres y promedio de 28
area_name nvarchar(50), -- El valor mas grande es de 49 caracteres y promedio de 32
latitude float,
longitude float,
PRIMARY KEY (store_id))

-- Tabla restaurants_visitors:
CREATE TABLE restaurants_visitors (
id char(16), -- Todos los valores son de 16 caracteres
reserve_visitors int,
visit_datetime datetime,
visit_date date,
reserve_datetime datetime,
FOREIGN KEY (id) REFERENCES store_info(store_id),
FOREIGN KEY (visit_date) REFERENCES date_info(calendar_date)
);


SELECT * FROM store_info
SELECT * FROM date_info
SELECT * FROM restaurants_visitors
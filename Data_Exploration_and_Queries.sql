USE DIDI

SELECT *
FROM restaurants_visitors



-- SQL QUERIES FOR QUESTIONS 1 to 3

--  1. Write the SQL queries necessary to generate a list of the five restaurants that have the highest average number of visitors on holidays. The result table should also contain that average per restaurant.

SELECT TOP 5 id, genre_name, area_name, AVG(reserve_visitors) AS 'avg_visitors_holidays'
FROM restaurants_visitors
JOIN date_info ON calendar_date = visit_date
JOIN store_info ON store_id = id
WHERE holiday_flg = 1
GROUP BY id, genre_name, area_name
ORDER BY 'avg_visitors_holidays' DESC

-- 2. Use SQL to discover which day of the week there are usually more visitors on average in restaurants.SELECT day_of_week, AVG(reserve_visitors) AS 'avg_visitors'
FROM date_info
JOIN restaurants_visitors ON visit_date = calendar_date
GROUP BY day_of_week
ORDER BY 'avg_visitors' DESC


-- 3. How was the percentage of growth of the amount of visitors week over week for the last four weeks of the data? Use SQL too.
WITH CTE AS (
    SELECT TOP 5 DATEPART(wk, visit_date) AS week_num, SUM(reserve_visitors) AS total_visitors, ROW_NUMBER() OVER (ORDER BY DATEPART(wk, visit_date) DESC) AS rn1
    FROM restaurants_visitors
	WHERE YEAR(visit_date) = 2017
    GROUP BY DATEPART(wk, visit_date)
)

SELECT T1.week_num, T1.total_visitors, ((T1.total_visitors - T2.total_visitors) * 1.0 / T2.total_visitors) * 100 AS 'Percentage_Change'
FROM CTE T1
LEFT JOIN CTE T2 ON T1.rn1 = T2.rn1 - 1;









-- Queries for data exploration


-- Numero de Restaurantes con registros de reservas en la tabla restaurants_visitors
SELECT COUNT(DISTINCT id) as 'Restaurants'
FROM restaurants_visitors

-- Restaurantes con suma Total de Visitantes acomodados en orden descendente
SELECT id, SUM(reserve_visitors) AS 'Total Visitantes'
FROM restaurants_visitors
GROUP BY id
ORDER BY 'Total Visitantes' DESC

-- Restaurantes con Promedio de Visitantes acomodados en orden descendente
SELECT id, AVG(reserve_visitors) AS 'Promedio Visitantes'
FROM restaurants_visitors
GROUP BY id
ORDER BY 'Promedio Visitantes' DESC

-- Restaurantes con Total de Visitantes y Promedio de Visitantes acomodados por Total de Visitantes en orden descendente
SELECT id, SUM(reserve_visitors) AS 'Total Visitantes', AVG(reserve_visitors) AS 'Promedio Visitantes'
FROM restaurants_visitors
GROUP BY id
ORDER BY 'Total Visitantes' DESC

-- Numero de fechas en la tabla date_info
SELECT COUNT(calendar_date)
FROM date_info

-- Numero de Holidays por Dia de la Semana en la tabla date_info
SELECT day_of_week, COUNT(holiday_flg) as 'Holidays'
FROM date_info
WHERE holiday_flg = 1
GROUP BY day_of_week
ORDER BY 'Holidays' DESC

-- Numero de Holidays por Dia de la Semana en el año 2016
SELECT day_of_week, COUNT(holiday_flg) as 'Holidays'
FROM date_info
WHERE holiday_flg = 1 AND YEAR(calendar_date) = 2016
GROUP BY day_of_week
ORDER BY 'Holidays' DESC

-- Numero de Holidays por Dia de la Semana en el año 2017
SELECT day_of_week, COUNT(holiday_flg) as 'Holidays'
FROM date_info
WHERE holiday_flg = 1 AND YEAR(calendar_date) = 2017
GROUP BY day_of_week
ORDER BY 'Holidays' DESC

-- Restaurantes con Promedio de Visitas en dias festivos
SELECT id, AVG(reserve_visitors) AS 'Promedio de Visitas', holiday_flg
FROM restaurants_visitors
JOIN date_info ON calendar_date = visit_date
WHERE holiday_flg = 1
GROUP BY id, holiday_flg
ORDER BY 'Promedio de Visitas' DESC

-- Id, genero del restaurante y promedio de visitas de los restaurantes en dias festivos
SELECT id, genre_name,  AVG(reserve_visitors) AS 'Promedio de Visitas'
FROM restaurants_visitors
JOIN date_info ON calendar_date = visit_date
JOIN store_info ON store_id = id
WHERE holiday_flg = 1
GROUP BY id, genre_name
ORDER BY 'Promedio de Visitas' DESC

-- Total de visitas por day of week
SELECT day_of_week, SUM(reserve_visitors) AS 'Total de Visitas'
FROM date_info
JOIN restaurants_visitors ON visit_date = calendar_date
GROUP BY day_of_week
ORDER BY 'Total de Visitas' DESC

-- !! REGISTRO INCORRECTO (Fecha de visita es menor que la fecha de reserva)
SELECT * 
FROM restaurants_visitors
WHERE visit_datetime < reserve_datetime

-- Borrar registro equivocado
DELETE FROM restaurants_visitors
WHERE visit_datetime < reserve_datetime-- Numero Total de Visitantes por numero de semana en el año 2017 en orden descendente por semanaSELECT DATEPART(wk, visit_date) AS 'WeekNumber', SUM(reserve_visitors) as 'Total de Visitantes'FROM restaurants_visitorsWHERE YEAR(visit_date) = 2017GROUP BY DATEPART(wk, visit_date)ORDER BY 'WeekNumber' DESC-- Numero Total de Visitantes por numero de semana y separadaos por id del restaurante en el año 2017 en orden descendente por semanaSELECT id,DATEPART(wk, visit_date) AS 'WeekNumber', SUM(reserve_visitors) as 'Total de Visitantes'FROM restaurants_visitorsWHERE YEAR(visit_date) = 2017GROUP BY id,DATEPART(wk, visit_date)ORDER BY 'WeekNumber' DESC
-- Suma total de visitantes para los meses del 06-2016 al 11-2016
SELECT MONTH(visit_date), SUM(reserve_visitors)
FROM restaurants_visitors
WHERE MONTH(visit_date) > 05 AND MONTH(visit_date) < 12 AND YEAR(visit_date) = 2016
GROUP BY MONTH(visit_date)
ORDER BY MONTH(visit_date) ASC

-- Numero Total de Visitantes por mes en orden descendente por mesSELECT YEAR(visit_date) AS 'Año', MONTH(visit_date) AS 'Numero de Mes', SUM(reserve_visitors) as 'Total de Visitantes'
FROM restaurants_visitors
GROUP BY YEAR(visit_date), MONTH(visit_date)
ORDER BY 'Año', 'Numero de Mes'

-- Tipos de restaurantes
SELECT genre_name, COUNT(genre_name) AS 'Cantidad de Restaurantes'
FROM store_info
JOIN restaurants_visitors ON id = store_id
GROUP BY genre_name
ORDER BY 'Cantidad de Restaurantes' DESC

-- Mes, total de visitantes y promedio de visitantes en el 2016
SELECT MONTH(calendar_date) AS 'Mes', SUM(reserve_visitors) AS 'Total Visitantes', AVG(reserve_visitors) AS 'Promedio Visitantes'
FROM date_info
JOIN restaurants_visitors ON visit_date = calendar_date
WHERE YEAR(calendar_date) = 2016 
GROUP BY MONTH(calendar_date)
ORDER BY MONTH(calendar_date) 

-- id del restaurante, day of week y total de visitantes para noviembre del 2016 en dias festivos
SELECT id, day_of_week, SUM(reserve_visitors) AS 'Total Visitantes'
FROM date_info
JOIN restaurants_visitors ON calendar_date = visit_date
WHERE YEAR(calendar_date) = 2016 AND holiday_flg = 1 AND MONTH(calendar_date) = 11
GROUP BY id,day_of_week
ORDER BY day_of_week,'Total Visitantes' DESC

-- day of week, total de visitantes y promedio de visitantes para diciembre del 2016
SELECT MONTH(calendar_date)AS 'MES', day_of_week, SUM(reserve_visitors) AS 'Total Visitantes', AVG(reserve_visitors) AS 'Promedio Visitantes'
FROM date_info
JOIN restaurants_visitors ON calendar_date = visit_date
WHERE YEAR(calendar_date) = 2016 AND MONTH(calendar_date) = 12
GROUP BY MONTH(calendar_date), day_of_week
ORDER BY MONTH(calendar_date), day_of_week,'Total Visitantes' DESC

-- restauranes, genero y suma total de visitanets
SELECT id, genre_name, sum(reserve_visitors) AS 'Total Visitantes'
FROM store_info
JOIN restaurants_visitors ON store_id = id
GROUP BY id, genre_name 
ORDER BY 'Total Visitantes' DESC

-- cantidad de restaurantes por genero
SELECT genre_name, COUNT(genre_name)
FROM store_info
GROUP BY genre_name

-- Top 5 id, genero, total de visitantes y promedio de visitanes ordenado por total de visitantes.
SELECT TOP 5 id, genre_name, SUM(reserve_visitors) AS 'Total Visitantes', AVG(reserve_visitors) AS 'Promedio Visitantes'
FROM restaurants_visitors
JOIN store_info ON store_id = id
GROUP BY id, genre_name
ORDER BY 'Total Visitantes' DESC

-- Nombres de las diferentes areas con restaurantes reportados
SELECT DISTINCT area_name
FROM restaurants_visitors
JOIN store_info ON store_id = id

-- Total de visitantes 
SELECT SUM(reserve_visitors)
FROM restaurants_visitors

-- Promedio de Visitnates por horas por dia de la semana
SELECT day_of_week, DATEPART(HOUR, visit_datetime) AS hour_of_day, AVG(reserve_visitors) AS avg_visitors
FROM restaurants_visitors
JOIN date_info ON restaurants_visitors.visit_date = date_info.calendar_date
GROUP BY day_of_week, DATEPART(HOUR, visit_datetime)
ORDER BY day_of_week, hour_of_day

-- Numero total de restaurantes por area
SELECT area_name, COUNT(DISTINCT store_id) AS 'restaurant_count'
FROM store_info
GROUP BY area_name
ORDER BY restaurant_count DESC;

-- Numero de restaurantes reportados por area
SELECT area_name, COUNT(DISTINCT store_id) AS 'restaurant_count'
FROM store_info 
JOIN restaurants_visitors ON store_id = id
GROUP BY area_name
ORDER BY 'restaurant_count' DESC;

-- Id de restaurantes, genero, total de visitantes y promedio de visitas
SELECT store_id, genre_name, SUM(reserve_visitors) AS 'total_visitors', AVG(reserve_visitors) AS 'avg_visitors'
FROM store_info
JOIN restaurants_visitors ON store_id = id
GROUP BY store_id, genre_name
ORDER BY 'total_visitors' ASC


-- Queries de Holidays

-- Numero de Holidays en la tabla date_info
SELECT COUNT(holiday_flg) as 'Holidays'
FROM date_info
WHERE holiday_flg = 1

-- Cantidad de Holidays por año
SELECT YEAR(calendar_date) as 'Año', COUNT(holiday_flg) as 'Holidays'
FROM date_info
WHERE holiday_flg = 1
GROUP BY YEAR(calendar_date)

-- Cantidad de Holidays por año y mes
SELECT YEAR(calendar_date) as 'Año', COUNT(holiday_flg) as 'Holidays'
FROM date_info
WHERE holiday_flg = 1
GROUP BY YEAR(calendar_date)

-- Frecuencia de dias Festivos por Mes, Año
SELECT YEAR(calendar_date) AS 'Año', MONTH(calendar_date) AS 'Mes', COUNT(holiday_flg) AS 'Dias Festivos'
FROM date_info
WHERE holiday_flg = 1
GROUP BY YEAR(calendar_date), MONTH(calendar_date)
ORDER BY YEAR(calendar_date), MONTH(calendar_date)

-- Day of Week de los dias festivos en 2016 
SELECT YEAR(calendar_date) AS 'Año', MONTH(calendar_date) AS 'Mes',day_of_week, COUNT(day_of_week)
FROM date_info
WHERE holiday_flg = 1 AND YEAR(calendar_date) = 2016
GROUP BY YEAR(calendar_date), MONTH(calendar_date), day_of_week
ORDER BY YEAR(calendar_date), MONTH(calendar_date)

-- Numero de dia, de los dias festivos en 2016 
SELECT YEAR(calendar_date) AS 'Año', MONTH(calendar_date) AS 'Mes',DAY(calendar_date) AS 'Dia', day_of_week
FROM date_info
WHERE holiday_flg = 1 AND YEAR(calendar_date) = 2016
GROUP BY YEAR(calendar_date), MONTH(calendar_date),DAY(calendar_date), day_of_week
ORDER BY YEAR(calendar_date), MONTH(calendar_date),DAY(calendar_date)

-- Mes, Total y Promedio de visitantes en dias festivos de 2016
SELECT MONTH(calendar_date) AS 'Mes', SUM(reserve_visitors) AS 'Total Visitantes', AVG(reserve_visitors) AS 'Promedio Visitantes'
FROM date_info
JOIN restaurants_visitors ON visit_date = calendar_date
WHERE YEAR(calendar_date) = 2016 AND holiday_flg = 1
GROUP BY MONTH(calendar_date)
ORDER BY MONTH(calendar_date)

-- Mes, Total y Promedio de visitantes en dias festivos de 2017
SELECT MONTH(calendar_date) AS 'Mes', SUM(reserve_visitors) AS 'Total Visitantes', AVG(reserve_visitors) AS 'Promedio Visitantes'
FROM date_info
JOIN restaurants_visitors ON visit_date = calendar_date
WHERE YEAR(calendar_date) = 2017 AND holiday_flg = 1
GROUP BY MONTH(calendar_date)
ORDER BY MONTH(calendar_date) 

-- Total visitantes por mes en 2016
SELECT MONTH(calendar_date) AS 'Mes', SUM(reserve_visitors) AS 'Total Visitantes'
FROM date_info
JOIN restaurants_visitors ON visit_date = calendar_date
WHERE YEAR(calendar_date) = 2016
GROUP BY MONTH(calendar_date)
ORDER BY MONTH(calendar_date)

-- Total visitantes por mes en 2017
SELECT MONTH(calendar_date) AS 'Mes', SUM(reserve_visitors) AS 'Total Visitantes'
FROM date_info
JOIN restaurants_visitors ON visit_date = calendar_date
WHERE YEAR(calendar_date) = 2017
GROUP BY MONTH(calendar_date)
ORDER BY MONTH(calendar_date) 



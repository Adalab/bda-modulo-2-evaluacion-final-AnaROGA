-- ARCHIVO TRABAJO: EJERCICIO TÉCNICO MOD 02
USE sakila;

/* Ejercicio 1:
Selecciona todos los nombres de las películas sin que aparezcan duplicados.
--> TABLA film: tenemos los nombres --> 1.000 (=film_id)
*/

SELECT DISTINCT(title)
FROM film; -- 1.000 resultados (no se repite ninguna)

                                               -- Comprobación:
-- USE tienda;
-- en tabla CUSTOMERS, el numde sales rep se repite: 122 filas
-- SELECT DISTINCT(sales_rep_employee_number)
-- FROM customers; -- 16 representantes distintos: TODO OK



/* Ejercicio 2:
Muestra los nombres de todas las películas que tengan una clasificación de "PG-13".
--> TABLA film: nombres de las películas
--> TABLA film: 'rating' está 'PG-13'  (excel = 223)
*/

SELECT title  AS 'Película PG-13'
FROM film
WHERE rating = 'PG-13'; -- 223 películas: ok



/* Ejercicio 3:
Encuentra el título y la descripción:
- todas las películas que contengan la palabra "amazing" en su descripción.

--> TABLA film: nombres de las películas
--> TABLA film: 'description' (excel = 48)
*/

SELECT title  AS 'Películas "amazing"', description AS 'Descripción'
FROM film
WHERE description LIKE '%amazing%'; -- 48 películas: ok



/* Ejercicio 4:
Encuentra el título de todas las películas que tengan:
- una duración mayor a 120 minutos.

--> TABLA film: nombres de las películas
--> TABLA film: 'length' duración en min (excel = 457)
*/

SELECT title  AS 'Películas', length AS 'Duración > 120 min'
FROM film
WHERE length > 120; -- 457 películas: ok


/* Ejercicio 5:
Recupera los nombres:
- de todos los actores.

--> TABLA actor: nombres (200 actores diferentes)
*/

SELECT CONCAT(first_name, ' ', last_name) AS 'Nombre Completo'
FROM actor; -- 200 resultados (ok)


/* Ejercicio 6:
Encuentra el nombre y apellido de los actores:
- que tengan "Gibson" en su apellido.

--> TABLA actor: first_name
--> TABLA actor: last_name (excel: Sólo 1)
*/

SELECT first_name, last_name
FROM actor
WHERE last_name LIKE '%gibson%'; -- 1 resultado (ok)



/* Ejercicio 7:
Encuentra los nombres de los actores:
- que tengan un actor_id entre 10 y 20. (11 resgistros)

--> TABLA actor: first_name / last_name / actor_id
--> TABLA film_actor: actor_id (identificación del actor que actúa en la película --> relacionarlo con film)
*/

SELECT a.first_name, a.last_name, fa.actor_id
FROM actor AS a
INNER JOIN film_actor AS fa ON a.actor_id = fa.actor_id
WHERE a.actor_id BETWEEN 10 AND 20
GROUP BY a.actor_id;    -- 11 filas: ok


/* Ejercicio 8:
Encuentra el título de las películas en la tabla film que:
- no sean ni "R" 
- ni "PG-13" en cuanto a su clasificación (=rating)

--> TABLA film: 'rating' (excel = 582 registros)
 */
 
SELECT title AS 'Películas', rating 
FROM film
WHERE rating NOT IN ('R', 'PG-13'); -- 582 resultados: ok


/* Ejercicio 9:
Encuentra:
- la cantidad total de películas en cada clasificación de la tabla film 
- y muestra la clasificación junto con el recuento.

--> TABLA film: 'rating'
 */
 
SELECT rating AS 'Clasificación', COUNT(rating) AS 'Cantidad Total Películas'
FROM film
GROUP BY rating;  

/*
'PG'--> '194' ok
'G' --> '178' ok
'NC-17'--> '210' ok
'PG-13'--> '223' ok
'R'--> '195' ok          => total: 1.000
*/

######### TODO BIEN HASTA AQUÍ ###########
 
/* Ejercicio 10:
Encuentra:
- la cantidad total de películas alquiladas por cada cliente
- y muestra el ID del cliente, su nombre y apellido junto con la cantidad de películas alquiladas.

--> TABLA customer: first_name, last_name, customer_id, 
--> TABLA rental:                          customer_id, inventory_id
*/

                                                     -- 1. TABLA rental:  
SELECT customer_id, COUNT(inventory_id) AS 'Num de alquileres'
FROM rental
GROUP BY customer_id; -- 599 customers + num de pelis que han alquilado

                              -- sale la misma info desde TABLA payment:
/*SELECT customer_id, COUNT(payment_id) 'Num de pagos'
FROM payment
GROUP BY customer_id; -- Con payment_id NOS SALEN 5 registros de más!*/

SELECT customer_id, COUNT(rental_id) 'Num de alquileres'
FROM payment
GROUP BY customer_id; 
												   -- 2.TABLA customer:
SELECT customer_id, first_name, last_name
FROM customer; -- 599 customers,

                                                      -- > SOLUCIÓN < --
SELECT c.customer_id, c.first_name, c.last_name,
	   COUNT(r.inventory_id) AS 'Num de alquileres'
FROM customer AS c
INNER JOIN rental AS r ON c.customer_id =r.customer_id 
GROUP BY c.customer_id;  -- 599 customers, num pelis cada uno ok (desde rental con inventory_id)





/* Repaso maíra
Obtener TODAS las pelis
- y si están disponibles en el inventario, mostrar la cantidad disponible*/

SELECT f.title, COUNT(DISTINCT i.inventory_id) AS 'Cantidad Disponible'
FROM film            AS f
LEFT JOIN inventory AS i           ON f.film_id = i.film_id
GROUP BY f.title;  -- 1000 resultados, ok
                                          -- Lista de las NO disponibles (42)
SELECT f.title AS 'NO Disponible'
FROM film            AS f
LEFT JOIN inventory AS i           ON f.film_id = i.film_id
GROUP BY f.title
HAVING COUNT(DISTINCT i.inventory_id) = 0;  -- 42 resultados, ok

/* Repaso maíra
clientes <-> NOMBRES pelis alquiladas */

SELECT c.customer_id, f.title
FROM customer AS c
INNER JOIN rental AS r              ON c.customer_id = r.customer_id
INNER JOIN inventory AS i           ON r.inventory_id = i.inventory_id
INNER JOIN film AS f                ON i.film_id = f.film_id;
-- customer_id del 1 al 599, ok  (1000 filas = rental 1000 registros)



/* Ejercicio 11:
Encuentra 
- la cantidad total de películas alquiladas por categoría 
- y muestra el nombre de la categoría junto con el recuento de alquileres.

--> TABLA category: name, category_id
--> TABLA film_category:  category_id, film_id
--> TABLA inventory:                   film_id, inventory_id
--> TABLA rental:                               inventory_id, rental_id
*/

                                       -- cuántas veces alquilada cada peli
SELECT f.title, COUNT(c.customer_id) AS 'Total Veces Alquilada'
FROM customer AS c
INNER JOIN rental AS r              ON c.customer_id = r.customer_id
INNER JOIN inventory AS i           ON r.inventory_id = i.inventory_id
INNER JOIN film AS f                ON i.film_id = f.film_id
GROUP BY f.title;  -- 958 filas --> 42 NO FUERON ALQUILADAS

         -- > SUBCONSULTA (basada en clientes <-> nombres pelis alquiladas)
SELECT f.title
FROM customer AS c
INNER JOIN rental AS r              ON c.customer_id = r.customer_id
INNER JOIN inventory AS i           ON r.inventory_id = i.inventory_id
INNER JOIN film AS f                ON i.film_id = f.film_id
GROUP BY f.title; -- 958 PELIS ALQUILADAS, ok (nombre)

		-- juntamos rental_id <-> inventory_id <-> film_id <-> category_id
SELECT c.category_id, c.name, COUNT(rental_id) AS 'Veces alquiladas'
FROM category AS c
INNER JOIN film_category AS fc      ON c.category_id = fc.category_id
-- INNER JOIN film AS f                ON fc.film_id = f.film_id
INNER JOIN inventory AS i			ON fc.film_id = i.film_id
INNER JOIN rental AS r 				ON i.inventory_id = r.inventory_id
GROUP BY c.category_id;
                                                         -- > SOLUCIÓN <--
SELECT c.name, COUNT(rental_id) AS 'Veces alquiladas'
FROM category AS c
INNER JOIN film_category AS fc      ON c.category_id = fc.category_id
INNER JOIN inventory AS i			ON fc.film_id = i.film_id
INNER JOIN rental AS r 				ON i.inventory_id = r.inventory_id
GROUP BY c.category_id;   -- 16 filas, ok (16.044 pelis alquiladas en total, ok)

                 
/* Ejercicio 12:
Encuentra 
- el promedio de duración de las películas 
- para cada clasificación de la tabla film  (=rating:5)
- y muestra la clasificación (junto con el promedio de duración).

--> TABLA film: eating, lenght
*/

SELECT rating AS 'Clasificación', AVG(length) AS 'Duración Promedio'
FROM film
GROUP BY rating; -- 5 resultados, ok



/* Ejercicio 13:
Encuentra
- el nombre y apellido de los actores 
- que aparecen en la película con title "Indian Love".

--> TABLA film: title, film_id
--> TABLA film_actor:  film_id, actor_id
--> TABLA actor:                actor_id, first_name, last_name
*/

										           -- en TABLA film_actor
SELECT actor_id
FROM film_actor AS fa
INNER JOIN film AS f 		ON fa.film_id = f.film_id
WHERE f.title = 'Indian Love';  -- 10 filas, 10 actores

                                                        -- > SOLUCIÓN <--
SELECT CONCAT(a.first_name, ' ', a.last_name) AS 'Actores en Indian Love'
FROM actor            AS a
WHERE actor_id IN ( SELECT actor_id
					FROM film_actor AS fa
					INNER JOIN film AS f ON fa.film_id = f.film_id
					WHERE f.title = 'Indian Love');


/* Ejercicio 14:
Muestra 
- el título de todas las películas 
- que contengan la palabra "dog" o "cat" en su descripción

--> TABLA film: title
*/

SELECT title, description
FROM film
WHERE description LIKE '%dog%'; -- 99 filas

SELECT title, description
FROM film
WHERE description LIKE '%cat%'; -- 70 filas

                                        -- > SOLUCIÓN < --
SELECT title, description
FROM film
WHERE description REGEXP 'dog|cat'; -- 167 filas


/* Ejercicio 15:
Encuentra
- el título de todas las películas 
- que fueron lanzadas entre el año 2005 y 2010.

--> TABLA film: title, release_year
*/

SELECT release_year, COUNT(film_id)
FROM film
GROUP BY release_year; -- TODAS! (en 2006)

SELECT release_year, COUNT(film_id)
FROM film
GROUP BY release_year
HAVING release_year REGEXP '[2006-2010]'; -- what?¿?¿?

SELECT title, release_year
FROM film
WHERE release_year REGEXP '[2006-2010]';

                                                 -- > SOLUCIÓN <--
SELECT title AS 'Películas lanzadas entre 2005 - 2010', release_year
FROM film
WHERE release_year IN ('2005','2006','2007','2008','2009','2010');


/* Ejercicio 16:
Encuentra 
- el título de todas las películas 
- que son de la misma categoría que "Family".

--> TABLA film:          title, film_id
--> TABLA film_category:        film_id, category_id
--> TABLA category:                      category_id, name (categoría)
*/

                                 -- Qué id tiene la categoría 'Family'
SELECT category_id, name
FROM category
WHERE name = 'Family'; -- categoría 8

                           -- cuántas pelis están en 'Family' (film_id)
SELECT film_id
FROM film_category
WHERE category_id = 8; -- 69 películas

					                            -- unimos toda esa info
SELECT c.category_id, c.name, fc.film_id
FROM category            AS c
INNER JOIN film_category AS fc     ON c.category_id = fc.category_id
WHERE c.name = 'Family'; -- 69 resultados

													-- > SOLUCIÓN <--
SELECT title AS 'Películas de categoría "Family"'
FROM film AS f
WHERE film_id IN   (SELECT fc.film_id
					FROM category AS c
					INNER JOIN film_category AS fc ON c.category_id = fc.category_id
					WHERE c.name = 'Family');



/* Ejercicio 17:
Encuentra 
- el título de todas las películas 
- que son "R" (excel: 195 pelis)
- y tienen una duración mayor a 2 horas en la tabla film. 
(excel: 457 pelis total / de R 90 pelis)

--> TABLA film: title, rating, length 
*/
/* (ej 8) Encuentra el título de las películas en la tabla film que:
- no sean ni "R" 
- ni "PG-13" en cuanto a su clasificación (=rating)
 */
 
                                                         -- películas en R
SELECT title AS 'Películas', rating 
FROM film
WHERE rating IN ('R'); -- 195 resultados: ok
-- ó
SELECT title AS 'Películas', rating 
FROM film
WHERE rating = 'R'; -- 195 resultados: ok

                                                      -- duración películas
SELECT title, length
FROM film
WHERE length > 120; -- 457 películas (de todos los rating)

                                                          -- > SOLUCIÓN <--
SELECT title AS 'Películas clasificación "R"', length AS 'Duración'
FROM film
WHERE length > 120 AND rating = 'R'; -- 90 películas 
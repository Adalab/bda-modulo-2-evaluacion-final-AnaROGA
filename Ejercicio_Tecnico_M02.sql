#### EJERCICIO TÉCNICO MOD 02 ####
-- base de datos Sakila:
USE sakila;

/* Ejercicio 1:
Selecciona todos los nombres de las películas sin que aparezcan duplicados.
--> TABLA film: tenemos los nombres 
*/

SELECT DISTINCT(title)
FROM film; 
-- 1.000 resultados (no se repite ninguna)

/* Ejercicio 2:
Muestra los nombres de todas las películas que tengan una clasificación de "PG-13".
--> TABLA film: nombres de las películas
--> TABLA film: 'rating' está 'PG-13' 
*/

SELECT title  AS 'Película PG-13'
FROM film
WHERE rating = 'PG-13'; 
-- 223 películas

/* Ejercicio 3:
Encuentra el título y la descripción:
- todas las películas que contengan la palabra "amazing" en su descripción.

--> TABLA film: nombres de las películas
--> TABLA film: 'description'
*/

SELECT title  AS 'Películas "amazing"', description AS 'Descripción'
FROM film
WHERE description LIKE '%amazing%';
 -- 48 películas

/* Ejercicio 4:
Encuentra el título de todas las películas que tengan:
- una duración mayor a 120 minutos.

--> TABLA film: nombres de las películas
--> TABLA film: 'length' duración en min
*/

SELECT title  AS 'Películas', length AS 'Duración > 120 min'
FROM film
WHERE length > 120; 
-- 457 películas

/* Ejercicio 5:
Recupera los nombres:
- de todos los actores.

--> TABLA actor: nombres 
*/

SELECT CONCAT(first_name, ' ', last_name) AS 'Nombre Completo'
FROM actor; 
-- 200 actores

/* Ejercicio 6:
Encuentra el nombre y apellido de los actores:
- que tengan "Gibson" en su apellido.

--> TABLA actor: first_name
--> TABLA actor: last_name
*/

SELECT first_name, last_name
FROM actor
WHERE last_name LIKE '%gibson%'; 
-- 1 actriz 

/* Ejercicio 7:
Encuentra los nombres de los actores:
- que tengan un actor_id entre 10 y 20. 
(11 resgistros)

--> TABLA actor: first_name / last_name / actor_id
--> TABLA film_actor: actor_id (identificación del actor que actúa en la película --> relacionarlo con film)
*/

SELECT a.first_name, a.last_name, fa.actor_id
FROM actor AS a
INNER JOIN film_actor AS fa ON a.actor_id = fa.actor_id
WHERE a.actor_id BETWEEN 10 AND 20
GROUP BY a.actor_id;    
-- 11 filas

/* Ejercicio 8:
Encuentra el título de las películas en la tabla film que:
- no sean ni "R" 
- ni "PG-13" en cuanto a su clasificación (=rating)

--> TABLA film: 'rating', title 
 */
 
SELECT title AS 'Películas', rating 
FROM film
WHERE rating NOT IN ('R', 'PG-13'); 
-- 582 resultados

/* Ejercicio 9:
Encuentra:
- la cantidad total de películas en cada clasificación de la tabla film 
- y muestra la clasificación junto con el recuento.

--> TABLA film: 'rating'
 */
 
SELECT rating AS 'Clasificación', COUNT(rating) AS 'Cantidad Total Películas'
FROM film
GROUP BY rating;  
-- 5 filas
/*
'PG'--> '194' 
'G' --> '178' 
'NC-17'--> '210' 
'PG-13'--> '223' 
'R'--> '195'           
*/
 
/* Ejercicio 10:
Encuentra:
- la cantidad total de películas alquiladas por cada cliente
- y muestra el ID del cliente, su nombre y apellido 
- junto con la cantidad de películas alquiladas.

--> TABLA customer: first_name, last_name, customer_id, 
--> TABLA rental:                          customer_id, inventory_id
*/

SELECT c.customer_id, c.first_name, c.last_name,
	   COUNT(r.inventory_id) AS 'Num de alquileres'
FROM customer AS c
INNER JOIN rental AS r ON c.customer_id =r.customer_id 
GROUP BY c.customer_id;  
-- 599 customers, num pelis cada uno

/* Ejercicio 11:
Encuentra 
- la cantidad total de películas alquiladas por categoría 
- y muestra el nombre de la categoría junto con el recuento de alquileres.

--> TABLA category: name, category_id
--> TABLA film_category:  category_id, film_id
--> TABLA inventory:                   film_id, inventory_id
--> TABLA rental:                               inventory_id, rental_id
*/

SELECT c.name, COUNT(rental_id) AS 'Veces alquiladas'
FROM category AS c
INNER JOIN film_category AS fc      ON c.category_id = fc.category_id
INNER JOIN inventory AS i			ON fc.film_id = i.film_id
INNER JOIN rental AS r 				ON i.inventory_id = r.inventory_id
GROUP BY c.category_id;   
-- 16 filas (16 categorías)
                 
/* Ejercicio 12:
Encuentra 
- el promedio de duración de las películas 
- para cada clasificación de la tabla film 
- y muestra la clasificación (junto con el promedio de duración).

--> TABLA film: eating, lenght
*/

SELECT rating AS 'Clasificación', AVG(length) AS 'Duración Promedio'
FROM film
GROUP BY rating; 
-- 5 filas (5 categorías)

/* Ejercicio 13:
Encuentra
- el nombre y apellido de los actores 
- que aparecen en la película con title "Indian Love".

--> TABLA film: title, film_id
--> TABLA film_actor:  film_id, actor_id
--> TABLA actor:                actor_id, first_name, last_name
*/

								                         -- subconsulta
SELECT actor_id
FROM film_actor AS fa
INNER JOIN film AS f 		ON fa.film_id = f.film_id
WHERE f.title = 'Indian Love';  
-- 10 filas, 10 actores

                                                        -- > SOLUCIÓN <--
SELECT CONCAT(a.first_name, ' ', a.last_name) AS 'Actores en Indian Love'
FROM actor            AS a
WHERE actor_id IN ( SELECT actor_id
					FROM film_actor AS fa
					INNER JOIN film AS f ON fa.film_id = f.film_id
					WHERE f.title = 'Indian Love');
-- 10 filas (nombres de los 10 actores)

/* Ejercicio 14:
Muestra 
- el título de todas las películas 
- que contengan la palabra "dog" o "cat" en su descripción

--> TABLA film: title
*/

SELECT 
title AS 'Título Películas'
-- description AS 'Descripción'
FROM film
WHERE description REGEXP 'dog|cat'; 
-- 167 películas

/* Ejercicio 15:
Encuentra
- el título de todas las películas 
- que fueron lanzadas entre el año 2005 y 2010.

--> TABLA film: title, release_year
*/

SELECT title AS 'Películas lanzadas entre 2005 - 2010', release_year
FROM film
WHERE release_year IN ('2005','2006','2007','2008','2009','2010');
-- 1000 películas (todas en 2006)

/* Ejercicio 16:
Encuentra 
- el título de todas las películas 
- que son de la misma categoría que "Family".

--> TABLA film:          title, film_id
--> TABLA film_category:        film_id, category_id
--> TABLA category:                      category_id, name (categoría)
*/
					                                   -- subconsulta
SELECT fc.film_id
FROM category            AS c
INNER JOIN film_category AS fc     ON c.category_id = fc.category_id
WHERE c.name = 'Family'; 
-- 69 resultados (id de las películas)

													-- > SOLUCIÓN <--
SELECT title AS 'Películas de categoría "Family"'
FROM film AS f
WHERE film_id IN   (SELECT fc.film_id
					FROM category AS c
					INNER JOIN film_category AS fc ON c.category_id = fc.category_id
					WHERE c.name = 'Family');
-- 69 películas

/* Ejercicio 17:
Encuentra 
- el título de todas las películas 
- que son "R" (excel: 195 pelis)
- y tienen una duración mayor a 2 horas en la tabla film. 

--> TABLA film: title, rating, length 
*/

SELECT title AS 'Películas clasificación "R"', length AS 'Duración'
FROM film
WHERE length > 120 AND rating = 'R'; 
-- 90 películas 
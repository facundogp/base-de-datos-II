
show tables;
select * from film;
select * from actor;
select * from film_actor;
select * from store;
select * from staff;
select * from rental;
select * from payment;
select * from category;
select * from address;
select * from country;
select * from city;
select * from inventory;
select * from customer;

#class 4

#1
select title, special_features from film;
#2
select last_update from film;
#3
select title, rental_rate, replacement_cost from film where replacement_cost between 20.00 and 24.00;
#4
select title, rating, special_features from film where special_features like '%Behind the Scenes%';
#5
select c.first_name, c.last_name, f.title from actor c, film f, film_actor fc where c.actor_id = fc.actor_id and fc.film_id = f.film_id and f.title like '%ZOOLANDER FICTION%';
#6
select address, country, city, store_id from store s, address a, country co, city ci where a.address_id = s.address_id and a.city_id = ci.city_id and ci.country_id = co.country_id and s.store_id = 1;
#7
select f1.title, f1.description, f2.title from film f1, film f2 where f1.description = f2.description;
#8
select f.title, c.first_name, c.last_name from film f, inventory i, store s, customer c where f.film_id = i.film_id and i.store_id = s.store_id and s.store_id = c.store_id and s.store_id=2;


#class 6

#1
SELECT *
FROM actor a1
WHERE EXISTS (
    SELECT *
    FROM actor a2
    WHERE a1.actor_id <> a2.actor_id
    AND a1.last_name = a2.last_name
)
ORDER BY last_name;                                        
#2
select first_name 
from actor a1 where not exists 
(select * from film_actor a2 where a1.actor_id = a2.actor_id);
#3
select * from customer c1 
where exists 
(select * from rental c2 where c1.customer_id = c2.customer_id having count(inventory_id) = 1);
#4
select * from customer c1 
where exists 
(select * from rental c2 where c1.customer_id = c2.customer_id having count(inventory_id) > 1);

#opcion1                  5
select * from actor a1 
where actor_id in 
(select actor_id from film_actor inner join film using(film_id) where actor_id = film_id and film.title = 'BETRAYED REAR' or film.title = 'CATCH AMISTAD' );
#opcion2 opcion correcta          5
select * from actor a1 where actor_id in 
(select actor_id from film_actor inner join film using(film_id) where film.title = 'BETRAYED REAR' or film.title = 'CATCH AMISTAD' );

#opcion1                     6
select * from actor a1 
where actor_id in 
(select actor_id from film_actor inner join film using(film_id) where film.title = 'BETRAYED REAR');

#opcion2 opcion correcta               6
SELECT last_name, first_name
	FROM actor
WHERE actor_id IN (SELECT actor_id
				FROM film_actor INNER JOIN film USING(film_id)
				WHERE film.title = 'BETRAYED REAR')
AND actor_id NOT IN (SELECT actor_id
					FROM film_actor INNER JOIN film using(film_id)
					WHERE film.title = 'CATCH AMISTAD');

#opcion1 mejor opcion           7                 
SELECT last_name, first_name
	FROM actor
WHERE actor_id IN (SELECT actor_id
				FROM film_actor INNER JOIN film USING(film_id)
				WHERE film.title = 'BETRAYED REAR')
AND actor_id IN (SELECT actor_id
					FROM film_actor INNER JOIN film using(film_id)
					WHERE film.title = 'CATCH AMISTAD');			
#opcion2                       7
select * from actor a1 where actor_id in (select actor_id from film_actor inner join film using(film_id) where film.title = 'BETRAYED REAR' and film.title = 'CATCH AMISTAD' );

#opcion1             8
select * from actor a1 where actor_id not in 
(select actor_id from film_actor inner join film using(film_id) where film.title = 'BETRAYED REAR' or film.title = 'CATCH AMISTAD' );

#opcion2             8
SELECT last_name, first_name
	FROM actor a1
WHERE a1.actor_id IN (SELECT fa.actor_id 
					FROM film_actor fa
					WHERE fa.film_id IN (SELECT f.film_id FROM film f WHERE f.title <> 'BETRAYED REAR'))
AND a1.actor_id IN (SELECT fa.actor_id
					FROM film_actor fa
					WHERE fa.film_id IN (SELECT f.film_id FROM film f where f.title <> 'CATCH AMISTAD'));
	
				
#repaso clase 6
#1Listar todos los actores que comparten el apellido. Mostrarlos en orden
#2Encuentra actores que no trabajan en ninguna película.
#3Encuentra clientes que hayan alquilado solo una película.
#4Encuentra clientes que hayan alquilado más de una película.
#5Enumere los actores que actuaron en 'BETRAYED REAR' o en 'CATCH AMISTAD'
#6Enumere los actores que actuaron en 'BETRAYED REAR' pero no en 'CATCH AMISTAD'
#7Enumere los actores que actuaron en 'BETRAYED REAR' y 'CATCH AMISTAD'
#8Lista todos los actores que no trabajaron en 'BETRAYED REAR' o 'CATCH AMISTAD'

#1
select last_name from actor a1 
	where exists (select * 
		from actor a2 where a1.last_name = a2.last_name and a1.actor_id <> a2.actor_id);
#2

select * from actor f1
	where not exists (select *
		from film_actor f2 where f1.actor_id = f2.actor_id)

#3

select * from customer c1 
	where exists (select *  
	from rental c2 where c1.customer_id = c2.customer_id having count(inventory_id) = 1);

#4

select * from customer c1 
	where not exists (select *  
	from rental c2 where c1.customer_id = c2.customer_id having count(inventory_id) = 1);
	
#5  

select f1.film_id, title, a1.first_name, a1.last_name, a1.actor_id
from actor a1, film_actor fa1, film f1 
where a1.actor_id = fa1.actor_id and 
      fa1.film_id = f1.film_id and      
      f1.title in ('BETRAYED REAR', 'CATCH AMISTAD')
      
 #6
 
select * from actor a1
where actor_id in 
(select actor_id from film_actor inner join film using(film_id) where film.title = 'BETRAYED REAR')
	and actor_id not in 
	(select actor_id from film_actor inner join film using(film_id) where film.title = 'CATCH AMISTAD')

#7

select * from actor a1
where actor_id in 
(select actor_id from film_actor inner join film using(film_id) where film.title = 'BETRAYED REAR') 
	and actor_id in 
	(select actor_id from film_actor inner join film using(film_id) where film.title = 'CATCH AMISTAD')

#8
select f1.film_id, title, a1.first_name, a1.last_name, a1.actor_id
from actor a1, film_actor fa1, film f1 
where a1.actor_id = fa1.actor_id and 
      fa1.film_id = f1.film_id and      
      f1.title not in ('BETRAYED REAR', 'CATCH AMISTAD')
      
#clase 9

#Obtenga la cantidad de ciudades por país en la base de datos. Ordenarlos por país, country_id.
#Obtenga la cantidad de ciudades por país en la base de datos. Muestre solo los países con más de 10 ciudades, ordene desde la mayor cantidad de ciudades a la más baja
#Genere un informe con el nombre (nombre, apellido) del cliente, la dirección, el total de películas alquiladas y el dinero total gastado en el alquiler de películas.
#Muestra a los que gastaron más dinero primero.
#¿Qué categorías de películas tienen la mayor duración de la película (comparando el promedio)?     
#Ordenar por promedio en orden descendente
#Mostrar ventas por película

      SELECT COUNT(*)
  FROM inventory
  WHERE store_id = 1;

 
SELECT COUNT(DISTINCT film_id)
  FROM inventory
  WHERE store_id = 1;
 
 -- Find customers that rented only one film    
SELECT c.customer_id, first_name, last_name, COUNT(*)
  FROM rental r1, customer c
 WHERE c.customer_id = r1.customer_id
GROUP BY c.customer_id, first_name, last_name
HAVING COUNT(*) = 23

-- Show the films' ratings where the minimum film duration in that group is greater than 46
SELECT rating, MIN(`length`)
FROM film
GROUP BY rating
HAVING MIN(`length`) > 46

-- Show ratings that have less than 195 films
SELECT rating, COUNT(*) AS total
FROM film
GROUP BY rating
HAVING COUNT(*) < 195

-- Show ratings where their film duration average is grater than all films duration average.
SELECT rating, AVG(`length`)
    FROM film
    GROUP BY rating
    HAVING AVG(`length`) > (SELECT AVG(`length`) FROM film);
   

#Obtenga la cantidad de ciudades por país en la base de datos. Ordenarlos por país, country_id.
#1 opcion 1 
select co.country, count(c.city_id) 
from city c, country co 
where c.country_id = co.country_id
group by co.country_id order by co.country_id  

#1 opcion2 
select co.country, count(c.city_id) 
	from city c inner join country co 
	on c.country_id = co.country_id 
		group by co.country_id 
		order by co.country_id;
#Obtenga la cantidad de ciudades por país en la base de datos. Muestre solo los países con más de 10 ciudades, ordene desde la mayor cantidad de ciudades a la más baja
#2
select co.country, count(c.city_id)
from city c, country co 
where c.country_id = co.country_id
group by co.country_id having count(c.city_id) > 10 order by co.country_id desc;

#2   
SELECT country, COUNT(c.city_id) AS cities	
    FROM country co INNER JOIN city c
    ON co.country_id = c.country_id
    GROUP BY co.country_id
    HAVING cities > 10
    ORDER BY cities desc;
#Genere un informe con el nombre (nombre, apellido) del cliente, la dirección, el total de películas alquiladas y el dinero total gastado en el alquiler de películas.
#3
select concat_ws(" ", c.last_name, c.first_name) AS name, a.address, count(r.rental_id), sum(p.amount) 
from customer c, address a, rental r, payment p 
where c.address_id = a.address_id and c.customer_id = r.customer_id and r.rental_id = p.rental_id and c.customer_id = p.customer_id group by c.customer_id order by p.amount desc;

					
SELECT
    CONCAT_WS(" ", last_name, first_name) AS name,
    (SELECT a.address FROM address a WHERE c.address_id = a.address_id) AS address,
    (SELECT COUNT(*) FROM rental r WHERE c.customer_id = r.customer_id GROUP BY c.customer_id) AS films_rented,
    (SELECT SUM(p.amount) FROM payment p WHERE c.customer_id = p.customer_id) AS money_spent
    FROM customer c
    ORDER BY money_spent desc;


#Muestra a los que gastaron más dinero primero.
#4  
select c.name, AVG(`length`)
    from film f inner join category c inner join film_category fc
    on f.film_id = fc.film_id and c.category_id = fc.category_id
    group by c.name
    having AVG(`length`) > (select AVG(`length`) from film);
   
#4 
SELECT ct.name, 
	(SELECT AVG(film.`length`) FROM film 
		INNER JOIN film_category ON film.film_id = film_category.film_id 
		    WHERE film_category.category_id = ct.category_id) AS avg_len 
FROM category ct ORDER BY avg_len DESC;
  
#¿Qué categorías de películas tienen la mayor duración de la película (comparando el promedio)?

#5 opcion correcta
select c.name, avg(`rental_duration`) 
from film f inner join category c inner join film_category fc 
on fc.category_id = c.category_id and f.film_id = fc.film_id 
group by c.name 
having avg(`rental_duration`) > (select avg(`rental_duration`) from film);

#5 experimento 3286
select c.name, avg(`rental_duration`) 
 from film f inner join category c inner join film_category fc 
 on fc.category_id = c.category_id and f.film_id = fc.film_id 
 group by c.name;
    
#5 la respuesta correcta
SELECT rating, SUM(p.amount)
    FROM film f INNER JOIN inventory i INNER JOIN rental r INNER JOIN payment p
    ON f.film_id = i.film_id AND i.inventory_id = r.inventory_id AND r.rental_id = p.rental_id
    GROUP BY f.rating;
   
#-----------------   
-- 4 chesco
SELECT ct.name, 
	(SELECT AVG(film.`length`) FROM film 
		INNER JOIN film_category ON film.film_id = film_category.film_id 
		    WHERE film_category.category_id = ct.category_id) AS avg_len 
FROM category ct ORDER BY avg_len DESC;
-- 5 chesco
SELECT film.rating, SUM(payment.amount) AS amnt 
	FROM payment INNER JOIN rental ON payment.rental_id = rental.rental_id 
		INNER JOIN inventory ON rental.inventory_id = inventory.inventory_id  
			INNER JOIN film ON inventory.film_id = film.film_id 
GROUP BY film.rating ORDER BY amnt DESC;
#-----------------   
  
#los 3 scripts de la prueba 1
SELECT film.title, language.name
    FROM film, `language`
    WHERE film.language_id = language.language_id AND film.`length` > 100 AND language.name = 'English';
   

SELECT f.title, f.`length`, a.first_name, a.last_name
    FROM actor a INNER JOIN film_actor fa INNER JOIN film f
    ON a.actor_id = fa.actor_id AND fa.film_id = f.film_id
    WHERE f.`length` <= ALL (SELECT f2.`length` FROM film f2);

SELECT co.country, c.city, a.address, a.district, a.postal_code
    FROM address a INNER JOIN city c INNER JOIN country co
    ON a.city_id = c.city_id AND c.country_id = co.country_id
    WHERE co.country LIKE '%a' AND c.city LIKE 'E%'
    ORDER BY co.country, c.city;

SELECT c.name, f.title, f.`length`, l.name, f.rental_rate
    FROM film f INNER JOIN film_category fc INNER JOIN category c INNER JOIN `language` l
    ON f.film_id = fc.film_id AND fc.category_id = c.category_id AND f.language_id = l.language_id
    WHERE c.name IN ('Comedy', 'Children', 'Animation') AND rental_rate < 3
    ORDER BY c.name, f.rental_rate, f.title;
  
   
   
#class 11

#1Encuentra todos los títulos de películas que no están en el inventario.
#2Encuentra todas las películas que están en el inventario pero nunca fueron alquiladas.
#Mostrar título e inventory_id.
#Este ejercicio es complicado, Sugerencia: use las consultas secundarias en FROM y en DONDE o use la combinación izquierda y pregunte si uno de los campos es nulo
#3Generar un informe con:
#Nombre del cliente (nombre, apellido), identificación de la tienda, título de la película,
#cuando la película fue alquilada y devuelta para cada uno de estos clientes
#ordenar por store_id, cliente last_name
#4Mostrar ventas por tienda (dinero de películas alquiladas)
#Mostrar la ciudad de la tienda, el país, la información del gerente y las ventas totales (dinero)
#(Opcional) Use concat para mostrar la ciudad y el país y el nombre y apellido del gerente
#5¿Qué actor ha aparecido en la mayoría de las películas?

-- find films pairs with same duration
SELECT f1.title, f2.title, f1.`length` 
  FROM film f1, film f2
 WHERE f1.`length` = f2.`length` AND f1.film_id < f2.film_id;

-- with join
SELECT f1.title, f2.title, f1.`length` 
  FROM film f1 
       INNER JOIN film f2 USING(`length`)
WHERE f1.film_id < f2.film_id

-- add a new copy of ACADEMY DINOSAUR to store 1
INSERT INTO inventory
(film_id, store_id, last_update)
VALUES(1, 1, '2017-02-15 05:09:17.000');

SELECT title, rental.*
  FROM film
       INNER JOIN inventory USING (film_id)       
       LEFT OUTER JOIN rental USING (inventory_id)
WHERE store_id = 1 
AND film_id = 1;

#Encuentra todos los títulos de películas que no están en el inventario.
#1
select * from film f 
left join inventory i using (film_id) 
where i.film_id is null;

#1
select * from film f 
left join inventory i 
on f.film_id = i.film_id 
where i.film_id is null

#1 respuesta profe
SELECT film.title 
FROM film 
WHERE film.film_id NOT IN (SELECT film_id 
FROM inventory); 

#Encuentra todas las películas que están en el inventario pero nunca fueron alquiladas, Mostrar título e inventory_id.
#Este ejercicio es complicado, Sugerencia: use las consultas secundarias en FROM y en DONDE o use la combinación izquierda y pregunte si uno de los campos es nulo
#2 opcion 1
select f.title, i.inventory_id, r.inventory_id from film f 
inner join inventory i 
on f.film_id = i.film_id left join rental r on i.inventory_id = r.rental_id
where r.inventory_id is null

#2 opcion 2
SELECT f.title, i.inventory_id, r.inventory_id
    FROM film f 
    INNER JOIN inventory i ON f.film_id = i.film_id
    LEFT JOIN rental r ON i.inventory_id = r.inventory_id
    WHERE r.inventory_id IS NULL;
   
#2respuesta profe
SELECT film.title,inventory_id,rental.rental_id 
FROM film 
INNER JOIN inventory USING (film_id) 
LEFT OUTER JOIN rental USING (inventory_id) 
WHERE rental.rental_id IS NULL; 
  
#Generar un informe con:
#Nombre del cliente (nombre, apellido), identificación de la tienda, título de la película,
#cuando la película fue alquilada y devuelta para cada uno de estos clientes
#ordenar por store_id, cliente last_name
#3
select c.first_name, c.last_name, f.title, r.rental_date, r.return_date, s.store_id 
from customer c
inner join store s on c.store_id = s.store_id
inner join rental r on c.customer_id = r.customer_id
inner join inventory i on i.inventory_id = r.inventory_id 
inner join film f on f.film_id = i.film_id 
where r.rental_date is not null 
order by s.store_id, c.last_name;
-- 3
SELECT c.first_name, c.last_name, s.store_id, f.title, r.return_date
    FROM customer c
    INNER JOIN rental r ON c.customer_id = r.customer_id
    INNER JOIN store s ON c.store_id = s.store_id
    INNER JOIN inventory i ON r.inventory_id = i.inventory_id
    INNER JOIN film f ON i.film_id = f.film_id
    WHERE r.return_date IS NOT NULL
    ORDER BY s.store_id, c.last_name;
   
#3 respuesta profe
SELECT customer.first_name,customer.last_name,inventory.store_id,film.title, 
rental.rental_date,rental.return_date 
FROM film 
INNER JOIN inventory USING (film_id) 
INNER JOIN rental USING (inventory_id) 
INNER JOIN customer USING (customer_id) 
WHERE rental.return_date IS NOT NULL 
ORDER BY inventory.store_id,customer.last_name; 

#4Mostrar ventas por tienda (dinero de películas alquiladas)
#Mostrar la ciudad de la tienda, el país, la información del gerente y las ventas totales (dinero)
#(Opcional) Use concat para mostrar la ciudad y el país y el nombre y apellido del gerente

#4 opcion 1
select concat_ws(" ", c.city, co.country) as 'ubicacion', sum(p.amount), concat_ws(" ", st.first_name, st.last_name) as 'gerente', s.store_id 
from country co 
inner join city c on c.country_id = co.country_id
inner join address a on c.city_id = a.city_id
inner join store s on s.address_id = a.address_id
inner join staff st on st.store_id = s.store_id
inner join rental r on st.staff_id = r.staff_id
inner join payment p on r.rental_id = p.rental_id
inner join customer cu on cu.store_id = s.store_id; 
#4 opcion 2 correcta
SELECT
    CONCAT_WS(" ", ci.city, co.country) AS 'address',
    CONCAT_WS(" ", st.first_name, st.last_name) AS 'name',
    s.store_id,
    SUM(p.amount)
    FROM store s
    INNER JOIN customer c ON s.store_id = c.store_id
    INNER JOIN rental r ON c.customer_id = r.customer_id
    INNER JOIN payment p ON r.rental_id = p.rental_id
    INNER JOIN address a ON s.address_id = a.address_id
    INNER JOIN city ci ON a.city_id = ci.city_id
    INNER JOIN country co ON ci.country_id = co.country_id
    INNER JOIN staff st ON s.manager_staff_id = st.staff_id
    GROUP BY s.store_id;

#4 respuesta profe
SELECT CONCAT(c.city, ', ', co.country) AS store,
CONCAT(m.first_name, ' ', m.last_name) AS manager,
SUM(p.amount) AS total_sales
FROM payment AS p
INNER JOIN rental AS r ON p.rental_id = r.rental_id
INNER JOIN inventory AS i ON r.inventory_id = i.inventory_id
INNER JOIN store AS s ON i.store_id = s.store_id
INNER JOIN address AS a ON s.address_id = a.address_id
INNER JOIN city AS c ON a.city_id = c.city_id
INNER JOIN country AS co ON c.country_id = co.country_id
INNER JOIN staff AS m ON s.manager_staff_id = m.staff_id
GROUP BY s.store_id
ORDER BY co.country;
   
#5¿Qué actor ha aparecido en la mayoría de las películas?
#5 opcion 1
select a1.first_name, a1.last_name, f.title,  count(a1.actor_id)
from actor a1
inner join film_actor fa1 inner join film f 
on a1.actor_id = fa1.actor_id 
group by a1.actor_id 
having count(a1.actor_id) >= all(select count(a2.actor_id) 
from actor a2 
inner join film_actor fa2 
on a2.actor_id = fa2.actor_id 
group by a2.actor_id);

#5 opcion 2 mejorada
select a1.first_name, a1.last_name, f.title,  count(*)
from actor a1
inner join film_actor fa1 inner join film f 
on a1.actor_id = fa1.actor_id
having count(a1.actor_id) >= all(select count(a2.actor_id) 
from actor a2 
inner join film_actor fa2 
on a2.actor_id = fa2.actor_id);
  
#5 opcion 3 correcta
SELECT CONCAT_WS(" ", a.first_name, a.last_name) AS 'name', a.actor_id, COUNT(*) AS 'times'
    FROM actor a
    INNER JOIN film_actor fa ON a.actor_id = fa.actor_id
    GROUP BY a.actor_id
    HAVING COUNT(a.actor_id) >= ALL(SELECT COUNT(a2.actor_id)
                                        FROM actor a2
                                        INNER JOIN film_actor fa2
                                        ON a2.actor_id = fa2.actor_id
                                        GROUP BY a2.actor_id);
                                       
#5 respuesta profe
SELECT actor.actor_id, 
actor.first_name, 
actor.last_name, 
COUNT(actor_id) AS film_count 
FROM actor 
INNER JOIN film_actor USING (actor_id) 
GROUP BY actor_id, actor.first_name, actor.last_name 
HAVING COUNT(actor_id) >= (SELECT COUNT(film_id) 
FROM film_actor 
GROUP BY actor_id 
ORDER BY 1 DESC 
LIMIT 1) 
ORDER BY film_count desc


























#Genere un reporte mostrando el nombre y apellido de cada cliente con la cantidad 
#de películas que alquiló y la cantidad de dinero que ha gastado.
#Mostrar solo los clientes que hayan gastado entre 100 y 150 dolares.

select  concat_ws(" ",c.first_name, c.last_name) as nombre, count(r.rental_id), sum(p.amount)
from customer c 
inner join rental r on c.customer_id = r.customer_id
inner join payment p on r.rental_id = p.rental_id
group by c.customer_id having sum(p.amount) between 100 and 150;

#Muestre un reporte de la cantidad de películas rentadas por país y por categoría de películas
#Columnas a mostrar nombre del país, nombre la categoría y cantidad de películas alquiladas
#Ejemplo:
#Pais        Categoria   Cantidad
#Argentina	Action	    25
#Argentina	Animation	26
#Argentina	Children	13
#Argentina	Classics	18

select cat.name, c.country, count(rental_id)
from country c 
inner join city ci using(country_id)
inner join address a using(city_id)
inner join customer cu using(address_id)
inner join rental r using(customer_id)
inner join inventory i using(inventory_id)
inner join film f using(film_id)
inner join film_category ca using(film_id)
inner join category cat using(category_id)
group by cat.name, c.country order by c.country, cat.name

#Muestre la cantidad de películas que tienen los clientes alquiladas (es decir que todavía no se han devuelto) 
#agrupadas por rating (G, PG, etc...)

select f.rating, count(r.rental_id)  
from film f inner join inventory i inner join rental r
on f.film_id = i.film_id 
and i.inventory_id = r.inventory_id
where r.return_date is null
group by f.rating;   

#Muestre los clientes y actores que compartan el apellido
#Se deben mostrar todos los clientes, y cuando los actores compartan el apellido, mostrar esos actores. También mostrar la cantidad de películas en las que un actor determinado actuó.

select a.actor_id, a.first_name, a.last_name, c.customer_id, c.first_name, c.last_name 
from customer c
inner join rental r on c.customer_id = r.customer_id 
inner join inventory i on r.inventory_id = i.inventory_id
left join film f on f.film_id = i.film_id
left join film_actor fa on f.film_id = fa.film_id 
left join actor a on a.actor_id = fa.actor_id and c.last_name = a.last_name
group by c.last_name;


#clase 13                                     
#Escriba las declaraciones con todas las subconsultas necesarias, no use identificadores codificados a menos que se especifique.
#Verifique qué campos son obligatorios y cuáles se pueden omitir (use el valor predeterminado).
#1 Añadir un nuevo cliente
#Para almacenar 1
#Para la dirección use una dirección existente. El que tiene la dirección de correo electrónico más grande en 'Estados Unidos'
#2 Añadir un alquiler
#Facilita la selección de cualquier título de película. Es decir. Debería poder poner 'baldosas de película' en el lugar, y no en el id.
#No verifique si la película ya está alquilada, solo use alguna del inventario, por ejemplo. el de mayor id.
#Seleccione cualquier staff_id de la tienda 2.
#3 Actualización año de cine basado en la calificación.
#Por ejemplo, si la calificación es 'G', la fecha de lanzamiento será '2001'
#Puede elegir la asignación entre calificación y año.
#Escribe cuantas afirmaciones sean necesarias.
#4 Devolver una pelicula
#Escriba las declaraciones y consultas necesarias para los siguientes pasos.
#Encuentra una película que aún no haya sido devuelta. Y usa esa identificación de alquiler. Escoge lo último que se alquiló por ejemplo.
#Usa la identificación para devolver la película.
#5 Intenta borrar una película
#Comprueba qué pasa, describe qué hacer.
#Escriba todas las declaraciones de eliminación necesarias para eliminar por completo la película de la base de datos.
#6 Alquilar una película
#Encuentre una identificación de inventario que esté disponible para alquiler (disponible en la tienda) y elija cualquier película. Guarda esta identificación en algún lugar.
#Añadir una entrada de alquiler
#Añadir una entrada de pago
#Utilice subconsultas para todo, excepto el ID de inventario que se puede usar directamente en las consultas.
###Una vez que hayas terminado. Restaure los datos de la base de datos utilizando el script de llenado de la clase 3.

																															
#Añadir un nuevo cliente
#Para almacenar 1
#Para la dirección use una dirección existente. El que tiene la dirección de correo electrónico más grande en 'Estados Unidos'

#1 opcion 1 incorrecta
insert into customer 
(first_name, last_name, store_id, address_id)
values
('anna', 'bainotti', 1, 600)

update customer
set email = 'ANNA.HILL@sakilacustomer.org'
where address_id = 600

select * from customer where first_name like 'anna%' or address_id = 89

delete from customer where last_name = 'bainotti'

#1 opcion 2 mejorada
-- 1
SELECT * FROM customer ORDER BY customer_id DESC;

DELETE FROM customer WHERE customer_id = 600;

INSERT INTO customer
    (customer_id, store_id, first_name, last_name, email, address_id, active)
    VALUES
    (600, 1, "anna", "bainotti", "annitajodida.cba@gmail.com",
        (SELECT address_id
            FROM address a
            INNER JOIN city c ON a.city_id = c.city_id
            INNER JOIN country co ON c.country_id = co.country_id
            WHERE co.country LIKE 'United States'
            AND a.address_id >= ALL(SELECT a2.address_id
                                        FROM address a2
                                        INNER JOIN city c2 ON a2.city_id = c2.city_id
                                        INNER JOIN country co2 ON c2.country_id = co2.country_id
                                        WHERE co2.country LIKE 'United States')), 1);
                                       
#2 Añadir un alquiler
#Facilita la selección de cualquier título de película. Es decir. Debería poder poner 'baldosas de película' en el lugar, y no en el id.
#No verifique si la película ya está alquilada, solo use alguna del inventario, por ejemplo. el de mayor id.
#Seleccione cualquier staff_id de la tienda 2.
select f.title, r.store_id  from rental order by rental_id desc;
insert into rental
	(rental_id, rental_date, inventory_id, customer_id, return_date, staff_id, last_update)
	values
	(16050, "2005-09-23 22:50:12", 2777, 525, "2010-02-15 23:59:59", 2)
		(select film f 
		inner join inventory i on i.film_id = f.film_id 
		inner join rental r on r.inventory_id = i.inventory_id where i.store_id = 2)
		
		
SELECT * FROM rental ORDER BY rental_id DESC;
SELECT * FROM inventory ORDER BY inventory_id DESC;
SELECT * FROM customer ORDER BY customer_id DESC;
SELECT * FROM staff WHERE store_id = 2;
SELECT * FROM rental ORDER BY rental_id DESC;

DELETE FROM rental WHERE rental_id = 16050;

INSERT INTO rental
    (rental_id, inventory_id, customer_id, staff_id)
    VALUES
    (16050, 4581, 600, 2);

-- 3
-- G --> 2000
-- PG --> 2002
-- PG-13 --> 2004
-- R --> 2006
-- NC-17 --> 2010
SELECT f.film_id, f.title, f.release_year, f.rating FROM film f ORDER BY rating;

UPDATE film f 
SET f.release_year = 2000 WHERE f.rating LIKE 'G';
UPDATE film f
SET f.release_year = 2002 WHERE f.rating LIKE 'PG';
UPDATE film f 
SET f.release_year = 2004 WHERE f.rating LIKE 'PG-13';
UPDATE film f 
SET f.release_year = 2006 WHERE f.rating LIKE 'R';
UPDATE film f 
SET f.release_year = 2010 WHERE f.rating LIKE 'NC-17';

#3 Actualización año de cine basado en la calificación.
#Por ejemplo, si la calificación es 'G', la fecha de lanzamiento será '2001'
#Puede elegir la asignación entre calificación y año.
#Escribe cuantas afirmaciones sean necesarias.
select * from rental

SELECT rental_id, rental_date, return_date
    FROM rental r
    WHERE r.return_date IS NULL
    ORDER BY r.rental_date DESC
    LIMIT 1;

#4 Devolver una pelicula
#Escriba las declaraciones y consultas necesarias para los siguientes pasos.
#Encuentra una película que aún no haya sido devuelta. Y usa esa identificación de alquiler. Escoge lo último que se alquiló por ejemplo.
#Usa la identificación para devolver la película.

-- 4
SELECT rental_id, rental_date, return_date 
FROM rental 
WHERE rental_id = 16050;

UPDATE rental SET return_date = NULL WHERE rental_id = 16050;

UPDATE rental SET return_date = NOW()
    WHERE rental_id = (SELECT rental_id
                            FROM (SELECT r2.rental_id
                                        FROM rental r2
                                        WHERE r2.return_date IS NULL
                                        ORDER BY r2.rental_date DESC
                                        LIMIT 1) r); 
 
#5 Intenta borrar una película
#Comprueba qué pasa, describe qué hacer.
#Escriba todas las declaraciones de eliminación necesarias para eliminar por completo la película de la base de datos.
select * from film

insert into film
(film_id, title, description, language_id)
values
(1001, 'mi mundo', 'A intrepid era jodaa xddd ddd ddd lol', 1);

select * from film f order by f.film_id desc;

delete from film 
where film_id = 1001                                    

#6 Alquilar una película
#Encuentre una identificación de inventario que esté disponible para alquiler (disponible en la tienda) y elija cualquier película. Guarda esta identificación en algún lugar.
#Añadir una entrada de alquiler
#Añadir una entrada de pago
#Utilice subconsultas para todo, excepto el ID de inventario que se puede usar directamente en las consultas.
#######Una vez que hayas terminado. Restaure los datos de la base de datos utilizando el script de llenado de la clase 3.
SELECT *
    FROM store s
    INNER JOIN inventory i ON s.store_id = i.store_id
    INNER JOIN rental r ON i.inventory_id = r.inventory_id
    inner join film f on i.film_id = f.film_id
    
#clase 14
#1Escribe una consulta que consiga todos los clientes que viven en Argentina. Muestra el nombre y apellido en una columna, la dirección y la ciudad.
#2Escribe una consulta que muestre el título de la película, el idioma y la calificación. La clasificación se mostrará como el texto completo que se describe 
#aquí: https://en.wikipedia.org/wiki/Motion_picture_content_rating_system#United_States. Pista: caso de uso.
#3Escriba una consulta de búsqueda que muestre todas las películas (título y año de estreno) de las que formó parte un actor.
#Supongamos que el actor proviene de un cuadro de texto introducido a mano desde una página web.
#Asegúrese de "ajustar" el texto de entrada para tratar de encontrar las películas de la manera más efectiva posible.
#4Encuentra todos los alquileres realizados en los meses de mayo y junio. Mostrar el título de la película, el nombre del cliente y si fue devuelto o no. 
#Debe devolverse la columna con dos valores posibles 'Sí' y 'No'.
#5Investigar las funciones cast y convert. Explique las diferencias, si las hay, escriba ejemplos basados ​​en sakila DB.
#6Investigue el tipo de función NVL, ISNULL, IFNULL, COALESCE, etc. Explique lo que hacen. Cuáles no están en MySql y escriben ejemplos de uso.
  
#1Escribe una consulta que consiga todos los clientes que viven en Argentina. Muestra el nombre y apellido en una columna, la dirección y la ciudad.    
select concat_ws(" ", first_name, last_name) as nombrecompleto, concat_ws(" ", address, city)as calle, country 
from customer 
inner join address a using (address_id)
inner join city c using (city_id) 
inner join country using (country_id) where country = 'Argentina'
order by country asc

#2Escribe una consulta que muestre el título de la película, el idioma y la calificación. La clasificación se mostrará como el texto completo que se describe 


#Crear una vista llamada films_per_actor que devuelva las siguientes columnas: 'actor_id', 'actor first name', 'actor last name', 
#cantidad de películas en las que actuó con nombre 'film_count'. Una lista de las categorías de las películas en las que actuó, separadas por coma y sin duplicados llamada 
#'category_list' y una lista de las películas en las que actuó, ordenadas en forma descendente separada por dos puntos ‘:’

select * from actor;
select * from film;

    
CREATE VIEW films_per_actor_3  as 
	SELECT f.title, CONCAT_WS(" ", a.first_name, a.last_name) as 'name', count(f.length)
    	FROM film f
    	INNER JOIN film_actor fa ON f.film_id = fa.film_id
    	INNER JOIN actor a ON fa.actor_id = a.actor_id
    	WHERE CONCAT_WS(" ", a.first_name, a.last_name) LIKE TRIM(UPPER(' PeNELope guiNESs'))
   
  
    	
 SELECT f.title, CONCAT_WS(" ", a.first_name, a.last_name) as 'name', count(f.length) 
    	FROM film f
    	INNER JOIN film_actor fa ON f.film_id = fa.film_id
    	INNER JOIN actor a ON fa.actor_id = a.actor_id
    	inner join 
    	WHERE CONCAT_WS(" ", a.first_name, a.last_name);
    	
##prueba 3  
CREATE OR REPLACE VIEW films_per_actor AS 
SELECT
	a.actor_id,
	a.first_name,
	a.last_name,
	COUNT(fa.film_id) AS film_count,
	GROUP_CONCAT(DISTINCT CONCAT_WS(" " ,c.name) SEPARATOR ',') AS 'category_list',
	GROUP_CONCAT(CONCAT_WS(" " ,f.title) ORDER BY f.title DESC SEPARATOR ':') AS 'film_list'
FROM
	actor a
INNER JOIN film_actor fa ON
	a.actor_id = fa.actor_id
INNER JOIN film f ON
	f.film_id = fa.film_id
INNER JOIN film_category fc ON
	fc.film_id = f.film_id
INNER JOIN category c ON
	c.category_id = fc.category_id
GROUP BY
	a.actor_id;
#-------------------------------------------------------------------------------------------------------------

#Muestre un reporte de la cantidad de películas rentadas y no devueltas por país y por categoría de películas. 
#Columnas a mostrar nombre del país, 
#nombre la categoría y cantidad de películas alquiladas

select concat_ws (" ", cat.name) as 'Categoria', concat_ws (" ", c.country) as 'Pais', concat_ws (" ",  count(rental_id)) as 'Cantidad De Rentas'
from country c 
inner join city ci using(country_id)
inner join address a using(city_id)
inner join customer cu using(address_id)
inner join rental r using(customer_id)
inner join inventory i using(inventory_id)
inner join film f using(film_id)
inner join film_category ca using(film_id)
inner join category cat using(category_id)
where r.return_date is null
group by cat.name, c.country order by c.country, cat.name




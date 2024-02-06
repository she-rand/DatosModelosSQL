CREATE DATABASE liliana-zurita-567;

--1. Revisa el tipo de relación y crea el modelo correspondiente. Respeta las claves
--primarias, foráneas y tipos de datos.
CREATE TABLE peliculas(id INT primary key, nombre VARCHAR(255),anno INT);
CREATE TABLE tags(id INT primary key, tag VARCHAR(32));
CREATE TABLE peliculatag(pelicula_id INT, FOREIGN KEY(pelicula_id)REFERENCES peliculas(id),tag_id INT, FOREIGN KEY(tag_id)REFERENCES tags(id));

--2. Inserta 5 películas y 5 tags; la primera película debe tener 3 tags asociados, la
--segunda película debe tener 2 tags asociados
INSERT INTO peliculas (id,nombre,anno)VALUES(1,'Intensamente',2015);
INSERT INTO peliculas (id,nombre,anno)VALUES(2,'Midsommar',2019);
INSERT INTO peliculas (id,nombre,anno)VALUES(3,'Gladiador',2000);
INSERT INTO peliculas (id,nombre,anno)VALUES(4,'Ip man',2008);
INSERT INTO peliculas (id,nombre,anno)VALUES(5,'Interestellar',2014);



INSERT INTO tags(id,tag) VALUES(1,'infantil');
INSERT INTO tags(id,tag) VALUES(2,'comedia');
INSERT INTO tags(id,tag) VALUES(3,'animacion');
INSERT INTO tags(id,tag) VALUES(4,'terror');
INSERT INTO tags(id,tag) VALUES(5,'psicologico');


INSERT INTO peliculatag(pelicula_id,tag_id)VALUES(1,1);
INSERT INTO peliculatag(pelicula_id,tag_id)VALUES(1,2);
INSERT INTO peliculatag(pelicula_id,tag_id)VALUES(1,3);
INSERT INTO peliculatag(pelicula_id,tag_id)VALUES(2,4);
INSERT INTO peliculatag(pelicula_id,tag_id)VALUES(2,5);

--3. Cuenta la cantidad de tags que tiene cada película. Si una película no tiene tags debe mostrar 0.
SELECT peliculas.id,peliculas.nombre,COUNT(tags.id) FROM peliculas
LEFT JOIN peliculatag ON (peliculas.id=peliculatag.pelicula_id)
LEFT JOIN tags ON (peliculatag.tag_id=tags.id) GROUP BY peliculas.nombre,peliculas.id;




--4. Crea las tablas correspondientes respetando los nombres, tipos, claves primarias y
--foráneas y tipos de datos
CREATE TABLE preguntas(id int primary key, pregunta VARCHAR(255),respuesta_correcta VARCHAR);
CREATE TABLE usuarios(id int primary key, nombre VARCHAR(255),edad INT);
CREATE TABLE respuestas(id int primary key, respuesta VARCHAR(255),usuario_id INT, FOREIGN KEY (usuario_id)REFERENCES usuarios(id),pregunta_id INT,FOREIGN KEY(pregunta_id)REFERENCES preguntas(id));

--5. Agrega 5 usuarios y 5 preguntas
--La primera pregunta debe estar respondida correctamente dos veces, por dos usuarios diferentes.
--La segunda pregunta debe estar contestada correctamente solo por un usuario.
--Las otras tres preguntas deben tener respuestas incorrectas
INSERT INTO usuarios VALUES(1,'Mario',20);
INSERT INTO usuarios VALUES(2,'Juan',22);
INSERT INTO usuarios VALUES(3,'Patricia',22);
INSERT INTO usuarios VALUES(4,'Carlos',29);
INSERT INTO usuarios VALUES(5,'Beatriz',29);

INSERT INTO preguntas VALUES(1,'Capital de Canada','Ottawa');
INSERT INTO preguntas VALUES(2,'El perro de Charlie Brown','Snoopy');
INSERT INTO preguntas VALUES(3,'La montaña más alta del mundo','Everest');
INSERT INTO preguntas VALUES(4,'El nombre real de Superman','Clark Kent');
INSERT INTO preguntas VALUES(5,'Nombre de los osos de Stars Wars','Ewoks');

INSERT INTO respuestas(id,respuesta,usuario_id,pregunta_id)VALUES(1,'Ottawa',1,1);
INSERT INTO respuestas(id,respuesta,usuario_id,pregunta_id)VALUES(2,'Ottawa',2,1);
INSERT INTO respuestas(id,respuesta,usuario_id,pregunta_id)VALUES(3,'Snoopy',2,2);
INSERT INTO respuestas(id,respuesta,usuario_id,pregunta_id)VALUES(4,'Montblanc',3,3);
INSERT INTO respuestas(id,respuesta,usuario_id,pregunta_id)VALUES(5,'Hulk',4,4);
INSERT INTO respuestas(id,respuesta,usuario_id,pregunta_id)VALUES(6,'Jars',5,5);

SELECT * FROM usuarios  
LEFT JOIN respuestas  ON (respuestas.usuario_id=usuarios.id)
LEFT JOIN preguntas ON (respuestas.pregunta_id=preguntas.id)
WHERE respuestas.respuesta=preguntas.respuesta_correcta;

--6. Cuenta la cantidad de respuestas correctas totales por usuario (independiente de la pregunta).

SELECT usuarios.id, COALESCE(t.quant, 0) FROM usuarios
LEFT JOIN (SELECT usuarios.id AS usuarios_id, COUNT(respuestas.id) as quant FROM usuarios  
LEFT JOIN respuestas  ON (respuestas.usuario_id=usuarios.id)
LEFT JOIN preguntas ON (respuestas.pregunta_id=preguntas.id)
WHERE respuestas.respuesta=preguntas.respuesta_correcta GROUP BY usuarios.id) t
ON (usuarios.id=t.usuarios_id);

--7. Por cada pregunta, en la tabla preguntas, cuenta cuántos usuarios respondieron correctamente
SELECT preguntas.id, COALESCE(t.quant, 0) FROM preguntas
LEFT JOIN (SELECT preguntas.id AS preguntas_id, COUNT(usuarios.id) AS quant FROM usuarios  
LEFT JOIN respuestas  ON (respuestas.usuario_id=usuarios.id)
LEFT JOIN preguntas ON (respuestas.pregunta_id=preguntas.id)
WHERE respuestas.respuesta=preguntas.respuesta_correcta GROUP BY preguntas.id) t
ON (preguntas.id=t.preguntas_id);

--8. Implementa un borrado en cascada de las respuestas al borrar un usuario. 
--Prueba laimplementación borrando el primer usuario.
ALTER TABLE respuestas DROP CONSTRAINT respuestas_pregunta_id_fkey;
ALTER TABLE respuestas DROP CONSTRAINT respuestas_usuario_id_fkey;

ALTER TABLE respuestas ADD
FOREIGN KEY (usuario_id)
REFERENCES usuarios (id)
ON DELETE CASCADE;

ALTER TABLE respuestas ADD
FOREIGN KEY (pregunta_id)
REFERENCES preguntas (id)
ON DELETE CASCADE;

DELETE  FROM usuarios WHERE usuarios.id=1;

SELECT *FROM usuarios;
--9. Crea una restricción que impida insertar usuarios menores de 18 años en la base de datos.
ALTER TABLE usuarios
ADD CONSTRAINT edad_restringida CHECK (edad>18);

INSERT INTO usuarios VALUES(6,'Ana',9);


--10. Altera la tabla existente de usuarios agregando el campo email. Debe tener la restricción de ser único.
ALTER TABLE usuarios ADD COLUMN email VARCHAR(100),
ADD CONSTRAINT email_unique UNIQUE (email);

INSERT INTO usuarios VALUES(7,'Jose',19,'jose@mail.com');
INSERT INTO usuarios VALUES(8,'Josefa',19,'jose@mail.com');




/*CANDADO A
Posición: El candado A está ubicado en la posición calculada a partir del número obtenido en la/s
siguiente/s consulta/s:
Teniendo el máximo de asistencias por partido, muestre cuantas veces se logró dicho máximo.
*/
SELECT COUNT(Asistencias_por_partido)
FROM estadistica
WHERE Asistencias_por_partido = (
	SELECT MAX(Asistencias_por_partido)
	FROM estadistica); -- 2

/*
Clave: La clave del candado A estará con formada por la/s siguientes consulta/s a la base de
datos:
Muestre la suma total del peso de los jugadores, donde la conferencia sea Este y la posición sea
centro o esté comprendida en otras posiciones.
*/
SELECT SUM(j.peso)
FROM jugador AS j
INNER JOIN equipo AS e
ON j.nombre_equipo = e.nombre
WHERE e.conferencia = 'East' AND j.posicion LIKE '%C%'; -- 14043

/*
CANDADO B
Posición: El candado B está ubicado en la posición calculada a partir del número obtenido en la/s
siguiente/s consulta/s:
Muestre la cantidad de jugadores que poseen más asistencias por partidos, que el numero de
jugadores que tiene el equipo Heat.
Este resultado nos dará la posición del candado (1, 2, 3 o 4)
*/
SELECT COUNT(Asistencias_por_partido)
FROM estadistica
WHERE Asistencias_por_partido > (
	SELECT COUNT(*)
	FROM jugador
	WHERE nombre_equipo = 'Heat'); -- 3
/*
Clave: La clave del candado B estará con formada por la/s siguientes consulta/s a la base de
datos:
La clave será igual al conteo de partidos jugados durante las temporadas del año 1999.
*/
SELECT COUNT(*)
FROM partido
WHERE temporada LIKE '%99%'; -- 3480

/*
CANDADO C
Posición: El candado C está ubicado en la posición calculada a partir del número obtenido en la/s
siguiente/s consulta/s:
La posición del código será igual a la cantidad de jugadores que proceden de Michigan y forman
parte de equipos de la conferencia oeste.
Al resultado obtenido lo dividiremos por la cantidad de jugadores cuyo peso es mayor o igual a
195, y a eso le vamos a sumar 0.9945.
Este resultado nos dará la posición del candado (1, 2, 3 o 4)
*/
SELECT (COUNT(*) / 	
	(SELECT COUNT(*)
	FROM jugador
	WHERE peso >= 195) ) + 0.9945
FROM jugador AS j
INNER JOIN equipo AS e
ON e.nombre = j.nombre_equipo
WHERE j.procedencia = 'Michigan' AND e.conferencia = 'West'; -- 1

/*
Clave: La clave del candado B estará con formada por la/s siguientes consulta/s a la base de
datos:
Para obtener el siguiente código deberás redondear hacia abajo el resultado que se devuelve de
sumar: el promedio de puntos por partido, el conteo de asistencias por partido, y la suma de
tapones por partido. Además, este resultado debe ser, donde la división sea central.
*/
SELECT FLOOR(AVG(Puntos_por_partido)+COUNT(Asistencias_por_partido)+SUM(Tapones_por_partido))
FROM estadistica AS e
INNER JOIN jugador AS j
ON e.jugador = j.codigo
INNER JOIN equipo AS eq 
ON j.nombre_equipo = eq.nombre
WHERE eq.division = 'Central'; -- 631
/*
CANDADO D
Posición: El candado D está ubicado en la posición calculada a partir del número obtenido en la/s
siguiente/s consulta/s:
Muestre los tapones por partido del jugador Corey Maggette durante la temporada 00/01. Este
resultado debe ser redondeado. Nota: el resultado debe estar redondeado
Este resultado nos dará la posición del candado (1, 2, 3 o 4)
*/
SELECT  ROUND(Tapones_por_partido)
FROM estadistica AS e
INNER JOIN jugador AS j
ON jugador = codigo
WHERE j.nombre = 'Corey Maggette' AND e.temporada = '00/01'; -- 4

/*
Clave: La clave del candado D estará con formada por la/s siguientes consulta/s a la base de
datos:
Para obtener el siguiente código deberás redondear hacia abajo, la suma de puntos por partido
de todos los jugadores de procedencia argentina
*/ 
SELECT FLOOR(SUM(Puntos_por_partido))
FROM estadistica AS e
INNER JOIN jugador AS j
ON jugador = codigo
WHERE j.procedencia = 'Argentina'; -- 191
-- 1. Mostrar el nombre de todos los pokemon.
SELECT nombre
FROM pokemon;

-- 2. Mostrar los pokemon que pesen menos de 10k.
SELECT *
FROM pokemon
WHERE peso < 10;

-- 3. Mostrar los pokemon de tipo agua.
SELECT p.nombre
FROM pokemon AS p
INNER JOIN pokemon_tipo AS pt
ON p.numero_pokedex = pt.numero_pokedex
INNER JOIN tipo AS t
ON pt.id_tipo = t.id_tipo
WHERE t.nombre = 'Agua';

-- 4. Mostrar los pokemon de tipo agua, fuego o tierra ordenados por tipo.
SELECT p.nombre, t.nombre
FROM pokemon AS p
INNER JOIN pokemon_tipo AS pt
ON p.numero_pokedex = pt.numero_pokedex
INNER JOIN tipo AS t
ON pt.id_tipo = t.id_tipo
WHERE t.nombre IN ('Agua', 'Fuego', 'Tierra')
ORDER BY t.id_tipo;

-- 5. Mostrar los pokemon que son de tipo fuego y volador.
SELECT p.nombre, t.nombre
FROM pokemon AS p
INNER JOIN pokemon_tipo AS pt
ON p.numero_pokedex = pt.numero_pokedex
INNER JOIN tipo AS t
ON pt.id_tipo = t.id_tipo
WHERE t.nombre IN ('Fuego', 'Volador');

-- 6. Mostrar los pokemon con una estadística base de ps mayor que 200.
SELECT p.nombre, eb.ps
FROM pokemon AS p
INNER JOIN estadisticas_base AS eb
ON p.numero_pokedex = eb.numero_pokedex
WHERE eb.ps > 200;

-- 7. Mostrar los datos (nombre, peso, altura) de la prevolución de Arbok.
SELECT nombre, peso, altura
FROM pokemon
WHERE numero_pokedex =
	(SELECT pokemon_origen
	FROM pokemon AS p
	INNER JOIN evoluciona_de
	ON numero_pokedex = pokemon_evolucionado
	WHERE p.nombre = 'Arbok');

-- 8. Mostrar aquellos pokemon que evolucionan por intercambio.
SELECT p.nombre, te.tipo_evolucion
FROM pokemon AS p
INNER JOIN pokemon_forma_evolucion AS pfe
ON p.numero_pokedex = pfe.numero_pokedex
INNER JOIN forma_evolucion AS fe
ON  pfe.id_forma_evolucion = fe.id_forma_evolucion
INNER JOIN tipo_evolucion AS te
ON fe.tipo_evolucion = te.id_tipo_evolucion
WHERE te.tipo_evolucion = 'Intercambio';

-- 9. Mostrar el nombre del movimiento con más prioridad.
SELECT nombre, prioridad
FROM movimiento
ORDER BY prioridad DESC LIMIT 1;

-- 10. Mostrar el pokemon más pesado.
SELECT *
FROM pokemon
ORDER BY peso DESC LIMIT 1;

-- 11. Mostrar el nombre y tipo del ataque con más potencia.
SELECT m.nombre, ta.tipo, m.potencia
FROM movimiento AS m
INNER JOIN tipo AS t
ON m.id_tipo = t.id_tipo
INNER JOIN tipo_ataque AS ta
ON t.id_tipo_ataque = ta.id_tipo_ataque
ORDER BY m.potencia DESC LIMIT 1;

-- 12. Mostrar el número de movimientos de cada tipo.
SELECT t.nombre, COUNT(*)
FROM movimiento AS m
INNER JOIN tipo AS t
ON m.id_tipo = t.id_tipo
GROUP BY m.id_tipo;

-- 13. Mostrar todos los movimientos que puedan envenenar.
SELECT m.nombre, es.efecto_secundario
FROM movimiento AS m
INNER JOIN movimiento_efecto_secundario AS mes
ON m.id_movimiento = mes.id_movimiento
INNER JOIN efecto_secundario AS es
ON mes.id_efecto_secundario = es.id_efecto_secundario
WHERE es.efecto_secundario = 'Envenenamiento leve';

-- 14. Mostrar todos los movimientos que causan daño, ordenados alfabéticamente por nombre.
SELECT *
FROM movimiento
WHERE potencia <> 0
ORDER BY nombre;

-- 15. Mostrar todos los movimientos que aprende pikachu.
SELECT nombre
FROM movimiento AS m
INNER JOIN pokemon_movimiento_forma AS pmf
ON m.id_movimiento = pmf.id_movimiento 
WHERE numero_pokedex = (
		SELECT numero_pokedex
		FROM pokemon
		WHERE nombre = 'Pikachu');

-- 16. Mostrar todos los movimientos que aprende pikachu por MT (tipo de aprendizaje).
SELECT MT
FROM mt
INNER JOIN forma_aprendizaje AS fa
ON mt.id_forma_aprendizaje = fa.id_forma_aprendizaje
INNER JOIN pokemon_movimiento_forma AS pmf
ON fa.id_forma_aprendizaje = pmf.id_forma_aprendizaje
WHERE numero_pokedex = (
		SELECT numero_pokedex
		FROM pokemon
		WHERE nombre = 'Pikachu');
        
-- 17. Mostrar todos los movimientos de tipo normal que aprende pikachu por nivel.
SELECT m.nombre, t.nombre, nivel
FROM movimiento AS m
INNER JOIN tipo AS t
ON m.id_tipo = t.id_tipo
INNER JOIN pokemon_movimiento_forma AS pmf
ON m.id_movimiento = pmf.id_movimiento 
INNER JOIN nivel_aprendizaje AS na
ON pmf.id_forma_aprendizaje = na.id_forma_aprendizaje
WHERE numero_pokedex = (
		SELECT numero_pokedex
		FROM pokemon
		WHERE nombre = 'Pikachu' AND t.nombre = 'Normal');
        
-- 18. Mostrar todos los movimientos de efecto secundario cuya probabilidad sea mayor al 30%.
SELECT m.nombre, mes.probabilidad
FROM movimiento AS m
INNER JOIN movimiento_efecto_secundario AS mes
ON m.id_movimiento = mes.id_movimiento
WHERE mes.probabilidad > 30;

-- 19. Mostrar todos los pokemon que evolucionan por piedra.
SELECT p.nombre, id_tipo_piedra
FROM pokemon AS p
INNER JOIN pokemon_forma_evolucion AS pfe
ON p.numero_pokedex = pfe.numero_pokedex
INNER JOIN piedra AS p2
ON pfe.id_forma_evolucion = p2.id_forma_evolucion;

-- 20. Mostrar todos los pokemon que no pueden evolucionar.
SELECT nombre
FROM pokemon
LEFT JOIN evoluciona_de
ON numero_pokedex = pokemon_origen
WHERE pokemon_origen IS NULL;

-- 21. Mostrar la cantidad de los pokemon de cada tipo. 
SELECT t.nombre, COUNT(*)
FROM pokemon AS p
INNER JOIN pokemon_tipo AS pt
ON p.numero_pokedex = pt.numero_pokedex
INNER JOIN tipo AS t
ON pt.id_tipo = t.id_tipo
GROUP BY pt.id_tipo;
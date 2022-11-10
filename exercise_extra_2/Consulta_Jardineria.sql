-- Consultas sobre una tabla
-- 1. Devuelve un listado con el código de oficina y la ciudad donde hay oficinas.
SELECT codigo_oficina, ciudad
FROM oficina;

-- 2. Devuelve un listado con la ciudad y el teléfono de las oficinas de España.
SELECT ciudad, pais, telefono
FROM oficina
WHERE pais = 'España';

-- 3. Devuelve un listado con el nombre, apellidos y email de los empleados cuyo jefe tiene un código de jefe igual a 7.
SELECT nombre, apellido1, apellido2, email, codigo_jefe
FROM empleado
WHERE codigo_jefe = 7;

-- 4. Devuelve el nombre del puesto, nombre, apellidos y email del jefe de la empresa.
SELECT nombre, apellido1, apellido2, email, puesto
FROM empleado
WHERE codigo_jefe IS NULL;

-- 5. Devuelve un listado con el nombre, apellidos y puesto de aquellos empleados que no sean representantes de ventas.
SELECT nombre, apellido1, apellido2, puesto
FROM empleado
WHERE puesto NOT LIKE 'Representante Ventas';

-- 6. Devuelve un listado con el nombre de los todos los clientes españoles.
SELECT nombre_cliente, pais
FROM cliente
WHERE pais = 'Spain';

-- 7. Devuelve un listado con los distintos estados por los que puede pasar un pedido.
SELECT estado
FROM pedido
GROUP BY estado;

/* 8. Devuelve un listado con el código de cliente de aquellos clientes que realizaron algún pago
en 2008. Tenga en cuenta que deberá eliminar aquellos códigos de cliente que aparezcan
repetidos. Resuelva la consulta:
o Utilizando la función YEAR de MySQL.
o Utilizando la función DATE_FORMAT de MySQL.
o Sin utilizar ninguna de las funciones anteriores. */
SELECT codigo_cliente, fecha_pago
FROM pago
-- WHERE YEAR(fecha_pago) = '2008'
-- WHERE DATE_FORMAT(fecha_pago, '%Y') = '2008'
WHERE fecha_pago LIKE '2008%'
GROUP BY codigo_cliente;

-- 9. Devuelve un listado con el código de pedido, código de cliente, fecha esperada y fecha de
-- entrega de los pedidos que no han sido entregados a tiempo.
SELECT codigo_pedido, fecha_esperada, fecha_entrega, codigo_cliente
FROM pedido
WHERE fecha_esperada < fecha_entrega;

/*10. Devuelve un listado con el código de pedido, código de cliente, fecha esperada y fecha de
entrega de los pedidos cuya fecha de entrega ha sido al menos dos días antes de la fecha
esperada.
o Utilizando la función ADDDATE de MySQL.
o Utilizando la función DATEDIFF de MySQL. */
SELECT codigo_pedido, fecha_esperada, fecha_entrega, DATEDIFF(fecha_esperada, fecha_entrega) AS diferencia, codigo_cliente
FROM pedido
--  WHERE ADDDATE(fecha_entrega, INTERVAL 2 DAY) <= fecha_esperada;
WHERE DATEDIFF(fecha_esperada, fecha_entrega) >= 2;

-- 11. Devuelve un listado de todos los pedidos que fueron rechazados en 2009.
SELECT *
FROM pedido
WHERE estado = 'Rechazado' AND YEAR(fecha_pedido) = '2009';

-- 12. Devuelve un listado de todos los pedidos que han sido entregados en el mes de enero de cualquier año.
SELECT *
FROM pedido
-- WHERE estado = 'Entregado' AND MONTH(fecha_entrega) = '01';
WHERE estado = 'Entregado' AND DATE_FORMAT(fecha_entrega, '%m') = '01';

-- 13. Devuelve un listado con todos los pagos que se realizaron en el año 2008 mediante Paypal.
-- Ordene el resultado de mayor a menor.
SELECT *
FROM pago
WHERE YEAR(fecha_pago) = '2008' AND forma_pago = 'Paypal'
ORDER BY total;

-- 14. Devuelve un listado con todas las formas de pago que aparecen en la tabla pago. Tenga en
-- cuenta que no deben aparecer formas de pago repetidas.
SELECT forma_pago
FROM pago 
GROUP BY forma_pago;

/* 15. Devuelve un listado con todos los productos que pertenecen a la gama Ornamentales y que
tienen más de 100 unidades en stock. El listado deberá estar ordenado por su precio de
venta, mostrando en primer lugar los de mayor precio. */
SELECT *
FROM producto
WHERE gama = 'Ornamentales' AND cantidad_en_stock > 100
ORDER BY precio_venta DESC;

-- 16. Devuelve un listado con todos los clientes que sean de la ciudad de Madrid y cuyo
-- representante de ventas tenga el código de empleado 11 o 30.
SELECT *
FROM cliente
WHERE region = 'Madrid' AND codigo_empleado_rep_ventas IN (11,30);

/* Consultas multitabla (Composición interna)
Las consultas se deben resolver con INNER JOIN.
1. Obtén un listado con el nombre de cada cliente y el nombre y apellido de su representante de ventas.*/
SELECT nombre_cliente, nombre, apellido1, apellido2
FROM cliente
INNER JOIN empleado
ON codigo_empleado_rep_ventas = codigo_empleado;


-- 2. Muestra el nombre de los clientes que hayan realizado pagos junto con el nombre de sus representantes de ventas.
SELECT c.nombre_cliente, nombre, apellido1, apellido2, p.id_transaccion
FROM cliente AS c
INNER JOIN empleado
ON c.codigo_empleado_rep_ventas = codigo_empleado
INNER JOIN pago AS p
ON c.codigo_cliente = p.codigo_cliente;

-- 3. Muestra el nombre de los clientes que no hayan realizado pagos junto con el nombre de sus representantes de ventas.
SELECT nombre_cliente, nombre, apellido1, apellido2
FROM cliente
INNER JOIN empleado
ON codigo_empleado_rep_ventas = codigo_empleado
WHERE codigo_cliente NOT IN  (
	SELECT codigo_cliente
	FROM pago);

-- 4. Devuelve el nombre de los clientes que han hecho pagos y el nombre de sus representantes
-- junto con la ciudad de la oficina a la que pertenece el representante.
SELECT c.nombre_cliente, nombre, apellido1, apellido2, o.ciudad, p.id_transaccion
FROM cliente AS c
INNER JOIN empleado AS e
ON c.codigo_empleado_rep_ventas = e.codigo_empleado
INNER JOIN pago AS p
ON c.codigo_cliente = p.codigo_cliente
INNER JOIN oficina AS o
ON e.codigo_oficina = o.codigo_oficina;

-- 5. Devuelve el nombre de los clientes que no hayan hecho pagos y el nombre de sus
-- representantes junto con la ciudad de la oficina a la que pertenece el representante.
SELECT nombre_cliente, nombre, apellido1, apellido2, o.ciudad
FROM cliente
INNER JOIN oficina AS o
ON codigo_oficina = o.codigo_oficina
INNER JOIN empleado
ON codigo_empleado_rep_ventas = codigo_empleado
WHERE codigo_cliente NOT IN  (
	SELECT codigo_cliente
	FROM pago);

-- 6. Lista la dirección de las oficinas que tengan clientes en Fuenlabrada.
SELECT o.linea_direccion1, o.linea_direccion2, c.ciudad
FROM oficina AS o 
INNER JOIN empleado AS e 
ON o.codigo_oficina = e.codigo_oficina
INNER JOIN cliente AS c
ON e.codigo_empleado = c.codigo_empleado_rep_ventas
WHERE c.ciudad = 'Fuenlabrada';

-- 7. Devuelve el nombre de los clientes y el nombre de sus representantes junto con la ciudad
-- de la oficina a la que pertenece el representante.
SELECT c.nombre_cliente, e.nombre, e.apellido1, e.apellido2, o.ciudad
FROM oficina AS o 
INNER JOIN empleado AS e 
ON o.codigo_oficina = e.codigo_oficina
INNER JOIN cliente AS c
ON e.codigo_empleado = c.codigo_empleado_rep_ventas;

-- 8. Devuelve un listado con el nombre de los empleados junto con el nombre de sus jefes.
SELECT e1.codigo_empleado, e1.nombre, e1.codigo_jefe, e2.nombre
FROM empleado AS e1
INNER JOIN empleado AS e2
ON e1.codigo_jefe = e2.codigo_empleado;

-- 9. Devuelve el nombre de los clientes a los que no se les ha entregado a tiempo un pedido.
SELECT nombre_cliente, fecha_entrega, fecha_esperada
FROM cliente AS c
INNER JOIN pedido AS p
ON c.codigo_cliente = p.codigo_cliente
WHERE fecha_entrega = fecha_esperada;

-- 10. Devuelve un listado de las diferentes gamas de producto que ha comprado cada cliente.
SELECT p2.gama
FROM cliente AS c 
INNER JOIN pedido AS p
ON c.codigo_cliente = p.codigo_cliente
INNER JOIN detalle_pedido AS d
ON p.codigo_pedido = d.codigo_pedido
INNER JOIN producto AS p2
ON d.codigo_producto = p2.codigo_producto;

/*Consultas multitabla (Composición externa)
Resuelva todas las consultas utilizando las cláusulas LEFT JOIN, RIGHT JOIN, JOIN.
1. Devuelve un listado que muestre solamente los clientes que no han realizado ningún pago.*/
SELECT c.codigo_cliente, c.nombre_cliente, c.nombre_contacto, c.apellido_contacto, c.telefono, c.fax, c.linea_direccion1, c.linea_direccion2, 
c.ciudad, c.region, c.pais, c.codigo_postal, c.codigo_empleado_rep_ventas, c.limite_credito
FROM cliente AS c
LEFT JOIN pago AS p
ON c.codigo_cliente = p.codigo_cliente
WHERE id_transaccion IS NULL;

-- 2. Devuelve un listado que muestre solamente los clientes que no han realizado ningún pedido.
SELECT c.codigo_cliente, c.nombre_cliente, c.nombre_contacto, c.apellido_contacto, c.telefono, c.fax, c.linea_direccion1, c.linea_direccion2, 
c.ciudad, c.region, c.pais, c.codigo_postal, c.codigo_empleado_rep_ventas, c.limite_credito
FROM cliente AS c
LEFT JOIN pedido AS p
ON c.codigo_cliente = p.codigo_cliente
WHERE codigo_pedido IS NULL;

-- 3. Devuelve un listado que muestre los clientes que no han realizado ningún pago y los que no han realizado ningún pedido.
SELECT c.codigo_cliente, c.nombre_cliente, c.nombre_contacto, c.apellido_contacto, c.telefono, c.fax, c.linea_direccion1, c.linea_direccion2, 
c.ciudad, c.region, c.pais, c.codigo_postal, c.codigo_empleado_rep_ventas, c.limite_credito
FROM cliente AS c
LEFT JOIN pago AS p
ON c.codigo_cliente = p.codigo_cliente
LEFT JOIN pedido AS p2
ON c.codigo_cliente = p2.codigo_cliente
WHERE p.id_transaccion IS NULL AND p2.codigo_pedido IS NULL;

-- 4. Devuelve un listado que muestre solamente los empleados que no tienen una oficina asociada.
SELECT e.codigo_empleado, e.nombre, e.apellido1, e.apellido2, e.extension, e.email, e.codigo_oficina, e.codigo_jefe, e.puesto
FROM empleado AS e
LEFT JOIN oficina AS o
ON e.codigo_oficina = o.codigo_oficina
WHERE o.codigo_oficina IS NULL;

-- 5. Devuelve un listado que muestre solamente los empleados que no tienen un cliente asociado.
SELECT e.codigo_empleado, e.nombre, e.apellido1, e.apellido2, e.extension, e.email, e.codigo_oficina, e.codigo_jefe, e.puesto
FROM empleado AS e
LEFT JOIN cliente AS c
ON e.codigo_empleado = c.codigo_empleado_rep_ventas
WHERE c.codigo_cliente IS NULL;

-- 6. Devuelve un listado que muestre los empleados que no tienen una oficina asociada y los
-- que no tienen un cliente asociado.
SELECT e.codigo_empleado, e.nombre, e.apellido1, e.apellido2, e.extension, e.email, e.codigo_oficina, e.codigo_jefe, e.puesto
FROM empleado AS e
LEFT JOIN cliente AS c
ON e.codigo_empleado = c.codigo_empleado_rep_ventas
LEFT JOIN oficina AS o
ON e.codigo_oficina = o.codigo_oficina
WHERE c.codigo_cliente AND c.codigo_cliente IS NULL;

-- 7. Devuelve un listado de los productos que nunca han aparecido en un pedido.
SELECT p.codigo_producto, p.nombre, p.gama, p.dimensiones, p.proveedor, p.descripcion, p.cantidad_en_stock, p.precio_venta, p.precio_proveedor
FROM producto AS p
LEFT JOIN detalle_pedido AS d
ON p.codigo_producto = d.codigo_producto
WHERE codigo_pedido IS NULL;

-- 8. Devuelve las oficinas donde no trabajan ninguno de los empleados que hayan sido los
-- representantes de ventas de algún cliente que haya realizado la compra de algún producto de la gama Frutales.
SELECT o.codigo_oficina, o.ciudad, o.pais, o.region, o.codigo_postal, o.telefono, o.linea_direccion1, o.linea_direccion2
FROM oficina AS o
LEFT JOIN empleado AS e
ON o.codigo_oficina = e.codigo_oficina
LEFT JOIN cliente AS c
ON e.codigo_empleado = c.codigo_empleado_rep_ventas
LEFT JOIN pedido AS p
ON c.codigo_cliente = p.codigo_cliente
LEFT JOIN detalle_pedido AS d
ON p.codigo_pedido = d.codigo_pedido
LEFT JOIN producto AS p2
ON d.codigo_producto = p2.codigo_producto
WHERE gama <> 'Frutales'
GROUP BY o.codigo_oficina;

-- 9. Devuelve un listado con los clientes que han realizado algún pedido, pero no han realizad ningún pago.
SELECT c.codigo_cliente, c.nombre_cliente, c.nombre_contacto, c.apellido_contacto, c.telefono, c.fax, c.linea_direccion1, c.linea_direccion2, 
c.ciudad, c.region, c.pais, c.codigo_postal, c.codigo_empleado_rep_ventas, c.limite_credito
FROM cliente AS c
RIGHT JOIN pedido AS p
ON c.codigo_cliente = p.codigo_cliente
LEFT JOIN pago AS p2
ON c.codigo_cliente = p2.codigo_cliente
WHERE p2.id_transaccion IS NULL
GROUP BY c.codigo_cliente;

-- 10. Devuelve un listado con los datos de los empleados que no tienen clientes asociados y el nombre de su jefe asociado.
SELECT e.codigo_empleado, e.nombre, e.apellido1, e.apellido2, e.extension, e.email, e.codigo_oficina, e.codigo_jefe, e.puesto, e2.nombre
FROM empleado AS e
LEFT JOIN cliente AS c
ON e.codigo_empleado = c.codigo_empleado_rep_ventas
LEFT JOIN empleado AS e2
ON e.codigo_jefe = e2.codigo_empleado
WHERE c.codigo_cliente IS NULL;

-- Consultas resumen
-- 1. ¿Cuántos empleados hay en la compañía?
SELECT COUNT(*)
FROM empleado;

-- 2. ¿Cuántos clientes tiene cada país?
SELECT pais, COUNT(*)
FROM cliente
GROUP BY pais;

-- 3. ¿Cuál fue el pago medio en 2009?
SELECT AVG(total)
FROM pago
WHERE YEAR(fecha_pago) = 2009;

-- 4. ¿Cuántos pedidos hay en cada estado? Ordena el resultado de forma descendente por el número de pedidos.
SELECT estado, COUNT(*)
FROM pedido
GROUP BY estado
ORDER BY COUNT(*) DESC;

-- 5. Calcula el precio de venta del producto más caro y más barato en una misma consulta.
SELECT MAX(precio_venta), MIN(precio_venta)
FROM producto;

-- 6. Calcula el número de clientes que tiene la empresa.
SELECT COUNT(*)
FROM cliente;

-- 7. ¿Cuántos clientes tiene la ciudad de Madrid?
SELECT COUNT(*)
FROM cliente
WHERE ciudad = 'Madrid';

-- 8. ¿Calcula cuántos clientes tiene cada una de las ciudades que empiezan por M?
SELECT ciudad, COUNT(*)
FROM cliente
WHERE ciudad LIKE 'M%'
GROUP BY ciudad;

-- 9. Devuelve el nombre de los representantes de ventas y el número de clientes al que atiende cada uno.
SELECT nombre, COUNT(codigo_cliente)
FROM empleado
INNER JOIN cliente
ON codigo_empleado = codigo_empleado_rep_ventas
WHERE puesto = 'Representante Ventas'
GROUP BY  nombre;

-- 10. Calcula el número de clientes que no tiene asignado representante de ventas.
SELECT COUNT(*)
FROM cliente
WHERE codigo_empleado_rep_ventas IS NULL;

-- 11. Calcula la fecha del primer y último pago realizado por cada uno de los clientes. El listado
-- deberá mostrar el nombre y los apellidos de cada cliente.
SELECT c.nombre_cliente, c.nombre_contacto, c.apellido_contacto, MAX(p.fecha_pago), MIN(p.fecha_pago)
FROM cliente AS c
INNER JOIN pago AS p
ON c.codigo_cliente = p.codigo_cliente
GROUP BY c.codigo_cliente;

-- 12. Calcula el número de productos diferentes que hay en cada uno de los pedidos.
SELECT codigo_pedido, COUNT(codigo_producto)
FROM detalle_pedido
GROUP BY codigo_pedido;

-- 13. Calcula la suma de la cantidad total de todos los productos que aparecen en cada uno de los pedidos.
SELECT codigo_pedido, SUM(cantidad)
FROM detalle_pedido
GROUP BY codigo_pedido;

-- 14. Devuelve un listado de los 20 productos más vendidos y el número total de unidades que
-- se han vendido de cada uno. El listado deberá estar ordenado por el número total de unidades vendidas.
SELECT codigo_producto, SUM(cantidad)
FROM detalle_pedido
GROUP BY codigo_producto
ORDER BY SUM(cantidad) DESC LIMIT 20;
/*
15. La facturación que ha tenido la empresa en toda la historia, indicando la base imponible, el
IVA y el total facturado. La base imponible se calcula sumando el coste del producto por el
número de unidades vendidas de la tabla detalle_pedido. El IVA es el 21 % de la base
imponible, y el total la suma de los dos campos anteriores.*/
SELECT SUM(precio_unidad * cantidad) AS base_imponible, (SUM(precio_unidad * cantidad)* 0.21) AS IVA, SUM(precio_unidad * cantidad) + (SUM(precio_unidad * cantidad)* 0.21) AS total_facturado
FROM detalle_pedido;

-- 16. La misma información que en la pregunta anterior, pero agrupada por código de producto
SELECT codigo_producto, SUM(cantidad) * precio_unidad AS base_imponible, SUM(cantidad) * precio_unidad * 0.21 AS IVA, SUM(cantidad) * precio_unidad + SUM(cantidad) * precio_unidad * 0.21 AS total
FROM detalle_pedido
GROUP BY codigo_producto;

-- 17. La misma información que en la pregunta anterior, pero agrupada por código de producto
-- filtrada por los códigos que empiecen por OR.
SELECT codigo_producto, SUM(cantidad) * precio_unidad AS base_imponible, SUM(cantidad) * precio_unidad * 0.21 AS IVA, SUM(cantidad) * precio_unidad + SUM(cantidad) * precio_unidad * 0.21 AS total
FROM detalle_pedido
WHERE codigo_producto LIKE 'OR%'
GROUP BY codigo_producto;

-- 18. Lista las ventas totales de los productos que hayan facturado más de 3000 euros. Se
-- mostrará el nombre, unidades vendidas, total facturado y total facturado con impuestos (21% IVA)
SELECT (SELECT nombre FROM producto AS p WHERE d.codigo_producto = p.codigo_producto) AS producto,
codigo_producto, unidades_vendidas, total_facturado, total_facturado * 1.21 AS total_facturado_con_impuestos
FROM (SELECT codigo_producto, SUM(cantidad) AS unidades_vendidas, SUM(cantidad) * precio_unidad AS total_facturado
		FROM detalle_pedido
		GROUP BY codigo_producto) AS d
WHERE total_facturado > 3000;

-- Subconsultas con operadores básicos de comparación
-- 1. Devuelve el nombre del cliente con mayor límite de crédito.
SELECT nombre_cliente, limite_credito
FROM cliente
ORDER BY limite_credito DESC LIMIT 1;

-- 2. Devuelve el nombre del producto que tenga el precio de venta más caro.
SELECT nombre, precio_venta
FROM producto
ORDER BY precio_venta DESC LIMIT 1;

/*3. Devuelve el nombre del producto del que se han vendido más unidades. (Tenga en cuenta
que tendrá que calcular cuál es el número total de unidades que se han vendido de cada
producto a partir de los datos de la tabla detalle_pedido. Una vez que sepa cuál es el código
del producto, puede obtener su nombre fácilmente.)*/
SELECT nombre
FROM producto 
WHERE codigo_producto = (
	SELECT codigo_producto
	FROM detalle_pedido
	GROUP BY codigo_producto
	ORDER BY SUM(cantidad) DESC LIMIT 1);

-- 4. Los clientes cuyo límite de crédito sea mayor que los pagos que haya realizado. (Sin utilizar INNER JOIN).
SELECT *
FROM cliente AS c
WHERE limite_credito >
	(SELECT SUM(total)
	FROM pago AS p
    WHERE p.codigo_cliente = c.codigo_cliente);

-- 5. Devuelve el producto que más unidades tiene en stock.
SELECT *
FROM producto
ORDER BY cantidad_en_stock DESC LIMIT 1;

-- 6. Devuelve el producto que menos unidades tiene en stock.
SELECT *
FROM producto
ORDER BY cantidad_en_stock LIMIT 1;

-- 7. Devuelve el nombre, los apellidos y el email de los empleados que están a cargo de Alberto Soria.
SELECT nombre, apellido1, apellido2, email, codigo_jefe
FROM empleado
WHERE codigo_jefe = (
	SELECT codigo_empleado
	FROM empleado
	WHERE nombre = 'Alberto' AND apellido1 = 'Soria');
    
-- Subconsultas con ALL y ANY
-- 1. Devuelve el nombre del cliente con mayor límite de crédito.
SELECT nombre_cliente, limite_credito 
FROM cliente 
WHERE limite_credito >= ALL (
	SELECT limite_credito
    FROM cliente);

-- 2. Devuelve el nombre del producto que tenga el precio de venta más caro.
SELECT nombre, precio_venta 
FROM producto 
WHERE precio_venta >= ALL (
	SELECT precio_venta
    FROM producto);

-- 3. Devuelve el producto que menos unidades tiene en stock.
SELECT nombre, cantidad_en_stock 
FROM producto 
WHERE cantidad_en_stock <= ALL (
	SELECT cantidad_en_stock
    FROM producto);

-- Subconsultas con IN y NOT IN
-- 1. Devuelve el nombre, apellido1 y cargo de los empleados que no representen a ningún cliente.
SELECT codigo_empleado, nombre, apellido1, apellido2
FROM empleado
WHERE codigo_empleado NOT IN (
	SELECT codigo_empleado_rep_ventas
    FROM cliente);

-- 2. Devuelve un listado que muestre solamente los clientes que no han realizado ningún pago.
SELECT codigo_cliente, nombre_cliente
FROM cliente
WHERE codigo_cliente NOT IN (
	SELECT codigo_cliente
    FROM pago);

-- 3. Devuelve un listado que muestre solamente los clientes que sí han realizado ningún pago.
SELECT codigo_cliente, nombre_cliente
FROM cliente
WHERE codigo_cliente IN (
	SELECT codigo_cliente
    FROM pago);

-- 4. Devuelve un listado de los productos que nunca han aparecido en un pedido.
SELECT *
FROM producto
WHERE codigo_producto NOT IN (
	SELECT codigo_producto
    FROM detalle_pedido);
    
-- 5. Devuelve el nombre, apellidos, puesto y teléfono de la oficina de aquellos empleados que
-- no sean representante de ventas de ningún cliente.
SELECT codigo_empleado, nombre, apellido1, apellido2, puesto, 
(SELECT telefono FROM oficina WHERE codigo_oficina = e.codigo_oficina) AS telefono_oficina
FROM empleado AS e
WHERE codigo_empleado NOT IN (
	SELECT codigo_empleado_rep_ventas
    FROM cliente);

-- Subconsultas con EXISTS y NOT EXISTS
-- 1. Devuelve un listado que muestre solamente los clientes que no han realizado ningún pago.
SELECT codigo_cliente, nombre_cliente
FROM cliente AS c
WHERE NOT EXISTS (
	SELECT codigo_cliente
    FROM pago AS p
    WHERE p.codigo_cliente = c.codigo_cliente);

-- 2. Devuelve un listado que muestre solamente los clientes que sí han realizado ningún pago.
SELECT codigo_cliente, nombre_cliente
FROM cliente AS c
WHERE EXISTS (
	SELECT codigo_cliente
    FROM pago AS p
    WHERE p.codigo_cliente = c.codigo_cliente);
    
-- 3. Devuelve un listado de los productos que nunca han aparecido en un pedido.
SELECT *
FROM producto AS p
WHERE NOT EXISTS (
	SELECT codigo_producto
    FROM detalle_pedido AS d
    WHERE d.codigo_producto = p.codigo_producto);
    
-- 4. Devuelve un listado de los productos que han aparecido en un pedido alguna vez.
SELECT *
FROM producto AS p
WHERE EXISTS (
	SELECT codigo_producto
    FROM detalle_pedido AS d
    WHERE d.codigo_producto = p.codigo_producto);
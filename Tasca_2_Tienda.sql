USE tienda;

-- 1
SELECT nombre
FROM producto;

-- 2
SELECT nombre, precio
FROM producto;

-- 3
SELECT *
FROM producto;

-- 4
-- En el moment de fer l'activitat, el rate EURUSD és 1 EUR == 1.13 USD
-- Font: https://duckduckgo.com/?q=1+eur+to+usd&t=ffab&ia=currency
SELECT nombre, precio AS precio_EUR, ROUND((precio * 1.13), 2) AS precio_USD
FROM producto;

-- 5
SELECT nombre AS 'nom de producto', precio AS euros, ROUND((precio * 1.13), 2) AS dolars
FROM producto;

-- 6
SELECT UPPER(nombre), precio
FROM producto;

-- 7
SELECT LOWER(nombre), precio
FROM producto;

-- 8
SELECT nombre, UPPER(SUBSTRING(nombre, 1, 2)) AS abbr
FROM fabricante;

-- 9
SELECT nombre, ROUND(precio)
FROM producto;

-- 10
SELECT nombre, FLOOR(precio)
FROM producto;

-- 11
SELECT f.codigo
FROM fabricante f,
     producto p
WHERE f.codigo = p.codigo_fabricante;

-- 12
SELECT DISTINCT f.codigo
FROM fabricante f,
     producto p
WHERE f.codigo = p.codigo_fabricante;

-- 13
SELECT nombre
FROM fabricante
ORDER BY nombre;

-- 14
SELECT nombre
FROM fabricante
ORDER BY nombre DESC;

-- 15
SELECT nombre
FROM producto
ORDER BY nombre, precio DESC;

-- 16
SELECT *
FROM fabricante
LIMIT 5;

-- 17
SELECT *
FROM fabricante
LIMIT 2 OFFSET 3;

-- 18
SELECT nombre, precio
FROM producto
ORDER BY precio
LIMIT 1;

-- 19
SELECT nombre, precio
FROM producto
ORDER BY precio DESC
LIMIT 1;

-- 20
SELECT nombre
FROM producto
WHERE codigo_fabricante = 2;

-- 21
SELECT p.nombre AS producto, precio, f.nombre AS fabricante
FROM producto p,
     fabricante f
WHERE p.codigo_fabricante = f.codigo;

-- 22
SELECT p.nombre AS producto, precio, f.nombre AS fabricante
FROM producto p,
     fabricante f
WHERE p.codigo_fabricante = f.codigo
ORDER BY fabricante;

-- 23
SELECT p.codigo AS codigo_producto, p.nombre AS producto, f.codigo AS codigo_fabricante, f.nombre AS fabricante
FROM producto p,
     fabricante f
WHERE p.codigo_fabricante = f.codigo;

-- 24
SELECT p.nombre AS producto, precio, f.nombre AS fabricante
FROM producto p,
     fabricante f
WHERE p.codigo_fabricante = f.codigo
ORDER BY precio
LIMIT 1;

-- 25
SELECT p.nombre AS producto, precio, f.nombre AS fabricante
FROM producto p,
     fabricante f
WHERE p.codigo_fabricante = f.codigo
ORDER BY precio DESC
LIMIT 1;

-- 26
SELECT p.codigo, p.nombre
FROM producto p,
     fabricante f
WHERE p.codigo_fabricante = f.codigo
  AND f.nombre = 'Lenovo';

-- 27
SELECT p.codigo, p.nombre
FROM producto p,
     fabricante f
WHERE p.codigo_fabricante = f.codigo
  AND f.nombre = 'Crucial'
  AND precio > 200;

-- 28
SELECT p.codigo, p.nombre AS producto, f.nombre AS fabricante
FROM producto p,
     fabricante f
WHERE p.codigo_fabricante = f.codigo
  AND (f.nombre = 'Asus' OR f.nombre = 'Hewlett-Packard' OR f.nombre = 'Seagate');

-- 29
SELECT p.codigo, p.nombre AS producto, f.nombre AS fabricante
FROM producto p,
     fabricante f
WHERE p.codigo_fabricante = f.codigo
  AND f.nombre IN ('Asus', 'Hewlett-Packard', 'Seagate');

-- 30
SELECT p.nombre, precio
FROM producto p,
     fabricante f
WHERE p.codigo_fabricante = f.codigo
  AND RIGHT(f.nombre, 1) = 'e';

-- 31
SELECT p.nombre, precio
FROM producto p,
     fabricante f
WHERE p.codigo_fabricante = f.codigo
  AND LOCATE('w', f.nombre) > 0;

-- 32
SELECT p.codigo, p.nombre AS producto, f.nombre AS fabricante
FROM producto p,
     fabricante f
WHERE p.codigo_fabricante = f.codigo
  AND precio >= 180
ORDER BY precio DESC, p.nombre;

-- 33
SELECT DISTINCT f.codigo, f.nombre
FROM producto p,
     fabricante f
WHERE p.codigo_fabricante = f.codigo;

-- 34
SELECT DISTINCT f.nombre AS fabricante, p.nombre AS producto
FROM fabricante f
         LEFT JOIN producto p
                   ON f.codigo = p.codigo_fabricante;

-- 35
SELECT *
FROM fabricante
WHERE codigo NOT IN (
    SELECT codigo_fabricante
    FROM producto
);

-- 36
SELECT codigo, nombre
FROM producto
WHERE codigo_fabricante IN (
    SELECT codigo
    FROM fabricante
    WHERE nombre = 'Lenovo'
);

-- 37
SELECT *
FROM producto
WHERE precio = (
    SELECT precio
    FROM producto p,
         fabricante f
    WHERE p.codigo_fabricante = f.codigo
      AND f.nombre = 'Lenovo'
    ORDER BY precio DESC
    LIMIT 1
);

-- 38
SELECT p.nombre
FROM producto p,
     fabricante f
WHERE p.codigo_fabricante = f.codigo
  AND f.nombre = 'Lenovo'
ORDER BY precio DESC
LIMIT 1;

-- 39
SELECT p.nombre
FROM producto p,
     fabricante f
WHERE p.codigo_fabricante = f.codigo
  AND f.nombre = 'Hewlett-Packard'
ORDER BY precio
LIMIT 1;

-- 40
SELECT *
FROM producto
WHERE precio >= (
    SELECT precio
    FROM producto p,
         fabricante f
    WHERE p.codigo_fabricante = f.codigo
      AND f.nombre = 'Lenovo'
    ORDER BY precio DESC
    LIMIT 1
);

-- 41
SELECT p.codigo, p.nombre, precio
FROM producto p,
     fabricante f
WHERE p.codigo_fabricante = f.codigo
  AND f.nombre = 'Asus'
  AND precio
    > (
          SELECT AVG(p.precio)
          FROM producto p,
               fabricante f
          WHERE p.codigo_fabricante = f.codigo
            AND f.nombre = 'Asus'
      );
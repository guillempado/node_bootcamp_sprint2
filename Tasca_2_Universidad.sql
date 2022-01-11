USE universidad;

-- Primer apartat

-- 1
SELECT DISTINCT nombre, apellido1, apellido2
FROM persona
WHERE tipo = 'alumno';

-- 2
SELECT DISTINCT nombre, apellido1, apellido2
FROM persona
WHERE tipo = 'alumno'
  AND telefono IS NULL;

-- 3
SELECT DISTINCT nombre, apellido1, apellido2
FROM persona
WHERE tipo = 'alumno'
  AND LEFT(fecha_nacimiento, 4) = '1999';

-- 4
SELECT DISTINCT nombre, apellido1, apellido2
FROM persona
WHERE tipo = 'profesor'
  AND telefono IS NULL
  AND RIGHT(nif, 1) = 'k';

-- 5
SELECT id, nombre, creditos, tipo, id_profesor
FROM asignatura
WHERE cuatrimestre = 1
  AND curso = 3
  AND id_grado = 7;

-- 6
SELECT apellido1, apellido2, per.nombre, d.nombre AS departamento
FROM profesor pro,
     persona per,
     departamento d
WHERE pro.id_profesor = per.id
  AND pro.id_departamento = d.id
ORDER BY apellido1, apellido2, per.nombre;

-- 7
SELECT a.nombre, c.anyo_inicio, c.anyo_fin
FROM alumno_se_matricula_asignatura mat,
     persona p,
     asignatura a,
     curso_escolar c
WHERE p.nif = '26902806M'
  AND mat.id_alumno = p.id
  AND mat.id_asignatura = a.id
  AND mat.id_curso_escolar = c.id;

-- 8
SELECT DISTINCT d.nombre
FROM departamento d,
     profesor p,
     asignatura a,
     grado g
WHERE g.nombre = 'Grado en Ingeniería Informática (Plan 2015)'
  AND g.id = a.id_grado
  AND a.id_profesor = p.id_profesor
  AND p.id_departamento = d.id;

-- 9
SELECT DISTINCT p.*
FROM persona p,
     alumno_se_matricula_asignatura m,
     curso_escolar c
WHERE p.id = m.id_alumno
  AND m.id_curso_escolar = c.id
  AND c.anyo_inicio = '2018'


-- Segon apartat: LEFT JOIN i RIGHT JOIN

-- 1

-- 2

-- 3

-- 4

-- 5

-- 6

-- Tercer apartat: Consultes resum

-- 1

-- 2

-- 3

-- 4

-- 5

-- 6

-- 7

-- 8

-- 9

-- 10

-- 11


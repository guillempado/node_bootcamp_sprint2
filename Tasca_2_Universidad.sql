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
  AND c.anyo_inicio = '2018';

-- Segon apartat: LEFT JOIN i RIGHT JOIN

-- 1
SELECT d.nombre AS departamento, apellido1, apellido2, per.nombre
FROM persona per
         LEFT JOIN profesor pro ON per.id = pro.id_profesor
         LEFT JOIN departamento d ON pro.id_departamento = d.id
WHERE per.tipo = 'profesor'
ORDER BY d.nombre, apellido1, apellido2, per.nombre;

-- 2
SELECT per.nombre, apellido1, apellido2
FROM persona per
         LEFT JOIN profesor pro ON per.id = pro.id_profesor
WHERE per.tipo = 'profesor'
  AND pro.id_departamento IS NULL;

-- 3
SELECT d.*
FROM departamento d
         LEFT JOIN profesor p ON d.id = p.id_departamento
WHERE id_profesor IS NULL;

-- 4
SELECT DISTINCT per.*
FROM persona per
         LEFT JOIN asignatura a ON per.id = a.id_profesor
WHERE per.tipo = 'profesor'
  AND a.id IS NULL;

-- 5
-- No entenc molt bé aquesta... no cal fer cap join?
SELECT *
FROM asignatura
WHERE id_profesor IS NULL;

-- 6
-- que un profe d'un departament no tingui assignatures (fent left join i mirant nulls) no vol dir que el departament no en tingui: hauria de mirar totes les combinacions departament + profe + assignatura i validar que tots els profes de cada departament tenen un null a id d'assignatura. No acabo d'entendre com hauria d'implementar aquesta comprovació exhaustiva i només se m'acut fer-ho al revés: mirar els departaments que en tenen alguna assignatura i seleccionar els contraris.

SELECT *
FROM departamento
WHERE id NOT IN (
    SELECT d.id
    FROM departamento d
             JOIN profesor p ON d.id = p.id_departamento
             JOIN asignatura a ON p.id_profesor = a.id_profesor
);


-- Tercer apartat: Consultes resum

-- 1
SELECT COUNT(*)
FROM persona
WHERE tipo = 'alumno';

-- 2
SELECT COUNT(*)
FROM persona
WHERE tipo = 'alumno'
  AND LEFT(fecha_nacimiento, 4) = '1999';

-- 3
SELECT d.nombre AS departamento, COUNT(p.id_profesor) AS num_de_profesores
FROM departamento d
         JOIN profesor p ON d.id = p.id_departamento
GROUP BY d.id
ORDER BY num_de_profesores DESC;

-- 4
SELECT d.nombre AS departamento, COUNT(p.id_profesor) AS num_de_profesores
FROM departamento d
         LEFT JOIN profesor p ON d.id = p.id_departamento
GROUP BY d.id;

-- 5
SELECT g.nombre AS grado, COUNT(a.id) AS num_asignaturas
FROM grado g
         LEFT JOIN asignatura a ON g.id = a.id_grado
GROUP BY g.id
ORDER BY num_asignaturas DESC;

-- 6
SELECT *
FROM (
         SELECT g.nombre AS grado, COUNT(a.id) AS num_asignaturas
         FROM grado g
                  JOIN asignatura a ON g.id = a.id_grado
         GROUP BY g.id
         ORDER BY num_asignaturas DESC
     ) src_alias
WHERE num_asignaturas > 40;

-- 7
SELECT g.nombre AS grado, a.tipo AS tipo_asignatura, SUM(a.creditos) AS num_creditos
FROM grado g
         JOIN asignatura a ON g.id = a.id_grado
GROUP BY g.id, a.tipo;

-- 8
SELECT c.anyo_inicio, COUNT(m.id_alumno) AS num_alumnos
FROM curso_escolar c
         LEFT JOIN alumno_se_matricula_asignatura m ON c.id = m.id_curso_escolar
GROUP BY c.id;

-- 9
SELECT per.id, per.nombre, apellido1, apellido2, COUNT(a.id) AS num_asignaturas
FROM persona per
         LEFT JOIN asignatura a ON per.id = a.id_profesor
WHERE per.tipo = 'profesor'
GROUP BY per.id
ORDER BY num_asignaturas DESC;

-- 10
SELECT *
FROM persona
WHERE fecha_nacimiento = (SELECT MAX(fecha_nacimiento)
                          FROM persona
                          WHERE tipo = 'alumno');

-- 11
SELECT per.nombre, apellido1, apellido2
FROM persona per
         JOIN profesor pro ON per.id = pro.id_profesor
         JOIN departamento d ON pro.id_departamento = d.id
         LEFT JOIN asignatura a ON pro.id_profesor = a.id_profesor
WHERE a.id IS NULL;

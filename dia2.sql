-- Ctrl + Enter ejecuta la línea en la que estamos posicionados
select * from emp;
select apellido, oficio, salario from emp;
select * from dept;
-- Ordenación de datos. La ordenación siempre es ascendente, con 'desc' al final la ordenación es descendente. El 'order by' siempre va al final
select * from emp order by apellido;
select * from emp order by apellido desc;
-- Ordenar por más de un campo separados por comas
select * from emp order by dept_no, oficio;
select apellido from emp order by fecha_alt, apellido; -- Ordena primero por la fecha de alta y luego por apellido
-- Filtrado de registros mediante operadores de comparación
/*
= igual
>= mayor o igual
<= menor o igual
> mayor
< menor
<>, != distinto de
*/
select apellido, oficio, salario from emp where salario >=180000;
-- Oracle, por defecto diferencia entre mayus y minus en sus textos (string/varchar)
-- Todo lo que no sea un número, se escribe entre comillas simples '...'
-- Mostrar todos los empleados cuyo oficio sea diferente a 'DIRECTOR'
select * from emp where oficio <>'DIRECTOR';
-- Operadores relacionales. Nos permiten realizar más de una pregunta dentro de una consulta
/*
OR - Muestra los datos de cada filtro
AND - Todos los filtros deben cumplirse
NOT - Negación de una condición (intentar evitarlo siempre que podamos)
*/
select * from emp where apellido = 'rey' and oficio = 'PRESIDENTE';
select * from emp where dept_no=10 and oficio = 'DIRECTOR';
select * from emp where dept_no=10 or oficio =  'DIRECTOR';
select * from emp where dept_no=10 or dept_no=20;
-- Otros operadores opcionales
/*
BETWEEN - Muestra los datos entre un rango inclusive
*/
select * from emp where salario between 251000 and 390000 order by salario;
-- Podemos hacer la misma consulta con operadores y es eficiente igualmente (en vez de between, con los operadores < y >
-- El operador NOT va antes de la condición
select * from emp where NOT oficio = 'DIRECTOR';
-- Podemos realizar la consulta con operador en lugar del NOT
select * from emp where oficio <> 'DIRECTOR';
-- Existe un operador para buscar coincidencias en textos. Nos permite, mediante caracteres especiales hacer filtros en textos
/*
% - Busca cualquier caracter y longitud
_ - Un caracter cualquiera
? - Un caracter numérico
*/
select * from emp where apellido like 's%'; -- Muestra los datos de los empleados cuyo apellido empieza por S
select * from emp where apellido like '%a'; -- Muestra los datos de los empleados cuyo apellido termine por A
select * from emp where apellido like 's%a'; -- Muestra los datos de los empleados cuyo apellido empiece por S y termine por A
select * from emp where apellido like '____'; -- Muestra los datos de los empleados cuyo apellido sea de 4 letras (un _ por cada letra)
-- Existe un operador para buscar coincidencias de igualdad en un mismo campo
select * from emp where dept_no in (10,20); -- Muestra los datos de los empleados de los departamentos 10 y 20
select * from emp where dept_no in (10,20,30); -- Muestra los datos de los empleados de los departamentos 10, 20 y 30
-- El operador NOT IN realiza lo mismo pero recupera los que no coincidan
select * from emp where dept_no not in (20,30); -- Muestra todos los datos de los empleados que NO estén en los departamentos 20 y 30
-- Campos calculados. Un campo calculado es una herramienta en una consulta, sirve para generar campos que no existan en la tabla y los podemos calcular
select apellido, salario, comision, (salario+comision)  from emp; -- Muestra el apellido, el salario, la comisión y la suma de salario y comisión de los empleados, creando una columna nueva para la suma
-- Un campo calculado siempre debe tener un alias
select apellido, salario, comision, (salario+comision)  as TOTAL from emp; -- Crea un alias llamado 'TOTAL' de la suma del salario y comisión. Sólo admite una palabra. No modifica la tabla original
-- Un campo calculado solo es para el cursor.
select apellido, salario, comision, (salario+comision) as TOTAL from emp where TOTAL >= 344500;-- Los datos de los empleados cuyo salario más comisión sea mayor a 344500. El where no puede filtrar los alias. Consulta errónea 
select apellido, salario, comision, (salario+comision) as TOTAL from emp where (salario+comision) >= 344500; -- Esta es la misma consulta de arriba pero de forma correcta
select apellido, salario, comision, (salario+comision)  as TOTAL from emp order by TOTAL;
-- Clausula DISTINCT: se utiliza para el SELECT y lo que hace es eliminar repetidos de la consulta
select distinct oficio from emp; -- Muestra todos los oficios de los empleados pero sin repetir datos
select distinct oficio, apellido from emp; -- Muestra todos los oficios y apellidos sin repetirse ambas condiciones
select * from dept;
-- 6.Mostrar todos los enfermos nacidos antes del 11/01/1970.
select * from enfermo where fecha_nac < '11/01/1970';
-- 7.Igual que el anterior, para los nacidos antes del 1/1/1970 ordenados por número de inscripción.
select * from enfermo where fecha_nac <'11/01/1970' order by inscripcion;
--8. Listar todos los datos de la plantilla del hospital del turno de mañana
select * from plantilla where turno = 'M';
--9. Idem del turno de noche.
select * from plantilla where turno = 'N';
--10. Listar los doctores que su salario anual supere 3.000.000 €
select * from doctor where salario*12 >3000000;
--11. Visualizar los empleados de la plantilla del turno de mañana que tengan un salario entre 200.000 y 250.000.
select * from plantilla where turno = 'M' and salario between 200000 and 250000;
--12. Visualizar los empleados de la tabla emp que no se dieron de alta entre el 01/01/1980 y el 12/12/1982.
/* select * from emp where fecha_alt not between '01/01/1986 and '12/12/1994'; */
select * from emp where fecha_alt <= '01/01/1986' or fecha_alt >= '12/12/1994' and oficio = 'EMPLEADO';
--13. Mostrar los nombres de los departamentos situados en Madrid o en Barcelona.
-- select dnombre from dept where loc = 'MADRID' or loc = 'BARCELONA';
select dnombre from dept where loc in ('MADRID','BARCELONA');
-- Con el comando desc Nombre_Tabla puedes ver las columnas que tiene la tabla y sus tipos de datos, además de si son null o no
desc enfermo;

-- CONSULTAS DE AGRUPACIÓN
-- Este tipo de consultas nos permiten mostrar algún resumen sobre un grupo determinado de los datos. Utilizan funciones de agrupación para conseguir el resumen
-- Las funciones deben tener alias
/*
count(*) - Cuenta el número de registros, incluyendo nulos
count(campo) - Cuenta el número de registros, sin incluir nulos
sum(numero) - Suma el total de un campo numérico
avg(numero) - Muestra la media de un campo numérico
max(campo) - Devuelve el valor máximo de un campo
min(campo) - Devuelve el valor mínimo de un campo
*/
select count(*) as NUMERO_DOCTORES from doctor; -- Muestra el número de registros de la tabla DOCTOR. Debe tener un alias
select count(apellido) as NUMERO_DOCTORES from doctor; -- Muestra el número de registros de la tabla DOCTOR pero sin campos nulos. Debe tener un alias
select count(*) as DOCTORES, max(salario) as MAXIMO from doctor; -- Muestra el número de doctores y el salario máximo
select avg(salario) as MEDIA from doctor;
-- Los datos resultantes de las funciones podemos agruparlos por algún campo/s de la tabla
-- Cuando queremos agrupar utilizamos GROUP BY después del FROM
-- TRUCO: debemos agrupar por cada campo que no sea una función
select count(*) as DOCTORES, especialidad from doctor group by especialidad; -- Muestra el número de doctores que hay por cada especialidad
select count(*) as PERSONAS, max(salario) as MAXIMO, dept_no, oficio from emp group by dept_no, oficio; /* Muestra el número de personas, el salario máximo,
el número de departamento y el oficio por cada departamento y oficio */
select count(*) as PERSONAS from plantilla;
select count(*) as PERSONAS, turno from plantilla group by turno;
-- Filtrando en consultas de agrupación. Hay dos posibilidades, WHERE antes del GROUP BY o HAVING después del GROUP BY
select count(*) as EMPLEADOS, oficio from emp group by oficio; -- Muestra cuantos empleados hay por cada oficio
select count(*) as EMPLEADOS, oficio from emp where salario > 200000 group by oficio; --Muestra cuantos empleados hay por cada oficio que cobren más de 200000€
select count(*) as EMPLEADOS, oficio from emp group by oficio having oficio in ('ANALISTA','VENDEDOR'); /* Muestra cuantos empleados hay por cada oficio y 
que sean analistas o vendedores */
-- Cuando no podemos decidir entre WHERE y HAVING y estamos obligados a usar HAVING: Si queremos filtrar por una función de agrupación
select count(*) as EMPLEADOS, oficio from emp group by oficio having count(*) >= 2; -- Mostrar cuantos empleados tenemos por cada oficio pero solamente donde tengamos 2 o más empleados del mismo oficio
-- HAVING filtra según los datos que haya en el SELECT. 
-- WHERE filtra según todos los datos de la tabla, por eso HAVING es más rápido


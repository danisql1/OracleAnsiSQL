--1. Seleccionar el apellido, oficio, salario, numero de departamento y su nombre de todos los empleados cuyo salario sea mayor de 300000
select emp.apellido, emp.oficio, emp.salario, emp.dept_no, dept.dnombre from emp inner join dept on emp.dept_no = dept.dept_no where salario>=300000;
--2. Mostrar todos los nombres de Hospital con sus nombres de salas correspondientes.
select hospital.nombre as NOMBRE_HOSPITAL, sala.nombre as NOMBRE_SALA from hospital inner join sala on hospital.hospital_cod = sala.hospital_cod;
-- Cuando en el select pides dos campos con el mismo nombre, hay que ponerle un alias
--3. Calcular cuántos trabajadores de la empresa hay en cada ciudad.
select count(emp.emp_no) as TRABAJADORES, dept.loc  from emp right join dept on emp.dept_no = dept.dept_no group by dept.loc;
--4. Visualizar cuantas personas realizan cada oficio en cada departamento mostrando el nombre del departamento.
select count(emp.emp_no) as PERSONAS, emp.oficio, dept.dnombre from emp right join dept on emp.dept_no = dept.dept_no group by emp.oficio, dept.dnombre;
--5. Contar cuantas salas hay en cada hospital, mostrando el nombre de las salas y el nombre del hospital.
select count(sala.sala_cod) as SALAS, sala.nombre, hospital.nombre from hospital inner join sala on hospital.hospital_cod = sala.hospital_cod group by hospital.nombre, sala.nombre;
--6. Queremos saber cuántos trabajadores se dieron de alta entre el año 1997 y 1998 y en qué departamento.
select count(emp.emp_no) as TRABAJADORES, dept.dnombre from emp inner join dept on emp.dept_no = dept.dept_no where emp.fecha_alt between '01/01/1997' and '31/12/1998' group by dept.dnombre;
--7. Buscar aquellas ciudades con cuatro o más personas trabajando.
select dept.loc, count(emp.emp_no) as TRABAJADORES from emp inner join dept on emp.dept_no = dept.dept_no group by dept.loc having count(emp.emp_no)>=4;
--8. Calcular la media salarial por ciudad.  Mostrar solamente la media para Madrid y Sevilla.
select dept.loc, avg(emp.salario) as MEDIA_SALARIO from emp inner join dept on emp.dept_no = dept.dept_no group by dept.loc having dept.loc in ('MADRID','SEVILLA');
--9. Mostrar los doctores junto con el nombre de hospital en el que ejercen, la dirección y el teléfono del mismo.
select doctor.apellido, hospital.nombre, hospital.direccion, hospital.telefono from doctor inner join hospital on doctor.hospital_cod = hospital.hospital_cod;
--10. Mostrar los nombres de los hospitales junto con el mejor salario de los empleados de la plantilla de cada hospital.
select hospital.nombre, max(plantilla.salario) as MEJOR_SALARIO from hospital inner join plantilla on hospital.hospital_cod = plantilla.hospital_cod group by hospital.nombre;
--11. Visualizar el Apellido, función y turno de los empleados de la plantilla junto con el nombre de la sala y el nombre del hospital con el teléfono.
select plantilla.apellido, plantilla.funcion, plantilla.turno, sala.nombre as NOMBRE_SALA, hospital.nombre as NOMBRE_HOSPITAL, hospital.telefono from plantilla
inner join hospital on plantilla.hospital_cod = hospital.hospital_cod inner join sala  on hospital.hospital_cod = sala.hospital_cod and plantilla.sala_cod = sala.sala_cod; 
--12. Visualizar el máximo salario, mínimo salario de los Directores dependiendo de la ciudad en la que trabajen. Indicar el número total de directores por ciudad.
select max(emp.salario) as SALARIO_MAXIMO, min(emp.salario) as SALARIO_MINIMO, count(emp_no) as NUMERO_DIRECTORES, dept.loc as CIUDAD from emp
inner join dept on emp.dept_no = dept.dept_no where oficio = 'DIRECTOR' group by dept.loc;
--13. Averiguar la combinación de que salas podría haber por cada uno de los hospitales.
select distinct(sala.nombre) as NOMBRE_SALA, hospital.nombre as NOMBRE_HOSPITAL from sala cross join hospital;

-- SUBCONSULTAS

/* Son consultas que necesitan del resultado de otra consulta para poder ser ejecutadas. No son autónomas, necesitan de algún valor. No importa el nivel de anidamiento de 
subconsultas, aunque pueden ralentizar la respuesta. Generan bloqueos en consultas SELECT, lo que también ralentiza las respuestas.
Debemos intentar evitarlas en la medida de lo posible con SELECT
*/
-- Visualizar los datos del empleado que más cobra de la empresa (emp)
select * from emp where salario=(select max(salario) from emp);
-- Se ejecutan las dos consultas a la vez, y se anida el resultado de una consulta con la igualdad de la respuesta de otra consulta. Las subconsultas van entre paréntesis
-- Mostrar los empleados que tienen el mismo oficio que el empleado Gil.
select * from emp where oficio = (select oficio from emp where apellido = 'gil');
-- Mostrar los empleados que tienen el mismo oficio que el empleado Gil y que cobren menos que Jimenez
select * from emp where oficio = (select oficio from emp where apellido = 'gil') and salario < (select salario from emp where apellido = 'jimenez');
-- Mostrar los empleados que tienen el mismo oficio que el empleado Gil y el mismo oficio que Jimenez
select * from emp where oficio = (select oficio from emp where apellido = 'gil' or apellido = 'jimenez'); 
-- Si una subconsulta devuelve más de un valor (como la de arriba), se utiliza el operador IN
select * from emp where oficio in (select oficio from emp where apellido = 'gil' or apellido = 'jimenez'); 
-- Por supuesto, podemos utilizar subconsultas para otras tablas
-- Mostrar el apellido y el oficio de los empleados del departamento de Madrid
select apellido, oficio from emp where dept_no = (select dept_no from dept where loc='MADRID');
-- La consulta de arriba no debería hacerse con subconsulta, mejor con JOIN porque ambas tablas se relacionan directamente y la subconsulta genera bloqueos.
-- La consulta correcta sería:
select emp.apellido, emp.oficio from emp inner join dept on emp.dept_no = dept.dept_no where dept.loc = 'MADRID';

-- CONSULTAS UNION

-- Muestran, en un mismo cursor, un mismo conjunto de resultados. Estas consultas se utilizan como concepto, no como relación. Tenemos que seguir 3 normas:
-- 1) La primera consulta es la jefa
-- 2) Todas las consultas deben tener el mismo número de columnas 
-- 3) Todas las columnas deben tener el mismo tipo de dato entre sí
-- En nuestra BBDD, tenemos datos de personas en diferentes tablas, como emp, plantilla y doctor. 
select apellido, oficio, salario from emp union select apellido, funcion, salario from plantilla;
select apellido, oficio, salario from emp union select apellido, funcion, salario from plantilla union select dnombre, loc, dept_no from dept;
-- Por supuesto, podemos ordenar sin problemas
select apellido, oficio, salario from emp union select apellido, funcion, salario from plantilla union select apellido, especialidad, salario from doctor order by 3; -- 3 es el salario, está en la posición 3
-- En las consultas UNION deberíamos utilizar siempre numerando como recomendación. Si ponemos un alias, no funciona.
select apellido, oficio, salario from emp union select apellido, funcion, salario from plantilla union select apellido, especialidad, salario from doctor order by oficio; 
-- En la consulta de arriba, oficio sólo está en una tabla, por eso no funcionaría, al igual que funcion o especialidad. Por eso hay que hacer el order by con un número, no con palabra.
-- Por supuesto, podemos filtrar los datos de la consulta. Por ejemplo, mostrar los datos de las personas que cobren menos de 300.000.
select apellido, oficio, salario from emp where salario<300000
union 
select apellido, funcion, salario from plantilla where salario<300000 
union 
select apellido, especialidad, salario from doctor where salario <300000 
order by 1;
-- Para que el filtro del salario se aplique en las 3 consultas, hay que filtrar por cada consulta individualmente. Cada WHERE es independiente del UNION
select apellido, oficio from emp union select apellido, oficio from emp; -- UNION elimina los resultados repetidos. Si queremos repetidos, debemos utilizar UNION ALL
select apellido, oficio from emp union all select apellido, oficio from emp; 


















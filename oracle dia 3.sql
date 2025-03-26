-- 1. Encontrar el salario medio de los analistas, mostrando el número de los empleados con oficio analista.
select count(*) as NUMERO_EMPLEADOS, oficio, avg(salario) as SALARIO_MEDIO from emp group by oficio having oficio ='ANALISTA';
--2. Encontrar el salario más alto, mas bajo y la diferencia entre ambos de todos los empleados con oficio EMPLEADO.
select oficio, max(salario) as MAXIMO, min(salario) as MINIMO, max(salario) - min(salario) as DIFERENCIA from emp group by oficio having oficio = 'EMPLEADO';
--3. Visualizar los salarios mayores para cada oficio.
select oficio, max(salario) as SALARIO_MAXIMO from emp group by oficio;
--4. Visualizar el número de personas que realizan cada oficio en cada departamento ordenado por departamento.
select count(*) as PERSONAS, oficio, dept_no from emp group by oficio, dept_no order by dept_no;
--5. Buscar aquellos departamentos con cuatro o más personas trabajando.
select dept_no, count(*) as PERSONAS from emp group by dept_no having count(*)>=4;
--6. Mostrar el número de directores que existen por departamento.
select count(*) as NUMERO_DIRECTORES, dept_no from emp where oficio = 'DIRECTOR' group by dept_no;
--7. Visualizar el número de enfermeros, enfermeras e interinos que hay en la plantilla, ordenados por la función.
select count(*) as ENFERMEROS, funcion from plantilla group by funcion having funcion in ('ENFERMERO','ENFERMERA','INTERINO');
--8. Visualizar departamentos, oficios y número de personas, para aquellos departamentos que tengan dos o más personas trabajando en el mismo oficio.
select dept_no, oficio, count(*) as EMPLEADOS from emp group by dept_no, oficio having count(*)>=2;
--9. Calcular el salario medio, Diferencia, Máximo y Mínimo de cada oficio. Indicando el oficio y el número de empleados de cada oficio.
select oficio, count(*) as EMPLEADOS, min(salario) as SALARIOMAXIMO, max(salario) as SALARIOMINIMO, max(salario) - min(salario) as DIFERENCIA, avg(salario) as MEDIA from emp group by  oficio;
--10. Calcular el valor medio de las camas que existen para cada nombre de sala. Indicar el nombre de cada sala y el número de cada una de ellas.
select nombre, avg(num_cama) as MEDIA, count(*) as NUMERO_SALA from sala group by nombre;
--11. Calcular el salario medio de la plantilla de la sala 6, según la función que realizan. Indicar la función y el número de empleados.
select avg(salario) as SALARIO_MEDIO, funcion, count(*) as EMPLEADOS from plantilla where sala_cod=6 group by funcion;
--12. Averiguar los últimos empleados que se dieron de alta en la empresa en cada uno de los oficios, ordenados por la fecha.
select max(fecha_alt) AS FECHAMAXIMA, Oficio from emp group by oficio order by 1;
--13. Mostrar el número de hombres y el número de mujeres que hay entre los enfermos.
select count(*) as HOMBRES, count(*) as MUJERES from enfermo group by sexo having sexo in ('H','M');
--14. Mostrar la suma total del salario que cobran los empleados de la plantilla para cada función y turno.
select funcion, Turno, sum(salario) as SUMASALARIAL from plantilla group by funcion, Turno;
--15. Calcular el número de salas que existen en cada hospital.
select hospital_cod, count(*) as NUMERO_SALAS from sala group by hospital_cod;
--16. Mostrar el número de enfermeras que existan por cada sala.
select count(*) as NUMERO_ENFERMERAS, sala_cod from plantilla where funcion = 'ENFERMERA' group by sala_cod;

-- CONSULTAS DE COMBINACIÓN
-- Nos permiten mostrar datos de varias tablas que deben estar relacionadas entre sí mediante una clave
/*
-- 1) Necesitamos el campo/s de relación entre las tablas
-- 2) Debemos poner el nombre de cada tabla y cada campo en la consulta
*/
-- SINTAXIS (de la forma más eficiente, con JOIN, creada por Oracle en 1999 y estandarizada):
select tabla1.campo1, tabla1.campo2, tabla2.campo1, tabla2.campo2 from tabla1 inner join tabla2 on tabla1.campoDeRelacion = tabla2.campoDeRelacion;
-- Muestra el apellido, el oficio de empleados junto a su nombre de departamento y localidad
select emp.apellido, emp.oficio, dept.dnombre, dept.loc from emp inner join dept on emp.dept_no = dept.dept_no;
-- Tenemos otra sintaxis para realizar los JOIN (versión estándar del '92. Forma menos eficiente):
select emp.apellido, emp.oficio, dept.dnombre, dept.loc from emp, dept where emp.dept_no = dept.dept_no;
-- Podemos realizar, por supuesto, el WHERE.
-- Mostrar los datos solo de Madrid
select emp.apellido, emp.oficio, dept.dnombre, dept.loc from emp inner join dept on emp.dept_no = dept.dept_no where dept.loc = 'MADRID';
-- No es obligatorio incluir el nombre de la tabla antes del campo a mostrar en el select (no recomendado)
select emp.dept_no, apellido, oficio, dnombre, loc from emp inner join dept on emp.dept_no = dept.dept_no;
-- Podemos incluir alias a los nombres de las tablas para llamarlas así a lo largo de la consulta. Es útil cuando tenemos tablas con nombres muy largos.
-- Cuando ponemos alias, la tabla se llamará así para toda la consulta
select e.apellido, e.oficio, d.dnombre, d.loc from emp e inner join dept d on e.dept_no = d.dept_no;
-- Tenemos múltiples tipos de JOIN en las bases de datos
-- INNER: combina los resultados de las dos tablas
-- LEFT: combina las dos tablas y también la tabla izquierda. La tabla de la izquierda es la que está antes del JOIN
-- RIGHT: combina las dos tablas y también la tabla derecha. La tabla de la derecha es la que está después del JOIN
-- FULL: combina las dos tablas y fuerza todas las tablas
-- CROSS: producto cartesiano, combina cada dato de una tabla con los otros datos de la tabla, es decir, todas las posibilidades

-- Tenemos un departamento, el 40, producción, Granada, sin empleados. Vamos a crear un nuevo empleado que no tenga departamento
select emp.apellido, dept.dnombre, dept.loc from emp left  join dept on emp.dept_no = dept.dept_no;
select emp.apellido, dept.dnombre, dept.loc from emp right  join dept on emp.dept_no = dept.dept_no;
select emp.apellido, dept.dnombre, dept.loc from emp full  join dept on emp.dept_no = dept.dept_no;
select emp.apellido, dept.dnombre, dept.loc from emp cross  join dept; -- El CROSS no lleva ON

-- Mostrar la media salarial de los doctores por hospital
select avg(salario) as MEDIA_SALARIAL, hospital_cod from doctor group by hospital_cod order by hospital_cod;
-- Mostrar la media salarial de los doctores por hospital, mostrando el nombre del hospital
select avg(doctor.salario) as MEDIA_SALARIAL, hospital.nombre from doctor inner join hospital on doctor.hospital_cod = hospital.hospital_cod group by hospital.nombre;
-- Mostrar el número de empleados que existen por cada localidad
select count(*) as NUMERO_EMPLEADOS, dept.loc from emp right join dept on emp.dept_no = dept.dept_no group by dept.loc; 
select * from dept;
select * from emp;










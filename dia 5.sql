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

-- SELECT TO SELECT

/* Es una consulta sobre un cursor (es decir, sobre un SELECT ya realizado). Cuando hacemos un SELECT, en realidad estamos recuperando datos de una tabla.
Este tipo de consultas nos permiten recuperar datos de un SELECT ya realizado, los WHERE y demás se hacen sobre el cursor.
La sintaxis es: 
select * from
    (select TABLA1.CAMPO1 as ALIAS, TABLA2.CAMPO2 from TABLA1
    union
    select TABLA2.CAMPO1, TABLA2.CAMPO2 from TABLA2) CONSULTA
    where CONSULTA.ALIAS = 'VALOR';
CONSULTA en la sintaxis es el alias que le tienes que dar a todo el paréntesis obligatoriamente.
*/
-- Queremos mostrar los datos de todas las personas de mi BBDD (emp, doctor y plantilla). Solamente queremos los que cobren menos sueldo de 300.000€
select * from
    (select apellido, oficio, salario as SUELDO from emp
    union
    select apellido, funcion, salario from plantilla
    union 
    select apellido, especialidad, salario from doctor) CONSULTA
where CONSULTA.sueldo < 300000;

-- CONSULTAS A NIVEL DE FILA

/* Son consultas creadas para dar formato a la salida de datos. No modifican los datos de la tabla, los muestran de otra forma según lo necesitemos. Van con 
preguntas en la consulta. 
-- 1) A NIVEL DE IGUALDAD
La sintaxis evaluando un campo (en este caso el 3) es:
    select CAMPO1, CAMPO2,
    case CAMPO 3
        when 'dato1' then 'valor1'
        when 'dato2' then 'valor2'
        else 'valor3'
    end as ALIAS
    from TABLA;
*/
-- Mostrar los apellidos de la plantilla pero con su turno que se vea bien (en la tabla está guardado como M, T y N, que nos muestre Mañana, Tarde y Noche)
select apellido, funcion, case turno 
    when 'M' then 'Mañana'
    when 'T' then 'Tarde'
    else 'Noche'
    end as Turno
    from plantilla;
-- Si no le pones ELSE, en vez del turno de Noche te saldrían los campos como null. El ELSE es opcional.
-- Mostrar los distintos turnos junto con la suma de los salarios de los empleados de dichos turnos.
select consulta.formato, sum(consulta.salario) from
(select apellido, funcion, salario, case turno 
    when 'M' then 'Mañana'
    when 'T' then 'Tarde'
    else 'Noche'
    end as Formato
    from plantilla) CONSULTA
group by Formato;

-- 2) Evaluar por un operador (rango, mayor o menor, distinto)
    select CAMPO1, CAMPO2, 
    case -- En este caso no se pone campo en el CASE
    when CAMPO3 <= X then 'RESULTADO1'
    when CAMPO3 > X then 'RESULTADO2'
    else 'RESULTADO3'
    end as FORMATO 
    from TABLA;

-- SALARIOS DE LA PLANTILLA
select apellido, funcion, salario, case
when salario >=250000 then 'SALARIO CORRECTO'
when salario >=170000 and salario < 250000 then 'SALARIO MEDIO'
else 'BECARIO'
end as RANGO_SALARIAL 
from plantilla;
-- El ELSE también es opcional aquí, pero hay que evitar los campos null.
-- Mostrar la suma salarial de los empleados por su nombre de departamento.
select sum(emp.salario) as SUMA_SALARIAL, dept.dnombre as DEPARTAMENTO from emp right join dept on emp.dept_no = dept.dept_no group by dept.dnombre;
-- Mostrar la suma salarial de los doctores por su nombre de hospital.
select sum(doctor.salario) as SUMA_SALARIAL, hospital.nombre as NOMBRE_HOSPITAL from doctor right join hospital on doctor.hospital_cod = hospital.hospital_cod group by hospital.nombre;
-- Me gustaría poder ver todo junto en una misma consulta.
select sum(emp.salario) as SUMA_SALARIAL, dept.dnombre as DEPARTAMENTO from emp right join dept on emp.dept_no = dept.dept_no group by dept.dnombre
union 
select sum(doctor.salario), hospital.nombre from doctor right join hospital on doctor.hospital_cod = hospital.hospital_cod group by hospital.nombre;

-- CONSULTAS DE ACCIÓN

/* Son consultas para modificar los registros de la base de datos. Son estándar,en Oracle, las consultas de acción son transaccionales, es decir, se almacenan de 
forma temporal por sesión. Para deshacer los cambios o para hacerlos permanentes, tenemos dos palabras:
    COMMIT: hace los cambios permanentes.
    ROLLBACK: deshace los cambios realizados.
*/
-- 1) Inserto 2 registros nuevos
-- 2) COMMIT permanente
-- 3) Inserto otro registro nuevo
-- 4) ROLLBACK solamente quita el paso 3, porque anteriormente hemos hecho un COMMIT.

/* Tenemos 3 tipos de consultas de acción:
    1) INSERT: inserta un nuevo registro en una tabla.
    2) UPDATE: modifica uno o varios registros de una tabla.
    3) DELETE: elimina uno o varios registros de una tabla.
*/
------------------------------------------------------------------------------------------
-- INSERT
-- Cada registro a insertar, es una instrucción INSERT distinta. Si queremos insertar 5 registros, tenemos que hacer 5 INSERT diferentes.
-- Tenemos 2 tipos de sintaxis:
        -- 1) Insertar todos los datos de la tabla: debemos indicar todas las columnas/campos de la tabla y en el mismo orden que estén en la propia tabla.
        -- INSERT INTO tabla VALUES (valor1, valor2, valor3, valor4...);
insert into dept values (50, 'ORACLE', 'BERNABEU');
commit;
insert into dept values (51, 'BORRAR', 'BORRAR');
rollback;
select * from dept;
        -- 2) Insertar solamente algunos datos de la tabla: debemos indicar el nombre de las columnas que deseamos insertar y los valores irán en dicho orden, la tabla
        -- no tiene nada que ver.
        -- INSERT INTO tabla (campo3, campo7) values (valor3, valor7);
        -- Queremos insertar un nuevo departamento en Almería
insert into dept (dept_no, loc) values (55, 'ALMERIA');
-- Las subconsultas son evitables si estamos en un SELECT, pero súper útiles si estamos en consultas de acción.
-- Necesito un departamento de sidra en Gijón.
-- Generar el siguiente número dsponible en la consulta de acción.
select max(dept_no)+1 from dept; -- Para ver cuál es el siguiente número para darle el departamento
insert into dept values ((select max(dept_no)+1 from dept), 'SIDRA', 'GIJON'); -- Al meter un SELECT, tiene que ir entre paréntesis 
select * from dept;

-- DELETE

-- Elimina una o varias filas de una tabla. Si no existe nada para eliminar, no hace nada (no da error). La sintaxis es:
    -- DELETE from TABLA;
-- La sintaxis anterior elimina TODOS los registros de la tabla. Opcionalmente, podemos incluir un WHERE con las condiciones necesarias.
-- Eliminar el departamento de Oracle.
delete from dept where dnombre = 'ORACLE';
select * from dept;
rollback;
-- Imprescindible utilizar subconsultas para DELETE 
-- Eliminar todos los empleados de Granada.
delete from emp where dept_no = (select dept_no from dept where loc = 'GRANADA'); -- Como no tenía empleados, no borra ningún registro pero no da error.
select * from emp;

-- UPDATE

-- Modifica una o varias filas de una tabla. Puede modificar varias columnas a la vez. La sintaxis es:
    -- UPDATE tabla SET campo1=valor1, campo2=valor2;
-- Esta consulta modifica TODAS las filas de la tabla, es conveniente utilizar un WHERE.
-- Modificar el salario de la plantilla del turno de noche, todos cobrarán 315.000€
select * from plantilla;
update plantilla set salario = 315000
where turno = 'N';
-- Modificar la ciudad y el nombre del departamento 10. Se llamará CUENTAS y estará localizado en TOLEDO.
select * from dept;
update dept set loc='TOLEDO', dnombre='CUENTAS' where dept_no=10;
-- Podemos mantener el valor de una columna y asignar "algo" con operaciones matemáticas. 
-- Incrementar en 1 el salario de todos los empleados.
update emp set salario =salario+1;
select * from emp;
-- Podemos utilizar subconsultas en UPDATE:
    -- 1) Si las subconsultas están en el SET, solamente deben devolver 1 dato.
-- Arroyo está envidioso de Sala, poner el mismo salario a Arroyo que a Sala.
update emp set salario = (select salario from emp where apellido = 'sala') where apellido = 'arroyo';
select * from emp;

-- Poner a la mitad el salario de los empleados de Barcelona.
update emp set salario = salario/2 where dept_no = (select dept_no from dept where loc = 'BARCELONA');

-- 1. Dar de alta con fecha actual al empleado José Escriche Barrera como programador perteneciente al departamento de producción.  Tendrá un salario base de 70000 pts/mes y no cobrará comisión. 
insert into emp (emp_no, apellido, oficio, salario, comision, dept_no) values ((select max(emp_no)+1 from emp), 'jose escriche barrera', 'PROGRAMADOR', 70000, 0,
(select dept_no from dept where dnombre='PRODUCCIÓN'));
-- 2. Se quiere dar de alta un departamento de informática situado en Fuenlabrada (Madrid).
insert into dept values ((select max(dept_no)+10 from dept),'INFORMÁTICA','FUENLABRADA');
--3. El departamento de ventas, por motivos peseteros, se traslada a Teruel, realizar dicha modificación.
update dept set loc = 'TERUEL' where dnombre = 'VENTAS';
--4. En el departamento anterior (ventas), se dan de alta dos empleados: Julián Romeral y Luis Alonso.  Su salario base es el menor que cobre un empleado, y cobrarán una comisión del 15% de dicho salario.
insert into emp (emp_no, apellido, salario, comision, dept_no) values ((select max(emp_no)+1 from emp), 'julian romeral', (select min(salario) from emp), (select min(salario)*0.15 from emp),
(select dept_no from dept where dnombre = 'VENTAS'));
insert into emp (emp_no, apellido, salario, comision, dept_no) values ((select max(emp_no)+1 from emp), 'luis alonso', (select min(salario) from emp), (select min(salario)*0.15 from emp),
(select dept_no from dept where dnombre = 'VENTAS'));
--5. Modificar la comisión de los empleados de la empresa, de forma que todos tengan un incremento del 10% del salario.
update emp set salario = salario+(salario*0.1);
--6. Incrementar un 5% el salario de los interinos de la plantilla que trabajen en el turno de noche.
update plantilla set salario = salario+(salario*0.05) where funcion = 'INTERINO' and turno = 'N';
--7. Incrementar en 5000 Pts. el salario de los empleados del departamento de ventas y del presidente, tomando en cuenta los que se dieron de alta antes que el presidente de la empresa.
update emp set salario = salario+5000 where dept_no = (select dept_no from dept where dnombre = 'VENTAS') and oficio = (select oficio from emp where oficio = 'EMPLEADO') 
and fecha_alt < (select fecha_alt from emp where oficio = 'PRESIDENTE') or oficio = (select oficio from emp where oficio = 'PRESIDENTE') 
and dept_no = (select dept_no from dept where dnombre = 'VENTAS');
--8. El empleado Sanchez ha pasado por la derecha a un compañero.  Debe cobrar de comisión 12.000 ptas más que el empleado Arroyo y su sueldo se ha incrementado un 10% respecto a su compañero.
update emp set comision = (select comision+12000 from emp where apellido = 'arroyo'), salario = (select salario+(salario*0.1) from emp where apellido = 'arroyo') where apellido = 'sanchez';
--9. Se tienen que desplazar cien camas del Hospital SAN CARLOS para un Hospital de Venezuela.  Actualizar el número de camas del Hospital SAN CARLOS.
update hospital set num_cama = num_cama-100 where nombre = 'san carlos';
--10. Subir el salario y la comisión en 100000 pesetas y veinticinco mil pesetas respectivamente a los empleados que se dieron de alta en este año.
update emp set comision = comision+100000 where fecha_alt >= '01/01/2025' and fecha_alt <= '31/12/2025', salario = salario+25000 where fecha_alt between '01/01/2025' and '31/12/2025';
-- 11. Ha llegado un nuevo doctor a la Paz.  Su apellido es House y su especialidad es Diagnostico.   Introducir el siguiente número de doctor disponible.
insert into doctor (hospital_cod, doctor_no, apellido, especialidad) values ((select hospital_cod from hospital where nombre = 'la paz'), (select max(doctor_no)+1 from doctor), 'House', 'Diagnostico');
-- 12. Borrar todos los empleados dados de alta entre las fechas 01/01/80 y 31/12/82.
delete from emp where fecha_alt between '01/01/80' and '31/12/82';
-- 13. Modificar el salario de los empleados trabajen en la paz y estén destinados a Psiquiatría.  Subirles el sueldo 20000 Ptas. más que al señor Amigo R.
update emp set salario = (select salario+20000 from emp where apellido = 'Amigo R.') and nombre = (select nombre from hospital where nombre = 'la paz') and
especialidad = (select especialidad from doctor where especialidad = 'Psiquiatria');
-- 14. Insertar un empleado con valores null (por ejemplo la comisión o el oficio), y después borrarlo buscando como valor dicho valor null creado.
insert into emp (emp_no, apellido) values ((select max(emp_no)+1 from emp), 'nulos');
delete from emp where oficio = null and dir = null and fecha_alt = null and comision = null and dept_no = null;
-- 15. Borrar los empleados cuyo nombre de departamento sea producción.
delete from emp where dept_no = (select dept_no from dept where dnombre = 'PRODUCCION');
-- 16. Borrar todos los registros de la tabla Emp sin delete.
update emp set apellido = null, oficio = null, dir = null, fecha_alt = null, salario = null, comision = null, dept_no = null;

-- BBDD de Oracle de pruebas
select * from dual;

------------------------- INSERT ALL sintaxis (siempre necesita un SELECT al final):

insert all 
    into dept values (50,'ORACLE','BERNABEU')
    into dept values (60,'I+D','OVIEDO')
select * from dual;

------------------------------ INSERT INTO VS INSERT ALL. INSERT INTO lo hace de una en una, INSERT ALL es más rápida porque lo ejecuta todo a la vez.
insert into dept values ((select max(dept_no)+1 from dept),'INTO','INTO');
insert into dept values ((select max(dept_no)+1 from dept),'INTO2','INTO2');
insert into dept values ((select max(dept_no)+1 from dept),'INTO3','INTO3');

insert all 
    into dept values ((select max(dept_no)+1 from dept),'ALL','ALL')
    into dept values ((select max(dept_no)+1 from dept),'ALL2','ALL2')
    into dept values ((select max(dept_no)+1 from dept),'ALL3','ALL3')
select * from dual;

-- Cuando son valores estáticos es mejor el INSERT ALL, si hay subconsultas mejor el INSERT INTO.
------------------ CREATE
-- La sintaxis es:
create table destino
    as
    select * from origen;
--------------------------
-- Una copia de seguridad de los departamentos
describe dept;

create table departamentos
as
select * from dept;

describe departamentos;
---------------------
create table doctores_hospital
as
select doctor.doctor_no as iddoctor, doctor.apellido, hospital.nombre, hospital.telefono
from doctor
inner join hospital
on doctor.hospital_cod = hospital.hospital_cod;

select * from doctores_hospital;
---------------------

---------------------- INSERT INTO SELECT

-- Nos permite copiar datos de una tabla origen a una tabla destino. La diferencia con CREATE SELECT está en que la tabla debe de existir. Sin tabla de destino, no
-- podemos ejecutar esta instrucción. La tabla de destino tiene que tener la misma estructura que los datos del SELECT de origen.
-- La sintaxis es:

insert into DESTINO
select * from ORIGEN;
----------------------
-- Copiar los datos de la tabla dept dentro de la tabla departamentos.
insert into departamentos
select * from dept;

select * from departamentos;
-----------------------------
--------------------VARIABLES DE SUSTITUCIÓN
-- Son elementos que nos van a permitir sustituir parte del código de una consulta. Cuando encuentra un & o &&, preguntará por el valor al usuario. El texto que haya después
-- del & o && es el texto que te aparecerá en la ventana cuando el programa te pregunte.

select apellido, oficio, salario, comision from emp where emp_no = &numero; -- Aquí te pide que introduzcas un número que es el ID del trabajador para que te muestre sus datos
select apellido, oficio, salario, comision from emp where apellido = '&ape'; -- Para el tipo de dato string, hay que ponerle comillas. Te muestra los datos del trabajador del que introduzcas su apellido
select apellido, oficio, salario, comision from emp where &condicion; -- Una condición entera se puede sustituir. Tendrías que poner oficio='ANALISTA' en el cuadro de texto
-- Al utilizar &&, sólo nos pedirá una vez la variable a introducir. Tendríamos que cerrar sesión y volver a iniciarla para que nos vuelva a preguntar.
select apellido, &&campo1,salario, comision from emp where &campo1='&dato1'; -- Aquís nos preguntará dos veces la primera vez, una por el campo (oficio) y otra por el dato (DIRECTOR)
-- Si volvemos a realizar esta consulta, el campo ya no nos lo pedirá, sólo el dato (DIRECTOR, ANALISTA...)

----------------------- Otros tipos de JOIN
-- NATURAL JOIN (es un INNER JOIN para vagos, no sustituye al LEFT JOIN o al RIGHT JOIN)
-- Los nombres de las columnas de las tablas tiene que ser el mismo para realizar un join. No hay que nombrar las columnas en el JOIN.
select apellido, oficio, dnombre, loc, dept_no from emp natural join dept;
select * from emp natural join dept; -- Al hacer un SELECT * nos devuelve todo, ignorando las columnas repetidas o que existan en ambas tablas.

-- USING
-- Permite especificar el campo/campos por el cual se enlazarán las tablas. Los campos tienen que tener el mismo nombre y ser del mismo tipo de datos.
select apellido, loc, dnombre from emp inner join dept using (dept_no);

------------------- RECUPERACIÓN JERÁRQUICA

-- Necesito saber los empleados que trabajan para Negro.
select * from emp where dir = 7698;
-- Tenemos un presidente que es el jefe de la empresa. Se llama Rey con código 7839. Mostrar todos los empleados que trabajan para él directamente.
select * from emp where dir = 7839;

-- Mostrar los empleados subordinados a partir del director Jimenez.
select level as NIVEL, apellido, oficio, dir 
from emp
connect by prior emp_no = dir
start with apellido = 'jimenez' order by 1;

-- El level es opcional.
-- Si la prioridad es en el campo que tiene repetidos en la tabla, es ascendente, si no es descendente. 

-- Mostrar los trabajadores que estén por encima del director Jimenez.

select level as NIVEL, apellido, oficio, dir 
from emp
connect by emp_no = prior dir
start with apellido = 'jimenez' order by 1;

-- Arroyo ha metido la pata. Quiero ver a todos sus jefes en mi despacho. Manda el listado.

select level as NIVEL, apellido, oficio, dir
from emp
connect by emp_no = prior dir
start with apellido = 'arroyo';

------------------------- SYS_CONNECT_BY_PATH
-- Concatena los valores de las ramas del árbol en el recorrido.

select level as NIVEL, apellido, oficio, dir, SYS_CONNECT_BY_PATH (apellido, '/') as RELACION
from emp
connect by prior emp_no = dir
start with apellido = 'jimenez' order by 1;

------------------ OPERADORES DE CONJUNTOS

-- Operador INTERSECT
-- Muestra las filas que coincidan en ambas consultas

-- Operador MINUS
-- Combina dos SELECT de forma que aparecerán los registros del primer SELECT que no estén presentes en el segundo.
select * from plantilla where turno ='T' minus select * from plantilla where funcion = 'ENFERMERA';

----------------------- CREAR UNA TABLA DE PRUEBA PARA LOS EJEMPLOS

create table prueba (
    identificador integer,
    texto10 varchar2(10),
    textochar char(5)
);

insert into prueba values (1,'skdjfepwls','aeiou');
insert into prueba values (1,'s','a');

select * from prueba;

-- Si hacemos un rollback no eliminamos la tabla, sólo los textos que le hemos introducido. La tabla permanecerá aunque sea sin datos.

drop table prueba; -- Para eliminar una tabla. También puede eliminar cualquier otro objeto si le indicamos el objeto que sea junto con su nombre.
select * from prueba;
------------------------ AGREGAR REGISTROS A UNA TABLA
-- Vamos a crear una columna nueva de tipo texto llamada "nueva".

alter table prueba add (nueva varchar2(3));

-- Los ALTER TABLE ejecutan un COMMIT también, si haces un ROLLBACK no se va a eliminar el registro que hayas metido antes del ALTER TABLE.
-- No podemos agregar una nueva columna que sea not null si ya hemos hecho un ALTER TABLE previamente
-- Agregamos otra columna de tipo texto llamada "sinnulos" y no admitirá nulos

alter table prueba add (sinnulos varchar2(7) not null);

-- Eliminar columnas de una tabla
alter table prueba
drop column nueva; -- Borra la columna aunque tenga datos en ella.

-- Modificar el tipo de dato de una columna
alter table prueba
modify (nueva float); 

-- Cambiar de nombre a una tabla
rename prueba to prueba2;

-- Borrar todos los registros de una tabla, pero no la tabla en sí. 
truncate table prueba;

-- Añadir comentarios a una tabla
comment on table prueba is 'esto es un comentario';

select * from user_tab_comments; -- Para ver los comentarios
select * from user_tab_comments where table_name = 'PRUEBA'; --Para ver los comentarios de una tabla en concreto

-- Consultas al diccionario de datos

select * from user_tables; -- Muestra todas las tablas que son propiedad del usuario, en orden de creación de dichas tablas
select * from all_tables; -- Muestra todas las tablas de todo el sistema.
select distinct object_type from user_objects; -- Muestra todos los tipos de objetos que ha creado el usuario 
select * from cat; -- Muestra los objetos que son propiedad del usuario

-------------------------- RESTRICCIONES EN LAS TABLAS

/*
DEFAULT: no es una restricción como tal, pero ayuda a que no haya nulos en una tabla incluyendo un valor por defecto si no le hemos asignado nada.
PRIMARY KEY: sólo puede haber una por tabla. No admite valores nulos ni repetidos.
UNIQUE: no admite nulos, pero puedes tener más de un campo UNIQUE dentro de una tabla.
FOREIGN KEY
CHECK: sirve para validación de datos. Puedes indicarle los datos que tienen que entrar a esa columna, no permite meter otros datos
*/

select * from prueba;
describe prueba;

-- Añadimos una nueva columna llamada test
alter table prueba add (test int);
-- Añadimos otra columna pero que contenga valores por defecto. El DEFAULT no impide nulos.
alter table prueba add (defecto int default -1);
insert into prueba (identificador, texto10, textochar) values (2,'AA','AA');
insert into prueba (identificador, texto10, textochar, defecto) values (3,'BB','BB', 22);
insert into prueba (identificador, texto10, textochar, defecto) values (4,'CC','CC',null);

-- Incluir las restricciones cuando creamos la tabla.
create table TABLA
    (idtabla int not null primary key, campo1 varchar2(80));
--------------------
-- Incluir una restricción primary key en el campo dept_no de departamentos para que no pueda admitir nulos
alter table dept 
add constraint pk_dept
primary key (dept_no);
-- Todas las restricciones del usuario se encuentran en el diccionario llamado user_constraints
 select * from user_constraints;
 -- Intentamos insertar un departamento repetido
insert into dept values (10, 'REPE', 'REPE');
-- Eliminamos la restricción de primary key de departamentos
alter table dept
drop constraint pk_dept;
-- Ahora sí nos deja insertar el departamento repetido
select * from dept;
---------------------------- EMPLEADOS ---------------------------------
-- Creamos una primary key para el campo emp_no
alter table emp
add constraint pk_emp
primary key (emp_no);
-- Creamos una restricción para comprobar que el salario siempre sea positivo
alter table emp
add constraint ch_emp_salario
check (salario >= 0);
-- Ponemos un valor negativo a un empleado
update emp set salario = -1 where emp_no = 7788; -- Dará un error de restricción de control violada
-- Eliminamos la restricción
alter table emp
drop constraint ch_emp_salario;
-- Modificamos un empleado en negativo
update emp set salario = -1 where emp_no = 7788;
-- Ahora sí deja cambiar el salario al no tener restricción
select * from emp;
-- Al volver a crear la restricción (habiendo un salario negativo ya en la tabla) no permite crear la restricción. Habría que poner en positivo ese salario de nuevo.
--------------------------------------
select * from enfermo;

alter table enfermo
add constraint pk_enfermo
primary key (inscripcion);

alter table enfermo
add constraint u_enfermo_nss
unique (nss);

insert into enfermo values (10991, 'Nuevo', 'Calle Nueva', '10/10/2024', 'M', '280862482');
insert into enfermo values (10991, 'Nuevo', 'Calle Nueva', '10/10/2024', 'M', null);
insert into enfermo values (10992, 'Nuevo', 'Calle Nueva', '10/10/2024', 'M', null);










-- 1. Mostrar todos los apellidos de los empleados en Mayúsculas

select upper(apellido) as APELLIDOS from emp;

-- 2. Construir una consulta para que salga la fecha de hoy con el siguiente formato:
--FECHA DE HOY
-----------------------------------------
--Martes 06 de Octubre de 2020

select to_char(sysdate,'"FECHA DE HOY -------" day DD "de" Month "de" YYYY', 'nls_date_language = Spanish') as FECHA from dual;

-- Ahora en italiano

select to_char(sysdate,'"FECHA DE HOY -------" day DD "de" Month "de" YYYY', 'nls_date_language = Italian') as FECHA from dual;

-- 3. Queremos cambiar el departamento de Barcelona y llevarlo a Tabarnia. Para ello tenemos que saber qué empleados cambiarían de localidad y cuáles no.  
-- Combinar tablas y mostrar el nombre del departamento junto a los datos del empleado.

select dnombre as DEPARTAMENTO, apellido, decode(loc, 'BARCELONA', 'A TABARNIA', 'NO CAMBIA DE LOCALIDAD') as TRASLADO from emp INNER JOIN dept ON emp.dept_no = dept.dept_no; 

-- 4. Mirar la fecha de alta del presidente. Visualizar todos los empleados dados de alta 330 días antes que el presidente. 

select * from emp where fecha_alt = (select fecha_alt-330 from emp where oficio = 'PRESIDENTE');

-- 5. Nos piden un informe como este:

select rpad(initcap(apellido),14,'.') as APELLIDO, rpad(initcap(oficio),14,'.') as OFICIO, rpad(salario,14,'.') as SALARIO, 
rpad(comision,14,'.') as COMISION, rpad(dept_no,14,'.') as DEPARTAMENTO  from emp;

-- 6. Nos piden otro, en el que se muestren todos los empleados de la siguiente manera:

select 'El señor ' || initcap(apellido)|| ' con cargo de ' ||initcap(oficio)|| ' se dio de alta el ' 
    || to_char(fecha_alt, 'day D "de" Month "de" YYYY', 'nls_date_language = Spanish')|| ' en la empresa' as fechas_de_alta
from emp;



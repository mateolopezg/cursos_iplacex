
-- REQ 1
-- Declaración de variables
DECLARE
  v_total_dep NUMBER(3) := 0;
  v_dep VARCHAR2(40);
BEGIN

  -- Obtener el nombre del departamento y el total de empleados en Finanzas
  SELECT department_name, COUNT(*) AS total_empleados
  INTO v_dep, v_total_dep
  FROM employees e
  JOIN departments d ON e.department_id = d.department_id
  WHERE d.department_name = 'Finance';

  -- Mostrar la información
  DBMS_OUTPUT.PUT_LINE('En el departamento ' || v_dep || ' trabajan ' || v_total_dep || ' empleados');

END;
/

-- REQ 2
-- Declaración de variables
DECLARE
  v_id_empleado NUMBER(4);
  v_salario NUMBER(8,2);
  v_categoria VARCHAR2(30);
BEGIN

  -- Bucle para procesar empleados del 100 al 130
  FOR v_id_empleado IN 100..130 LOOP

    -- Obtener el salario del empleado actual
    SELECT salary
    INTO v_salario
    FROM employees
    WHERE employee_id = v_id_empleado;

    -- Determinar la categoría del salario
    IF v_salario > 10000 THEN
      v_categoria := 'Es un buen sueldo';
    ELSIF v_salario >= 9000 THEN
      v_categoria := 'Es un salario normal';
    ELSE
      v_categoria := 'Es un sueldo que se debe aumentar';
    END IF;

    -- Mostrar la información del empleado
    DBMS_OUTPUT.PUT_LINE('ID: ' || v_id_empleado || ', Salario: ' || v_salario || ', Categoría: ' || v_categoria);
  END LOOP;

END;
/

-- REQ 3
-- Solución

DECLARE
  v_prom NUMBER;
  v_nombre VARCHAR2(20);
  v_sum NUMBER;
BEGIN
  -- Corregir la función ROUND y agregar alias a department_name
  SELECT ROUND(AVG(salary), 0) AS prom_salario,
         department_name,
         SUM(salary) AS sum_salario
  INTO v_prom, v_nombre, v_sum
  FROM employees e
  JOIN departments d ON e.department_id = d.department_id
  GROUP BY department_name;

  -- Corregir la cláusula HAVING
  IF v_nombre = '&Ingrese_ID_departamento' THEN
    -- Mostrar la información
    DBMS_OUTPUT.PUT_LINE('Se seleccionaron: ' || SQL%ROWCOUNT || ' Filas');
    DBMS_OUTPUT.PUT_LINE('Su valoraciones: ' ||
                          CASE
                            WHEN v_prom < 5000 THEN 'Excelente'
                            WHEN v_prom < 3000 THEN 'Bueno'
                            WHEN v_prom < 1000 THEN 'Inaceptable'
                            ELSE '-'
                          END ||
                          ', el valor de promedio es: ' ||
                          TO_CHAR(v_prom, '$999g999') ||
                          ' y el nombre del departamento es: ' || v_nombre);
  ELSE
    DBMS_OUTPUT.PUT_LINE('No se selecciono nada');
  END IF;
END;
/


-- REQ 4
-- Solución

DECLARE
  v_total_dep_50 NUMBER;
  v_empleado_bajo_salario VARCHAR2(50);
  v_salario_bajo NUMBER(8,2);
  v_prom_comision NUMBER(8,2);
  v_id_dep_mayor NUMBER(4);
  v_nombre_dep_mayor VARCHAR2(40);
  v_jefe_dep_mayor NUMBER(4);
  v_ubicacion_dep_mayor NUMBER(4);
BEGIN

  -- Total de empleados en el departamento 50
  SELECT COUNT(*)
  INTO v_total_dep_50
  FROM employees e
  JOIN departments d ON e.department_id = d.department_id
  WHERE d.department_id = 50;

  -- Empleado con el salario más bajo
  SELECT first_name || ' ' || last_name, salary
  INTO v_empleado_bajo_salario, v_salario_bajo
  FROM employees
  ORDER BY salary ASC
  FETCH FIRST 1 ROWS ONLY;

  -- Promedio de comisiones
  SELECT AVG(salary * commission_pct)
  INTO v_prom_comision
  FROM employees;

  -- Departamento con más empleados
  SELECT d.department_id, d.department_name, d.manager_id, d.location_id
  INTO v_id_dep_mayor, v_nombre_dep_mayor, v_jefe_dep_mayor, v_ubicacion_dep_mayor
  FROM departments d
  JOIN employees e ON e.department_id = d.department_id
  GROUP BY d.department_id, d.department_name, d.manager_id, d.location_id
  ORDER BY COUNT(*) DESC
  FETCH FIRST 1 ROWS ONLY;

  -- Mostrar información
  DBMS_OUTPUT.PUT_LINE('En el departamento Shipping trabajan ' || v_total_dep_50 || ' empleados.');
  DBMS_OUTPUT.PUT_LINE('El empleado con el salario más bajo es ' || v_empleado_bajo_salario || '.');
  DBMS_OUTPUT.PUT_LINE('El promedio de las comisiones es $' || TO_CHAR(v_prom_comision, '$999g999'));
  DBMS_OUTPUT.PUT_LINE('La información del departamento con mayor cantidad de empleados es la siguiente:');
  DBMS_OUTPUT.PUT_LINE('Identificación: ' || v_id_dep_mayor);
  DBMS_OUTPUT.PUT_LINE('Nombre: ' || v_nombre_dep_mayor);
  DBMS_OUTPUT.PUT_LINE('Jefe: ' || v_jefe_dep_mayor);
  DBMS_OUTPUT.PUT_LINE('Ubicación: ' || v_ubicacion_dep_mayor);
END;
/

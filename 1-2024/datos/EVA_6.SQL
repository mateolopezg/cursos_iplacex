--------------------------------------------------------------------------------------
-- Requerimiento 1
--------------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION calcular_total_pago (anno IN NUMBER, mes IN NUMBER)
RETURN NUMBER
IS
    total_pago NUMBER := 0;
BEGIN
    -- Calcula la suma de sueldos base de la tabla VENDEDORES
    SELECT NVL(SUM(SUELDO_BASE), 0)
    INTO total_pago
    FROM VENDEDORES
    WHERE ID_VENDEDOR IN (SELECT ID_VENDEDOR
                          FROM FACTURAS
                          WHERE EXTRACT(YEAR FROM FECHA) = anno
                          AND EXTRACT(MONTH FROM FECHA) = mes);

    -- Calcula la suma de comisiones
    SELECT NVL(SUM(VALOR_COMISION), 0)
    INTO total_pago
    FROM COMISIONES
    WHERE FOLIO IN (SELECT FOLIO
                    FROM FACTURAS
                    WHERE EXTRACT(YEAR FROM FECHA) = anno
                    AND EXTRACT(MONTH FROM FECHA) = mes);

    -- Añade 21%
    total_pago := total_pago * 1.21;

    RETURN total_pago;
END;


-- Llama a la función

DECLARE
    monto_total NUMBER;
BEGIN
    monto_total := calcular_total_pago(2023, 2); -- año, mes
    DBMS_OUTPUT.PUT_LINE('El monto total a pagar es: ' || monto_total);
END;

--------------------------------------------------------------------------------------
-- Requerimiento 2
--------------------------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE estadistica_edad_jubilacion
AS
    cantidad_personas NUMBER;
    cantidad_trabajadores NUMBER;
BEGIN
    -- Contar la cantidad de personas con 65 años
    SELECT COUNT(*)
    INTO cantidad_personas
    FROM PERSONAS
    WHERE TRUNC(MONTHS_BETWEEN(SYSDATE, FECHA_NACIMIENTO) / 12) = 65;

    -- Contar la cantidad de trabajadores con 65 años
    SELECT COUNT(*)
    INTO cantidad_trabajadores
    FROM PERSONAS p
    JOIN VENDEDORES v ON p.RUT = v.RUT
    WHERE TRUNC(MONTHS_BETWEEN(SYSDATE, p.FECHA_NACIMIENTO) / 12) = 65;

    -- Mostrar el resultado
    DBMS_OUTPUT.PUT_LINE('PERSONAS CON 65 AÑOS ES: ' || cantidad_personas);
    DBMS_OUTPUT.PUT_LINE('CANTIDAD TRABAJADORES ES: ' || cantidad_trabajadores);
END;


--------------------------------------------------------------------------------------
-- Requerimiento 3
--------------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION contar_comunas_distintas
RETURN NUMBER
IS
    cantidad_comunas NUMBER;
BEGIN
    -- Contar la cantidad de comunas distintas
    SELECT COUNT(DISTINCT COMUNA)
    INTO cantidad_comunas
    FROM PERSONAS;

    RETURN cantidad_comunas;
END;


-- Llamada

DECLARE
    num_comunas NUMBER;
BEGIN
    num_comunas := contar_comunas_distintas;
    DBMS_OUTPUT.PUT_LINE('El número de comunas distintas es: ' || num_comunas);
END;
 -- El número de comunas distintas es: 83


--------------------------------------------------------------------------------------
-- Requerimiento 4
--------------------------------------------------------------------------------------


CREATE OR REPLACE PROCEDURE insertar_persona (
    p_rut IN NUMBER,
    p_digito_v IN CHAR,
    p_primer_nombre IN VARCHAR2,
    p_segundo_nombre IN VARCHAR2,
    p_primer_apellido IN VARCHAR2,
    p_segundo_apellido IN VARCHAR2,
    p_fecha_nacimiento IN DATE,
    p_direccion IN VARCHAR2,
    p_comuna IN NUMBER,
    p_nacionalidad IN VARCHAR2,
    p_telefono IN VARCHAR2,
    p_email IN VARCHAR2
)
AS
BEGIN
    -- Inserta la persona en la tabla PERSONAS
    INSERT INTO PERSONAS (RUT, DIGITO_V, PRIMER_NOMBRE, SEGUNDO_NOMBRE, PRIMER_APELLIDO, SEGUNDO_APELLIDO, FECHA_NACIMIENTO, DIRECCION, COMUNA, NACIONALIDAD, TELEFONO, EMAIL)
    VALUES (p_rut, p_digito_v, p_primer_nombre, p_segundo_nombre, p_primer_apellido, p_segundo_apellido, p_fecha_nacimiento, p_direccion, p_comuna, p_nacionalidad, p_telefono, p_email);
    COMMIT; -- Confirmar la transacción
    DBMS_OUTPUT.PUT_LINE('Persona insertada correctamente.');
END;



DECLARE
BEGIN
    insertar_persona(
        6146847, -- RUT
        '1',     -- Dígito Verificador
        'Jasper',  -- Primer Nombre
        'Carla',   -- Segundo Nombre
        'Ferrell', -- Primer Apellido
        'Nichols', -- Segundo Apellido
        TO_DATE('03/29/96', 'MM/DD/YY'), -- Fecha de Nacimiento
        '9900 Aliquam Av.', -- Dirección
        14,       -- Comuna (cambia este valor según la comuna correspondiente)
        '4',      -- Nacionalidad
        '56 9 8639 8561', -- Teléfono
        'primis.in@Donec.com' -- Email
    );
    COMMIT; -- Confirmar la transacción
    DBMS_OUTPUT.PUT_LINE('Persona insertada correctamente.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error al insertar la persona: ' || SQLERRM);
        ROLLBACK; -- Revertir la transacción en caso de error
END;

--------------------------------------------------------------------------------------
-- Requerimiento 5
--------------------------------------------------------------------------------------


-- Crear el PACKAGE
CREATE OR REPLACE PACKAGE gestion_base_datos AS
    -- PROCEDURE para insertar un producto
    PROCEDURE insertar_producto(
        p_id_producto IN NUMBER,
        p_marca IN VARCHAR2,
        p_modelo IN VARCHAR2,
        p_descripcion IN VARCHAR2,
        p_valor_unitario IN NUMBER
    );

    -- PROCEDURE para insertar un vendedor
    PROCEDURE insertar_vendedor(
        p_id_vendedor IN NUMBER,
        p_rut IN NUMBER,
        p_email IN VARCHAR2,
        p_sueldo_base IN NUMBER
    );

    -- retorna la cantidad de vendedores sin ventas
    FUNCTION contar_vendedores_sin_ventas RETURN NUMBER;

    -- retorna la cantidad de personas sin compras
    FUNCTION contar_personas_sin_compras RETURN NUMBER;
END gestion_base_datos;


-- Crear el cuerpo del PACKAGE
CREATE OR REPLACE PACKAGE BODY gestion_base_datos AS
    -- PROCEDURE para insertar un producto
    PROCEDURE insertar_producto(
        p_id_producto IN NUMBER,
        p_marca IN VARCHAR2,
        p_modelo IN VARCHAR2,
        p_descripcion IN VARCHAR2,
        p_valor_unitario IN NUMBER
    ) AS
    BEGIN
        INSERT INTO PRODUCTOS (ID_PRODUCTO, MARCA, MODELO, DESCRIPCION, VALOR_UNITARIO)
        VALUES (p_id_producto, p_marca, p_modelo, p_descripcion, p_valor_unitario);
    END insertar_producto;

    -- PROCEDURE para insertar un vendedor
    PROCEDURE insertar_vendedor(
        p_id_vendedor IN NUMBER,
        p_rut IN NUMBER,
        p_email IN VARCHAR2,
        p_sueldo_base IN NUMBER
    ) AS
    BEGIN
        INSERT INTO VENDEDORES (ID_VENDEDOR, RUT, EMAIL, SUELDO_BASE)
        VALUES (p_id_vendedor, p_rut, p_email, p_sueldo_base);
    END insertar_vendedor;

    -- Función que retorna la cantidad de vendedores sin ventas
    FUNCTION contar_vendedores_sin_ventas RETURN NUMBER AS
        v_count NUMBER;
    BEGIN
        SELECT COUNT(*)
        INTO v_count
        FROM VENDEDORES v
        WHERE NOT EXISTS (
            SELECT 1 FROM FACTURAS f WHERE f.ID_VENDEDOR = v.ID_VENDEDOR
        );
        RETURN v_count;
    END contar_vendedores_sin_ventas;

    -- Función que retorna la cantidad de personas sin compras
    FUNCTION contar_personas_sin_compras RETURN NUMBER AS
        v_count NUMBER;
    BEGIN
        SELECT COUNT(*)
        INTO v_count
        FROM PERSONAS p
        WHERE NOT EXISTS (
            SELECT 1 FROM FACTURAS f WHERE f.CLIENTE = p.RUT
        );
        RETURN v_count;
    END contar_personas_sin_compras;
END gestion_base_datos;


-- Bloque anónimo 

DECLARE
    v_cant_vendedores_sin_ventas NUMBER;
    v_cant_personas_sin_compras NUMBER;
BEGIN
    -- Inserta un producto
    gestion_base_datos.insertar_producto(101, 'Marca1', 'Modelo1', 'Descripción1', 100);

    -- Inserta un vendedor
    gestion_base_datos.insertar_vendedor(201, 123456789, 'correo@example.com', 2000);

    -- Obtener la cantidad de vendedores sin ventas
    v_cant_vendedores_sin_ventas := gestion_base_datos.contar_vendedores_sin_ventas;

    -- Obtener la cantidad de personas sin compras
    v_cant_personas_sin_compras := gestion_base_datos.contar_personas_sin_compras;

    -- Mostrar los resultados
    DBMS_OUTPUT.PUT_LINE('Cantidad de vendedores sin ventas: ' || v_cant_vendedores_sin_ventas);
    DBMS_OUTPUT.PUT_LINE('Cantidad de personas sin compras: ' || v_cant_personas_sin_compras);
END;





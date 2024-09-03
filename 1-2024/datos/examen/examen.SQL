-- Requerimiento 1

-- En base la estructura de la base de datos y se creo una función SQL para calcular el IVA total de las facturas en un mes y año específicos 
-- utilizando un bloque anónimo para mostrar el resultado.

CREATE OR REPLACE FUNCTION calcular_iva(p_anno IN NUMBER, p_mes IN NUMBER)
RETURN NUMBER
IS
    v_total_iva NUMBER := 0;
BEGIN
    SELECT SUM(IVA)
    INTO v_total_iva
    FROM FACTURAS
    WHERE EXTRACT(YEAR FROM FECHA) = p_anno
    AND EXTRACT(MONTH FROM FECHA) = p_mes;

    RETURN v_total_iva;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 0; -- Retorna 0 si no hay facturas para el año y mes especificados
    WHEN OTHERS THEN
        RETURN -1; -- Retorna -1 en caso de cualquier otro error
END;

-- Call function

DECLARE
    v_anno NUMBER := 2024; -- Ingresar el año deseado
    v_mes NUMBER := 5; -- Ingresarr el mes deseado
    v_total_iva NUMBER;
BEGIN
    v_total_iva := calcular_iva(v_anno, v_mes);
    IF v_total_iva = -1 THEN
        DBMS_OUTPUT.PUT_LINE('Error al calcular el IVA.');
    ELSIF v_total_iva = 0 THEN
        DBMS_OUTPUT.PUT_LINE('No hay facturas para el año ' || v_anno || ' y mes ' || v_mes);
    ELSE
        DBMS_OUTPUT.PUT_LINE('Total a pagar por concepto de IVA para el año ' || v_anno || ' y mes ' || v_mes || ': ' || v_total_iva);
    END IF;
END;

-- REquerimiento 2

-- Un procedimiento almacenado para contar las comunas totales y las comunas sin personas registradas, 
-- controlando posibles errores.

CREATE OR REPLACE PROCEDURE estadistica_comunas IS
    v_total_comunas NUMBER := 0;
    v_comunas_sin_personas NUMBER := 0;
BEGIN
    -- Obtiene la cantidad total de comunas
    SELECT COUNT(*)
    INTO v_total_comunas
    FROM COMUNAS;

    -- Obtener la cantidad de comunas sin personas registradas en la base
    SELECT COUNT(*)
    INTO v_comunas_sin_personas
    FROM COMUNAS c
    LEFT JOIN PERSONAS p ON c.ID_COMUNA = p.COMUNA
    WHERE p.RUT IS NULL;

    -- Muestra el resultado
    DBMS_OUTPUT.PUT_LINE('CANTIDAD COMUNAS : ' || v_total_comunas || ' ------ CANTIDAD DE COMUNAS SIN PERSONAS : ' || v_comunas_sin_personas);
END;

-- call procedure:

BEGIN
    estadistica_comunas;
END;

-- Requerimiento 3

-- Una función para determinar en cuántos países distintos se distribuyen las personas registradas, 
-- considerando la comuna en la que viven, y la llamé desde un bloque anónimo para mostrar el resultado.

CREATE OR REPLACE FUNCTION contar_paises_distribucion RETURN NUMBER
IS
    v_num_paises NUMBER := 0;
BEGIN
    -- Contar la cantidad de paises distintos en los que se encuentran distribuidas las personas
    SELECT COUNT(DISTINCT p.ID_PAIS)
    INTO v_num_paises
    FROM PERSONAS pe -- uso JOIN cruzar datos
    JOIN COMUNAS c ON pe.COMUNA = c.ID_COMUNA
    JOIN REGIONES r ON c.ID_REGION = r.ID_REGION
    JOIN PAISES p ON r.ID_PAIS = p.ID_PAIS;

    RETURN v_num_paises;
EXCEPTION
    WHEN OTHERS THEN
        RETURN -1; -- Retorna -1 en caso de cualquier otro error
END;

 -- call function
DECLARE
    v_num_paises NUMBER;
BEGIN
    v_num_paises := contar_paises_distribucion;
    IF v_num_paises = -1 THEN
        DBMS_OUTPUT.PUT_LINE('Error al contar los países.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Número de países en los que se distribuyen los registros de personas: ' || v_num_paises);
    END IF;
END;


-- Requerimiento 5

-- Agrupación de las operaciones de inserción de facturas y detalles de factura en un paquete, creando procedimientos y funciones para estas tareas, 
-- y con eso aseguré controlar todas las excepciones.


CREATE OR REPLACE PACKAGE gestion_facturas AS
    PROCEDURE insertar_detalle_factura(     -- PROCEDURE 1
        p_id_producto NUMBER,
        p_cantidad NUMBER,
        p_subtotal NUMBER
    );
    PROCEDURE insertar_factura(              -- PROCEDURE 2
        p_folio NUMBER,
        p_fecha DATE,
        p_id_vendedor NUMBER,
        p_cliente NUMBER,
        p_valor_neto NUMBER,
        p_descuento NUMBER DEFAULT 0
    );
    FUNCTION calcular_iva_factura(p_folio NUMBER) RETURN NUMBER;               -- FUNCTION 1
    FUNCTION calcular_total_factura(p_folio NUMBER) RETURN NUMBER;             -- FUNCTION 2
END gestion_facturas;
/

CREATE OR REPLACE PACKAGE BODY gestion_facturas AS            -- Body
    PROCEDURE insertar_detalle_factura(
        p_folio NUMBER,
        p_id_producto NUMBER,
        p_cantidad NUMBER,
        p_subtotal NUMBER
    ) IS
    BEGIN
        -- Insertar detalle de factura
        INSERT INTO DETALLE_FACTURAS (FOLIO, ID_PRODUCTO, CANTIDAD, SUBTOTAL_DETALLE)
        VALUES (p_folio, p_id_producto, p_cantidad, p_subtotal);
    EXCEPTION
        WHEN OTHERS THEN
            NULL; -- Controlar todas las excepciones
    END insertar_detalle_factura;

    PROCEDURE insertar_factura(
        p_folio NUMBER,
        p_fecha DATE,
        p_id_vendedor NUMBER,
        p_cliente NUMBER,
        p_valor_neto NUMBER,
        p_descuento NUMBER DEFAULT 0
    ) IS
    BEGIN
        -- Inserta factura
        INSERT INTO FACTURAS (FOLIO, FECHA, ID_VENDEDOR, CLIENTE, VALOR_NETO, IVA, DESCUENTO, TOTAL)
        VALUES (p_folio, p_fecha, p_id_vendedor, p_cliente, p_valor_neto, 0, p_descuento, p_valor_neto - p_descuento);
    EXCEPTION
        WHEN OTHERS THEN
            NULL; -- Controla todas las excepciones
    END insertar_factura;

    FUNCTION calcular_iva_factura(p_folio NUMBER) RETURN NUMBER IS
        v_iva NUMBER;
    BEGIN
        -- Calcula IVA de la factura (19% del valor neto)
        SELECT ROUND(VALOR_NETO * 0.19, 2) INTO v_iva
        FROM FACTURAS
        WHERE FOLIO = p_folio;

        RETURN v_iva;
    EXCEPTION
        WHEN OTHERS THEN
            RETURN -1; -- Controlar todas las excepciones
    END calcular_iva_factura;

    FUNCTION calcular_total_factura(p_folio NUMBER) RETURN NUMBER IS
        v_total NUMBER;
    BEGIN
        -- Calcula valor total de la factura (valor neto + IVA)
        SELECT ROUND(VALOR_NETO + calcular_iva_factura(p_folio), 2) INTO v_total
        FROM FACTURAS
        WHERE FOLIO = p_folio;

        RETURN v_total;
    EXCEPTION
        WHEN OTHERS THEN
            RETURN -1; -- Controlar todas las excepciones
    END calcular_total_factura;
END gestion_facturas;

-- Bloque anonimo


DECLARE
    v_folio_factura NUMBER := 1001; -- Ingresa el folio de la factura deseada
    v_fecha_factura DATE := SYSDATE; -- Ingresa la fecha de la factura deseada
    v_id_vendedor NUMBER := 101; -- Ingresa el ID del vendedor deseado
    v_cliente NUMBER := 123456789; -- Ingresa el ID del cliente deseado
    v_valor_neto NUMBER := 1000; -- Ingresa el valor neto de la factura deseada
BEGIN
    -- Insertar factura
    gestion_facturas.insertar_factura(v_folio_factura, v_fecha_factura, v_id_vendedor, v_cliente, v_valor_neto);

    -- Insertar detalle de factura
    gestion_facturas.insertar_detalle_factura(v_folio_factura, 1, 2, 200); -- Ejemplo de detalle de factura

    -- Mostrar el valor del IVA y el valor total de la factura en específico
    DBMS_OUTPUT.PUT_LINE('Valor del IVA para la factura ' || v_folio_factura || ': ' || gestion_facturas.calcular_iva_factura(v_folio_factura));
    DBMS_OUTPUT.PUT_LINE('Valor total de la factura ' || v_folio_factura || ': ' || gestion_facturas.calcular_total_factura(v_folio_factura));
END;





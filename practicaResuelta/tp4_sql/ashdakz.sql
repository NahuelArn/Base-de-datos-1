-- Eliminar el procedure si existe
DROP PROCEDURE IF EXISTS ejercicio_6;

DELIMITER //
CREATE PROCEDURE ejercicio_6()
BEGIN
    -- Declaro variables auxiliares
    DECLARE id_paciente INT;
    DECLARE cantidad_citas INT;
    DECLARE fecha_actual DATETIME;
    DECLARE usuario_actual VARCHAR(16);
    DECLARE fin INT DEFAULT 0;
    -- Declaro cursor para tener el conteo de citas por paciente
    DECLARE cursor_citas CURSOR FOR
        SELECT a.patient_id, COUNT(*) AS cant_citas
        FROM appointment a
        GROUP BY a.patient_id;
    -- Declaro handler para el fin del cursor
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET fin = 1;
    -- Seguridad ante fallos en la transacción
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;
    -- Obtengo los valores de fecha y usuario actual
    SET fecha_actual = NOW();
    SET usuario_actual = SUBSTRING(CURRENT_USER(), 1, 16);
    -- Inicio la transacción
    START TRANSACTION;
    -- Limpio la tabla antes de insertar (no lo pide pero sino genero redundancia si ejecuto varias veces el SP)
    DELETE FROM appointments_per_patient;
    -- Abro el cursor
    OPEN cursor_citas;
    -- Itero sobre el cursor
    leer_cursor: LOOP
        FETCH cursor_citas INTO id_paciente, cantidad_citas;
        IF fin THEN
            LEAVE leer_cursor;
        END IF;
        -- Inserto los datos en la tabla
        INSERT INTO appointments_per_patient (id_patient, count_appointments, last_update, user)
        VALUES (id_paciente, cantidad_citas, fecha_actual, usuario_actual);
    END LOOP leer_cursor;
    -- Cierro el cursor y confirmo la transacción
    CLOSE cursor_citas;
    COMMIT;
END //
DELIMITER ;

CALL ejercicio_6();
SELECT * FROM appointments_per_patient;
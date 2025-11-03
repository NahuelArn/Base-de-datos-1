DELIMITER //
CREATE PROCEDURE ejercicio_6()
BEGIN 
	--variables auxiliares
    DECLARE id_paciente INT;
    DECLARE cantidad_citas INT;
    DECLARE fecha_actual DATETIME;
    DECLARE usuario_actual VARCHAR(16);
	DECLARE fin INT DEFAULT 0;
    --Declaro cursor para teneer el conteo de citas por paciente, es como un exist, va fila por fila
    DECLARE cursor_citas CURSOR FOR
    	SELECT a.patient_id, COUNT(*) AS cant_citas
        FROM appointment a 
        GROUP BY a.patient_id;
        --declaro handler para el fin del cursor
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET fin = 1;
    --Seguridad ante fallos en la transaccion
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
    	ROLLBACK;
    END;
    -- Obtengo los valores de fecha y usuario actual
    SET fecha_actual = NOW();
    SET usuario_actual = SUBSTRING(CURRENT_USER(), 1, 16);
    OPEN cursor_citas;
    --Itero sobre el CURSOR
    leer_cursor: LOOP	
    	FETCH  cursor_citas INTO id_paciente, cantidad_citas;
        IF fin THEN
        	LEAVE leer_cursor;
        END IF;
        --inserto los datos en la tabla
        INSERT INTO appointments_per_patient (id_patient, count_appointments, last_update, user);
        VALUES (id_paciente, cantidad_citas, fecha_actual, usuario_actual);
     END LOOP leer_cursor;
     --Cierro el cursor y confirmo la transaccion
     CLOSE cursor_citas;
     COMMIT;
END //
DELIMITER ;
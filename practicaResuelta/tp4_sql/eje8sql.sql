8. Crear un Trigger de modo que al insertar un dato en la tabla Appointment, se
actualice la cantidad de appointments del paciente, la fecha de actualización y el
usuario responsable de la misma (actualiza la tabla APPOINTMENTS PER
PATIENT).
DELIMITER //
CREATE TRIGGER inserccion_actualizacion 
AFTER INSERT ON appointment
FOR EACH ROW 
BEGIN
	DECLARE v_fecha_actual DATETIME DEFAULT NOW();
    DECLARE v_usuario_actual VARCHAR(16) DEFAULT SUBSTRING(CURRENT_USER(), 1, 16);
    DECLARE v_cant_citas INT;
    --Obtengo la cantidad de citas del paciente
    SELECT COUNT(*) INTO v_cant_citas
    FROM appointment
    WHERE patient_id = NEW.patient_id;
    --Verificamos si el paciente existe o no 
    IF EXISTS (SELECT 1 FROM APPOINTMENTS_PER_PATIENT WHERE id_patient = NEW.patient_id)THEN
    --SI EXISTE ACTUALIZAMOS EL REGISTRO
    	UPDATE APPOINTMENTS_PER_PATIENT
        SET count_appoinments = v_cant_citas,
        	last_update = v_fecha_actual,
        	user = v_usuario_actual
        WHERE id_patient = NEW.patient_id;
    ELSE 
    	 -- Si no existe, insertamos un nuevo registro
        INSERT INTO APPOINTMENTS_PER_PATIENT (id_patient, count_appointments, last_update, user)
        VALUES (NEW.patient_id, v_cant_citas, v_fecha_actual, v_usuario_actual);
    END IF;
END //
DELIMITER ;

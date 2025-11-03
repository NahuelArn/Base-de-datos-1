DELIMITER //
CREATE PROCEDURE ejeB()
BEGIN
	DECLARE fin_cursor INT DEFAULT 0;
    DECLARE v_id_patient INT;
    DECLARE v_count_appointmets INT;
    --declaracion del cursor (guarda la consulta en un cursor)
    DECLARE cur_conteo_pacientes CURSOR FOR 
    	SELECT 
        	a.patient_id,
            COUNT(*) AS cant_citas
         FROM appointment a 
         GROUP BY a.patient_id
     --Declaracion del handler (necesario para avisar al cursor que pare)
     DECLARE CONTINUE HANDLER FOR NOT FOUND SET fin_cursor =1;
     START TRANSACTION 
     INSERT INTO APPOINTMENTS_PER_PATIENT(
     	 id_patient,
         count_appointments,
         last_update,
         user
     )
     SELECT 
     	a.patient,
        COUNT(*) AS cant_citas,
        NOW() AS fecha_actual,
        SUBSTRING(CURRENT_USER(),1,16)
      FROM appointment a 
      GROUP BY a.patient_id
      
      --ARRANCA EL CURSOR
      --ABRO EL CURSOR
      OPEN cur_conteo_pacientes;
      --una vez que cuenta la cantidad y termina su tarea cierro el CURSOR
      CLOSE cur_conteo_pacientes;
      --confirmar la transaccion
      COMMIT;
END //
DELIMITER ;
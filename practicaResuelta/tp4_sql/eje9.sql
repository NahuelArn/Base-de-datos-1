DELIMITER //
CREATE PROCEDURE eje9(
	IN p_patient_id INT,
    IN p_doctor_id INT,
    IN p_duration INT,
    IN p_contact_phone VARCHAR(50),
    IN p_appointment_address VARCHAR(100),
    IN p_medication_name VARCHAR(100)
)

BEGIN
	-- Declaramos la variable que vamos a usar en los inserts
	DECLARE fecha_actual DATETIME;
    SET fecha_actual = NOW();
    -- EMPEZAAA
    START TRANSACTION;
    -- Inserta un appointment 
    INSERT INTO appointment(
    	patient_id, 
        appointment_date, 
        appointment_duration, 
        contact_phone,
		observations, 
        payment_card, 
        appointment_address
    )
    VALUES(p_patient_id, 
           fecha_actual, 
           p_duration, 
           p_contact_phone, 
           NULL,
		   NULL, 
           p_appointment_address);
     -- Inserta el doctor que lo atendio 
     INSERT INTO medical_review(
     	 patient_id,
         appointment_date,	
         doctor_id        
     )
     VALUES(p_patient_id,
            fecha_actual,
            p_doctor_id     		
     );
     INSERT INTO prescribed_medication(
     	patient_id,
        appointment_date, 
        medication_name
     )
     VALUES(p_patient_id, 
     	fecha_actual,
        p_medicacion_name
     );
     COMMIT 
END;

DELIMITER ;
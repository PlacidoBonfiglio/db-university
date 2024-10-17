-- 1. Selezionare tutti gli studenti nati nel 1990 (160)
SELECT *
FROM `students` 
WHERE YEAR(date_of_birth) = 1990; 

-- 2. Selezionare tutti i corsi che valgono più di 10 crediti (479)
SELECT *
FROM `courses`
WHERE `cfu` > 10;

-- 3. Selezionare tutti gli studenti che hanno più di 30 anni
SELECT *
FROM `students` 
WHERE TIMESTAMPDIFF(YEAR, `date_of_birth`, CURDATE()) > 30;

-- 4. Selezionare tutti i corsi del primo semestre del primo anno di un qualsiasi corso di laurea (286)
SELECT *
FROM `courses`
WHERE `period` = "I semestre"
AND `year` = 1;

-- 5. Selezionare tutti gli appelli d'esame che avvengono nel pomeriggio (dopo le 14) del 20/06/2020 (21)
SELECT *
FROM `exams`
WHERE `hour` > "14:00:00"
AND `date` = "2020-06-20";

-- 6. Selezionare tutti i corsi di laurea magistrale (38)
SELECT *
FROM `degrees`
WHERE `level` = "magistrale";

-- 7. Da quanti dipartimenti è composta l'università? (12)
SELECT COUNT(`id`)
FROM `departments`;

-- 8. Quanti sono gli insegnanti che non hanno un numero di telefono? (50)
SELECT COUNT(`id`)
FROM `teachers`
WHERE `phone` IS NULL;

-- 9. Inserire nella tabella degli studenti un nuovo record con i propri dati (per il campo degree_id, inserire un valore casuale)
INSERT INTO `students` (`degree_id`, `name`, `surname`, `date_of_birth`, `fiscal_code`, `enrolment_date`, `registration_number`, `email`)
VALUES (1 , "Placido", "Bonfiglio", "1997-07-31", "NPXVYW51Z02T971B", "2019-02-21", 999999, "dino@gmail.com");


-- 10. Cambiare il numero dell’ufficio del professor Pietro Rizzo in 126
UPDATE `teachers`
SET `office_number` = "126" 
WHERE `id`= 58;

-- 11. Eliminare dalla tabella studenti il record creato precedentemente al punto 9
DELETE FROM `students`
WHERE `id` = 5001;


-- ! ----- ESERCIZIO GROUP BY ------
--1. Contare quanti iscritti ci sono stati ogni anno
SELECT COUNT(*) AS `numero_di_iscrizioni`, YEAR(`enrolment_date`) AS `anno_di_iscrizione`
FROM `students`
GROUP BY `anno_di_iscrizione`;

-- 2. Contare gli insegnanti che hanno l'ufficio nello stesso edificio
SELECT COUNT(*) AS `insegnanti_per_ufficio`, `office_address` AS `indirizzo_ufficio`
FROM `teachers`
GROUP BY `indirizzo_ufficio`;

-- 3. Calcolare la media dei voti di ogni appello d'esame
SELECT COUNT(`exam_id`) AS `appello_esame`, AVG(`vote`) AS `media_voti`
FROM `exam_student` 
GROUP BY `exam_id`; -- ! sbagliata

-- 4. Contare quanti corsi di laurea ci sono per ogni dipartimento
SELECT COUNT(*) AS `dipartimento`, `name` AS `corso_laurea`
FROM `degrees`
GROUP BY `corso_laurea`; -- ! sbagliata


-- ! ----- ESERCIZIO JOIN ------
-- 1. Selezionare tutti gli studenti iscritti al Corso di Laurea in Economia
SELECT `students`.`name` AS `nome_studente`, `degrees`.`name` AS `nome_corso`
FROM `degrees` 
INNER JOIN `students`
ON `students`.`degree_id` = `degrees`.`id`
WHERE `degrees`.`name` = "Corso di Laurea in Economia";

-- 2. Selezionare tutti i Corsi di Laurea Magistrale del Dipartimento di Neuroscienze
SELECT `departments`.`name` AS `nome_dipartimento`, `degrees`.`name` AS `nome_corso`
FROM `departments` 
INNER JOIN `degrees`
ON `degrees`.`department_id` = `departments`.`id`
WHERE `departments`.`name` = "Dipartimento di Neuroscienze"
AND `degrees`.`name` LIKE("% Magistrale %");

-- 3. Selezionare tutti i corsi in cui insegna Fulvio Amato (id=44)

-- 4. Selezionare tutti gli studenti con i dati relativi al corso di laurea a cui sono iscritti e il relativo dipartimento, in ordine alfabetico per cognome e nome

-- 5. Selezionare tutti i corsi di laurea con i relativi corsi e insegnanti

-- 6. Selezionare tutti i docenti che insegnano nel Dipartimento di Matematica (54)

-- 7. BONUS: Selezionare per ogni studente il numero di tentativi sostenuti per ogni esame, stampando anche il voto massimo. Successivamente, filtrare i tentativi con voto minimo 18.
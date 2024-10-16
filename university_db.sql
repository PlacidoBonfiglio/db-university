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
GROUP BY `indirizzo_ufficio`
ORDER BY `insegnanti_per_ufficio` DESC;

-- 3. Calcolare la media dei voti di ogni appello d'esame
SELECT `exam_id`, AVG(`vote`) AS `media_voti`
FROM `exam_student` 
GROUP BY `exam_id`;

-- 4. Contare quanti corsi di laurea ci sono per ogni dipartimento
SELECT `department_id`, COUNT(`degrees`.`id`) AS `corso_laurea`
FROM `degrees`
GROUP BY `degrees`.`id`; 


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
SELECT `teachers`.`id` AS `id_insegnate`, `teachers`.`name` AS `nome_insegnate`, `teachers`.`surname` AS `cognome_insegnate`, `course_teacher`.`course_id` 
FROM `teachers` 
INNER JOIN `course_teacher`
ON `course_teacher`.`teacher_id` = `teachers`.`id`
WHERE `teachers`.`name` = "Fulvio"
AND `teachers`.`surname` = "Amato";

-- 4. Selezionare tutti gli studenti con i dati relativi al corso di laurea a cui sono iscritti e il relativo dipartimento, in ordine alfabetico per cognome e nome
SELECT `students`.`name` AS `nome_studente`, `students`.`surname` AS `cognome_studente`, `departments`.`name` AS `nome_dipartimento`, `degrees`.`name` AS `nome_corso`
FROM `departments` 
JOIN `degrees` ON `degrees`.`department_id` = `departments`.`id`
JOIN `students` ON `students`.`degree_id` = `degrees`.`id`
ORDER BY `students`.`name`, `students`.`surname` ASC;

-- 5. Selezionare tutti i corsi di laurea con i relativi corsi e insegnanti
SELECT *
FROM `degrees`
JOIN `courses` ON `degrees`.`id` = `courses`.`degree_id`
JOIN `course_teacher` ON `courses`.`id` = `course_teacher`.`course_id`
JOIN `teachers` ON `teachers`.`id` = `course_teacher`.`teacher_id`;

-- 6. Selezionare tutti i docenti che insegnano nel Dipartimento di Matematica (54)
SELECT `teachers`.`name`, `teachers`.`surname`, `departments`.`name`
FROM `departments`
JOIN `degrees` ON `departments`.`id` = `degrees`.`department_id`
JOIN `courses` ON `degrees`.`id` = `courses`.`degree_id`
JOIN `course_teacher` ON `courses`.`id` = `course_teacher`.`course_id`
JOIN `teachers`  `teachers`.`id` = `course_teacher`.`teacher_id`
WHERE `departments`.`name` = "Dipartimento di Matematica";

-- 7. BONUS: Selezionare per ogni studente il numero di tentativi sostenuti per ogni esame, stampando anche il voto massimo. Successivamente, filtrare i tentativi con voto minimo 18.
SELECT `students`.`id`, `students`.`name`, `students`.`surname`, MAX(`exam_student`.`vote`) AS `miglior_voto`, `courses`.`name`, COUNT(`exam_student`.`vote`) AS `tentativi_appello`
FROM `students`
JOIN `exam_student` ON `students`.`id` = `exam_student`.`student_id`
JOIN `exam` ON `exam`.`id` = `exam_student`.`exam_id`
JOIN `courses` ON `courses`.`id` = `exams`.`course_id`
GROUP BY `students`.`id`, `courses`.`id`
HAVING `miglior_voto` >= 18;

---
-- Quelques exemples de fonctions et déclencheurs. Corrections des exercices vus en cours.
---

-- EXERCICE 1. Fonction PLPGSQL comptant le nombre d'étudiants dans une matière
CREATE OR REPLACE FUNCTION nbetudiants(code_course varchar)
RETURNS table (total bigint)
AS $$
BEGIN
   RETURN QUERY
	SELECT count(*) FROM course_student
	WHERE code=$1 ;
END;
$$ LANGUAGE PLPGSQL;


-- EXERCICE 2. Fonction PLPGSQL affichant les noms des étudiants pour un cours donné
CREATE OR REPLACE FUNCTION liste_etudiant_cours(code_course varchar)
RETURNS SETOF PERSON
AS $$
BEGIN
   RETURN QUERY
	SELECT PERSON.* FROM PERSON JOIN COURSE_STUDENT 
      ON PERSON.email = COURSE_STUDENT.student
	WHERE code = code_course ;
END;
$$ 
LANGUAGE PLPGSQL ;

-- EXERCICE 3. Trigger qui vérifie qu'un étudiant n'est pas un enseignant et vice versa
-- Création en 3 étapes

-- ETAPE 1. Création de fonctions qui vérifient qu'une personne n'est pas un enseignant et vice-versa
create or replace function verif_etudiant_non_enseignant(email_person varchar)
returns  bool as $$
BEGIN
RETURN NOT EXISTS 
(
   select teacher as email from course_teacher where teacher = email_person
);
END;
$$
LANGUAGE PLPGSQL;

create or replace function verif_enseignant_non_etudiant(email_person varchar)
returns  bool as $$
BEGIN
RETURN NOT EXISTS 
(
   select student as email from course_student where student = email_person
);
END;
$$
LANGUAGE PLPGSQL;

-- ETAPE 2. Création de fonctions trigger qui lèvent une exception si un étudiant est déjà un enseignant et vice-versa
create or replace function verif_enseignant_non_etudiant()
RETURNS "trigger" as $$
BEGIN
   IF (verif_enseignant_non_etudiant(NEW.teacher) = false) THEN
      RAISE EXCEPTION 'L enseignant est déjà étudiant !';
   ELSE
      RETURN NEW;
   END IF;
END;
$$
LANGUAGE PLPGSQL;


create or replace function verif_etudiant_non_enseignant()
RETURNS "trigger" as $$
BEGIN
   IF (verif_etudiant_non_enseignant(NEW.student) = false) THEN
      RAISE EXCEPTION 'L étudiant est déjà enseignant !';
   ELSE
      RETURN NEW;
   END IF;
END;
$$
LANGUAGE PLPGSQL;

-- ETAPE 3.. Création de triggers sur les tables COURSE_TEACHER et COURSE_STUDENT
create trigger verif_non_etudiant_trigger
before insert 
on course_teacher
for each  row
execute procedure verif_enseignant_non_etudiant();

create trigger verif_non_enseignant_trigger
before insert 
on course_student
for each  row
execute procedure verif_etudiant_non_enseignant();


-- TEST
INSERT INTO PERSON VALUES ('joseph.martin@example.com', 'Joseph', 'Martin'); 
INSERT INTO PERSON VALUES ('maryline.turin@example.com', 'Maryline', 'Turin');
INSERT INTO PERSON VALUES ('clemence.dupin@example.com', 'Clémence', 'Dupin');

INSERT INTO COURSE_STUDENT VALUES ('I51', 'joseph.martin@example.com');
INSERT INTO COURSE_TEACHER VALUES ('I51', 'joseph.martin@example.com'); -- lève une exception car cette personne est déjà étudiante

INSERT INTO COURSE_TEACHER VALUES ('I51', 'maryline.turin@example.com'); 
INSERT INTO COURSE_STUDENT VALUES ('I51', 'maryline.turin@example.com'); -- lève une exception car cette personne est déjà enseignante

INSERT INTO COURSE_TEACHER VALUES ('I63', 'maryline.turin@example.com'); -- ne lève pas d'exception
INSERT INTO COURSE_STUDENT VALUES ('I63', 'joseph.martin@example.com'); -- ne lève pas d'exception
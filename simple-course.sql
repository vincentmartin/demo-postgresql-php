-----------------	BDD - Illustrative examples	 	-----------------
-----------------	version 26 mars 2013			-----------------

-----------------------------------------------------------------------------
-- Clear previous information.
-----------------------------------------------------------------------------
DROP TABLE IF EXISTS PERSON CASCADE;
DROP TABLE IF EXISTS COURSE CASCADE;
DROP TABLE IF EXISTS COURSE_TEACHER CASCADE;
DROP TABLE IF EXISTS COURSE_STUDENT CASCADE;
DROP VIEW IF EXISTS  COURSE_DETAILS CASCADE;

DROP ROLE IF EXISTS teachers;
DROP ROLE IF EXISTS students;
DROP ROLE IF EXISTS "jean.dupont@univ-tln.fr";
DROP ROLE IF EXISTS "kevin.durant@univ-tln.fr";
DROP ROLE IF EXISTS "justine.clavier@univ-tln.fr";


-----------------------------------------------------------------------------
-- Initialize the structure.
-----------------------------------------------------------------------------
CREATE PROCEDURAL LANGUAGE plpgsql;

CREATE TABLE PERSON (
email VARCHAR(100) NOT NULL,
first_name VARCHAR(100)  NOT NULL,
last_name VARCHAR(100) NOT NULL,
CONSTRAINT email CHECK (((email)::text ~* '^[0-9a-zA-Z._-]+@[0-9a-zA-Z._-]{2,}[.][a-zA-Z]{2,4}$'::text)),
PRIMARY KEY (email)
);

CREATE TABLE COURSE (
code VARCHAR(10) NOT NULL,
name VARCHAR(100) NOT NULL,
description VARCHAR(1000),
PRIMARY KEY (code)
);

CREATE TABLE COURSE_TEACHER(
code VARCHAR(100) REFERENCES COURSE (code),
teacher VARCHAR(100) REFERENCES PERSON(email),
PRIMARY KEY(code, teacher)
);

CREATE TABLE COURSE_STUDENT(
code VARCHAR(100) REFERENCES COURSE (code), 
student VARCHAR(100) REFERENCES PERSON(email),
PRIMARY KEY(code, student)
);


-----------------------------------------------------------------------------
-- Defining roles.
-----------------------------------------------------------------------------

CREATE ROLE teachers;
CREATE ROLE students;

CREATE ROLE "jean.dupont@univ-tln.fr" LOGIN IN GROUP teachers;
	ALTER ROLE "jean.dupont@univ-tln.fr" ENCRYPTED PASSWORD 'tch';
CREATE ROLE "kevin.durant@univ-tln.fr" LOGIN IN GROUP students;
	ALTER ROLE "kevin.durant@univ-tln.fr" ENCRYPTED PASSWORD 'std';
-- DOCTORANT = students + teachers
CREATE ROLE "justine.clavier@univ-tln.fr" LOGIN IN GROUP students, teachers;
	ALTER ROLE "justine.clavier@univ-tln.fr" ENCRYPTED PASSWORD 'std';


-----------------------------------------------------------------------------
-- Insert some data.
-----------------------------------------------------------------------------

INSERT INTO PERSON VALUES ('jean.dupont@univ-tln.fr', 'Jean', 'Dupont');
INSERT INTO PERSON VALUES ('kevin.durant@univ-tln.fr', 'Kevin', 'Durant');

INSERT INTO COURSE VALUES ('I51', 'Systèmes et Réseaux', NULL);
INSERT INTO COURSE VALUES ('I63', 'BDD', 'Bases de données');

INSERT INTO COURSE_TEACHER VALUES ('I51', 'jean.dupont@univ-tln.fr');
INSERT INTO COURSE_TEACHER VALUES('I63', 'jean.dupont@univ-tln.fr');

INSERT INTO COURSE_STUDENT VALUES('I63', 'kevin.durant@univ-tln.fr');
INSERT INTO COURSE_STUDENT VALUES('I51', 'kevin.durant@univ-tln.fr');


-----------------------------------------------------------------------------
-- Views & Functions.
-------------------------------------------------------
CREATE VIEW COURSE_DETAILS AS 
	SELECT COURSE.code AS COURSE_code, COURSE.name as COURSE_name, PERSON.first_name AS teacher_first_name, PERSON.last_name as teacher_last_name, PERSON.email AS teacher_email 
	FROM COURSE_TEACHER JOIN COURSE ON COURSE.code = COURSE_TEACHER.code  JOIN PERSON ON COURSE_TEACHER.teacher = PERSON.email;

CREATE OR REPLACE FUNCTION curr_roles() RETURNS SETOF TEXT
    LANGUAGE plpgsql AS $$
DECLARE
	role text := '';
BEGIN
	FOR role IN SELECT DISTINCT (CAST(role_name AS VARCHAR)) FROM information_schema.applicable_roles LOOP
		RETURN NEXT role;
	END LOOP;
END;
$$;

-----------------------------------------------------------------------------
-- Permissions.
-----------------------------------------------------------------------------
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE PERSON TO teachers;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE COURSE TO teachers;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE COURSE_TEACHER TO teachers;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE COURSE_STUDENT TO students;

GRANT SELECT ON TABLE COURSE TO students;
GRANT SELECT ON TABLE COURSE_TEACHER TO students;
-- Only teachers have an acces to the view.
GRANT SELECT ON VIEW COURSE_DETAILS TO teachers;

CREATE OR REPLACE FUNCTION COURSE_DETAILS_UPDATE()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $function$
   BEGIN
      IF TG_OP = 'INSERT' THEN
        INSERT INTO  COURSE VALUES(NEW.COURSE_code,NEW.COURSE_name);
        INSERT INTO  PERSON VALUES(NEW.teacher_email,NEW.teacher_first_name, NEW.teacher_last_name);
        RETURN NEW;
      ELSIF TG_OP = 'UPDATE' THEN
	UPDATE   COURSE SET code = NEW.COURSE_code, name= NEW.COURSE_name WHERE code = OLD.COURSE_code;
       UPDATE PERSON SET email=NEW.PERSON_email,first_name= NEW.teacher_first_name, last_name = NEW.teacher_last_name WHERE email=OLD.teacher_email;
       RETURN NEW;
      ELSIF TG_OP = 'DELETE' THEN
       DELETE FROM COURSE WHERE code=OLD.COURSE_code;
       DELETE FROM PERSON WHERE email=OLD.teacher_email;
       RETURN NULL;
      END IF;
      RETURN NEW;
    END;
$function$;

CREATE TRIGGER COURSE_DETAILS_TRIGGER
    INSTEAD OF INSERT OR UPDATE OR DELETE ON
      COURSE_DETAILS_TRIGGER FOR EACH ROW EXECUTE PROCEDURE COURSE_DETAILS_UPDATE();


-- Exercices : connectez-vous avec les trois utilisateurs et constater par vous-même les droits de chacun.

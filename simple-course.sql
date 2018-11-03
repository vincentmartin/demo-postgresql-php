-----------------	BDD - Illustrative examples	 	-----------------
----------- version 31 mars 2013, mise à jour le 09 février 2015 ----------------

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
DROP ROLE IF EXISTS "jean.dupont";
DROP ROLE IF EXISTS "kevin.durant";
DROP ROLE IF EXISTS "justine.clavier";


-----------------------------------------------------------------------------
-- Initialize the structure.
-----------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURAL LANGUAGE plpgsql;

CREATE TABLE PERSON (
email VARCHAR(100) NOT NULL,
first_name VARCHAR(100)  NOT NULL,
last_name VARCHAR(100) NOT NULL,
CONSTRAINT email_chk CHECK (((email)::text ~* '^[0-9a-zA-Z._-]+@[0-9a-zA-Z._-]{2,}[.][a-zA-Z]{2,4}$'::text)),
PRIMARY KEY (email)
);

CREATE TABLE COURSE (
code VARCHAR(10) NOT NULL,
name VARCHAR(100) NOT NULL,
description VARCHAR(1000),
CONSTRAINT code_chk CHECK (LENGTH(code) > 2),
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

CREATE ROLE "jean.dupont" LOGIN IN GROUP teachers;
	ALTER ROLE "jean.dupont" ENCRYPTED PASSWORD 'tch';
CREATE ROLE "kevin.durant" LOGIN IN GROUP students;
	ALTER ROLE "kevin.durant" ENCRYPTED PASSWORD 'std';
-- DOCTORANT = students + teachers
CREATE ROLE "justine.clavier" LOGIN IN GROUP students, teachers;
	ALTER ROLE "justine.clavier" ENCRYPTED PASSWORD 'std';


-----------------------------------------------------------------------------
-- Insert some data.
-----------------------------------------------------------------------------

INSERT INTO PERSON VALUES ('jean.dupont@example.com', 'Jean', 'Dupont');
INSERT INTO PERSON VALUES ('kevin.durant@example.com', 'Kevin', 'Durant');

INSERT INTO COURSE VALUES ('I51', 'Systèmes et Réseaux', NULL);
INSERT INTO COURSE VALUES ('I63', 'BDD', 'Bases de données');

INSERT INTO COURSE_TEACHER VALUES ('I51', 'jean.dupont@example.com');
INSERT INTO COURSE_TEACHER VALUES('I63', 'jean.dupont@example.com');

INSERT INTO COURSE_STUDENT VALUES('I63', 'kevin.durant@example.com');
INSERT INTO COURSE_STUDENT VALUES('I51', 'kevin.durant@example.com');


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
GRANT SELECT ON COURSE_DETAILS TO teachers; -- 9.X+
-- GRANT SELECT ON VIEW COURSE_DETAILS TO teachers;  -- 8.X

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
      COURSE_DETAILS FOR EACH ROW EXECUTE PROCEDURE COURSE_DETAILS_UPDATE();

-- Exercices : connectez-vous avec les trois utilisateurs et constater par vous-même les droits de chacun.

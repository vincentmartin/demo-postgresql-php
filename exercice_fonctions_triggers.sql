---
-- Quelques exemples de fonctions et déclencheurs. Corrections des exercices vus en cours.
---

------------------------------------------------------------------------------------
-- EXERCICE 1. Fonction PLPGSQL comptant le nombre d'étudiants dans une matière
------------------------------------------------------------------------------------

-- TODO : écrire le code de la fonction
------------------------------------------------------------------------------------

------------------------------------------------------------------------------------
-- EXERCICE 2. Fonction PLPGSQL affichant les noms des étudiants pour un cours donné
------------------------------------------------------------------------------------

-- TODO : écrire le code de la fonction

------------------------------------------------------------------------------------

------------------------------------------------------------------------------------
-- EXERCICE 3. Trigger qui vérifie qu'un étudiant n'est pas un enseignant et vice versa
------------------------------------------------------------------------------------

-- Création en 3 étapes

-- ETAPE 1. Création de 2 fonctions : une qui vérifie qu'une personne n'est pas un enseignant et une autre qui 
-- vérifie qu'un enseignant n'est pas un étudiant

-- TODO : ecrire de code de la première fonction

-- TODO : écrire le code de la seconde fonction


-- ETAPE 2. Création des 2 triggers associés

-- TODO : écrire le code de la première fonction trigger associée à la première fonction

-- TODO  écrire le code de la seconde fonction trigger  associée à la seconde fonction

-- ETAPE 3.. Création de triggers sur les tables COURSE_TEACHER et COURSE_STUDENT

-- TODO : écrire le trigger sur la table course_teacher

-- TODO : écrire le trigger sur la table course_student
------------------------------------------------------------------------------------

-- TEST : exécuter les lignes suivante pour vérifier le bon fonctionnement de vos triggers.
INSERT INTO PERSON VALUES ('joseph.martin@example.com', 'Joseph', 'Martin'); 
INSERT INTO PERSON VALUES ('maryline.turin@example.com', 'Maryline', 'Turin');
INSERT INTO PERSON VALUES ('clemence.dupin@example.com', 'Clémence', 'Dupin');

INSERT INTO COURSE_STUDENT VALUES ('I51', 'joseph.martin@example.com');
INSERT INTO COURSE_TEACHER VALUES ('I51', 'joseph.martin@example.com'); -- lève une exception car cette personne est déjà étudiante

INSERT INTO COURSE_TEACHER VALUES ('I51', 'maryline.turin@example.com'); 
INSERT INTO COURSE_STUDENT VALUES ('I51', 'maryline.turin@example.com'); -- lève une exception car cette personne est déjà enseignante

INSERT INTO COURSE_TEACHER VALUES ('I63', 'maryline.turin@example.com'); -- ne lève pas d'exception
INSERT INTO COURSE_STUDENT VALUES ('I63', 'joseph.martin@example.com'); -- ne lève pas d'exception
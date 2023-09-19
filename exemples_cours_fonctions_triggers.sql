-- Création de la BDD

-- Création de la table EDITIONS
CREATE TABLE EDITIONS (
    codeEdition INT PRIMARY KEY,
    nom VARCHAR(255) NOT NULL,
    adresse VARCHAR(255),
    dateCreation DATE
);

-- Création de la table COLLECTIONS

CREATE TABLE COLLECTIONS (
    codeColl INT PRIMARY KEY,
    intitule VARCHAR(255) NOT NULL,
    codeEdition INT REFERENCES EDITIONS(codeEdition),
    theme VARCHAR(255)
);



-- Création de la table LIVRES
CREATE TABLE LIVRES (
    isbn VARCHAR(13) PRIMARY KEY,
    titre VARCHAR(255) NOT NULL,
    prix DECIMAL(10, 2),
    depotLegal DATE,
    CodeColl INT REFERENCES COLLECTIONS(codeColl)
);


-- Insertion de données dans la table EDITIONS
INSERT INTO EDITIONS (codeEdition, nom, adresse, dateCreation) VALUES
    (1, 'Éditions ABC', '123 Rue de l''Éditeur', '2022-01-15'),
    (2, 'Éditions XYZ', '456 Avenue de l''Imprimeur', '2021-11-20'),
    (3, 'Éditions 123', '789 Boulevard de l''Écrivain', '2023-03-05');

-- Insertion de données dans la table COLLECTIONS
INSERT INTO COLLECTIONS (codeColl, intitule, codeEdition, theme) VALUES
    (1, 'Collection A', 1, 'Fiction'),
    (2, 'Collection B', 1, 'Science-fiction'),
    (3, 'Collection C', 2, 'Fantasy'),
    (4, 'Collection D', 3, 'Policier');

-- Insertion de données dans la table LIVRES
INSERT INTO LIVRES (isbn, titre, prix, depotLegal, CodeColl) VALUES
    ('9781234567890', 'Livre 1', 19.99, '2016-01-15', 1),
    ('9782345678901', 'Livre 2', 15.99, '2016-01-15', 1),
    ('9783456789012', 'Livre 3', 24.99, '2017-01-15', 2),
    ('9784567890123', 'Livre 4', 12.99, '2018-01-15', 3),
    ('9785678901234', 'Livre 5', 29.99, '2019-01-15', 4);




CREATE OR REPLACE FUNCTION VerifDatesEditionPublication()
RETURNS TRIGGER
AS $$
DECLARE
    dates_ok boolean := false;
BEGIN
    SELECT new.depotLegal >= E.dateCreation
    INTO dates_ok
    FROM EDITIONS E
    WHERE E.codeEdition = (SELECT C.codeEdition
                            FROM COLLECTIONS C
                            WHERE C.CodeColl = new.CodeColl);
    IF (dates_ok) THEN
        
        RETURN new;
    ELSE
        RAISE INFO 'date de publication antérieure à la date de création de l''édition' ;
        RETURN NULL; -- ne renvoie rien, insertion abandonnée --
    END IF;
END;
$$ LANGUAGE PLPGSQL;

CREATE TRIGGER VerifDatesEditionPublication
	BEFORE INSERT OR UPDATE ON LIVRES
	FOR EACH ROW 
	EXECUTE PROCEDURE VerifDatesEditionPublication();

-- test trigger OK
INSERT INTO LIVRES (isbn, titre, prix, depotLegal, CodeColl) VALUES
    ('9781234567891', 'Livre 6', 19.99, '2016-01-15', 1);

-- test trigger KO
INSERT INTO LIVRES (isbn, titre, prix, depotLegal, CodeColl) VALUES
    ('9781234567894', 'Livre 9', 19.99, '2023-12-15', 1);
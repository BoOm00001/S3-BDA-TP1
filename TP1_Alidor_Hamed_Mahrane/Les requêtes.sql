
USE [VolsBD];

--- QUESTION 1.
/*
SELECT id_vol 
FROM vol;

SELECT *
FROM circuit
WHERE code_depart = 'YVR' AND code_destination = 'YQB'
ORDER BY duree ASC;

SELECT *
FROM vol
WHERE nbplacemax = 150 AND prix = 665;
*/

INSERT INTO vol (id_vol, no_circuit, date_depart, nbplacemax, prix)
VALUES (
    565,
    (
        SELECT TOP 1 no_circuit
        FROM circuit
        WHERE code_depart = 'YVR' AND code_destination = 'YQB'
        ORDER BY duree ASC
    ),
    DATEADD(MONTH, 3, SYSDATETIME()), 
    150, 
    665 
);
GO

SELECT *
FROM vol
WHERE prix = 665;
GO
--- QUESTION 2.
SELECT COUNT(*) AS nb_inscriptions_2020
FROM inscription
WHERE YEAR(date_inscription) =2020;
GO
--- QUESTION 3
SELECT COUNT(DISTINCT id_vol) AS nb_vols_uniques_2020
FROM vol
WHERE YEAR(date_depart) = 2020;
GO
--- QUESTION 4
CREATE OR ALTER VIEW VUE2 AS
SELECT 
    c.code_depart,
    AVG(v.nbplacemax) AS nb_places,
    AVG(v.prix) AS prix,
    COUNT(*) AS nb_vols
FROM vol v
JOIN circuit c ON v.no_circuit = c.no_circuit
WHERE 
    v.prix > (SELECT AVG(prix) FROM vol)
    AND v.nbplacemax > 1500
GROUP BY c.code_depart;

GO

SELECT * FROM VUE2
ORDER BY nb_vols;
GO

/*
SELECT AVG(prix) AS moyenneprix FROM vol;
SELECT AVG(nbplacemax) AS moyenne FROM vol;
SELECT * FROM vol WHERE nbplacemax > 1500;
SELECT * FROM vol WHERE prix > 365;
select * from vol;
select COUNT(*) from vol;

select v.id_vol, c.code_depart, c.code_destination, v.prix
from vol v
join circuit c ON v.no_circuit = c.no_circuit;
*/
-- QUESTION 5

CREATE OR ALTER VIEW dbo.Vue2 AS
SELECT
    v.id_vol,
    (v.nbplacemax - COUNT(i.noclient)) AS [Nombre de places libres],
    (COUNT(i.noclient) * v.prix)       AS [Total],
    v.prix,
    v.nbplacemax
FROM dbo.vol AS v
LEFT JOIN dbo.inscription AS i
    ON i.id_vol = v.id_vol
GROUP BY
    v.id_vol, v.prix, v.nbplacemax;
GO
-- Pour tester
SELECT * 
FROM dbo.Vue2
ORDER BY id_vol;
GO

-- QUESTION 6
SELECT 
    c.no_circuit,
    c.code_depart,
    a1.nom_aeroport AS [Aeroport depart],
    c.code_destination,
    a2.nom_aeroport AS [Aeroport destination]
FROM dbo.circuit AS c
JOIN dbo.aeroport AS a1
    ON c.code_depart = a1.IATA_CODE
JOIN dbo.aeroport AS a2
    ON c.code_destination = a2.IATA_CODE
ORDER BY c.no_circuit;
GO

-- QUESTION 7
SELECT 
    c.no_circuit,
    c.code_depart,
    a1.nom_aeroport AS [Aeroport depart],
    c.code_destination,
    a2.nom_aeroport AS [Aeroport destination]
FROM dbo.circuit AS c
JOIN dbo.aeroport AS a1
    ON c.code_depart = a1.IATA_CODE
JOIN dbo.aeroport AS a2
    ON c.code_destination = a2.IATA_CODE
LEFT JOIN dbo.vol AS v
    ON c.no_circuit = v.no_circuit
WHERE v.id_vol IS NULL
ORDER BY c.no_circuit;
GO

-- 8) Montant total payé par chaque client

SELECT 
    c.noclient,
    c.nom_client,
    SUM(v.prix) AS Total,
    COUNT(i.id_vol) AS [nombre de voyages]
FROM dbo.client AS c
JOIN dbo.inscription AS i ON i.noclient = c.noclient
JOIN dbo.vol AS v ON v.id_vol   = i.id_vol
GROUP BY c.noclient, c.nom_client
ORDER BY c.noclient;  
GO

-- 9 Création de la vue3
CREATE OR ALTER VIEW dbo.vue3 AS
SELECT
    v.id_vol,
    v.no_circuit,
    c.code_depart,
    c.code_destination,
    v.date_depart,
    vil.nom_ville,
    v.prix,
    v.nbplacemax
FROM dbo.vol AS v
JOIN dbo.circuit AS c
    ON v.no_circuit = c.no_circuit
JOIN dbo.aeroport AS a
    ON c.code_depart = a.IATA_CODE
JOIN dbo.ville AS vil
    ON a.id_ville = vil.id_ville;
GO

-- Pour tester
SELECT * 
FROM dbo.vue3
ORDER BY id_vol;
GO

-- 10 Création de la table temporaire TMPtable3

CREATE TABLE #TMPtable3 (
    id INT,                      
    date_depart DATETIME2,        
    nom_ville NVARCHAR(100),      
    prix DECIMAL(10,2),          
    nbplacemax INT                
);
GO

-- 1) Insertion des vols au départ de Paris et dans le futur (par rapport à 2023-08-23)
INSERT INTO #TMPtable3 (id, date_depart, nom_ville, prix, nbplacemax)
SELECT 
    id_vol,
    date_depart,
    nom_ville,
    prix,
    nbplacemax
FROM dbo.vue3
WHERE nom_ville = 'Paris'
  AND date_depart > '2023-08-23';
  GO

-- 2) Vérification du contenu
SELECT * 
FROM #TMPtable3
ORDER BY date_depart;
GO

-- 11  Affichage du classement de vols
SELECT
    id_vol,
    prix,
    RANK() OVER (ORDER BY prix DESC) AS classement
FROM dbo.vol
ORDER BY classement, id_vol;
GO

-- 12 Requete SQL prix moyen
SELECT 
    c.code_depart,
    v.id_vol,
    v.prix,
    AVG(v.prix) OVER (PARTITION BY c.code_depart) AS prix_moyen_depart,
    MAX(c.duree) OVER (PARTITION BY c.code_depart) AS duree_max_depart
FROM dbo.vol AS v
JOIN dbo.circuit AS c
    ON v.no_circuit = c.no_circuit
ORDER BY c.code_depart, v.id_vol;
GO

-- 13  Requête SQL  prix le plus bas de chaque mois
/*
WITH MinParMois AS (

SELECT

YEAR(date_depart) AS Annee,

MONTH(date_depart) AS Mois,

MIN(prix) AS PrixMin

FROM vol

GROUP BY YEAR(date_depart), MONTH(date_depart)

),

DiffMois AS (

SELECT

Annee,

Mois,

PrixMin,

PrixMin - LAG(PrixMin) OVER (ORDER BY Annee, Mois) AS DiffAvecPrecedent

FROM MinParMois

)

SELECT

Mois,

PrixMin,

DiffAvecPrecedent

FROM DiffMois

ORDER BY Annee, Mois;

GO
*/

WITH MinsParMois AS (
    SELECT
        Mois = DATEFROMPARTS(YEAR(v.date_depart), MONTH(v.date_depart), 1),
        PrixMin = MIN(v.prix)
    FROM dbo.vol AS v
    GROUP BY DATEFROMPARTS(YEAR(v.date_depart), MONTH(v.date_depart), 1)
)
SELECT
    Mois,
    PrixMin,
    DiffAvecMoisPrecedent = PrixMin - LAG(PrixMin) OVER (ORDER BY Mois)
FROM MinsParMois
ORDER BY Mois;
GO

-- 14   Fichier pays5.json

DECLARE @json NVARCHAR(MAX);

-- 1) Charger le JSON 
SELECT @json = BulkColumn
FROM OPENROWSET(
  BULK 'C:\Temp\tp1_bd_nouveau\pays5.json',
  SINGLE_CLOB
) AS src;

-- 2) Table source temporaire
IF OBJECT_ID('tempdb..#NewPays') IS NOT NULL DROP TABLE #NewPays;
CREATE TABLE #NewPays (
    id_pays      INT           NOT NULL,
    nom_pays     VARCHAR(30)   NOT NULL,
    taux         DECIMAL(10,3) NOT NULL,
    code_monnaie CHAR(3)       NOT NULL
);

-- 3)  mapping

INSERT INTO #NewPays (id_pays, nom_pays, taux, code_monnaie)
SELECT *
FROM OPENJSON(@json)
WITH (
    id_pays      INT           '$.id',
    nom_pays     VARCHAR(30)   '$.pays',
    taux         DECIMAL(10,3) '$.taux',
    code_monnaie CHAR(3)       '$.monnaie'
);

-- 4)Vérifier ce qui a été lu
SELECT * FROM #NewPays ORDER BY id_pays;

-- 5) MERGE vers dbo.pays
MERGE INTO dbo.pays AS target
USING #NewPays AS source
   ON target.id_pays = source.id_pays

WHEN MATCHED THEN
    UPDATE SET
      target.nom_pays     = source.nom_pays,
      target.taux         = source.taux,
      target.code_monnaie = source.code_monnaie

WHEN NOT MATCHED BY TARGET THEN
    INSERT (id_pays, nom_pays, taux, code_monnaie)
    VALUES (source.id_pays, source.nom_pays, source.taux, source.code_monnaie);

GO

-- 6)Pour tester

SELECT * FROM dbo.pays ORDER BY id_pays;
GO
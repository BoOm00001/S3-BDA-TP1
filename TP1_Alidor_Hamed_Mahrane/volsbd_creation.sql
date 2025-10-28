
USE master;
GO

-- Supprimer la base si elle existe
IF EXISTS (SELECT name FROM sys.databases WHERE name = 'VolsBD')
BEGIN
    ALTER DATABASE [VolsBD] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE [VolsBD];
END
GO

/*
BEGIN
	ALTER DATABASE [VolsBD] SET OFFLINE WITH ROLLBACK IMMEDIATE;
	ALTER DATABASE [VolsBD] SET ONLINE;
	DROP DATABASE [VolsBD];
END
*/

-- Recréer la base
CREATE DATABASE [VolsBD];
GO

-- Utiliser la base
USE [VolsBD];
GO

-- Table : pays
CREATE TABLE [dbo].[pays] (
    id_pays INT NOT NULL PRIMARY KEY,
    nom_pays VARCHAR(30) NOT NULL,
    taux DECIMAL(10,3) NOT NULL,
    code_monnaie CHAR(3) NOT NULL
);
GO

-- Table : provinces
CREATE TABLE [dbo].[provinces] (
    id_province INT PRIMARY KEY,
    nom_province VARCHAR(100),
    id_pays INT,
    FOREIGN KEY (id_pays) REFERENCES pays(id_pays)
);
GO

-- Table : ville
CREATE TABLE [dbo].[ville] (
    id_ville INT PRIMARY KEY,
    nom_ville VARCHAR(100),
    id_province INT,
    FOREIGN KEY (id_province) REFERENCES provinces(id_province)
);
GO

-- Table : aeroport
CREATE TABLE [dbo].[aeroport] (
    nom_aeroport VARCHAR(100),
    id_ville INT,
    IATA_CODE CHAR(3) PRIMARY KEY,
    FOREIGN KEY (id_ville) REFERENCES ville(id_ville)
);
GO

-- Table : circuit
CREATE TABLE [dbo].[circuit] (
    no_circuit VARCHAR(20) PRIMARY KEY,
    code_depart CHAR(3),
    code_destination CHAR(3),
    duree INT,
    FOREIGN KEY (code_depart) REFERENCES aeroport(IATA_CODE),
    FOREIGN KEY (code_destination) REFERENCES aeroport(IATA_CODE)
);
GO

CREATE TABLE [dbo].[vol] (
    id_vol INT PRIMARY KEY,
    no_circuit VARCHAR(20) NOT NULL,
    date_depart DATETIME NOT NULL,
    nbplacemax INT NOT NULL,
    prix INT NOT NULL
        CONSTRAINT chk_prix_valide CHECK (prix BETWEEN 20 AND 3000),
    FOREIGN KEY (no_circuit) REFERENCES circuit(no_circuit)
);

-- Table : client
CREATE TABLE [dbo].[client] (
    noclient INT PRIMARY KEY,
    nom_client VARCHAR(100),
    tel_client VARCHAR(20),
    codepostal_client VARCHAR(10),
    adresse_client VARCHAR(200),
    id_ville INT NOT NULL,
    FOREIGN KEY (id_ville) REFERENCES ville(id_ville)
);
GO

-- Table : inscription
CREATE TABLE [dbo].[inscription] (
    noclient INT NOT NULL,
    id_vol INT NOT NULL,
    date_inscription DATETIME NOT NULL,
    PRIMARY KEY (noclient, id_vol),
    FOREIGN KEY (noclient) REFERENCES client(noclient),
    FOREIGN KEY (id_vol) REFERENCES vol(id_vol),
    CONSTRAINT chk_date_inscription CHECK (date_inscription <= GETDATE())
);
GO









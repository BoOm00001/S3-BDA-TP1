
USE [VolsBD];

BULK INSERT [dbo].[pays]
FROM 'C:\\Temp\\tp1_bd_nouveau\\vgPays.csv'
WITH (
    FIELDTERMINATOR = ';',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2,
    CODEPAGE = '65001',
    TABLOCK
);

select * from [dbo].[pays];



BULK INSERT [dbo].[provinces]
FROM 'C:\\Temp\\tp1_bd_nouveau\\vgProvinces.csv'
WITH (
    FIELDTERMINATOR = '|',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2,
    CODEPAGE = '65001',
    TABLOCK
);
GO
select * from [dbo].[provinces];

BULK INSERT [dbo].[ville]
FROM 'C:\\Temp\\tp1_bd_nouveau\\vgVilles.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2,
    CODEPAGE = '65001',
    TABLOCK
);
GO
select * from [dbo].[ville];

BULK INSERT [dbo].[aeroport]
FROM 'C:\\Temp\\tp1_bd_nouveau\\vg_aeroports.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0A',
    FIRSTROW = 2,
    CODEPAGE = '65001',
    TABLOCK
);


select * from [dbo].[aeroport];

BULK INSERT [dbo].[circuit]
FROM 'C:\\Temp\\tp1_bd_nouveau\\vgCircuits.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0A',
    FIRSTROW = 2,
    CODEPAGE = '65001',
    TABLOCK
);
Go
select * from [dbo].[circuit];

SELECT TOP 5 *
FROM OPENROWSET(
    BULK 'C:\Temp\tp1_bd_nouveau\vgVols.csv',
    SINGLE_CLOB
) AS t;
GO

BULK INSERT [dbo].[vol]
FROM 'C:\\Temp\\tp1_bd_nouveau\\vgVols.csv'
WITH (
    FORMAT = 'CSV',
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0A',
    FIRSTROW = 2,
    CODEPAGE = '65001',
    TABLOCK
);
Go

select * from  [dbo].[vol];

BULK INSERT [dbo].[client]
FROM 'C:\\Temp\\tp1_bd_nouveau\\vgclients.csv'
WITH (
    FORMAT = 'CSV',
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0A',
    FIRSTROW = 2,
    CODEPAGE = '65001',
    FIELDQUOTE = '"',
    TABLOCK
);
Go
select * from [dbo].[client];

BULK INSERT [dbo].[inscription]
FROM 'C:\\Temp\\tp1_bd_nouveau\\vgInscriptions.csv'
WITH (
     FIELDTERMINATOR = ';',
    ROWTERMINATOR = '0x0A',
    FIRSTROW = 2,
    CODEPAGE = '65001',
    TABLOCK
);
Go

select * from [dbo].[inscription];

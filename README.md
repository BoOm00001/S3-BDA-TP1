TP1 - Bases de donnees avancees (VolsBD)
========================================

Cours : 420-W34-SF - Bases de donnees avancees  
Professeur : Ali Awde  
Etablissement : Cegep de Sainte-Foy  
Environnement : SQL Server  
Travail en equipe

---------------------------------------------------------

Objectif du projet
------------------
Ce premier travail pratique vise a construire la base de donnees VolsBD et a manipuler des donnees reelles a partir de fichiers CSV et JSON.  
L'objectif est de maitriser la creation d'une base relationnelle, l'importation de donnees externes et la redaction de requetes SQL avancees (sous-requetes, vues, fonctions d'agregation, etc.).



---------------------------------------------------------

Partie A - Creation de la base de donnees
-----------------------------------------
1. Creer la base de donnees VolsBD selon le diagramme fourni.  
2. Determiner les types de donnees adequats pour chaque colonne (a partir des fichiers CSV).  
3. Respecter les contraintes suivantes :
   - Table INSCRIPTION : la date d'inscription doit etre inferieure ou egale a la date actuelle.
   - Table VOL : le prix doit etre un entier compris entre 20 et 3000.
4. Importer les donnees des fichiers CSV avec la commande BULK INSERT.
   Exemple :
   BULK INSERT provinces
   FROM 'C:\\tmp\\vgProvinces.txt'
   WITH (
       FIELDTERMINATOR = '|',
       ROWTERMINATOR = '\\n',
       FIRSTROW = 2
   );

---------------------------------------------------------

Partie B - Requetes SQL
-----------------------

1. Ajouter un vol entre YVR et YQB avec des sous-requetes et la fonction SYSDATETIME().
2. Afficher le nombre d'inscriptions effectuees en 2020.
3. Afficher le nombre de vols uniques effectues en 2020.
4. Creer une vue VUE2 affichant les vols dont le prix est superieur a la moyenne et le nombre de places > 1500.
5. Creer une vue Vue2 (ou Vue3 selon la consigne) affichant pour chaque vol :
   - le nombre de places restantes,
   - le montant total paye par les clients,
   - le prix et le nombre maximum de places.
6. Afficher tous les circuits avec le code et le nom des aeroports de depart et d'arrivee.
7. Afficher les circuits qui n'ont aucun vol.
8. Afficher, pour chaque client, le montant total paye pour tous ses vols.
9. Creer une vue vue3 affichant les vols et la ville de depart (id_vol, no_circuit, code_depart, ville_depart, code_destination, date_depart).
10. Creer la table temporaire TMPtable3 et y inserer les vols qui partent de Paris dans le futur.
11. Lister les vols avec leur prix et leur classement (RANK()) du plus cher au moins cher.
12. Afficher pour chaque vol le code_depart, le prix, le prix moyen des vols de la ville de depart, et la duree maximale.
13. Calculer, pour chaque mois, le prix le plus bas des vols et la difference avec le mois precedent.
14. Lire le fichier pays5.json et mettre a jour la table PAYS en utilisant la commande MERGE (taux de change et monnaies).

---------------------------------------------------------

Technologies utilisees
----------------------
- SQL Server / T-SQL
- BULK INSERT et MERGE
- Vues, sous-requetes, fonctions d'agregation
- Manipulation de donnees CSV et JSON
- Visual Studio Code ou SSMS (SQL Server Management Studio)

---------------------------------------------------------

Remise finale
-------------
1. Livrer les fichiers :
   - Script de creation de la base (VolsBD_Create.sql)
   - Script d'importation (VolsBD_Import.sql)
   - Script des requetes (VolsBD_Queries.sql)
2. Compresser tous les fichiers dans un .zip et deposer sur LEA.

---------------------------------------------------------

Auteur
------
Cherif Ouattara - Etudiant AEC Programmation, bases de donnees et serveurs  
Cegep de Sainte-Foy  
GitHub : https://github.com/BoOm00001
LinkedIn : https://www.linkedin.com/in/cherif-ouattara/ 

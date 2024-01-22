
# Streaming_TD




## Installation

Pour commencer il faut installer POSTGRESQL au lien suivant:

    https://www.enterprisedb.com/downloads/postgres-postgresql-downloads


**obligatoire** 

Vous devez télécharger pgAdmin 4 directement depuis l'installateur de postgresql c'est une interface graphique pour postgresql

**Attention**

Mettre la langue francaise à l'installation sinon il peut avoir des erreurs dans les input de date

# Initialisation de la base


## pgadmin 

Ouvrer le serveur puis faites clic droit sur **Database** puis entrez le nom de votre base de donnée et valider

![plot](/img/create_db.png)

![plot](/img/create_db2.png)


## Création des tables

Récupèrer le fichier create_table.sql et lancer executé le dans leurs environnement respectifs

![plot](/img/run_query.png)

![plot](/img/open_file.png)

![plot](/img/execute.png)



### Syntaxe des tables

Nom de table : 

    Abréviation du nom de la base ici Streaming = SMG + underscore + Nom de la table
    Exemple : SMG_ACTOR

Nom des champs de table

    Un suffixe composé de la première lettre du nom de la base 
    + 2 premières lettres de la table exemple la table Actor donne SAC 
    + underscore
    + nom du champs
    Ce qui donne par exemple SAC_FIRSTNAME

### Insertion des données

Pour insérer les données dans la base executer le fichier 

    insertion.sql



### Requetes minimal 

#### 1

Les titres et dates de sortie des films du plus récent au plus ancien

```sql
SELECT 
    SMO_TITLE,
    SMO_RELEASEYEAR 
FROM 
    SMG_MOVIE 
ORDER BY 
    SMO_RELEASEYEAR 
DESC;
```

#### 2

les noms, prénoms et âges des acteurs/actrices de plus de 30 ans dans l'ordre alphabétique (prénom d'abord, puis nom)

```sql
SELECT 
	SAC_LASTNAME,
	SAC_FIRSTNAME,
	EXTRACT(YEAR FROM AGE(NOW(), SAC_BIRTHDATE)) AS AGE 
FROM 
	SMG_ACTOR
WHERE
	EXTRACT(YEAR FROM AGE(NOW(), SAC_BIRTHDATE))>30
ORDER BY
	SAC_FIRSTNAME,
	SAC_LASTNAME;

```

#### 3 

la liste des acteurs/actrices principaux pour un film donné

```sql
SELECT
	SAC_FIRSTNAME,
	SAC_LASTNAME
FROM 
	SMG_ACTOR
INNER JOIN 
	SMG_PERFORM 
ON 
	SMG_ACTOR.SAC_ACTORID = SMG_PERFORM.SPE_ACTORID
INNER JOIN 
	SMG_MOVIE 
ON 
	SMG_PERFORM.SPE_MOVIEID = SMG_MOVIE.SMO_MOVIEID
WHERE
	SPE_ISLEADROLE IS TRUE
AND
	SMO_TITLE = 'Chantilly Lace';
```

**Attention** Il est possible en changeant le nom du film qu'il n'est aucun acteur principal du à la génération aléatoire de données

#### 4 

la liste des films pour un acteur/actrice donné

```sql
SELECT
	SMO_TITLE
FROM 
	SMG_MOVIE
INNER JOIN 
	SMG_PERFORM 
ON 
	SMG_MOVIE.SMO_MOVIEID = SMG_PERFORM.SPE_MOVIEID
INNER JOIN 
	SMG_ACTOR
ON 
	SMG_PERFORM.SPE_ACTORID = SMG_ACTOR.SAC_ACTORID
WHERE
	SAC_FIRSTNAME = 'Dame'
AND
	SAC_LASTNAME = 'O''Looney'
```

**Attention** Il est possible en changeant le nom et prénom de l'acteur qu'il n'est aucun film du à la génération aléatoire de données

#### 5 

ajouter un film

```sql
insert into 
    SMG_Movie (SMO_TITLE, SMO_RELEASEYEAR, SMO_DURATION, SMO_DIRECTORID) 
values 
    ('WALLAH C MOI', 2023, '180 minutes', 418);
```

#### 6 

ajouter un acteur/actrice

```sql
INSERT INTO 
    SMG_Actor (SAC_FIRSTNAME, SAC_LASTNAME, SAC_BIRTHDATE) 
values 
    ('Théo', 'Duflos', '07/06/2001');
```
#### 7 

modifier un film

```sql
UPDATE 
	SMG_MOVIE
SET
	SMO_TITLE = 'KEBAB A 4 EUROS JE FONCE',
	SMO_RELEASEYEAR = 2023
WHERE 
	SMO_MOVIEID = 20;
```

#### 8 

supprimer un acteur/actrice

```sql
delete from 
    smg_actor 
where 
    sac_actorid = 18;

```

#### 9 

afficher les 3 derniers acteurs/actrices ajouté(e)s

```sql
insert into 
    SMG_Actor (SAC_FIRSTNAME, SAC_LASTNAME, SAC_BIRTHDATE) 
values 
    ('Jean', 'Michel', '26/1/1950');
insert into 
    SMG_Actor (SAC_FIRSTNAME, SAC_LASTNAME, SAC_BIRTHDATE) 
values 
    ('Crapaud', 'Clui', '3/3/1994');
insert into 
    SMG_Actor (SAC_FIRSTNAME, SAC_LASTNAME, SAC_BIRTHDATE) 
values 
    ('Ilest', 'DANSLARIVER', '19/12/1961');
select 
    * 
from 
    smg_actor 
order by 
    sac_datecrea 
desc 
limit 3;

```

#### 10 (Bonus)

La moyenne du nombre de films des acteurs/trices de plus de 50

```sql
SELECT
	avg(cnt)
	
FROM (
	SELECT 
		SAC_ACTORID,
		COUNT(SMO_MOVIEID) as cnt
	FROM
		SMG_MOVIE
	INNER JOIN 
		SMG_PERFORM
	ON
		SMG_MOVIE.SMO_MOVIEID = SMG_PERFORM.SPE_MOVIEID
	INNER JOIN 
		SMG_ACTOR
	ON
		SMG_PERFORM.SPE_ACTORID = SMG_ACTOR.SAC_ACTORID
	WHERE
		EXTRACT(YEAR FROM AGE(NOW(), SAC_BIRTHDATE))>50
	GROUP BY
		SAC_ACTORID
);
```

#### 11 (Bonus)

Le réalisateur ayant le plus de film mis en favoris et combien de ses films ont été mis en favoris.

```sql
SELECT
    SMO_DIRECTORID,
    MAX(number_director) AS max_number_director
FROM (
    SELECT 
        SMO_DIRECTORID,
        COUNT(SMO_DIRECTORID) as number_director
    FROM
        SMG_MOVIE
    INNER JOIN
        SMG_FAVORITE ON SMG_MOVIE.SMO_MOVIEID = SMG_FAVORITE.SFA_MOVIEID
    GROUP BY 
        SMO_DIRECTORID
) AS director_counts
GROUP BY
    SMO_DIRECTORID
ORDER BY
    max_number_director DESC
limit 1;
```

#### 12 (Bonus)

Les films qui ont plus d'acteurs que la moyenne des acteurs par film.

```sql
SELECT
	SMO_TITLE,
	COUNT(SPE_ACTORID) AS NOMBRE_ACTEUR
FROM
	SMG_MOVIE
INNER JOIN 
	SMG_PERFORM
ON
	SMG_MOVIE.SMO_MOVIEID = SMG_PERFORM.SPE_MOVIEID
GROUP BY 
	SMO_TITLE
HAVING
	COUNT(SPE_ACTORID) > (SELECT 
								AVG(cnt)
							FROM (
								SELECT 
									COUNT(SPE_ACTORID) as cnt
								FROM
									SMG_PERFORM
								group by 
									spe_movieid
								) 
						);
```

#### 13 (bonus)

Écrivez un script de transaction qui ajoute un nouveau film, puis l'ajoute aux films favoris d'un utilisateur spécifique, en s'assurant que les deux opérations réussissent ou échouent ensemble. (Astuce : Utilisez BEGIN TRANSACTION, COMMIT, et ROLLBACK)

```sql
DO $$
    DECLARE
        movieInsertedCount int;
BEGIN
    INSERT INTO SMG_MOVIE (smo_title, smo_duration, smo_releaseyear, smo_directorid)
    VALUES ('Rambo XIIII', '159 minutes', 2025, 65);

    INSERT INTO SMG_FAVORITE (sfa_userid,sfa_movieid) 
    VALUES (1,lastVal());

    select COUNT(*) INTO movieInsertedCount from SMG_FAVORITE where sfa_movieid =lastVal();

    IF movieInsertedCount = 0 THEN
        ROLLBACK;
    ELSE
        COMMIT;
    END IF;
END$$;
```
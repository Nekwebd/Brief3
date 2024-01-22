SELECT 
    SMO_TITLE,
    MO_RELEASEYEAR 
FROM 
    MG_MOVIE 
ORDER BY 
    MO_RELEASEYEAR 
DESC;

/***********************************************/
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

/******************************************************/

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

/******************************************************/
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

/*******************************************************/
INSERT INTO SMG_Movie (SMO_TITLE, SMO_RELEASEYEAR, SMO_DURATION, SMO_DIRECTORID) VALUES ('WALLAH C MOI', 2023, '180 minutes', 418);

/*******************************************************/
INSERT INTO SMG_Actor (SAC_FIRSTNAME, SAC_LASTNAME, SAC_BIRTHDATE) VALUES ('Théo', 'Duflos', '07/06/2001');

/*******************************************************/

UPDATE 
	SMG_MOVIE
SET
	SMO_TITLE = 'KEBAB A 4 EUROS JE FONCE',
	SMO_RELEASEYEAR = 2023
WHERE 
	SMO_MOVIEID = 807;

/*******************************************************/

DELETE FROM smg_actor WHERE sac_actorid = 18;

/*******************************************************/

INSERT INTO SMG_Actor (SAC_FIRSTNAME, SAC_LASTNAME, SAC_BIRTHDATE) VALUES ('Jean', 'Michel', '26/1/1950');
INSERT INTO SMG_Actor (SAC_FIRSTNAME, SAC_LASTNAME, SAC_BIRTHDATE) VALUES ('Crapaud', 'Clui', '3/3/1994');
INSERT INTO SMG_Actor (SAC_FIRSTNAME, SAC_LASTNAME, SAC_BIRTHDATE) VALUES ('Ilest', 'DANSLARIVER', '19/12/1961');
SELECT * FROM smg_actor ORDER BY sac_datecrea desc limit 3;

/*******************************************************/

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

/********************************************************/

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

/*********************************************************/

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
/*************************************************************/

DO $$
    DECLARE
        movieInsertedCount int;
BEGIN
    INSERT INTO SMG_MOVIE (smo_title, smo_duration, smo_releaseyear, smo_directorid)
    VALUES ('Rambo XIIII', '159 minutes', 2025, 65);

    INSERT INTO SMG_FAVORITE (sfa_userid,sfa_movieid) 
    VALUES (1,lastVal());

    SELECT COUNT(*) INTO movieInsertedCount FROM SMG_FAVORITE WHERE sfa_movieid =lastVal();

    IF movieInsertedCount = 0 THEN
        ROLLBACK;
    ELSE
        COMMIT;
    END IF;
END$$;

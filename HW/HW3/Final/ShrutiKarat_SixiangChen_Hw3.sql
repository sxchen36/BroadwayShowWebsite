HW-3
Sixiang Chen : schen97
Shruti Karat : kjayach1

/*Views*/
DROP VIEW IF EXISTS TotalPoints;
CREATE VIEW TotalPoints as
   SELECT Section, HW1, HW2a, HW2b, Midterm, HW3, FExam
   FROM Rawscores
   WHERE SSN = 0001
;

DROP VIEW IF EXISTS Weights;
CREATE VIEW Weights as
   SELECT Section, HW1, HW2a, HW2b, Midterm, HW3, FExam
   FROM Rawscores
   WHERE SSN = 0002
;

DROP VIEW IF EXISTS WtdPts;
CREATE VIEW WtdPts AS
SELECT (1/T.HW1)*W.HW1 as factor1, (1/T.HW2a)*W.HW2a as factor2a, (1/T.HW2b)*W.HW2b as factor2b, (1/T.Midterm)*W.Midterm as factorMid,(1/T.HW3)*W.HW3 as factor3,(1/T.FExam)*W.FExam as factorFExam
FROM TotalPoints T, Weights W
;


/*Query 1*/

DELIMITER $$
DROP PROCEDURE IF EXISTS ShowRawScores;
CREATE PROCEDURE ShowRawScores(IN ssn VARCHAR(10))
BEGIN
IF EXISTS (SELECT * FROM Rawscores R WHERE R.SSN = ssn) THEN            
   SELECT *
   FROM Rawscores
   WHERE Rawscores.SSN = ssn;
ELSE
   SELECT 'Incorrect SSN' as Error;
END IF;
END;
$$
DELIMITER ;


/*Query 2*/

DELIMITER $$
DROP PROCEDURE IF EXISTS ShowPercentages;
CREATE PROCEDURE ShowPercentages(IN ssn VARCHAR(10))
BEGIN
IF EXISTS (SELECT * FROM Rawscores R WHERE R.SSN = ssn) THEN 
   SELECT R.Fname, R.LName, (R.HW1/T.HW1)*100 AS HW1, (R.HW2a/T.HW2a)*100 AS HW2a, (R.HW2b/T.HW2b)*100 AS HW2b, (R.Midterm/T.Midterm)*100 AS Midterm, (R.HW3/T.HW3)*100 AS HW3, (R.FExam/T.FExam)*100 AS FExam
        FROM TotalPoints AS T, Rawscores AS R
        WHERE R.SSN = ssn;
   
   SELECT CONCAT('The cumulative course average for ',Ans.FName, ' ', Ans.LName, ' is ', Ans.CumAvg) as Answer
   FROM
   (SELECT  LName, FName, (R.HW1*W.factor1 + R.HW2a*W.factor2a + R.HW2b*W.factor2b + R.Midterm*W.factorMid + R.HW3*W.factor3 + R.FExam*W.factorFExam) as CumAvg
   FROM Rawscores R, WtdPts W
   WHERE R.SSN = ssn
   ) as Ans;
ELSE
   SELECT 'Incorrect SSN' as Error;
END IF;
END;
$$
DELIMITER ;

/*Query 3*/

DELIMITER $$
DROP PROCEDURE IF EXISTS AllRawScores;
CREATE PROCEDURE AllRawScores(IN password VARCHAR(15))
BEGIN
   IF EXISTS (SELECT * FROM Passwords WHERE password = CurPasswords) THEN
	(SELECT * 
	 FROM Rawscores 
	 WHERE SSN != '0001' AND SSN != '0002'
	 ORDER BY Section, LName, FName	 );
   ELSE 
	(SELECT 'Error: Incorrect Password');
   END IF;	
END;
$$
DELIMITER ;


/*Query 4*/

DELIMITER $$
DROP PROCEDURE IF EXISTS AllPercentages;
CREATE PROCEDURE AllPercentages(IN password VARCHAR(15))
BEGIN
   IF EXISTS (SELECT * FROM Passwords WHERE password = CurPasswords) THEN
	SELECT R.Fname, R.LName, R.Section, (R.HW1/T.HW1)*100 AS HW1, (R.HW2a/T.HW2a)*100 AS HW2a, (R.HW2b/T.HW2b)*100 AS HW2b, (R.Midterm/T.Midterm)*100 AS Midterm, (R.HW3/T.HW3)*100 AS HW3, (R.FExam/T.FExam)*100 AS FExam, (R.HW1*W.factor1 + R.HW2a*W.factor2a + R.HW2b*W.factor2b + R.Midterm*W.factorMid + R.HW3*W.factor3 + R.FExam*W.factorFExam) as WeightedAvg
        FROM TotalPoints AS T, Rawscores AS R, WtdPts W
        WHERE R.SSN != '0001' AND R.SSN != '0002'
	ORDER BY R.Section, WeightedAvg
	;   

   ELSE
        (SELECT 'Error: Incorrect Password');
   END IF;
END;
$$
DELIMITER ;


/*Query 5*/
DELIMITER $$
DROP PROCEDURE IF EXISTS Stats;
CREATE PROCEDURE Stats(In pwd VARCHAR(100))  -- Password should be entered using ''
BEGIN
   IF EXISTS ( SELECT * FROM Passwords AS P WHERE pwd = P.CurPasswords ) THEN 
       SELECT *
       FROM
          (
           SELECT R.SSN AS SSN, R.LName AS LName, R.FName AS FName, R.Section AS Section, (R.HW1/T.HW1)*100 AS HW1, (R.HW2a/T.HW2a)*100 AS HW2a, (R.HW2b/T.HW2b)*100 AS HW2b, (R.Midterm/T.Midterm)*100 AS Midterm, (R.HW3/T.HW3)*100 AS HW3, (R.FExam/T.FExam)*100 AS FExam, (R.HW1*W.HW1 + R.HW2a*W.HW2a + R.HW2b*W.HW2b + R.Midterm*W.Midterm + R.HW3*W.HW3 + R.FExam*W.FExam) AS WeightAvg
           FROM TotalPoints AS T, Rawscores AS R, WtdPts AS W
           WHERE R.SSN <> 0001 AND R.SSN <> 0002
          ) AS Temp
       ORDER BY Temp.Section, Temp.WeightAvg;

      SELECT AVG(A.HW1) AS HW1, AVG(A.HW2a) AS HW2a, AVG(A.HW2b) AS HW2b, AVG(A.Midterm) AS Midterm, AVG(A.HW3) AS HW3, AVG(A.FExam) AS FExam,'Mean' AS Statistic
       FROM
               (SELECT R.SSN AS SSN, R.LName AS LName, R.FName AS FName, R.Section AS Section, (R.HW1/T.HW1)*100 AS HW1, (R.HW2a/T.HW2a)*100 AS HW2a, (R.HW2b/T.HW2b)*100 AS HW2b, (R.Midterm/T.Midterm)*100 AS Midterm, (R.HW3/T.HW3)*100 AS HW3, (R.FExam/T.FExam)*100 AS FExam 
               FROM TotalPoints AS T, Rawscores AS R, WtdPts AS W
               WHERE R.SSN <> 0001 AND R.SSN <> 0002
              ) AS A;

       -- Min
       SELECT Min(A.HW1) AS HW1, Min(A.HW2a) AS HW2a, Min(A.HW2b) AS HW2b, Min(A.Midterm) AS Midterm, Min(A.HW3) AS HW3, Min(A.FExam) AS FExam,'Minimum' AS Statistic
       FROM
               (SELECT R.SSN AS SSN, R.LName AS LName, R.FName AS FName, R.Section AS Section, (R.HW1/T.HW1)*100 AS HW1, (R.HW2a/T.HW2a)*100 AS HW2a, (R.HW2b/T.HW2b)*100 AS HW2b, (R.Midterm/T.Midterm)*100 AS Midterm, (R.HW3/T.HW3)*100 AS HW3, (R.FExam/T.FExam)*100 AS FExam 
               FROM TotalPoints AS T, Rawscores AS R, WtdPts AS W
               WHERE R.SSN <> 0001 AND R.SSN <> 0002
              ) AS A;

       -- Max
       SELECT Max(A.HW1) AS HW1, Max(A.HW2a) AS HW2a, Max(A.HW2b) AS HW2b, Max(A.Midterm) AS Midterm, Max(A.HW3) AS HW3, Max(A.FExam) AS FExam,'Maximum' AS Statistic
       FROM
               (SELECT R.SSN AS SSN, R.LName AS LName, R.FName AS FName, R.Section AS Section, (R.HW1/T.HW1)*100 AS HW1, (R.HW2a/T.HW2a)*100 AS HW2a, (R.HW2b/T.HW2b)*100 AS HW2b, (R.Midterm/T.Midterm)*100 AS Midterm, (R.HW3/T.HW3)*100 AS HW3, (R.FExam/T.FExam)*100 AS FExam 
               FROM TotalPoints AS T, Rawscores AS R, WtdPts AS W
               WHERE R.SSN <> 0001 AND R.SSN <> 0002
              ) AS A;

       -- Standard Deviation
       SELECT STD(A.HW1) AS HW1, STD(A.HW2a) AS HW2a, STD(A.HW2b) AS HW2b, STD(A.Midterm) AS Midterm, STD(A.HW3) AS HW3, STD(A.FExam) AS FExam,'Std. Dev.' AS Statistic
       FROM
               (SELECT R.SSN AS SSN, R.LName AS LName, R.FName AS FName, R.Section AS Section, (R.HW1/T.HW1)*100 AS HW1, (R.HW2a/T.HW2a)*100 AS HW2a, (R.HW2b/T.HW2b)*100 AS HW2b, (R.Midterm/T.Midterm)*100 AS Midterm, (R.HW3/T.HW3)*100 AS HW3, (R.FExam/T.FExam)*100 AS FExam 
               FROM TotalPoints AS T, Rawscores AS R, WtdPts AS W
               WHERE R.SSN <> 0001 AND R.SSN <> 0002
              ) AS A;

   ELSE 
      (SELECT 'Wrong password!');
   END IF;
END;
$$
DELIMITER ;


/*For extra credit, we separated the sections 315 and 415*/
/*The query below does not always work, we think its because too many tables are being generated*/
DELIMITER $$
DROP PROCEDURE IF EXISTS Stats;
CREATE PROCEDURE Stats(IN password VARCHAR(15))
BEGIN
   IF EXISTS (SELECT * FROM Passwords WHERE password = CurPasswords) THEN
        SELECT R.Fname, R.LName, R.Section, (R.HW1/T.HW1)*100 AS HW1, (R.HW2a/T.HW2a)*100 AS HW2a, (R.HW2b/T.HW2b)*100 AS HW2b, (R.Midterm/T.Midterm)*100 AS Midterm, (R.HW3/T.HW3)*100 AS HW3, (R.FExam/T.FExam)*100 AS FExam, (R.HW1*W.factor1 + R.HW2a*W.factor2a + R.HW2b*W.factor2b + R.Midterm*W.factorMid + R.HW3*W.factor3 + R.FExam*W.factorFExam) as WeightedAvg
        FROM TotalPoints AS T, Rawscores AS R, WtdPts W
        WHERE R.SSN != '0001' AND R.SSN != '0002'
        ORDER BY R.Section, WeightedAvg
        ;

	SELECT Min.Section, min(Min.HW1) as Hw1, min(Min.HW2a) as Hw2a, min(Min.HW2b) as Hw2b, min(Min.Midterm) as Midterm, min(Min.HW3) as Hw3, min(Min.FExam) as FExam, 'Minimum' as Statistic
	FROM ( SELECT *
	       FROM ( SELECT R.Fname, R.LName, R.Section, (R.HW1/T.HW1)*100 AS HW1, (R.HW2a/T.HW2a)*100 AS HW2a, (R.HW2b/T.HW2b)*100 AS HW2b, (R.Midterm/T.Midterm)*100 AS Midterm, (R.HW3/T.HW3)*100 AS HW3, (R.FExam/T.FExam)*100 AS FExam
        		FROM TotalPoints AS T, Rawscores AS R, WtdPts W
        		WHERE R.SSN != '0001' AND R.SSN != '0002'
			) A

		) Min
	WHERE Min.Section = '315';

	SELECT Min.Section, min(Min.HW1) as Hw1, min(Min.HW2a) as Hw2a, min(Min.HW2b) as Hw2b, min(Min.Midterm) as Midterm, min(Min.HW3) as Hw3, min(Min.FExam) as FExam, 'Minimum' as Statistic
        FROM ( SELECT *               FROM ( SELECT R.Fname, R.LName, R.Section, (R.HW1/T.HW1)*100 AS HW1, (R.HW2a/T.HW2a)*100 AS HW2a, (R.HW2b/T.HW2b)*100 AS HW2b, (R.Midterm/T.Midterm)*100 AS Midterm, (R.HW3/T.HW3)*100 AS HW3, (R.FExam/T.FExam)*100 AS FExam
                        FROM TotalPoints AS T, Rawscores AS R, WtdPts W
                        WHERE R.SSN != '0001' AND R.SSN != '0002'
                        ) A

                ) Min
        WHERE Min.Section = '415';

	SELECT Min.Section, max(Min.HW1) as Hw1, max(Min.HW2a) as Hw2a, max(Min.HW2b) as Hw2b, max(Min.Midterm) as Midterm, max(Min.HW3) as Hw3, max(Min.FExam) as FExam, 'Maximum' as Statistic
        FROM ( SELECT *
               FROM ( SELECT R.Fname, R.LName, R.Section, (R.HW1/T.HW1)*100 AS HW1, (R.HW2a/T.HW2a)*100 AS HW2a, (R.HW2b/T.HW2b)*100 AS HW2b, (R.Midterm/T.Midterm)*100 AS Midterm, (R.HW3/T.HW3)*100 AS HW3, (R.FExam/T.FExam)*100 AS FExam
                        FROM TotalPoints AS T, Rawscores AS R, WtdPts W
                        WHERE R.SSN != '0001' AND R.SSN != '0002'
                        ) A

                ) Min
        WHERE Min.Section = '315';

	SELECT Min.Section, max(Min.HW1) as Hw1, max(Min.HW2a) as Hw2a, max(Min.HW2b) as Hw2b, max(Min.Midterm) as Midterm, max(Min.HW3) as Hw3, max(Min.FExam) as FExam, 'Maximum' as Statistic
        FROM ( SELECT *
               FROM ( SELECT R.Fname, R.LName, R.Section, (R.HW1/T.HW1)*100 AS HW1, (R.HW2a/T.HW2a)*100 AS HW2a, (R.HW2b/T.HW2b)*100 AS HW2b, (R.Midterm/T.Midterm)*100 AS Midterm, (R.HW3/T.HW3)*100 AS HW3, (R.FExam/T.FExam)*100 AS FExam
                        FROM TotalPoints AS T, Rawscores AS R, WtdPts W
                        WHERE R.SSN != '0001' AND R.SSN != '0002'
                        ) A

                ) Min
        WHERE Min.Section = '415';

	SELECT Min.Section, avg(Min.HW1) as Hw1, avg(Min.HW2a) as Hw2a, avg(Min.HW2b) as Hw2b, avg(Min.Midterm) as Midterm,avg(Min.HW3) as Hw3, avg(Min.FExam) as FExam, 'Mean' as Statistic
        FROM ( SELECT *
               FROM ( SELECT R.Fname, R.LName, R.Section, (R.HW1/T.HW1)*100 AS HW1, (R.HW2a/T.HW2a)*100 AS HW2a, (R.HW2b/T.HW2b)*100 AS HW2b, (R.Midterm/T.Midterm)*100 AS Midterm, (R.HW3/T.HW3)*100 AS HW3, (R.FExam/T.FExam)*100 AS FExam
                        FROM TotalPoints AS T, Rawscores AS R, WtdPts W
                        WHERE R.SSN != '0001' AND R.SSN != '0002'
                        ) A

                ) Min
        WHERE Min.Section = '315';

	SELECT Min.Section, avg(Min.HW1) as Hw1, avg(Min.HW2a) as Hw2a, avg(Min.HW2b) as Hw2b, avg(Min.Midterm) as Midterm,avg(Min.HW3) as Hw3, avg(Min.FExam) as FExam, 'Mean' as Statistic
        FROM ( SELECT *
               FROM ( SELECT R.Fname, R.LName, R.Section, (R.HW1/T.HW1)*100 AS HW1, (R.HW2a/T.HW2a)*100 AS HW2a, (R.HW2b/T.HW2b)*100 AS HW2b, (R.Midterm/T.Midterm)*100 AS Midterm, (R.HW3/T.HW3)*100 AS HW3, (R.FExam/T.FExam)*100 AS FExam
                        FROM TotalPoints AS T, Rawscores AS R, WtdPts W
                        WHERE R.SSN != '0001' AND R.SSN != '0002'
                        ) A

                ) Min
        WHERE Min.Section = '415';

	SELECT Min.Section, std(Min.HW1) as Hw1, std(Min.HW2a) as Hw2a, std(Min.HW2b) as Hw2b, std(Min.Midterm) as Midterm,std(Min.HW3) as Hw3, std(Min.FExam) as FExam, 'Std.Dev' as Statistic
        FROM ( SELECT *
               FROM ( SELECT R.Fname, R.LName, R.Section, (R.HW1/T.HW1)*100 AS HW1, (R.HW2a/T.HW2a)*100 AS HW2a, (R.HW2b/T.HW2b)*100 AS HW2b, (R.Midterm/T.Midterm)*100 AS Midterm, (R.HW3/T.HW3)*100 AS HW3, (R.FExam/T.FExam)*100 AS FExam
                        FROM TotalPoints AS T, Rawscores AS R, WtdPts W
                        WHERE R.SSN != '0001' AND R.SSN != '0002'
                        ) A

                ) Min
        WHERE Min.Section = '315';

	SELECT Min.Section, std(Min.HW1) as Hw1, std(Min.HW2a) as Hw2a, std(Min.HW2b) as Hw2b, std(Min.Midterm) as Midterm,std(Min.HW3) as Hw3, std(Min.FExam) as FExam, 'Std.Dev' as Statistic
        FROM ( SELECT *
               FROM ( SELECT R.Fname, R.LName, R.Section, (R.HW1/T.HW1)*100 AS HW1, (R.HW2a/T.HW2a)*100 AS HW2a, (R.HW2b/T.HW2b)*100 AS HW2b, (R.Midterm/T.Midterm)*100 AS Midterm, (R.HW3/T.HW3)*100 AS HW3, (R.FExam/T.FExam)*100 AS FExam
                        FROM TotalPoints AS T, Rawscores AS R, WtdPts W
                        WHERE R.SSN != '0001' AND R.SSN != '0002'
                        ) A

                ) Min
        WHERE Min.Section = '415';


   ELSE
        (SELECT 'Error: Incorrect Password');
   END IF;
END;
$$
DELIMITER ;

/*Query 6*/
/*When Password and SSN are correct the 'Before' state of the record is shown even if the Assignment is incorrect. However, it does generate an error message as well saying the Asignment name is wrong*/

DELIMITER $$
DROP PROCEDURE IF EXISTS ChangeScores;
CREATE PROCEDURE ChangeScores(IN password VARCHAR(15), IN ssn VARCHAR(15), IN asst VARCHAR(10), IN newScore INT)
BEGIN
   IF NOT EXISTS(SELECT * FROM Rawscores R WHERE R.SSN = ssn) THEN
        SELECT 'Invalid SSN' as Error;
   ELSEIF NOT EXISTS (SELECT * FROM Passwords WHERE password = CurPasswords) THEN
	SELECT 'Invalid Password' as Error;
   ELSEIF newScore < 0 THEN
	SELECT 'Invalid score' as Error;
   ELSE
        SELECT 'Before' as State, R.Hw1, R.Hw2a, R.Hw2b, R.Midterm, R.Hw3, R.FExam
        FROM Rawscores R
        WHERE R.SSN = ssn;

        IF asst LIKE 'HW1' THEN
                UPDATE Rawscores
                SET HW1 = newScore
                WHERE Rawscores.SSN = ssn;
                SELECT 'After' as State, R.Hw1, R.Hw2a, R.Hw2b, R.Midterm, R.Hw3, R.FExam
                FROM Rawscores R
                WHERE R.SSN = ssn;
        ELSEIF asst LIKE 'HW2a' THEN
                UPDATE Rawscores
                SET HW2a = newScore
                WHERE Rawscores.SSN = ssn;
                SELECT 'After' as State, R.Hw1, R.Hw2a, R.Hw2b, R.Midterm, R.Hw3, R.FExam
                FROM Rawscores R
                WHERE R.SSN = ssn;
        ELSEIF asst LIKE 'HW2b' THEN
                UPDATE Rawscores
                SET HW2b = newScore
                WHERE Rawscores.SSN = ssn;
                SELECT 'After' as State, R.Hw1, R.Hw2a, R.Hw2b, R.Midterm, R.Hw3, R.FExam
                FROM Rawscores R
                WHERE R.SSN = ssn;
        ELSEIF asst LIKE 'HW3' THEN
                UPDATE Rawscores
                SET HW3 = newScore
                WHERE Rawscores.SSN = ssn;
                SELECT 'After' as State, R.Hw1, R.Hw2a, R.Hw2b, R.Midterm, R.Hw3, R.FExam
                FROM Rawscores R
                WHERE R.SSN = ssn;
        ELSEIF asst LIKE 'Midterm' THEN
                UPDATE Rawscores
                SET Midterm = newScore
                WHERE Rawscores.SSN = ssn;
                SELECT 'After' as State, R.Hw1, R.Hw2a, R.Hw2b, R.Midterm, R.Hw3, R.FExam
                FROM Rawscores R
                WHERE R.SSN = ssn;
        ELSEIF asst LIKE 'FExam' THEN
                UPDATE Rawscores
                SET FExam = newScore
                WHERE Rawscores.SSN = ssn;
                SELECT 'After' as State, R.Hw1, R.Hw2a, R.Hw2b, R.Midterm, R.Hw3, R.FExam
                FROM Rawscores R
                WHERE R.SSN = ssn;
        ELSE
                SELECT 'Invalid Assignment Name' as Error;
        END IF;
   END IF;
END;
$$
DELIMITER ;



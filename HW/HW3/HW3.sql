


DROP VIEW IF EXISTS TotalPoints;
CREATE VIEW TotalPoints AS 
  SELECT * FROM Rawscores WHERE SSN = 0001;
DROP VIEW IF EXISTS Weights;
CREATE VIEW Weights AS 
  SELECT * FROM Rawscores WHERE SSN = 0002;

-- Q1

DELIMITER $$
DROP PROCEDURE IF EXISTS ShowRowScores;
CREATE PROCEDURE ShowRowScores (IN n1 VARCHAR(10))
BEGIN 
    SELECT *
    FROM Rawscores
    WHERE SSN = n1;
END;
$$
DELIMITER ;
-- Call ShowRowScores(9176);

-- Q2
DROP VIEW IF EXISTS WtdPts;
CREATE VIEW WtdPts AS
SELECT (1/T.HW1)*W.HW1 AS HW1, (1/T.HW2a)*W.HW2a AS HW2a,(1/T.HW2b)*W.HW2b AS HW2b, (1/T.Midterm)*W.Midterm AS Midterm, (1/T.HW3)*W.HW3 AS HW3, (1/T.FExam)*W.FExam AS FExam
FROM TotalPoints AS T, Weights AS W;

DELIMITER $$
DROP PROCEDURE IF EXISTS ShowPercentages;
CREATE PROCEDURE ShowPercentages(IN n2 VARCHAR(10))
BEGIN
   IF EXISTS ( SELECT * FROM Rawscores AS R WHERE n2 = R.SSN ) THEN
        SELECT R.SSN AS SSN, R.LName AS LName, R.FName AS FName, R.Section AS Section, (R.HW1/T.HW1)*100 AS HW1, (R.HW2a/T.HW2a)*100 AS HW2a, (R.HW2b/T.HW2b)*100 AS HW2b, (R.Midterm/T.Midterm)*100 AS Midterm, (R.HW3/T.HW3)*100 AS HW3, (R.FExam/T.FExam)*100 AS FExam
        FROM TotalPoints AS T, Rawscores AS R
        WHERE R.SSN = n2;

        SELECT CONCAT('The cumulative course average for ',FName,' ',LName,' is ', CumAvg) AS WeightAvg
        FROM (
        SELECT R.LName As LName, R.FName AS FName, (R.HW1*W.HW1 + R.HW2a*W.HW2a + R.HW2b*W.HW2b + R.Midterm*W.Midterm + R.HW3*W.HW3 + R.FExam*W.FExam) AS CumAvg
        FROM Rawscores AS R, WtdPts AS W
        WHERE R.SSN = n2
        ) AS Temp;
    ELSE 
      (SELECT 'Wrong SSN!');
   END IF;
END;
$$
DELIMITER ;
-- Call ShowPercentages(9176);



--Q3
DELIMITER $$
DROP PROCEDURE IF EXISTS AllRawScores;
CREATE PROCEDURE AllRawScores(In pwd VARCHAR(100))  -- Password should be entered using ''
BEGIN
   IF EXISTS ( SELECT * FROM Passwords AS P WHERE pwd = P.CurPasswords ) THEN 
      ( 
       SELECT *
       FROM
          (SELECT *
          FROM Rawscores AS R
          WHERE R.SSN <> 0001 AND R.SSN <> 0002) AS T
       ORDER BY T.Section, T.LName, T.FName
       );
   ELSE 
      (SELECT 'Wrong password!');
   END IF;
END;
$$
DELIMITER ;

-- Q4
DELIMITER $$
DROP PROCEDURE IF EXISTS AllPercentages;
CREATE PROCEDURE AllPercentages(In pwd VARCHAR(100))  -- Password should be entered using ''
BEGIN
   IF EXISTS ( SELECT * FROM Passwords AS P WHERE pwd = P.CurPasswords ) THEN 
      (
       SELECT *
       FROM
          (
           SELECT R.SSN AS SSN, R.LName AS LName, R.FName AS FName, R.Section AS Section, (R.HW1/T.HW1)*100 AS HW1, (R.HW2a/T.HW2a)*100 AS HW2a, (R.HW2b/T.HW2b)*100 AS HW2b, (R.Midterm/T.Midterm)*100 AS Midterm, (R.HW3/T.HW3)*100 AS HW3, (R.FExam/T.FExam)*100 AS FExam, (R.HW1*W.HW1 + R.HW2a*W.HW2a + R.HW2b*W.HW2b + R.Midterm*W.Midterm + R.HW3*W.HW3 + R.FExam*W.FExam) AS WeightAvg
           FROM TotalPoints AS T, Rawscores AS R, WtdPts AS W
           WHERE R.SSN <> 0001 AND R.SSN <> 0002
          ) AS Temp
       ORDER BY Temp.Section, Temp.WeightAvg
       );
   ELSE 
      (SELECT 'Wrong password!');
   END IF;
END;
$$
DELIMITER ;

-- Q5
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

      SELECT AVG(A.HW1) AS HW1, AVG(A.HW2a) AS HW2a, AVG(A.HW2b) AS HW2b, AVG(A.Midterm) AS Midterm, AVG(A.HW3) AS HW3, AVG(A.FExam) AS FExam,'315 Mean' AS Statistic
       FROM
               (SELECT R.SSN AS SSN, R.LName AS LName, R.FName AS FName, R.Section AS Section, (R.HW1/T.HW1)*100 AS HW1, (R.HW2a/T.HW2a)*100 AS HW2a, (R.HW2b/T.HW2b)*100 AS HW2b, (R.Midterm/T.Midterm)*100 AS Midterm, (R.HW3/T.HW3)*100 AS HW3, (R.FExam/T.FExam)*100 AS FExam 
               FROM TotalPoints AS T, Rawscores AS R, WtdPts AS W
               WHERE R.SSN <> 0001 AND R.SSN <> 0002
              ) AS A
        WHERE A.Section=315;

       
       SELECT Avg(A.HW1) AS HW1, Avg(A.HW2a) AS HW2a, Avg(A.HW2b) AS HW2b, Avg(A.Midterm) AS Midterm, Avg(A.HW3) AS HW3, Avg(A.FExam) AS FExam,'415 Mean' AS Statistic
       FROM
               (SELECT R.SSN AS SSN, R.LName AS LName, R.FName AS FName, R.Section AS Section, (R.HW1/T.HW1)*100 AS HW1, (R.HW2a/T.HW2a)*100 AS HW2a, (R.HW2b/T.HW2b)*100 AS HW2b, (R.Midterm/T.Midterm)*100 AS Midterm, (R.HW3/T.HW3)*100 AS HW3, (R.FExam/T.FExam)*100 AS FExam 
               FROM TotalPoints AS T, Rawscores AS R, WtdPts AS W
               WHERE R.SSN <> 0001 AND R.SSN <> 0002
              ) AS A
        WHERE A.Section=415;
       -- Min
       SELECT Min(A.HW1) AS HW1, Min(A.HW2a) AS HW2a, Min(A.HW2b) AS HW2b, Min(A.Midterm) AS Midterm, Min(A.HW3) AS HW3, Min(A.FExam) AS FExam,'315 Minimum' AS Statistic
       FROM
               (SELECT R.SSN AS SSN, R.LName AS LName, R.FName AS FName, R.Section AS Section, (R.HW1/T.HW1)*100 AS HW1, (R.HW2a/T.HW2a)*100 AS HW2a, (R.HW2b/T.HW2b)*100 AS HW2b, (R.Midterm/T.Midterm)*100 AS Midterm, (R.HW3/T.HW3)*100 AS HW3, (R.FExam/T.FExam)*100 AS FExam 
               FROM TotalPoints AS T, Rawscores AS R, WtdPts AS W
               WHERE R.SSN <> 0001 AND R.SSN <> 0002
              ) AS A
        WHERE A.Section=315;

       SELECT Min(A.HW1) AS HW1, Min(A.HW2a) AS HW2a, Min(A.HW2b) AS HW2b, Min(A.Midterm) AS Midterm, Min(A.HW3) AS HW3, Min(A.FExam) AS FExam,'415 Minimum' AS Statistic
       FROM
               (SELECT R.SSN AS SSN, R.LName AS LName, R.FName AS FName, R.Section AS Section, (R.HW1/T.HW1)*100 AS HW1, (R.HW2a/T.HW2a)*100 AS HW2a, (R.HW2b/T.HW2b)*100 AS HW2b, (R.Midterm/T.Midterm)*100 AS Midterm, (R.HW3/T.HW3)*100 AS HW3, (R.FExam/T.FExam)*100 AS FExam 
               FROM TotalPoints AS T, Rawscores AS R, WtdPts AS W
               WHERE R.SSN <> 0001 AND R.SSN <> 0002
              ) AS A
        WHERE A.Section=415;
       -- Max
       SELECT Max(A.HW1) AS HW1, Max(A.HW2a) AS HW2a, Max(A.HW2b) AS HW2b, Max(A.Midterm) AS Midterm, Max(A.HW3) AS HW3, Max(A.FExam) AS FExam,'315 Maximum' AS Statistic
       FROM
               (SELECT R.SSN AS SSN, R.LName AS LName, R.FName AS FName, R.Section AS Section, (R.HW1/T.HW1)*100 AS HW1, (R.HW2a/T.HW2a)*100 AS HW2a, (R.HW2b/T.HW2b)*100 AS HW2b, (R.Midterm/T.Midterm)*100 AS Midterm, (R.HW3/T.HW3)*100 AS HW3, (R.FExam/T.FExam)*100 AS FExam 
               FROM TotalPoints AS T, Rawscores AS R, WtdPts AS W
               WHERE R.SSN <> 0001 AND R.SSN <> 0002
              ) AS A
        WHERE A.Section=315;

       SELECT Max(A.HW1) AS HW1, Max(A.HW2a) AS HW2a, Max(A.HW2b) AS HW2b, Max(A.Midterm) AS Midterm, Max(A.HW3) AS HW3, Max(A.FExam) AS FExam,'415 Maximum' AS Statistic
       FROM
               (SELECT R.SSN AS SSN, R.LName AS LName, R.FName AS FName, R.Section AS Section, (R.HW1/T.HW1)*100 AS HW1, (R.HW2a/T.HW2a)*100 AS HW2a, (R.HW2b/T.HW2b)*100 AS HW2b, (R.Midterm/T.Midterm)*100 AS Midterm, (R.HW3/T.HW3)*100 AS HW3, (R.FExam/T.FExam)*100 AS FExam 
               FROM TotalPoints AS T, Rawscores AS R, WtdPts AS W
               WHERE R.SSN <> 0001 AND R.SSN <> 0002
              ) AS A
        WHERE A.Section=415;
       -- Standard Deviation
       SELECT STD(A.HW1) AS HW1, STD(A.HW2a) AS HW2a, STD(A.HW2b) AS HW2b, STD(A.Midterm) AS Midterm, STD(A.HW3) AS HW3, STD(A.FExam) AS FExam,'315 Std. Dev.' AS Statistic
       FROM
               (SELECT R.SSN AS SSN, R.LName AS LName, R.FName AS FName, R.Section AS Section, (R.HW1/T.HW1)*100 AS HW1, (R.HW2a/T.HW2a)*100 AS HW2a, (R.HW2b/T.HW2b)*100 AS HW2b, (R.Midterm/T.Midterm)*100 AS Midterm, (R.HW3/T.HW3)*100 AS HW3, (R.FExam/T.FExam)*100 AS FExam 
               FROM TotalPoints AS T, Rawscores AS R, WtdPts AS W
               WHERE R.SSN <> 0001 AND R.SSN <> 0002
              ) AS A
        WHERE A.Section=315;

       SELECT STD(A.HW1) AS HW1, STD(A.HW2a) AS HW2a, STD(A.HW2b) AS HW2b, STD(A.Midterm) AS Midterm, STD(A.HW3) AS HW3, STD(A.FExam) AS FExam,'415 Std. Dev.' AS Statistic
       FROM
               (SELECT R.SSN AS SSN, R.LName AS LName, R.FName AS FName, R.Section AS Section, (R.HW1/T.HW1)*100 AS HW1, (R.HW2a/T.HW2a)*100 AS HW2a, (R.HW2b/T.HW2b)*100 AS HW2b, (R.Midterm/T.Midterm)*100 AS Midterm, (R.HW3/T.HW3)*100 AS HW3, (R.FExam/T.FExam)*100 AS FExam 
               FROM TotalPoints AS T, Rawscores AS R, WtdPts AS W
               WHERE R.SSN <> 0001 AND R.SSN <> 0002
              ) AS A
        WHERE A.Section=415;
   ELSE 
      (SELECT 'Wrong password!');
   END IF;
END;
$$
DELIMITER ;

/*Query 6*/
DELIMITER $$
DROP PROCEDURE IF EXISTS ChangeScores;
CREATE PROCEDURE ChangeScores(IN password VARCHAR(15), IN ssn VARCHAR(15), IN asst VARCHAR(10), IN newScore INT)
BEGIN
   IF EXISTS (SELECT * FROM Passwords WHERE password = CurPasswords) THEN
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
                SELECT 'Error: Incorrect Assignment Name';
        END IF;
   ELSE
        (SELECT 'Error: Incorrect Password');
   END IF;
END;
$$
DELIMITER ;




DELIMITER $$
DROP PROCEDURE IF EXISTS Stats;
CREATE PROCEDURE Stats(In pwd VARCHAR(100))
BEGIN
   IF EXISTS ( SELECT * FROM Passwords AS P WHERE pwd = P.CurPasswords ) THEN 
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
      SELECT 'Wrong password!';
   END IF;
END;
$$
DELIMITER ;

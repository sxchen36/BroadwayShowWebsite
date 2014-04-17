--  1 
SELECT fname, lname, S1.major, age
FROM Student AS S1 INNER JOIN
     (SELECT major AS major, min(age) AS Youngest_Age
      FROM Student
      GROUP BY major) AS S2 ON S1.age = S2.Youngest_Age
WHERE S1.major = S2.major;

--  2. Skip


--  3.
SELECT S.stuid, fname, lname, major, sex, grade
FROM Student AS S INNER JOIN Enrolled_in AS E ON S.stuid = E.stuid
WHERE NOT EXISTS (
    SELECT StuID
    FROM Enrolled_in AS E1 INNER JOIN Course AS C ON E1.cid = C.cid
    WHERE C.cname= 'Algorithms I' AND
    E1.stuid NOT IN (
        SELECT L.WhoIsLiked
        FROM Likes AS L
        WHERE L.wholikes = S.stuid));


--  4.
SELECT C1.cname, S1.fname, S1.lname, S1.major, E1.grade, S2.fname, S2.lname, S2.major, E2.grade
FROM Student AS S1 
INNER JOIN Loves AS L1 ON S1.stuid = L1.wholoves 
INNER JOIN Enrolled_in AS E1 ON S1.stuid = E1.stuid
INNER JOIN Course AS C1 ON E1.cid = C1.cid
INNER JOIN Student AS S2 ON S2.stuid = L1.whoisloved
INNER JOIN Enrolled_in AS E2 ON S2.stuid = E2.stuid
INNER JOIN Course AS C2 ON E2.cid = C2.cid
INNER JOIN Loves AS L2 ON S2.stuid = L2.wholoves
WHERE L2.whoisloved = L1.wholoves AND C1.cid = C2.cid;

--  5.
SELECT lname, T
FROM (SELECT lname, COUNT(stuid) AS T
  FROM Student
  WHERE sex = 'F'
  GROUP BY lname) AS A1
ORDER BY T DESC LIMIT 0,1;

--  6.
SELECT S1.fname as Name1F, S1.lname as Name1L, S2.fname as Name2F, S2.lname as Name2L, S3.fname as Name3F, S3.lname as Name3L
FROM Student AS S1 
INNER JOIN Loves AS L1 ON S1.stuid = L1.wholoves 
INNER JOIN Student AS S2 ON S2.stuid = L1.whoisloved
INNER JOIN Loves AS L2 ON S2.stuid = L2.wholoves
INNER JOIN Student AS S3 ON S3.stuid = L2.whoisloved
INNER JOIN Loves AS L3 ON S3.stuid = L3.wholoves
WHERE L3.whoisloved = L1.wholoves;

--  7 
SELECT fname, lname, S1.major, age
FROM Student AS S1 INNER JOIN
     (SELECT major AS major, min(age) AS Youngest_Age
      FROM Student
      GROUP BY major) AS S2 ON S1.age = S2.Youngest_Age
WHERE S1.major = S2.major;

--  8.
SELECT fname, T
FROM (SELECT fname, COUNT(stuid) AS T
  FROM Student
  WHERE Sex = 'F'
  GROUP BY fname) AS A1
ORDER BY T DESC LIMIT 0,1;

--  9.
SELECT DISTINCT fname, lname, major, advisor
FROM Student AS S0 INNER JOIN Enrolled_in AS E0 ON S0.stuid = E0.stuid
                   INNER JOIN (SELECT AVG(age) AS avgAge, E.cid
                               FROM Student AS S INNER JOIN Enrolled_in AS E ON S.stuid= E.stuid
                               GROUP BY E.cid) AS T1
                   ON E0.cid = T1.cid
WHERE S0.age < T1.avgAge;

--  10.
SELECT T2.dname, T2.C2
FROM  (SELECT D1.dname, COUNT(S1.stuid) AS C1
      FROM Student AS S1 INNER JOIN Department AS D1 ON S1.major = D1.dno INNER JOIN Minor_in AS M1 ON S1.stuid = M1.stuid INNER JOIN Department AS D11 ON D11.dno = M1.dno
      WHERE (D1.dname = 'Computer Science' OR D1.dname = 'Mathematical Sciences')
      GROUP BY M1.dno
      ORDER BY C1 DESC LIMIT 0,1) AS T1 
      INNER JOIN 
      (SELECT D2.dname, COUNT(S2.stuid) AS C2
      FROM Student AS S2 INNER JOIN Department AS D2 ON S2.major = D2.dno INNER JOIN Minor_in AS M2 ON S2.stuid = M2.stuid INNER JOIN Department AS D22 ON D22.dno = M2.dno
      WHERE (D2.dname = 'Computer Science' OR D2.dname = 'Mathematical Sciences')
      GROUP BY M2.dno
      ) AS T2 
      ON T1.C1 = T2.C2;

--  11.
SELECT DISTINCT S1.stuid AS Name1, S2.stuid AS Name2
FROM Student AS S1 INNER JOIN Preferences AS P1 ON S1.stuid= P1.stuid INNER JOIN Lives_in AS L1 ON L1.stuid = S1.stuid
                   INNER JOIN Lives_in AS L2 ON L2.dormid = L1.dormid AND L2.room_number = L1.room_number
                   INNER JOIN Student AS S2 ON S2.stuid = L2.stuid
                   INNER JOIN Preferences AS P2 ON P2.stuid = S2.stuid
WHERE ((P1.SleepHabits <> P2.SleepHabits or
       P1.MusicType <> P2.MusicType) and
       P1.stuid > P2.stuid) or
      (P1.Smoking = 'Yes' and P2.Smoking = 'no-accept');

--  12.
SELECT DISTINCT fname, lname 
FROM 
  (SELECT S.stuid, SUM(gradepoint)/COUNT(E.stuid) AS GPA
  FROM Student AS S, Enrolled_in AS E, Gradeconversion AS GC
  WHERE S.stuid = E.stuid and E.grade = GC.lettergrade
  GROUP BY S.stuid
  HAVING GPA >= 3.3) AS T1 
  INNER JOIN Student ON T1.stuid = Student.stuid 
  INNER JOIN Enrolled_in ON Student.stuid = Enrolled_in.stuid
  WHERE Grade = 'A';

-- 14.
SELECT T1.fname, T1.lname, T1.PeopleTheyLike, T2.PeopleLikeThem, (T1.PeopleTheyLike - T2.PeopleLikeThem) AS difference
FROM
  (SELECT S1.fname AS fname, S1.lname AS lname, COUNT(L1.whoisliked) AS PeopleTheyLike
  FROM Student AS S1 INNER JOIN Likes AS L1 ON S1.stuid = L1.wholikes
  GROUP BY S1.stuid) AS T1
  INNER JOIN
  (SELECT S2.fname AS fname, S2.lname AS lname, COUNT(L2.wholikes) AS PeopleLikeThem
  FROM Student AS S2 INNER JOIN Likes AS L2 ON S2.stuid = L2.whoisliked
  GROUP BY S2.stuid) AS T2
  ON T1.fname = T2.fname and T1.lname = T2.lname;


--  16.
SELECT fname, lname, age, major
FROM Student
WHERE StuID NOT IN (
    SELECT StuID
    FROM Lives_in );

--  17. No Parent Table exist. Skip

--  18.
SELECT DISTINCT T1.fname, T1.lname, T1.sex 
FROM
(SELECT fname, lname, sex
FROM Student AS S INNER JOIN Enrolled_in AS E ON S.stuid = E.stuid INNER JOIN Course AS C ON E.cid = C.cid
WHERE C.cid = '600.315' or C.cid = '600.415') AS T1
INNER JOIN
(SELECT fname, lname, sex
FROM Student AS S INNER JOIN Enrolled_in AS E ON S.stuid = E.stuid INNER JOIN Course AS C ON E.cid = C.cid
WHERE C.cid LIKE '600.1%' OR C.cid LIKE '600.2%') AS T2
ON T1.fname = T2.fname AND T1.lname= T2.lname AND T1.sex=T2.sex;
      
-- 19.
SELECT F.fname, F.lname, COUNT(S.stuid) AS Enrollment
FROM Faculty AS F INNER JOIN Course AS C ON F.facid = C.instructor
                  INNER JOIN Member_of AS M ON F.facid = M.facid
                  INNER JOIN Department AS D ON M.dno = D.dno
                  INNER JOIN Enrolled_in AS E ON E.cid = C.cid
                  INNER JOIN Student AS S ON S.stuid = E.stuid
WHERE M.appt_type = 'Primary' and D.DName = 'Computer Science'
GROUP BY F.fname, F.lname
ORDER BY Enrollment DESC;


-- 20.
SELECT S.fname, S.lname, S.advisor, SUM(C.credits) AS totalCredit
FROM Student AS S INNER JOIN Enrolled_in AS E ON S.stuid = E.stuid
                  INNER JOIN Course AS C ON C.cid = E.cid
GROUP BY S.fname, S.lname, S.advisor
HAVING totalCredit > (
 SELECT SUM(totalCredit)/COUNT(T.stuid)
 FROM (
   SELECT S.stuid, SUM(C.credits) AS totalCredit
   FROM Student AS S INNER JOIN Enrolled_in AS E ON S.stuid = E.stuid
                     INNER JOIN Course AS C ON C.cid = E.cid
   GROUP BY S.stuid) AS T);

-- 21.
SELECT S.fname, S.lname, S.age
FROM Student AS S
WHERE S.age - 
  (SELECT STD(age)
   FROM Student) >
  (SELECT SUM(S1.age)/COUNT(S1.stuid)
  FROM Student AS S1);

-- 22. 
SELECT S.fname, S.lname, S.age
FROM Student AS S
  INNER JOIN Minor_in AS M ON S.stuid= M.stuid
  INNER JOIN Enrolled_in AS E ON E.stuid = S.stuid
  INNER JOIN Course AS C ON E.cid = C.cid
  INNER JOIN Faculty AS F ON F.facid = C.Instructor
  INNER JOIN Member_of AS Mem ON Mem.facid = F.facid
  INNER JOIN Department AS D ON Mem.dno = D.dno
  INNER JOIN Department AS DS ON DS.dno = S.major
WHERE
  S.sex = 'F' AND
  DS.division = 'EN'AND
  F.sex = 'F' AND
  Mem.appt_type = 'Primary' AND
  D.division = 'EN';

-- 23.Correct
SELECT S.fname, S.lname, S.stuid
FROM Student AS S
WHERE NOT EXISTS ( SELECT C.cid
                   FROM Course AS C INNER JOIN Faculty AS F ON C.Instructor = F.facid
                   WHERE F.fname = 'Paul' AND F.lname= 'Smolensky' AND
                         C.cid NOT IN ( SELECT E.cid
                                        FROM Enrolled_in AS E
                                        WHERE S.stuid = E.stuid));

-- 24. 
SELECT DISTINCT S.fname, S.lname, S.stuid
FROM Student AS S INNER JOIN Enrolled_in AS E ON S.stuid = E.stuid
WHERE E.cid IN (
 SELECT ET.cid
 FROM 
   (SELECT S0.stuid 
   FROM Student AS S0 INNER JOIN Enrolled_in AS E0 ON S0.stuid = E0.stuid
   WHERE E0.cid IN (SELECT EL.cid
                   FROM Student AS SL INNER JOIN Enrolled_in AS EL ON SL.stuid = EL.stuid
                   WHERE SL.fname = 'Linda' AND SL.lname = 'Smith')) AS T1
   INNER JOIN
   Enrolled_in AS ET ON T1.stuid = ET.stuid
 ) AND S.fname <> 'Linda' AND S.lname <> 'Smith';


-- 25.
SELECT T1.cname, T1.instructor, T1.AAbove, T2.EnrollNum, T1.AAbove/T2.EnrollNum
FROM
  (SELECT C.cid, C.cname, C.instructor, COUNT(E.grade) AS AAbove
   FROM Student AS S INNER JOIN Enrolled_in AS E ON S.stuid = E.stuid
                  INNER JOIN Course AS C ON C.cid = E.cid
   WHERE E.grade = 'A' OR E.grade = 'A+' OR E.grade = 'A-' 
   GROUP BY C.cid, C.cname, C.instructor) AS T1
  INNER JOIN
  (SELECT C.cid, COUNT(E.stuid) AS EnrollNum
   FROM Student AS S INNER JOIN Enrolled_in AS E ON S.stuid = E.stuid
                  INNER JOIN Course AS C ON C.cid = E.cid
   GROUP BY C.cid, C.cname, C.instructor) AS T2
  ON T1.cid = T2.cid;

-- 26. 
SELECT TT2.cname, TT2.instructor, TT2.BBelow, TT2.EnrollNum, TT2.Ratio
FROM (
SELECT T1.BBelow/T2.EnrollNum AS Ratio
FROM
  (SELECT C.cid, C.cname, C.instructor, COUNT(E.grade) AS BBelow
   FROM Student AS S INNER JOIN Enrolled_in AS E ON S.stuid = E.stuid
                  INNER JOIN Course AS C ON C.cid = E.cid
   WHERE E.grade = 'C+' OR E.grade = 'C' OR E.grade = 'C-' OR E.grade = 'D+' OR E.grade = 'D-' OR E.grade = 'D' OR E.grade = 'F' 
   GROUP BY C.cid, C.cname, C.instructor) AS T1
  INNER JOIN
  (SELECT C.cid, COUNT(E.stuid) AS EnrollNum
   FROM Student AS S INNER JOIN Enrolled_in AS E ON S.stuid = E.stuid
                  INNER JOIN Course AS C ON C.cid = E.cid
   GROUP BY C.cid, C.cname, C.instructor) AS T2
  ON T1.cid = T2.cid
ORDER BY Ratio DESC LIMIT 0,1
) AS TT1 
INNER JOIN 
(
SELECT T1.cname, T1.instructor, T1.BBelow, T2.EnrollNum, T1.BBelow/T2.EnrollNum AS Ratio
FROM
  (SELECT C.cid, C.cname, C.instructor, COUNT(E.grade) AS BBelow
   FROM Student AS S INNER JOIN Enrolled_in AS E ON S.stuid = E.stuid
                  INNER JOIN Course AS C ON C.cid = E.cid
   WHERE E.grade = 'C+' OR E.grade = 'C' OR E.grade = 'C-' OR E.grade = 'D+' OR E.grade = 'D-' OR E.grade = 'D' OR E.grade = 'F' 
   GROUP BY C.cid, C.cname, C.instructor) AS T1
  INNER JOIN
  (SELECT C.cid, COUNT(E.stuid) AS EnrollNum
   FROM Student AS S INNER JOIN Enrolled_in AS E ON S.stuid = E.stuid
                  INNER JOIN Course AS C ON C.cid = E.cid
   GROUP BY C.cid, C.cname, C.instructor) AS T2
   ON T1.cid = T2.cid
) AS TT2
ON TT2.Ratio = TT1.Ratio;


--  27.
SELECT AVG(SS.age)
FROM 
  (SELECT S.stuid, COUNT(P.actid) AS Times
  FROM Student AS S INNER JOIN Participates_in AS P ON S.stuid = P.stuid
  GROUP BY S.stuid) AS T1
  INNER JOIN
  Student AS SS ON SS.stuid = T1.stuid
WHERE T1.Times > 2;

--  28 
  (SELECT S.fname, S.lname
   FROM Student AS S INNER JOIN Participates_in AS P ON S.stuid = P.stuid
                     INNER JOIN Activity AS A ON A.actid = P.actid
   WHERE A.activity_name = 'Extreme Canasta')
   UNION
    (SELECT F.fname, F.lname
   FROM Faculty AS F INNER JOIN Faculty_Participates_in AS FP ON F.facid = FP.facid
                     INNER JOIN Activity AS A ON A.actid = FP.actid
   WHERE A.activity_name = 'Extreme Canasta');


--  29 
SELECT DISTINCT S1.fname AS Name1F, S1.lname AS Name1L, S2.fname AS Name2F, S2.lname AS Name2L
FROM (Student AS S1 INNER JOIN Lives_in AS L1 ON S1.stuid = L1.stuid ) 
     INNER JOIN
     Lives_in AS L2  ON L1.DormID = L2.DormID AND L1.Room_number = L2.Room_number INNER JOIN Student AS S2 ON S2.stuid = L2.stuid 
WHERE S1.stuid > S2.stuid;

--  30
-- a
DROP TABLE IF EXISTS Baltimore_distance;
CREATE TABLE IF NOT EXISTS Baltimore_distance(
         City1_code char(3) DEFAULT NULL, 
         City2_code char(3) DEFAULT NULL, 
         Distance  int(11) DEFAULT NULL);
INSERT INTO Baltimore_distance(City1_code, City2_code, Distance)
         SELECT DISTINCT C1.city2_code, C2.city2_code, C1.distance + C2.distance
         FROM 
             (SELECT D.city2_code, D.distance
              FROM Direct_distance AS D
              WHERE city1_code = 'BAL') AS C1 
              INNER JOIN 
             (SELECT D.city2_code, D.distance
              FROM Direct_distance AS D
              WHERE city1_code = 'BAL') AS C2
         WHERE C1.city2_code <> C2.city2_code;
-- b
DROP TABLE IF EXISTS Rectangular_distance;
CREATE TABLE IF NOT EXISTS Rectangular_distance(
         City1_code char(3) DEFAULT NULL, 
         City2_code char(3) DEFAULT NULL, 
         Distance  int(11) DEFAULT NULL);
INSERT INTO Rectangular_distance(City1_code, City2_code, Distance)
         SELECT DISTINCT C1.city_code, C2.city_code, 
                SQRT(POWER((70*C1.latitude-70*C2.latitude),2) + POWER((70*C1.longitude-70*C2.longitude),2))
         FROM 
              (SELECT city_code,latitude,longitude 
               FROM City) AS C1 
               JOIN 
              (SELECT city_code,latitude,longitude 
               FROM City) AS C2
         WHERE C1.city_code<>C2.city_code;

-- c

DROP TABLE IF EXISTS All_distance;
CREATE TABLE IF NOT EXISTS All_distance(
         City1_code char(3) DEFAULT NULL, 
         City2_code char(3) DEFAULT NULL, 
         Direct_distance int(11) DEFAULT NULL,
         Baltimore_distance int(11) DEFAULT NULL,
         Rectangular_distance int(11) DEFAULT NULL);
INSERT INTO All_distance(City1_code, City2_code, Direct_distance, Baltimore_distance, Rectangular_distance)
         SELECT B.City1_code, B.city2_code, D.distance, B.distance, R.distance
         FROM Rectangular_distance AS R JOIN Baltimore_distance AS B ON R.city1_code = B.city1_code AND R.city2_code = B.city2_code JOIN Direct_distance AS D ON D.city1_code = B.city1_code AND D.city2_code = B.city2_code;

-- d

DROP TABLE IF EXISTS Best_distance;
CREATE TABLE IF NOT EXISTS Best_distance(
         City1_code char(3) DEFAULT NULL, 
         City2_code char(3) DEFAULT NULL,           
         Distance int(11) DEFAULT NULL);
INSERT INTO Best_distance (City1_code, City2_code, Distance)
         SELECT T.city1_code,T.city2_code,LEAST(T.direct_distance,T.baltimore_distance,T.rectangular_distance) AS distance
         FROM ( SELECT A.city1_code, A.city2_code,IF(ISNULL(A.direct_distance),99999999,A.direct_distance) AS direct_distance,         A.baltimore_distance,A.rectangular_distance
                FROM All_distance AS A) AS T;


-- 31 Skip

-- 32.Skip

-- 33 Skip

-- 34 
SELECT A.activity_name, COUNT(P.stuid) AS Popular
FROM Activity AS A INNER JOIN Participates_in AS P ON A.actid= P.actid
                   INNER JOIN Student AS S ON S.stuid = P.stuid
GROUP BY A.activity_name
ORDER BY Popular DESC LIMIT 0,1;

-- 35. 
SELECT A0.activity_name
FROM Activity AS A0
WHERE A0.actid NOT IN ( SELECT A1.actid
                        FROM Student AS S INNER JOIN Participates_in AS P ON S.stuid = P.stuid
                        INNER JOIN Activity AS A1 ON A1.actid = P.actid)
      AND A0.actid IN ( SELECT A2.actid
                        FROM Faculty AS F INNER JOIN Faculty_Participates_in AS FP ON F.facid = FP.facid
                       INNER JOIN Activity AS A2 ON A2.actid = FP.actid);

-- 36. 
SELECT DISTINCT S.fname, S.lname, S.stuid
FROM Student AS S INNER JOIN Enrolled_in AS E ON S.stuid = E.stuid
WHERE E.cid IN (
 SELECT E1.cid
 FROM Enrolled_in AS E1 INNER JOIN Student AS S1 ON S1.stuid = E1.stuid INNER JOIN Lives_in AS L ON L.stuid = S1.stuid
 WHERE L.DormID IN (
    SELECT L2.dormid
    FROM Lives_in AS L2 INNER JOIN Student AS S2 ON S2.stuid = L2.stuid INNER JOIN City AS C ON C.City_code = S2.city_code
    WHERE C.City_name = 'PA'AND L2.room_number = L.room_number));

-- 37.
SELECT DISTINCT S1.fname AS Name1F, S1.lname AS Name1L, S2.fname AS Name2F, S2.lname AS Name2L
FROM (Student AS S1 INNER JOIN Lives_in AS L1 ON S1.stuid = L1.stuid INNER JOIN City AS C1 ON S1.city_code = C1.city_code) 
     INNER JOIN Lives_in AS L2  ON L1.DormID = L2.DormID AND L1.Room_number = L2.Room_number 
     INNER JOIN Student AS S2 ON S2.stuid = L2.stuid 
     INNER JOIN City AS C2 ON S2.city_code = C2.city_code
WHERE S1.stuid > S2.stuid AND C1.country <> C2.country;


-- 38. 
SELECT S.Major, COUNT(A.actid)/COUNT(DISTINCT S.stuid) AS AvgActivity
FROM Student AS S INNER JOIN Participates_in AS P ON S.stuid = P.stuid INNER JOIN Activity AS A ON A.actid = P.actid 
GROUP BY S.Major
HAVING COUNT(DISTINCT S.stuid) >1;

-- 39.
SELECT DISTINCT F1.fname, F1.lname
FROM Faculty AS F1 INNER JOIN Member_of AS Mem ON Mem.facid = F1.facid INNER JOIN Student AS S1 ON F1.facid = S1.advisor INNER JOIN Enrolled_in AS E1 ON S1.stuid = E1.stuid
WHERE E1.cid IN ( SELECT E2.cid
                  FROM Enrolled_in AS E2 INNER JOIN Student AS S2 ON E2.stuid = S2.stuid INNER JOIN Lives_in AS L2 ON L2.stuid = S2.stuid
                  WHERE L2.dormid IN ( SELECT L3.dormid
                                       FROM Lives_in AS L3 INNER JOIN Student AS S3 ON S3.stuid = L3.stuid INNER JOIN Minor_in AS M ON S3.stuid = M.stuid
                                       WHERE L2.room_number = L3.room_number AND (Mem.DNO = M.DNO OR Mem.DNO = S3.Major) 
                                      )
                );

-- 40 
SELECT S.fname, S.lname, F.fname, F.lname, S.Major, SUM(C.credits) AS TotalCredit, AvgCredit
FROM Student AS S INNER JOIN Enrolled_in AS E ON S.stuid = E.stuid INNER JOIN Course AS C ON E.cid = C.cid
               INNER JOIN Faculty AS F ON F.facid = S.advisor
               INNER JOIN
                       ( SELECT S1.Major, SUM(C1.credits)/COUNT(DISTINCT S1.stuid) AS AvgCredit
                       FROM Student AS S1 INNER JOIN Enrolled_in AS E1 ON S1.stuid = E1.stuid INNER JOIN Course AS C1 ON E1.cid = C1.cid 
                       GROUP BY S1.Major) AS T1 ON T1.Major = S.Major
GROUP BY S.fname, S.lname, F.fname, F.lname
HAVING TotalCredit > AvgCredit;

-- 41. 
SELECT C.cname, F.fname, F.lname, COUNT(E.stuid) AS EnrollmentNum
FROM Course AS C INNER JOIN Enrolled_in AS E ON C.cid = E.cid
                 INNER JOIN Faculty AS F ON F.facid = C.instructor
GROUP BY C.cname, F.fname, F.lname
HAVING EnrollmentNum >    ( SELECT SUM(EnrollPerCourse)
                           FROM Course AS C1
                                INNER JOIN ( SELECT C2.cname, COUNT(E2.stuid) AS EnrollPerCourse
                                             FROM Enrolled_in AS E2 INNER JOIN Course AS C2 ON E2.cid = C2.cid
                                             GROUP BY C2.cid) AS T1 ON T1.cname = C1.cname
                          )/ 
                          ( SELECT COUNT(DISTINCT E0.cid)
                            FROM Enrolled_in AS E0
                          );

-- 42 
SELECT F.fname, F.lname, F.Room, F.Building
FROM Faculty AS F INNER JOIN Member_of AS M ON F.facid = M.facid INNER JOIN Department AS D ON M.dno = D.dno
WHERE M.appt_type = 'Secondary' AND D.dname = 'Computer Science'
            AND F.building NOT IN (SELECT F1.building
                       FROM  Faculty AS F1 INNER JOIN Member_of AS M1 ON F1.facid = M1.facid INNER JOIN Department AS D1 ON M1.dno = D1.dno
                       WHERE F1.building = 'NEB');

-- 43. 
SELECT COUNT(S.stuid)
FROM Student AS S INNER JOIN Department AS D ON S.major = D.dno
                  INNER JOIN Preferences AS PF ON PF.stuid = S.stuid
WHERE D.dname = 'Computer Science' AND PF.smoking = 'Yes'
      AND S.stuid NOT IN (SELECT S1.stuid 
                      FROM Student AS S1 INNER JOIN Likes AS LK ON LK.wholikes = S1.stuid
                                         INNER JOIN Student AS S2 ON LK.whoisliked = S2.stuid
                      WHERE S2.stuid IN( SELECT stuid
                                         FROM Student)
                         );



                            

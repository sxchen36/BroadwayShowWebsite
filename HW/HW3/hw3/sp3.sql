delimiter #
CREATE PROCEDURE countfname (IN name varchar(12)) 
BEGIN
  -- declare variable
  DECLARE c INTEGER;
  -- put query result into variable. query must return 1 row.
  SELECT count(*) INTO c 
  FROM Student
  WHERE Fname = name;
  -- if statements 
  IF c > 0
  THEN SELECT "SUCCESS!!";
  ELSE SELECT "FAILURE!!";
  END IF;

END#
delimiter ;

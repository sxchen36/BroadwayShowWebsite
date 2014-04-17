delimiter #
-- define procedure with 1 parameter of type integer
CREATE PROCEDURE getstudent (IN sid INTEGER) 
BEGIN
  -- use parameter in query
  SELECT * from Student where StuID = sid;
END#
delimiter ;

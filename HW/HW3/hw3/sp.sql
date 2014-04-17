-- change delimiter! or else ;'s will cause mysql to stop parsing
delimiter #

-- define procedure and parameters (no parameters in this case)
CREATE PROCEDURE liststudents () 
BEGIN
  -- sql queries go between BEGIN and END. End with ;'s
  SELECT * from Student;
-- use the delimiter to indicate end of create statement
END#

-- revert changes to delimeter
delimiter ;

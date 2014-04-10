##SQL PROCEDURE

-- QUERY 1
DROP PROCEDURE IF EXISTS Artist;
delimiter //

CREATE PROCEDURE Artist (IN ArtistName varchar(30))
BEGIN

SELECT DISTINCT A.ArtistName, A.Gender, ST.ShowName
FROM   Artist AS A INNER JOIN CAST_IN AS CI ON A.AID=CI.AID
       INNER JOIN SHOW_INSTANCE AS SI ON CI.ShowID=SI.ShowID
       INNER JOIN SHOW_TEMPLATE AS ST ON ST.ShowNumber=SI.ShowNumber
WHERE  A.ArtistName=ArtistName;
END//

delimiter ;

# call Artist('Rafe Spall');


-- QUERY 2
DROP PROCEDURE IF EXISTS SearchType;
delimiter //

CREATE PROCEDURE SearchType (IN Type varchar(30))
BEGIN
SELECT DISTINCT SI.ShowID, ST.ShowName
FROM   SHOW_TEMPLATE AS ST INNER JOIN SHOW_INSTANCE AS SI ON ST.ShowNumber=SI.ShowNumber      
WHERE  ST.Category LIKE CONCAT("%",Type,"%");
END//

delimiter ;
#CALL SearchType ('PLAY');


-- QUERY 3
DROP PROCEDURE IF EXISTS SearchScore;
delimiter //

CREATE PROCEDURE SearchScore (IN Score int)
BEGIN
SELECT DISTINCT SI.ShowID, ST.ShowName
FROM   SHOW_TEMPLATE AS ST INNER JOIN SHOW_INSTANCE AS SI ON ST.ShowNumber=SI.ShowNumber
       INNER JOIN SCHEDUALED AS SCH ON SCH.ShowID=SI.ShowID 
       INNER JOIN SHOWTIME AS SHT ON SHT.TimeID=SCH.TimeID
       INNER JOIN HAS AS H ON SI.ShowID=H.ShowID
       INNER JOIN TICKET AS T ON H.TicketID=T.TicketID     
WHERE  ST.RatingScore>Score;
END //

delimiter ;
#CALL SearchScore (80);

-- QUERY 4
DROP PROCEDURE IF EXISTS SearchPrice;
delimiter //

CREATE PROCEDURE SearchPrice (IN Price float(4))
BEGIN
SELECT DISTINCT SI.ShowID, ST.ShowName
FROM   SHOW_TEMPLATE AS ST INNER JOIN SHOW_INSTANCE AS SI ON ST.ShowNumber=SI.ShowNumber
       INNER JOIN SCHEDUALED AS SCH ON SCH.ShowID=SI.ShowID 
       INNER JOIN SHOWTIME AS SHT ON SHT.TimeID=SCH.TimeID
       INNER JOIN HAS AS H ON SI.ShowID=H.ShowID
       INNER JOIN TICKET AS T ON H.TicketID=T.TicketID     
WHERE  T.Price<=Price;
END //

delimiter ;
#CALL SearchScore (80);

-- QUERY 5
DROP PROCEDURE IF EXISTS FindShow;
delimiter //

CREATE PROCEDURE FindShow (IN Type varchar(30), IN Score int, IN Price float(4), IN Seat varchar(20), IN Sdate date)
BEGIN

SELECT DISTINCT SI.ShowID, ST.ShowName, SHT.ShowDate, SHT.StartingTime
FROM   SHOW_TEMPLATE AS ST INNER JOIN SHOW_INSTANCE AS SI ON ST.ShowNumber=SI.ShowNumber
       INNER JOIN SCHEDUALED AS SCH ON SCH.ShowID=SI.ShowID 
       INNER JOIN SHOWTIME AS SHT ON SHT.TimeID=SCH.TimeID
       INNER JOIN HAS AS H ON SI.ShowID=H.ShowID
       INNER JOIN TICKET AS T ON H.TicketID=T.TicketID
       
WHERE  ST.Category LIKE CONCAT("%",Type,"%") AND ST.RatingScore>Score AND T.Price<=Price AND T.SeatLocation=Seat AND SHT.ShowDate=Sdate;
END //

delimiter ;

#call FindShow ('musical', 80, 250.00, 'Rear Mezzanine','2013-12-27');

-- QUERY 6
DROP PROCEDURE IF EXISTS LOGIN;
delimiter //

CREATE PROCEDURE LOGIN (IN UID varchar(20),IN password varchar(10))
BEGIN
SELECT * FROM USER WHERE USER.UserID=UID AND USER.Password=password;
end; //

delimiter ;

#call LOGIN ('jliu88', '123456');

-- QUERY 7
DROP PROCEDURE IF EXISTS REGISTER;
delimiter //

CREATE PROCEDURE REGISTER (IN UID varchar(20),IN UName varchar(30),IN Gender varchar(6),IN Age int, IN password varchar(10))
BEGIN
IF EXISTS(SELECT * FROM USER WHERE USER.UserID=UID)
THEN SELECT "This UserID Already Exists";
ELSE 
     INSERT INTO `USER` VALUES
     (UID,UName,CURDATE(), Gender, Age, password);
     SELECT "Successfully Registered";
END IF;
END; //

delimiter ;

#call REGISTER ('chunys91','Chun Yang', 'Female','22', '1q2w3e');


-- QUERY 8

DROP PROCEDURE IF EXISTS SearchTicket;
delimiter //

CREATE PROCEDURE SearchTicket (IN Sdate date)
BEGIN

SELECT SI.ShowID, MIN(T.Price) AS MinimumPrice, SI.AvailableTickets, ST.ShowName
FROM   SHOW_TEMPLATE AS ST INNER JOIN SHOW_INSTANCE AS SI ON ST.ShowNumber=SI.ShowNumber
       INNER JOIN HAS AS H ON SI.ShowID=H.ShowID
       INNER JOIN TICKET AS T ON H.TicketID=T.TicketID
       INNER JOIN SCHEDUALED AS SCH ON SCH.ShowID=SI.ShowID
       INNER JOIN SHOWTIME AS SHT ON SCH.TimeID=SHT.TimeID
WHERE  SHT.ShowDate=SDATE
GROUP BY SI.ShowID
limit 1;
END //

delimiter ;

#call SearchTicket ('2013-12-26');


-- QUERY 9
DROP PROCEDURE IF EXISTS Award;
delimiter //

CREATE PROCEDURE Award ()
BEGIN
SELECT ST.ShowName, A.ArtistName
FROM   SHOW_TEMPLATE AS ST INNER JOIN SHOW_INSTANCE AS SI ON ST.ShowNumber=SI.ShowNumber
       INNER JOIN CAST_IN AS CI ON CI.ShowID=SI.ShowID
       INNER JOIN Artist AS A ON A.AID=CI.AID
WHERE  ST.Category LIKE CONCAT("%","Tony Winners","%");
END//

delimiter ;

#CALL Award();




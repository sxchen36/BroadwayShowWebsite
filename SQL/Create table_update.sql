## Final Project

## Create Database
DROP TABLE IF EXISTS USER;
CREATE TABLE USER (UserID varchar(30), UserName varchar(30), Last_login date, Gender varchar(6), Age int, Password char(6) not null, CONSTRAINT u_pk PRIMARY KEY (UserID));


DROP TABLE IF EXISTS TICKET;
CREATE TABLE TICKET (TicketID char(17) primary key , Price float(4), SeatLocation varchar(20));

DROP TABLE IF EXISTS BOOKED;
CREATE TABLE BOOKED (UserID varchar(30) , TicketID char(10) , BookTime date, CONSTRAINT bk_fk FOREIGN KEY (TicketID) REFERENCES TICKET(TicketID));

DROP TABLE IF EXISTS SHOW_INSTANCE;
CREATE TABLE SHOW_INSTANCE (ShowID int ,ShowNumber int,  TotalTickets int, AvailableTickets int, CONSTRAINT si_pk PRIMARY KEY (ShowID));

DROP TABLE IF EXISTS HAS;
CREATE TABLE HAS (TicketID char(10), ShowID int, CONSTRAINT h_fk FOREIGN KEY (TicketID) REFERENCES TICKET(TicketID));

DROP TABLE IF EXISTS LOCATION;
CREATE TABLE LOCATION (LID char(8) primary key, Theater varchar(30), Address varchar(30), ZipCode varchar(10));

DROP TABLE IF EXISTS PUTON;
CREATE TABLE PUTON (LID char(8) , ShowID int, CONSTRAINT po_fk FOREIGN KEY (LID) REFERENCES LOCATION(LID));

DROP TABLE IF EXISTS SHOWTIME;
CREATE TABLE SHOWTIME (TimeID char(7), ShowDate date, StartingTime time, CONSTRAINT st_pk PRIMARY KEY (TimeID));

DROP TABLE IF EXISTS SCHEDUALED;
CREATE TABLE SCHEDUALED (TimeID char(7), ShowID int, CONSTRAINT sc_fk FOREIGN KEY (ShowID) REFERENCES SHOW_INSTANCE(ShowID));

DROP TABLE IF EXISTS SHOW_TEMPLATE;
CREATE TABLE SHOW_TEMPLATE (ShowNumber int, ShowName varchar(35), Category varchar(20), Duration varchar(10), RatingScore int, CONSTRAINT sht_pk PRIMARY KEY (ShowNumber));

DROP TABLE IF EXISTS ARTIST;
CREATE TABLE ARTIST (AID int, ArtistName varchar(30), Gender varchar(6), CONSTRAINT a_pk PRIMARY KEY (AID));

DROP TABLE IF EXISTS CAST_IN;
CREATE TABLE CAST_IN (AID INT, ShowID INT);





Lecture Notes:




Into to Stored procedures.


Stored procedures allow you to give a name to a sequence of sql queries, that can be executing by calling the procedure.


Any sql statement is fine. Separate them with ;’s.


Be sure to change delimiter before query, and revert it after query.


Simplest example: sp.sql   one single select statement, no parameters:
mysql> CALL liststudents();


Stored procedures can also take arguments. sp1.sql takes in a integer ( student id)
mysql> CALL getstudent(1001);


Stored procedures also allows some procedural code. Variables, loops, if statements, etc.


sp2.sql uses variables and control flow statements:
mysql> CALL countfname(‘eric);
mysql> CALL countfname(‘billybob’);




Look at the .sql files to inspect code used to create the procedures.


________________


Setting up website on ugradx:
https://support.cs.jhu.edu/wiki/Creating_a_Webpage


We need to set up student website for you to use PHP/mysql.


To do this, first ssh into a ugrad computer.


In your home directory, create a folder called public_html
ugradx> mkdir public_html


Now we need to expose this folder to the public internet.
ugradx> chmod 701 ~jwheeler


Use your ugrad username instead of jwheeler. Dont forget the ~


Then expose your public html folder:
ugradx> chmod 701 public_html


Now we can begin creating html or php files. Create a file called index.html and place it in the public_html folder. Put some actual HTML content in the file.


When you are ready for this page to appear on your site, run the following command:
ugradx> chmod 704 index.html


Now we can access this page at:
http://ugrad.cs.jhu.edu/~jwheeler/index.html


Be sure to run the chmod 704 command on each html or php file you create that you want to be public (accessible from browser)




________________


Using PHP/MYSQL
(more notes available on Dr. Yarowsky’s website)


The file test.php simply connects to the database, executes a SELECT statement, and prints all the results to HTML. 


Another thing we will need to do is use input from HTML forms.


Look at simpleform.html for an example.


The name of the input field is ‘name’. The post attribute of the form element specifies which php file should handle the input from the form. In this case, the form handler is “getname.php”.


Look at getname.php


It uses the $_POST variable to get the parameter passed from the form. $_POST is an array, where the indexes are the names of the input fields. In our case, this was ‘name’.


Then, we construct a query that uses the name provided as input in the WHERE clause. Results are output as before.




Lastly, we need to know how to get the results from stored procedures within PHP.


Look at sp.php


This is slightly more complicated, we connect to the database by creating a “mysqli” object, and providing our connection settings as parameters to its constructor.


This object has several functions, we first use the multi_query function to call our stored procedure. We use multi_query because the procedure could have multiple result sets. (if it contains multiple selects)


In the rest of the code, we iterate over each result set.
For each result set, we store the set to a variable, and iterate over the rows in the set, printing them to the screen.












Notes: don’t use any function that starts with mysql_. Use the mysqli_ version.


Using OUT parameter:


mysql> delimiter //

mysql> CREATE PROCEDURE simpleproc (OUT param1 INT)
   -> BEGIN
   ->   SELECT COUNT(*) INTO param1 FROM t;
   -> END//
Query OK, 0 rows affected (0.00 sec)

mysql> delimiter ;

mysql> CALL simpleproc(@a);
Query OK, 0 rows affected (0.00 sec)

mysql> SELECT @a;
+------+
| @a   |
+------+
| 3    |
+------+
1 row in set (0.00 sec)


Create view:


mysql> CREATE VIEW erics AS SELECT * FROM Student WHERE fname=’eric’;
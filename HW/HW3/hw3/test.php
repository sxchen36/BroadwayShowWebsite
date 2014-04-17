<?php
  // display errors!
  ini_set('display_errors', 'On');
  
  // Create connection
  $con=mysqli_connect("dbase.cs.jhu.edu","cs41513_jbw","newpass","cs41513_jbw_db");

  // Check connection
  if (mysqli_connect_errno($con))
  {
    echo "Failed to connect to MySQL: " . mysql_connect_error();
  }
 
  // create query 
  $query = "SELECT Fname,Lname FROM Student";

  // exec query
  $result = mysqli_query($con,$query);
  
  // iterate over results
  while ($row = mysqli_fetch_array($result))
  {
    echo $row['Fname'] . " " . $row['Lname'] . "<br>";
  }

  // close connection
  mysqli_close($con);
?>

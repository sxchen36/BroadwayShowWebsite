<?php
  // display errors!
  ini_set('display_errors', 'On');
  
  // Create connection
  $mysqli=mysqli_connect("dbase.cs.jhu.edu","cs41513_sxchen36","LtPK8WuBbe","cs41513_sxchen36_db");

  // Check connection
  if (mysqli_connect_errno($mysqli))
  {
    echo "Failed to connect to MySQL: " . mysql_connect_error();
  }

  // grab provided name from form. 
  $param_name = $_POST['pass'];
 
  // create query 
  $query = "Call Stats('$param_name');";
 if ($mysqli->multi_query($query)) {
    do {
       // store current result set into $result
       if ($result = $mysqli->store_result()) {
          // print output
         while ($row = $result->fetch_row()) {
		 echo "<table border='1'>";
		 echo "<tr>";
		 for ($i=0; $i<sizeof($row); $i++){
			 printf("<td> %s  </br>  </td>" , $row[$i]);
		 }
		 printf("</tr>");
        }
	 printf("</table>");
      // close this result set cursor
      $result->close();
      }
     // if there are more result sets coming, draw a line between them
     if ($mysqli->more_results()) {
//       printf("-----------------<br>");
     }
      // switch to next result set
    } while ($mysqli->next_result());
  }
  else {
    printf("<br>Error: %s\n", $mysqli->error);
  }
  // close connection
  mysqli_close($mysqli);
?>


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
  $query = "Call AllPercentages('$param_name');";
  $firsttime = true;
  $validInput = true;
 if ($mysqli->multi_query($query)) {
    do {
       // store current result set into $result
       if ($result = $mysqli->store_result()) {
          // print output
         while ($row = $result->fetch_row()) {
             if (sizeof($row)==1) {
                $validInput=false; 
             }
             if ($firsttime) {
               if ($validInput) {
	       echo "AllPercentages </br>";
	       echo "<table border='1'>
		       <tr>
		       <th> SSN </th>
		       <th> Lastname</th>
		       <th> Firstname</th>
		       <th> Section</th>
		       <th> HW1</th>
		       <th> HW2a</th>
		       <th> HW2b</th>
		       <th> Midterm</th>
		       <th> HW4</th>
		       <th> FinalExam</th>
		       <th> Weighted Avg</th>
		       </tr>";
                } else {
			echo "AllPercentages </br>";
			echo "<table border='1'>
				<tr>
				<th> Error </th>
				</tr>";
                }
                $firsttime = false;
             }
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
      // printf("-----------------<br>");
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


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
  $param_name = $_POST['ssn'];
 
  // create query 
  $query = "Call ShowPercentages($param_name);";
  $j = 0;
 if ($mysqli->multi_query($query)) {
    do {
       $firsttime = true;
       // store current result set into $result
       if ($result = $mysqli->store_result()) {
          // print output
         while ($row = $result->fetch_row()) {
           if ($firsttime) {
		   if ($j== 0 && sizeof($row)!=1){
			   echo "ShowPercentage </br>";
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
				   </tr>";
                             $j++;
		   } else if ($j==1){
                           echo "ShowPercentage </br>";
			   echo "<table border='1'>
				   <tr>
				   <th>CumAvg</th>
				   </tr>";
                   } else  {
			   echo "ShowPercentage </br>";
			   echo "<table border='1'>
				   <tr>
				   <th> Error Message </th>
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
  //     printf("-----------------<br>");
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


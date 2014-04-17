<?php
  // display errors!
  ini_set('display_errors', 'On');

  $param_name1 = $_POST['pass'];
  $param_name2 = $_POST['ssn'];
  $param_name3 = $_POST['asst'];
  $param_name4 = $_POST['newScore'];

  // mysqli object (different way of connecting)
  $mysqli = new mysqli("dbase.cs.jhu.edu","cs41513_kjayach1","qqq","cs41513_kjayach1_db");
  $firsttime = 0; 
  // define query
  $query = "CALL ChangeScores('$param_name1','$param_name2','$param_name3','$param_name4')";

  // multi-query executes queries (with possibly more than 1 result set)
  if ($mysqli->multi_query($query)) {
    do {
       // store current result set into $result
       if ($result = $mysqli->store_result()) {
         // print output

          while ($row = $result->fetch_row()) {
	if(sizeof($row) > 1){
		if($firsttime < 2){		

		echo "ChangeScores </br>";
       		echo "<table border='1'>
                <tr>
                <th> State </th>
                <th> HW1</th>
                <th> HW2a</th>
                <th> HW2b</th>
                <th> Midterm</th>
                <th> HW4</th>
                <th> FinalExam</th>
                </tr>";
		$firsttime = $firsttime + 1;
		}
	}         
	if(sizeof($row)==1){
		echo "AllPercentages </br>";
			echo "<table border='1'>
				<tr>
				<th> Error </th>
				</tr>";

	}




	      echo "<tr>";
     	   for($i = 0; $i < sizeof($row); $i++){
  	  	    echo "<td>" . $row[$i] ."</br>". "</td>";
     	   }  
	   echo "</tr>";
          }
        echo "</table>";
      // close this result set cursor
      $result->close();
      }
     // if there are more result sets coming, draw a line between them
     if ($mysqli->more_results()) {
       //printf("-----------------\n");
     }
	 // switch to next result set
    } while ($mysqli->next_result());
  }
  else {
    printf("<br>Error: %s\n", $mysqli->error);
  
   }
?>


<?php
  // display errors!
  ini_set('display_errors', 'On');

  $param_name = $_POST['pass'];

  // mysqli object (different way of connecting)
  $mysqli = new mysqli("dbase.cs.jhu.edu","cs41513_kjayach1","qqq","cs41513_kjayach1_db");

  // define query
  $query = "CALL AllRawScores('$param_name')";
  $firsttime = true;
  $validInput = true;

  // multi-query executes queries (with possibly more than 1 result set)
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
	       echo "AllRawScores </br>";
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
                } else {
			echo "AllRawScores </br>";
			echo "<table border='1'>
				<tr>
				<th> Error </th>
				</tr>";
                }
                $firsttime = false;
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
      // printf("-----------------\n");
     }
	// switch to next result set
    } while ($mysqli->next_result());
  }
  else {
    printf("<br>Error: %s\n", $mysqli->error);
  }

?>


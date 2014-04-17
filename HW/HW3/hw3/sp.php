<?php
  // display errors!
  ini_set('display_errors', 'On');

  // mysqli object (different way of connecting)
  $mysqli = new mysqli("dbase.cs.jhu.edu","cs41513_jbw","newpass","cs41513_jbw_db");
  
  // define query
  $query = "CALL liststudents();";
  
  // multi-query executes queries (with possibly more than 1 result set)
  if ($mysqli->multi_query($query)) {
    do {
       // store current result set into $result
       if ($result = $mysqli->store_result()) {
         // print output
         while ($row = $result->fetch_row()) {
            printf("%s, %s, %s<br>", $row[0], $row[1], $row[2]);
        }
      // close this result set cursor
      $result->close();
      }
     // if there are more result sets coming, draw a line between them
     if ($mysqli->more_results()) {
       printf("-----------------\n");
     }
      // switch to next result set
    } while ($mysqli->next_result());
  }
  else {
    printf("<br>Error: %s\n", $mysqli->error);
  }

?>

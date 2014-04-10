<!doctype html>

<head>

	<!-- Basics -->
	
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
	
	<title>Login</title>

	<!-- CSS -->
	
	<link rel="stylesheet" href="css/reset.css">
	<link rel="stylesheet" href="css/animate.css">
	<link rel="stylesheet" href="css/styles.css">
	
</head>

	<!-- Main HTML -->
	
<body>

	<div id="container">
	<a href="index.html"><input type="submit"  value="Home"></a>
	<img src="img/Home-icon.png" alt="web development" width="260" height="240" border="0" class="banner" />
	</div>
	
<?php

  // display errors!
  ini_set('display_errors', 'On');

  // grab value from select menu 
  $uid = $_POST["username"];
  $psw = $_POST["password"];
  // create query 
  $query = "CALL LOGIN('$uid', '$psw');";
  
  // Create connection
  $con=mysqli_connect("localhost","root","","firstdb");
  
    
  // Check connection
  if (mysqli_connect_errno($con))
  {
    echo "Failed to connect to MySQL: " . mysql_connect_error();
  }
  

		  // exec query
	$result = mysqli_query($con,$query);
  
	$row = $result->fetch_row();
	if ($result && $row>0) {
		echo "<td> . 'Login success'.</br>. </td>";
	} else {
	echo "<td> . 'User doesn't exist. Please go back to home and Sign up again'.</br>. </td>";
	}
  
  // close connection
  mysqli_close($con);

?>

</div>
<p class="bot"></p>
<br class="spacer" />
</div>
<!--body end -->
</body>
</html>



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
  $name = $_POST["username"];
  $psw = $_POST["password"];
  $uid = $_POST["userid"];
  $gender = $_POST["gender"];
  $age = $_POST["age"];
  // create query 
  $query = "CALL REGISTER('$uid', '$name', '$gender', $age, '$psw');";
  
  // Create connection
  $con=mysqli_connect("localhost","root","","firstdb");
  
    
  // Check connection
  if (mysqli_connect_errno($con))
  {
    echo "Failed to connect to MySQL: " . mysql_connect_error();
  }
  
    // insert user
	mysqli_query($con,$query);
    echo "Sign Up successfully! Please go to home page! ";
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



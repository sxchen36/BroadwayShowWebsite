<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>New Rise</title>
<link href="style.css" rel="stylesheet" type="text/css" />
	<!-- link calendar resources -->
<link rel="stylesheet" type="text/css" href="tcal.css" />
<script type="text/javascript" src="tcal.js"></script> 

</head>
<body>
<!--header start -->
<div id="header">
<a href="index.html" class="member">Home</a>
<img src="images/broadway2.jpg" alt="web development" width="300" height="50" border="0" class="banner" />
<ul class="nav">
<a href="index.html"><li class="home"> home</li></a>
<li><a href="#">contact</a></li>
</ul>
</div>
<!--header end -->
<!--body start -->
<div id="body">
<p class="top"></p>
<!--left panel start -->
<div id="left">
<h2>Search Result</h2>
<?php

  // display errors!
  ini_set('display_errors', 'On');

  // grab value from select menu 
  $name = $_POST["name"];

  // create query 
  $query = "CALL Artist('$name');";
  
  // Create connection
  $con=mysqli_connect("localhost","root","","firstdb");
  // echo $query . "<br>";
  
  // exec query
  $result = mysqli_query($con,$query);
  

  // Check connection
  if (mysqli_connect_errno($con))
  {
    echo "Failed to connect to MySQL: " . mysql_connect_error();
  }

	echo "<table border='1' width='400' height='100' background='images/body_bg_mid.gif'>";
while ($field = $result->fetch_field()) { 
   echo "<td>".$field->name."</td>\n"; 
} 
	echo "<tr>";
 
  while($row = $result->fetch_row()) {

	for($i = 0; $i < sizeof($row); $i++){
		echo "<td>" . $row[$i] ."</br>". "</td>";
	}
	echo "</tr>";     
	}
	
	echo "</table>";

  // close connection
  mysqli_close($con);
  
?>

</div>
<!--left panel end -->


<!--right panel start -->
<div id="right">
<h2>Search Artist</h2>
<form name="artist_search" action="#" method="post">
<p class="domain">enter the artist name</p>
<input type="text" name="name" />
<input type="submit" name="go" value="" class="go" />
<p >Hint: try 'Rafe Spall' or 'Zachary Levi' without quote</p>
</form>

<form name="submit_search" action="getname.php" method="post">
<ul>
   <h2 class="Type_text">Select Type</h2>
<li>
    <select id="show_type" name="show_type"> 
        <option selected value="*">All</option> 
        <option value="Musical">Musical</option>
        <option value="Comedy">Comedy</option>
		<option value="Tragedy">Tragedy</option>
        <option value="Play">Play</option>
		<option value="Kids-friendly">Kids-friendly</option>
		<option value="History">History</option>
		<option value="Classics">Classics</option>
    </select>
</li>
    <h2 class="Type_text">Select Score</h2>
<li>
    <select id="show_score" name="show_score"> 
        <option selected value="*">All</option> 
        <option value=85><85
        <option value=90><90
        <option value=95><95
		<option value=100><=100
    </select>
</li>
    <h2 class="Type_text">Select Price</h2>
<li>
    <select id="show_price" name="show_price"> 
        <option selected value="*">All</option> 
        <option value=100><100
        <option value=150><150
        <option value=200><200
		<option value=200>>200
    </select>
</li>
    <h2 class="Type_text">Select Location</h2>
<li>
    <select id="show_location" name="show_location"> 
        <option selected value="*">All</option> 
        <option value="Minskoff Th">Minskoff Th
        <option value="August Wils">August Wils
        <option value="Gershwin Th">Gershwin Th
		<option value="Bernard B.">Bernard B.
		<option value="Longacre Th">Longacre Th
		<option value="Broadhurst ">Broadhurst 
		<option value="Ambassador">Ambassador
	    <option value="Belasco Th">Belasco Th
		<option value="Walter Ker">Walter Ker
    </select>
</li>
    <h2 class="Type_text">Select Date</h2>
<li>
		<!-- add class="tcal" to your input field -->
		<div><input type="text" name="date" class="tcal" value="" /></div>
</li>
</ul>
</form >
<a href="index.html"><input class="classname" type="submit"  value="Home"></a>
<br></br>
<a href="#"><img src="images/banner.gif" alt="banner" width="157" height="146" border="0" class="banner" /></a>
<p class="bottom">
<a href="#" class="xhtm"></a>
<a href="#" class="css"></a>
</p>
</div>
<!--right panel end -->
<p class="bot"></p>
<br class="spacer" />
</div>
<!--body end -->
</body>
</html>



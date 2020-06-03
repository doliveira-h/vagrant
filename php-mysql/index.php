<?php
$mysql_server="192.168.33.15";
$username="phpuser";
$password="password";
$con = mysqli_connect($mysql_server,$username,$password);
if (!$con)
  {
  die('Could not connect: ' . mysql_error());
  }
  echo "Connected to MySQL Server!! IP : $mysql_server";
?>
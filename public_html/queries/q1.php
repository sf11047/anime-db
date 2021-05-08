<?php

include "../php/query-template.php"; //HTML Template

include '../php/open.php';

//Begin Query Code

    $query = "Test Question";
    echo "<h1>".$query."<h1>";
    
    $myQuery = "SELECT * FROM TV Limit 5;";

   

    $test = "Finished";
    echo $test;
//End Query Code

$conn->close();

include "../php/query-template-end.php"; //HTML Template
?>

<?php

include "../php/query-template.php"; //HTML Template

include '../php/open.php';

//Begin Query Code

    $query = "Max Viewer Age Group";
    echo "<h1>".$query."<h1>";

    $dataPoints = array();

    $myQuery = "CALL MaxAgeGroup();";

    $stmt = $conn->prepare($myQuery); 
    $stmt->execute();
    $result = $stmt->get_result();
    while ($row = $result->fetch_assoc()) {
        echo "<h1> Max Number of Viewers: ".$row['numUsers']."</h1>";
        echo "<h1> Max Age Group: ".$row['age']."</h1>";
    }

 
//End Query Code

$conn->close();
include "../php/query-template-end.php"; //HTML Template
?>

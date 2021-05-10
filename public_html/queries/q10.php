<?php

include "../php/query-template.php"; //HTML Template

include '../php/open.php';

//Begin Query Code
    if ($opt == "shows") {
        echo "<h1>What are the top 5 genres that have the most shows?</h1>";
    } else {
        echo "<h1>What are the top 5 genres that have the most viewers?</h1>";
    }

    echo '<div id="chartContainer" style="height: 400; width: 100%;"></div>'; //Needed for canvasjs

    $dataPoints = array();

    $opt = $_POST['q10'];

    $myQuery = "CALL TopGenresPop(?);";
    $stmt = $conn->prepare($myQuery); 
    $stmt->bind_param("s", $opt);
    $stmt->execute();
    $result = $stmt->get_result();
    while ($row = $result->fetch_assoc()) {
        //array_push($dataPoints, array( "label"=> $row["genreName"], "y"=> 0));
        echo "<p>Label: ".$row["genreName"]." Data: ".$row["count"]."</p>";
    }
    
//End Query Code
$conn->close();
?>

<?php
include "../php/query-template-end.php"; //HTML Template
?>

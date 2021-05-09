<?php

include "../php/query-template.php"; //HTML Template

include '../php/open.php';

//Begin Query Code

    $runType = $_POST['q7'];

    $query = "Studio With Most Anime Made By ".$runType;
    echo "<h1>".$query."<h1>";

    $myQuery = "Call MostAnimeMade(?);";
    $stmt = $conn->prepare($myQuery); 
    $stmt->bind_param("s", $runType);
    $stmt->execute();
    $result = $stmt->get_result();

    while ($row = $result->fetch_assoc()) {

        echo "<h1>".$row["studioName"]."</h1>";

        if ($runType == "Episode") {
            echo "<h1> Number of Episodes: ".$row['totalEpisodes']."<h1>";
        }
        
        if ($runType == "Show") {
            echo "<h1> Number of Shows: ".$row['showsMade']."<h1>";
        }
    }

//End Query Code
    $conn->close();
    include "../php/query-template-end.php"; //HTML Template
?>

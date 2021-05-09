<?php

include "../php/query-template.php"; //HTML Template

include '../php/open.php';

//Begin Query Code

    $runType = $_POST['q6'];

    $query = "Longest Running Anime By ".$runType;
    echo "<h1>".$query."<h1>";

    $myQuery = "Call LongestRunning(?);";
    $stmt = $conn->prepare($myQuery); 
    $stmt->bind_param("s", $runType);
    $stmt->execute();
    $result = $stmt->get_result();

    while ($row = $result->fetch_assoc()) {

        if ($runType == "Episode") {
            echo "<h1> Number of Episodes: ".$row['numEpisodes']."<h1>";
        }
        
        if ($runType == "Time") {
            echo "<h1> Days Run: ".$row['daysRun']."<h1>";
        }

        echo "<h2>".$row['titleJPN']."</h2>";
        echo "<h3> Rank: ".$row['rank']."</h3>";
        echo "<h3> Start Date: ".$row['startDate']."</h3>";
        echo "<h3> Source: ".$row['source']."</h3>";
        echo "<p>".$row['synopsis']."</p>";
    }

//End Query Code

$conn->close();

include "../php/query-template-end.php"; //HTML Template
?>

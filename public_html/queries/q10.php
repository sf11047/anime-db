<?php

include "../php/query-template.php"; //HTML Template

include '../php/open.php';

//Begin Query Code

    if ($opt == "shows") {
        echo "<h1>What are the top 5 genres that have the most shows?</h1>";
    } else {
        echo "<h1>What are the top 5 genres that have the most viewers?</h1>";
    }

    $stat = $_POST['q10'];
    $stat = "All";
    if ($stat != "All") {
        echo "<h1> Status: ".$stat."<h1>";
    }

    $myQuery = "Call PopularByStatus(?);";
    $stmt = $conn->prepare($myQuery); 
    $stmt->bind_param("s", $stat);
    $stmt->execute();
    $result = $stmt->get_result();
    while ($row = $result->fetch_assoc()) {
        if ($stat == "All") {
            echo "<h1> Status: ".$row['status']."</h1>"; 
            echo "<h1> Users with Status: ".$row['usersWithStatus']."</h1>";
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

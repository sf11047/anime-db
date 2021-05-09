<?php

include "../php/query-template.php"; //HTML Template

include '../php/open.php';

//Begin Query Code

    $query = "Most Popular Anime by Genre";
    echo "<h1>".$query."<h1>";
    

    $genreSelection = $_POST['genre'];
    echo "<h1> Genre: ".$genreSelection."<h1>";

    $myQuery = "Call PopByGenre(?);";
    $stmt = $conn->prepare($myQuery); 
    $stmt->bind_param("s", $genreSelection);
    $stmt->execute();
    $result = $stmt->get_result();
    while ($row = $result->fetch_assoc()) {
        echo "<h2>".$row['titleJPN']."</h2>";
        echo "<h3> Rank: ".$row['rank']."</h3>";
        echo "<h3> Start Date: ".$row['startDate']."</h3>";
        echo "<h3> Source: ".$row['source']."</h3>";
        echo "<p> Rank: ".$row['synopsis']."</p>";
    }
    
//End Query Code

$conn->close();

include "../php/query-template-end.php"; //HTML Template
?>

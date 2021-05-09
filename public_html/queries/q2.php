<?php

include "../php/query-template.php"; //HTML Template

include '../php/open.php';

//Begin Query Code

    $query = "Most Popular Anime Sources: Manga or Original Creation?";
    echo "<h1>".$query."<h1>";

    $myQuery = "SELECT AllMedia.source AS sourceType, COUNT(AllMedia.mediaID) AS numShows FROM AllMedia WHERE AllMedia.rank <= 1000 AND (AllMedia.source = 'Manga' OR AllMedia.source = 'Original') GROUP BY AllMedia.source;";
    $stmt = $conn->prepare($myQuery); 

    $stmt->execute();
    $result = $stmt->get_result();
    while ($row = $result->fetch_assoc()) {
        echo "<h2>".$row['sourceType']."</h2>";
    }
    
//End Query Code

$conn->close();

include "../php/query-template-end.php"; //HTML Template
?>

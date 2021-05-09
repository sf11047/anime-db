<?php

include "../php/query-template.php"; //HTML Template

include '../php/open.php';

//Begin Query Code

    $query = "Most Popular Anime by Genre";
    echo "<h1>".$query."<h1>";
    

    $rating = $_POST['q15'];
    $rating  = "All";

    $myQuery = "Call PopByGenre(?);";
    $stmt = $conn->prepare($myQuery); 
    $stmt->bind_param("s", $rating);
    $stmt->execute();
    $result = $stmt->get_result();
    while ($row = $result->fetch_assoc()) {
        echo "<h2>".$row['titleJPN']."</h2>";
    }
    
//End Query Code

$conn->close();

include "../php/query-template-end.php"; //HTML Template
?>

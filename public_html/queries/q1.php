<?php

include "../php/query-template.php"; //HTML Template

include '../php/open.php';

//Begin Query Code

    $query = "Test Question";
    echo "<h1>".$query."<h1>";

    $genreSelection = $_POST['genre'];
    echo "genre: ".$genreSelection." <br> </br>";

    $myQuery = "SELECT * FROM TV LIMIT 10;";
    $stmt = $conn->prepare($myQuery); 
    $stmt->execute();
    $result = $stmt->get_result();
    while ($row = $result->fetch_assoc()) {
        echo $row['titleJPN'];
    }
    echo "Finished";

//End Query Code

$conn->close();

include "../php/query-template-end.php"; //HTML Template
?>

<?php

include "../php/query-template.php"; //HTML Template

include '../php/open.php';

//Begin Query Code

    $query = "Most Popular Animation Studios";
    echo "<h1>".$query."<h1>";

    $myQuery = "Call PopularStudios();";
    $stmt = $conn->prepare($myQuery); 
    $stmt->execute();
    $result = $stmt->get_result();
    echo "<table border =\"2px solid black\">";
    echo "<tr><td>Studio</td><td>Average Show Rank</td></tr>";
    while ($row = $result->fetch_assoc()) {
        echo "<tr>";
        echo "<td>".$row["studioName"]."</td>";
        echo "<td>".$row["avgShowRank"]."</td>";
        echo "</tr>";
    }
    echo "</table>";
//End Query Code

$conn->close();

include "../php/query-template-end.php"; //HTML Template
?>

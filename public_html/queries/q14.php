<?php
include "../php/query-template.php"; //HTML Template

include '../php/open.php';

//Begin Query PHP Code

    echo "<h1>Which shows are being rewatched the most?<h1>"; //First line should be the question

    $myQuery = "Call MostRewatched();";
    $stmt = $conn->prepare($myQuery); 
    $stmt->execute();
    $result = $stmt->get_result();
    while ($row = $result->fetch_assoc()) {
        echo "<h2> Show: ".$row['titleJPN']."</h2>";
        echo "<p> Times Rewatched:".$row['rewatchCount']."/10</p>";
    }

//End Query PHP Code

$conn->close();
?>
<?php
include "../php/query-template-end.php"; //HTML Template
?>
<?php
include "../php/query-template.php"; //HTML Template

include '../php/open.php';

//Begin Query PHP Code

    echo "<h1>Most popular source of anime (Mange, Light Novel, etc.)? <h1>"; //First line should be the question

    $myQuery = "Call PopularSource();";
    $stmt = $conn->prepare($myQuery); 
    $stmt->execute();
    $result = $stmt->get_result();
    if (mysqli_num_rows($result) > 1) {
        echo "<h2> TIED </h2>";
    }
    while ($row = $result->fetch_assoc()) {
        echo "<h3>".$row['source']."</h3><p> Number of adaptions:".$row['sourceCount']."</p>";
    }

//End Query PHP Code

$conn->close();
?>
<?php
include "../php/query-template-end.php"; //HTML Template
?>
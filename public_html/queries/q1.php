<?php

include "../php/query-template.php"; //HTML Template

include '../php/open.php';

//Begin Query Code

    $query = "Test Question";
    echo "<h1>".$query."<h1>";
    
    $myQuery = "SELECT * FROM TV Limit 5;";
    $stmt= $conn->prepare($myQuery);
    $stmt->execute();

    echo "done";
    //if ($result = mysqli_query($conn, $myQuery)){
        //foreach($result as $row){
        //to improve the look of the output, we could add html table
    //tags too, which would add border lines, center the values, etc.
        //echo $row["titleJPN"]." ".$row["mediaID"]."<br>";
        //}
    //}

    $test = "Finished";
    echo $test;
//End Query Code

$conn->close();

include "../php/query-template-end.php"; //HTML Template
?>

<?php
include "../php/query-template.php"; //HTML Template

include '../php/open.php';

//Begin Query PHP Code

    echo "<h1>How many people completed more shows than they plan to watch and vice versa?<h1>"; //First line should be the question

    $opt = $_POST['q12'];

    $myQuery = "Call PlanVSComplete(?);";
    $stmt = $conn->prepare($myQuery); 
    $stmt->bind_param("s", $opt);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($opt == "plan") {
        echo "Number of people planning to watch more shows than completed:";
    } else {
        echo "Number of people who completed more shows than planning to watch:";
    }

    while ($row = $result->fetch_assoc()) {
        echo "<p>".$row['avgRating']."</p>";
    }

//End Query PHP Code

$conn->close();
?>
<?php
include "../php/query-template-end.php"; //HTML Template
?>
<?php
include "../php/query-template.php"; //HTML Template

include '../php/open.php';

//Begin Query PHP Code

    echo "<h1>What shows have the best animation? Best story? Best characters?<h1>"; //First line should be the question

    $rating = $_POST['q15'];

    $myQuery = "Call TopCategoryRating(?);";
    $stmt = $conn->prepare($myQuery); 
    $stmt->bind_param("s", $rating);
    $stmt->execute();
    $result = $stmt->get_result();
    while ($row = $result->fetch_assoc()) {
        echo "<h2> Show: ".$row['titleJPN']."</h2>";
        echo "<p> Rating:".$row['avgRating']."/10</p>";
    }

//End Query PHP Code

$conn->close();
?>
<?php
include "../php/query-template-end.php"; //HTML Template
?>
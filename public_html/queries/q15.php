<?php
include "../php/query-template.php"; //HTML Template

include '../php/open.php';

echo "Connected";

//Begin Query PHP Code

    echo "<h1>What shows have the best animation? Best story? Best characters?<h1>"; //First line should be the question

    $rating = $_POST['q15-rating'];

    $myQuery = "Call TopCategoryRating(?);";
    $stmt = $conn->prepare($myQuery); 
    $stmt->bind_param("s", $rating);
    $stmt->execute();
    $result = $stmt->get_result();
    echo $result;
    while ($row = $result->fetch_assoc()) {
        echo "Looping";
        echo "<h2>".$row['titleJPN']."</h2>";
        echo "<h2>".$row['avgRating']."</h2>";
        echo "<h2>".$row['mediaID']."</h2>";
    }

//End Query PHP Code

?>

<?php
$conn->close();
include "../php/query-template-end.php"; //HTML Template
?>
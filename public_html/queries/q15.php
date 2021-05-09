<?php
include "../php/query-template.php"; //HTML Template

include '../php/open.php';

//Begin Query PHP Code

    echo "<h1>What shows have the best animation? Best story? Best characters?<h1>"; //First line should be the question

    $rating = $_POST['q15-rating'];
    $all = "All'";


    $myQuery = "Call PopByGenre(?);";
    $stmt = $conn->prepare($myQuery); 
    $stmt->bind_param("s", $all);
    $stmt->execute();
    $result = $stmt->get_result();
    while ($row = $result->fetch_assoc()) {
        if ($genreSelection == "All") {
            echo "<h1> Genre: ".$row['genreName']."<h1>";
        }
        echo "<h2>".$row['titleJPN']."</h2>";
        echo "<h3> Rank: ".$row['rank']."</h3>";
        echo "<h3> Start Date: ".$row['startDate']."</h3>";
        echo "<h3> Source: ".$row['source']."</h3>";
        echo "<p>".$row['synopsis']."</p>";
    }

//End Query PHP Code

?>

<?php
$conn->close();
include "../php/query-template-end.php"; //HTML Template
?>
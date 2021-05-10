<?php

include "../php/query-template.php"; //HTML Template

include '../php/open.php';

//Begin Query Code
    if ($opt == "shows") {
        echo "<h1>What are the top 5 genres that have the most shows?</h1>";
    } else {
        echo "<h1>What are the top 5 genres that have the most viewers?</h1>";
    }

    echo '<div id="chartContainer" style="height: 400; width: 100%;"></div>'; //Needed for canvasjs

    $dataPoints = array();

    $myQuery = "CALL HighestReviewCategory();";
    $stmt = $conn->prepare($myQuery); 
    $stmt->execute();
    $result = $stmt->get_result();
    while ($row = $result->fetch_assoc()) {
        array_push($dataPoints, array( "label"=> $row["category"], "y"=> $row["numShows"]));
    }
    
//End Query Code
$conn->close();
?>
<script>
        window.onload = function () { 
            var chart = new CanvasJS.Chart("chartContainer", {
                animationEnabled: false,
                exportEnabled: true,
                theme: "light1", // "light1", "light2", "dark1", "dark2"
                title:{
                    text: "Number of Shows Most Highly Reviewed In Each Review Category"
                },
                data: [{
                    type: "column", //change type to column, bar, line, area, pie, etc  
                    dataPoints: <?php echo json_encode($dataPoints, JSON_NUMERIC_CHECK); ?>
                }]
            });
            chart.render(); 
        }
    </script>
<?php
include "../php/query-template-end.php"; //HTML Template
?>

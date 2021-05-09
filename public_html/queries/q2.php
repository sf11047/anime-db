<?php

include "../php/query-template.php"; //HTML Template

include '../php/open.php';

//Begin Query Code

    $query = "Most Popular Anime Sources: Manga or Original Creation?";
    echo "<h1>".$query."<h1>";

    $dataPoints = array();

    $myQuery = "CALL PopularSource();";
    $stmt = $conn->prepare($myQuery); 
    $stmt->execute();
    $result = $stmt->get_result();
    while ($row = $result->fetch_assoc()) {
        array_push($dataPoints, array( "label"=> $row["sourceType"], "y"=> $row["numShows"]));
    }
    
//End Query Code

?>
<script>
        window.onload = function () { 
            var chart = new CanvasJS.Chart("chartContainer", {
                animationEnabled: false,
                exportEnabled: true,
                theme: "light1", // "light1", "light2", "dark1", "dark2"
                title:{
                    text: "Most Popular Anime Sources"
                },
                data: [{
                    type: "column", //change type to column, bar, line, area, pie, etc  
                    dataPoints: <?php echo json_encode($dataPoints, JSON_NUMERIC_CHECK); ?>
                }]
            });
            chart.render(); 
        }
    </script>
    <div id="chartContainer" style="height: 400px; width: 100%;"></div>
	<script src="https://canvasjs.com/assets/script/canvasjs.min.js"></script>

<?php
$conn->close();
include "../php/query-template-end.php"; //HTML Template
?>

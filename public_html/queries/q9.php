<?php

include "../php/query-template.php"; //HTML Template

include '../php/open.php';

//Begin Query Code

    echo "<h1>How many new shows are created each year?</h1>";

    echo '<div id="chartContainer" style="height: 400; width: 100%;"></div>'; //Needed for canvasjs

    $dataPoints = array();

    $myQuery = "CALL NewShowsYear();";
    $stmt = $conn->prepare($myQuery); 
    $stmt->execute();
    $result = $stmt->get_result();
    while ($row = $result->fetch_assoc()) {
        array_push($dataPoints, array( "label"=> $row["year"], "y"=> $row["count"]));
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
                    text: "New shows each year"
                },
                data: [{
                    type: "line", //change type to column, bar, line, area, pie, etc  
                    dataPoints: <?php echo json_encode($dataPoints, JSON_NUMERIC_CHECK); ?>
                }]
            });
            chart.render(); 
        }
</script>
<?php
include "../php/query-template-end.php"; //HTML Template
?>

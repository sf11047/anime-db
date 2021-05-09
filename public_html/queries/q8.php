<?php

include "../php/query-template.php"; //HTML Template

include '../php/open.php';

//Begin Query Code

    $query = "Anime Viewers by Age Groups";
    echo "<h1>".$query."<h1>";

    $dataPoints = array();

    $myQuery1 = "CALL MaxAgeGroup();";
    $myQuery2 = "CALL AgeGroups();";

    $stmt1 = $conn->prepare($myQuery1); 
    $stmt1->execute();
    $result1 = $stmt1->get_result();
    while ($row = $result1->fetch_assoc()) {
        echo "<h1> Max Number of Viewers: ".$row['numUsers']."</h1>";
    }

    $stmt2 = $conn->prepare($myQuery2); 
    $stmt2->execute();
    $result2 = $stmt2->get_result();
    while ($row = $result2->fetch_assoc()) {
        array_push($dataPoints, array( "label"=> $row["age"], "y"=> $row["numPeople"]));
    }

    echo "<div id='chartContainer' style='height: 400px; width: 100%;'></div>";
    
//End Query Code

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
                    type: "line", //change type to column, bar, line, area, pie, etc  
                    dataPoints: <?php echo json_encode($dataPoints, JSON_NUMERIC_CHECK); ?>
                }]
            });
            chart.render(); 
        }
    </script>
	<script src="https://canvasjs.com/assets/script/canvasjs.min.js"></script>

<?php
$conn->close();
include "../php/query-template-end.php"; //HTML Template
?>

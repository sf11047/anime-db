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
        echo "<h1> Max Age Group: ".$row['age']."</h1>";
    }

    echo $myQuery2;

    $stmt2 = $conn->prepare($myQuery2); 
    $stmt2->execute();
    $result2 = $stmt2->get_result();

    echo $result2;
    while ($row2 = $result2->fetch_assoc()) {
        echo row2['age'];
        array_push($dataPoints, array( "label"=> $row2["age"], "y"=> $row2["numPeople"]));
    }
    
//End Query Code

?>

<script>
window.onload = function () { 
	var chart = new CanvasJS.Chart("chartContainer", {
		animationEnabled: true,
		exportEnabled: true,
		theme: "light1", // "light1", "light2", "dark1", "dark2"
		title:{
			text: "Number of Viewers Per Age"
		},
		data: [{
			type: "line", //change type to column, bar, line, area, pie, etc  
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

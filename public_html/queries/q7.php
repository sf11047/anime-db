<?php

include "../php/query-template.php"; //HTML Template

include '../php/open.php';

//Begin Query Code

    $runType = $_POST['q7'];

    $query = "Studio With Most Anime Made By ".$runType;
    echo "<h1>".$query."<h1>";

    $myQuery = "Call MostAnimeMade(?);";
    $stmt = $conn->prepare($myQuery); 
    $stmt->bind_param("s", $runType);
    $stmt->execute();
    $result = $stmt->get_result();

    while ($row = $result->fetch_assoc()) {

        if ($runType == "Episode") {
            echo "<h1> Number of Episodes: ".$row['numEpisodes']."<h1>";
        }
        
        if ($runType == "Time") {
            echo "<h1> Days Run: ".$row['daysRun']."<h1>";
        }

        echo "<h2>".$row['titleJPN']."</h2>";
        echo "<h3> Rank: ".$row['rank']."</h3>";
        echo "<h3> Start Date: ".$row['startDate']."</h3>";
        echo "<h3> Source: ".$row['source']."</h3>";
        echo "<p>".$row['synopsis']."</p>";
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

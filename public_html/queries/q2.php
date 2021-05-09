<?php

include "../php/q2visual.php"; //HTML Template

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
        echo "<h2>".$row['sourceType']."</h2>";
        array_push($dataPoints, array( "label"=> $row["sourceType"], "y"=> $row["numShows"]));
    }
    
//End Query Code

echo "<script>
window.onload = function () { 
    var chart = new CanvasJS.Chart('chartContainer', {
        animationEnabled: false,
        exportEnabled: true,
        theme: 'light1', 
        title:{
            text: 'Popular Show Sources'
        },
        data: [{
            type: 'column', //change type to column, bar, line, area, pie, etc  
            dataPoints: <?php echo json_encode($dataPoints, JSON_NUMERIC_CHECK); ?>
        }]
    });
    chart.render(); 
}
</script>"

$conn->close();

include "../php/query-template-end.php"; //HTML Template
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Query</title>
    <link rel="stylesheet" href="../style.css">

    <script>
    window.onload = function () { 
        var chart = new CanvasJS.Chart("chartContainer", {
            animationEnabled: true,
            exportEnabled: true,
            theme: "light1", // "light1", "light2", "dark1", "dark2"
            title:{
                text: "PHP Line Chart from Database - MySQLi"
            },
            data: [{
                type: "column", //change type to column, bar, line, area, pie, etc  
                dataPoints: <?php echo json_encode($dataPoints, JSON_NUMERIC_CHECK); ?>
            }]
        });
        chart.render(); 
    }
</script>
    <link rel="text/javascript" href="../canvasjs.min.js">
</head>
<body>
    <div class="welcome">
        <h1>Information</h1>
        <a href="../adas22_sfu12.html">Go Home</a> <!-- TODO Make Nicer-->
    </div>

    <div class="query-section">

    <div id="chartContainer" style="height: 400px; width: 100%;"></div>
	<script src="https://canvasjs.com/assets/script/canvasjs.min.js"></script>



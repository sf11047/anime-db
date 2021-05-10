<?php
include "../php/query-template.php"; //HTML Template

include '../php/open.php';

//Begin Query PHP Code

    //Rest of query
    $opt = $_POST['q10'];

    if ($opt == "shows") {
        echo "<h1>What are the top 5 genres that have the most shows?<h1>";
    } else {
        echo "<h1>What are the top 5 genres that have the most viewers?<h1>";
    }

    echo '<div id="chartContainer" style="height: 500px; width: 50%;"></div>'; //Needed for canvasjs

    $myQuery = "CALL TopGenresPop(?);";
    $stmt = $conn->prepare($myQuery); 
    $stmt->bind_param("s", $opt);
    $stmt->execute();
    $result = $stmt->get_result();

    $dataPoints = array();

    while ($row = $result->fetch_assoc()) {
        array_push($dataPoints, array( "label"=> $row["genreName"], "y"=> $row["count"]));
    }

//End Query PHP Code
    $conn->close();
?>

<!-- Begin JS -->

<script type="text/javascript">
        window.onload = function () { 
            var chart = new CanvasJS.Chart("chartContainer", {
                animationEnabled: false,
                exportEnabled: true,
                theme: "light1", // "light1", "light2", "dark1", "dark2"
                title:{
                    text: "Top 5 Genres"
                },
                data: [{
                    type: "column", //change type to column, bar, line, area, pie, etc  
                    dataPoints: <?php echo json_encode($dataPoints, JSON_NUMERIC_CHECK); ?>
                }]
            });
            chart.render(); 
        }
</script>

<!-- End JS -->

<?php
include "../php/query-template-end.php"; //HTML Template
?>
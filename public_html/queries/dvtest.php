<?php
include "../php/query-template.php"; //HTML Template

include '../php/open.php';

//Begin Query PHP Code

    echo "<h1>".$query."<h1>"; //First line should be the question

    echo '<div id="chartContainer" style="height: 500px; width: 50%;"></div>';

    //Rest of query

//End Query PHP Code

?>

<!-- Begin JS -->

<script type="text/javascript">
    window.onload = function () {
          var chart = new CanvasJS.Chart("chartContainer", {
              data: [
              {
                  type: "column",
                  dataPoints: [
                  { x: 10, y: 10 },
                  { x: 20, y: 15 },
                  { x: 30, y: 25 },
                  { x: 40, y: 30 },
                  { x: 50, y: 28 }
                  ]
              }
              ]
          });
 
          chart.render();
      }
</script>

<!-- End JS -->

<?php
$conn->close();
include "../php/query-template-end.php"; //HTML Template
?>
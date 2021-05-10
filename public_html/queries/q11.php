<?php
include "../php/query-template.php"; //HTML Template

include '../php/open.php';

    echo "<h1>How many shows do people watch at once? Average? Max? Min? <h1>"; //First line should be the question

    $opt = $_POST['q11'];

    $myQuery = "Call MultiShows(?);";
    $stmt = $conn->prepare($myQuery); 
    $stmt->bind_param("s", $opt);
    $stmt->execute();
    $result = $stmt->get_result();

    while ($row = $result->fetch_assoc()) {
        if ($opt == "avg") {
            echo "Average number of shows people watch at once: ".$row['out']." </p>";
        } else if ($opt == "min") {
            echo "Minimum number of shows people watch at once: ".$row['out']." </p>";
        } else {
            echo "<p>Maximum number of shows people watch at once: ".$row['out']." </p>";
        }
    }

    $conn->close();
?>

<?php
include "../php/query-template-end.php"; //HTML Template
?>
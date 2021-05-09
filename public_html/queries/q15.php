<?php
include "../php/query-template.php"; //HTML Template

include '../php/open.php';

//Begin Query PHP Code

    echo "<h1>What shows have the best animation? Best story? Best characters?<h1>"; //First line should be the question

//End Query PHP Code

?>

<?php
$conn->close();
include "../php/query-template-end.php"; //HTML Template
?>
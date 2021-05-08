
<?php

include "../php/query-template.php"; //HTML Template

include '../php/open.php';

//Begin Query Code

    echo "<h1>".$query."<h1>"; //First line should be the question

    //Rest of query

//End Query Code

$conn->close();

include "../php/query-template-end.php"; //HTML Template
?>
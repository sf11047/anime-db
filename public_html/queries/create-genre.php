<?php
include "../php/query-template.php"; //HTML Template

include '../php/open.php';

//Begin Query PHP Code

    echo "<h1>Adding Genre<h1>"; //First line should be the question

    $genre = $_POST['genre'];
    $desc = $_POST['desc'];

    if (!preg_match('/^[a-zA-Z]+$/', $genre)) {
        echo "<h2 style='color: red;'>Genre should not have spaces and only include A-z and a-z.";
    }
    elseif (!preg_match('/^[A-Za-z0-9\s]+$/', $desc)) {
        echo "<h2 style='color: red;'>Description should only include alphanumerics and spaces.";
    }
    else {
        $myQuery = "Call CreateGenre(?,?);";
        $stmt = $conn->prepare($myQuery); 
        $stmt->bind_param("ss", $genre, $desc);
        $stmt->execute();
        $result = $stmt->get_result();
        while ($row = $result->fetch_assoc()) {
            echo "<h2>".$row['outMessage']."</h2>";
        }
    }

//End Query PHP Code

$conn->close();
?>
<?php
include "../php/query-template-end.php"; //HTML Template
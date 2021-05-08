<?php

include "../php/query-template.php"; //HTML Template

include '../php/open.php';

//Begin Query Code

    $query = "Test Question";
    echo "<h1>".$query."<h1>";

    $genreSelection = $_POST['genre'];
    echo "genre: ".$genreSelection." <br> </br>";

    $myQuery = "WITH PopularByGenre AS (SELECT MIN(AllMedia.rank) AS rank, BelongsTo.genreName FROM AllMedia JOIN BelongsTo on AllMedia.mediaID = BelongsTo.mediaID GROUP BY BelongsTo.genreName) SELECT PopularByGenre.genreName, AllMedia.mediaID, AllMedia.titleJPN, AllMedia.synopsis, AllMedia.rank, AllMedia.startDate, AllMedia.source FROM BelongsTo JOIN AllMedia ON BelongsTo.mediaID = AllMedia.mediaID JOIN PopularByGenre ON PopularByGenre.genreName = BelongsTo.genreName AND PopularByGenre.rank = AllMedia.rank;";
    $stmt = $conn->prepare($myQuery); 
    $stmt->execute();
    $result = $stmt->get_result();
    while ($row = $result->fetch_assoc()) {
        echo $row['name'];
    }
    echo "Finished";

//End Query Code

$conn->close();

include "../php/query-template-end.php"; //HTML Template
?>

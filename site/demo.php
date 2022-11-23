<html>
<body>

<?php
	echo "hello world!<br/>";

	// variables
	$i = 1;
	$texte = "hello";
	
	$i = $i + 1;
	
	for ($i = 0; $i < 3; $i++){
		echo "Je suis au tour de boucle n° $i <br/>";
	}

     $i = 0;
        while($i<3) {
                echo "Tour de boucle while $i </br>";
                $i++;
        }




	

	// boucle for
	for ($i=0; $i<3; $i++) {
	    echo "Tour de boucle for $i </br>";
	}

	echo "<br/>";

	// boucle while
	$i = 0;
	while($i<3) {
		echo "Tour de boucle while $i </br>";
		$i++;
	}

	echo "<br/>";

	// for each
	$tab = [];
	$tab[0] = "indice0";
	$tab[1] = "indice1";
	$tab[2] = "indice2";
	foreach ($tab as $val) {
		echo "$val </br>";
	}

	echo "<br/>";

	// tableaux associatifs
	$dico = ["1" => ["nom" => "toto", "prenom" => "tata", "attributs" => ["1", "2"]]];
	foreach ($dico as $key => $value) {
		echo "$key => $value </br>";
	}
?>
<table border="1">
<?php
	$dico = ["1" => ["nom" => "toto", "prenom" => "tata", "attributs" => ["1", "2"]], 
	"2" => ["nom" => "toto", "prenom" => "tata", "attributs" => ["1", "2"]]];
	foreach($dico as $key => $sub_dic) {
		$id_card = $key;
		echo "<tr><th>".htmlspecialchars($id_card)."</th></tr>";

		?>
		<table border="1">

		<?php

		foreach($sub_dic as $sub_key => $sub_value) {
		if ($sub_key == "attributs") {
			$sub_value = implode(",", $sub_value); 
		}
		echo "<tr><th>".htmlspecialchars($sub_key)."</th></tr>";
		echo "</th><td>".htmlspecialchars($sub_value)."</th></tr>";
		
		echo "</table>";

	}
	}

?>
</table>

</body>
</html>



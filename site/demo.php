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
	$dico = ["nom" => "toto", "prenom" => "tata"];
	foreach ($dico as $key => $value) {
		echo "$key => $value </br>";
	}
	
?>

</body>
</html>



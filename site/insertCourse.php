<?php
session_start() ;
error_reporting(E_ALL);

include ('config.php');
$req = DB::get()->prepare("insert into course (code, name, description) values (:code, :name, :description)");

// Utilisation d'un try... catch pour captuer et gérer proprement les erreurs potentielles.
try {
	$req->execute(array(
		'code' => $_POST['code'],
		'name' => $_POST['name'],
		'description' => $_POST['description']
		));
		// redirection
		header('location: ./courses.php');
} catch(PDOException $erreur) {
echo "Erreur ".$erreur->getMessage();
}

?>
</html>


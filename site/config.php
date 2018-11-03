<?php
class DB
{
	private static $instance = null;
	///////////// Paramètres de connexions avec DOCKER ///////////////////////////////////
	// Paramètres de connexion à la base de données
	private static $dbhost = "db"; // adresse du serveur : 'db', cf docker-compose.yml
	private static $dbport = 5432; // port du serveur
	private static $dbuname = "postgres"; // login
	private static $dbpass = "changeme"; // mot de passe
	private static $dbname = "simple-course"; // nom de la base de données
	////////////////////////////////////////////////////////////////////////////
	public static function get()
	{
	if(self::$instance == null)
	{
	   try
	   {
	    self::$instance =  new PDO("pgsql:host=".self::$dbhost.";dbname=".self::$dbname, self::$dbuname, self::$dbpass); // config CHEZ VOUS
		//self::$instance = new PDO("pgsql:user=VOTRE_LOGIN;dbname=VOTRE_LOGIN"); // => À LA FAC
		self::$instance->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);  // report des erreurs.
	   }
	   catch(Exception $e)
	   {
		die('Error : ' . $e->getMessage());
	   }
	}
	return self::$instance;
	}
	public static function disconnect() {
		self::$instance = null;
	}
}
// le code ci-dessous sert à tester la connexion.
/*
$r = DB::get()->query('select * from course;');
while($data = $r->fetch()) {
echo $data['code'];
}
*/
?>


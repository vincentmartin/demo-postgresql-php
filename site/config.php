<?php
class DB
{
	private static $instance = null;
	///////////// >> VOS PARAMÈTRES ICI  << ///////////////////////////////////
	// Paramètres de connexion à la base de données
	private static $dbhost = "localhost"; // adresse du serveur : 'localhost' si la base est sur la même machine que les pages PHP
	private static $dbport = 5432; // port du serveur
	private static $dbuname = "jean.dupont"; // votre login
	private static $dbpass = "tch"; // votre mot de passe
	private static $dbname = "simple-course"; // nom de la base de données
	////////////////////////////////////////////////////////////////////////////


	public static function get()
	{
	if(self::$instance == null)
	{
	   try
	   {
	       self::$instance =  new PDO("pgsql:host=".self::$dbhost.";dbname=".self::$dbname, self::$dbuname, self::$dbpass);
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
?>



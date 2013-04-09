<?php
session_start() ;
error_reporting(E_ALL);

include ('config.php');
$req = DB::get()->prepare("insert into course (code, name, description) values (:code, :name, :description)");
$req->execute(array(
    'code' => $_POST['code'],
    'name' => $_POST['name'],
    'description' => $_POST['description']
    )) or die(print_r($req->errorInfo(), true));
// redirection
header('location: ./courses.php');
?>
</html>


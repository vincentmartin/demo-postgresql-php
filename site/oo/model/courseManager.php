<?php
include ('../config.php');

function getCourses() {
	$req = DB::get()->query('select * from course');
	$courses = $req->fetchAll();
	return $courses;
}	

<?

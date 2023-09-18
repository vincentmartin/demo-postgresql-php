<?php
// initialisation de la session
// INDISPENSABLE À CETTE POSITION SI UTILISATION DES VARIABLES DE SESSION.
session_start();
error_reporting(E_ALL);
?>


<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cours disponibles</title>
    
    <!-- Inclure le fichier CSS de Bootstrap -->
    <link rel="stylesheet" href="bootstrap/css/bootstrap.min.css">

    <!-- Inclure le fichier JavaScript de Bootstrap (et jQuery, qui est requis) -->
    <script src="bootstrap/js/jquery.min.js"></script>
    <script src="bootstrap/js/bootstrap.min.js"></script>
</head>
<body>

<div class="container mt-5">
    <?php
    include('config.php');
    // On appelle la méthode statique get() de la classe DB qui renvoie une instance du PDO.
    $request = DB::get()->query('select * from course');
    ?>
  // ...

<h1 class="mb-4">Liste des cours disponibles</h1>
<table class="table table-bordered">
    <thead>
        <tr>
            <th>Code</th>
            <th>Nom</th>
            <th>Description</th>
            <th>Enseignant</th> <!-- Ajout de la colonne Enseignant -->
            <th>Action</th>
        </tr>
    </thead>
    <tbody>
        <?php
        // On récupère les données en utilisant une jointure entre COURSE et COURSE_TEACHER
        $query = 'SELECT c.code, c.name, c.description, p.first_name AS teacher_first_name, p.last_name AS teacher_last_name
                  FROM COURSE c
                  LEFT JOIN COURSE_TEACHER ct ON c.code = ct.code
                  LEFT JOIN PERSON p ON ct.teacher = p.email';
        $request = DB::get()->query($query);

        while ($data = $request->fetch()) {
            ?>
            <tr>
                <td><?php echo $data['code']; ?></td>
                <td><?php echo $data['name']; ?></td>
                <td><?php echo $data['description']; ?></td>
                <td>
                    <?php
                    if ($data['teacher_first_name'] && $data['teacher_last_name']) {
                        echo $data['teacher_first_name'] . ' ' . $data['teacher_last_name'];
                    } else {
                        echo 'N/A'; // Si aucun enseignant n'est associé au cours
                    }
                    ?>
                </td>
                <td>
                    <form method="post" action="deleteCourse.php" style="display: inline;">
                        <input type="hidden" name="course_id" value="<?php echo $data['code']; ?>">
                        <button type="submit" class="btn btn-danger btn-sm">Supprimer le cours</button>
                    </form>
                </td>
            </tr>
            <?php
        }
        $request->closeCursor();
        ?>
    </tbody>
</table>


    <!-- Formulaire Bootstrap -->
    <form method="post" action="insertCourse.php" class="mt-4">
        <h2>Ajout d'un cours</h2>
        <div class="mb-3">
            <label for="code" class="form-label">Code :</label>
            <input type="text" class="form-control" id="code" name="code">
        </div>
        <div class="mb-3">
            <label for="name" class="form-label">Nom :</label>
            <input type="text" class="form-control" id="name" name="name">
        </div>
        <div class="mb-3">
            <label for="description" class="form-label">Description :</label>
            <textarea class="form-control" id="description" name="description" rows="5"></textarea>
        </div>
        <button type="submit" class="btn btn-primary">Valider</button>
    </form>
</div>

</body>
</html>
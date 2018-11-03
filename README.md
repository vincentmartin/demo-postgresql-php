Application mininimale POSTGRESL+APACHE+PHP
=========

Ce projet illustre la création d'une base de données sous PostgreSQL en mettant en œuvre les rôles, les vues, les fonctions et les triggers.
Le dossier 'site' contient un exemple de pages PHP permettant l'interaction avec la base de données.

Lancement de l'application avec Docker
---------------

Dans ce répertoire, exécuter
```
docker-compose up
```

L'application est accessible à l'adresse [http://localhost:8080](http://localhost:8080). La base de données est accessible sur le port **5432** et l'interface graphique d'administration [http://phppgadmin.sourceforge.net/doku.php](phpPgAdmin) est accesible à l'adresse [http://localhost:8081](http://localhost:8081)

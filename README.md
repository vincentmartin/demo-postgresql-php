Application mininimale POSTGRESQL+APACHE+PHP
=========

Introduction
---------------

Ce projet illustre la création d'une base de données sous PostgreSQL en mettant en œuvre les rôles, les vues, les fonctions et les triggers.
Le dossier 'site' contient un exemple de pages PHP permettant l'interaction avec la base de données.

Un exemple minimal de cahier des charges et de réponse au besoin associé est disponible [ici](./CDC.md)

Lancement de l'application avec Docker
---------------

Dans ce répertoire, exécuter la commande :
```
docker-compose up
```

L'application est accessible à l'adresse [http://localhost:8080](http://localhost:8080). 

La base de données est accessible sur le port **5432** (login : **postgres**, mot de passe : **changeme**).

L'interface graphique d'administration de la base de données [pgadmin4](https://www.pgadmin.org/) est accesible à l'adresse [http://localhost:8081](http://localhost:8081) (login : **postgres@local.int**, mot de passe : **changeme**). À la première connexion, déclarer un nouveau serveur (Add New Server) en précisant son nom (eg. local), son l'hôte (db), l'identifiant (postgres) et le mot de passe (changeme).

Modification de la BDD
---------------

Modifier le script `simple-course.sql` et re-créer les conteneurs pour que les modifications soient prises en compte. 
Le script `simple-course.sql` est exécuté automatiquement au lancement de l'application.

Il est conseillé de d'abord tester les blocs de code SQL dans un terminal ou via **PgAdmin4** afin de s'assurer qu'ils soient corrects.


Modification de l'interface Web
---------------

Modifier les codes dans le dossier `site` et recharger la page dans le navigateur pour que les modifications soient prises en compte.
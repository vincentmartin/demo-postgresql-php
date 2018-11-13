# Cahier des charges

## Contexte (ou Introduction)

L'Université Pierre-Marie de Saint-Martin-la-Plaine a été créée en janvier de l'an 1890. Aujourd'hui, elle compte un peu plus de 500 étudiants et 28 enseignants. L'udUniversité a vu ses effectifs augmenter de 70% ces 10 dernières années et les membres du personnel administratif rencontrent de nombreuses difficultés dans l'organisation des cours et des emplois du temps.

Le contexte est donc celui de la gestion des cours et des emplois du temps que l'Université Pierre-Marie de Saint-Martin-la-Plaine souhaiterait améliorer.

## Problématiques

Moins de dix personnes sont en charge de la gestion administrative de l'Université et une seule personne est en charge (à mi-temps) des emplois du temps (Monsieur Robert). Monsieur Robert doit aujourd'hui faire de nombreuses heures supplémentaires pour parvenir à finaliser ses emplois du temps et à satisfaire l'ensemble du coprs enseignant.

Plusieurs problématiques se posent donc aujourd'hui et voici les plus critiques : 
* Comment gérer efficacement le listing des étudiants et des enseignants ?
* Comment gérer efficacement les cours dispensés et éviter les redondances ?
* Comment accélérer la création et la modification des emplois du temps afin de satisfaire, tant que faire se peut, aux besoins des enseignants ?


## Besoins

Des quelques problématiques décrites ci-dessus, on peut en déduire les besoins principaux besoins du système qui ne allons mettre en place. Les voici : 

* Lors des inscriptions en début d'année, pouvoir facilement inscrire un nouvel étudiant en n'oubliant aucune information ;
* Lors des quadriennals durant lequel les programmes sont refondus, pouvoir définir selon un formalisme durable dans le temps, la description des différents enseignements ;
* Pouvoir facilement créer un emploi du temps et accélérer les modifications tout en évitant les conflits.

## Solutions

Pour répondre à ce besoin, notre société a la solution ! Fort de 50 ans d'expérience dans les bases de données, nous savons précisément quelles solutions mettre en place pour transformer votre Université en une véritable machine digitale.

### Solutions fonctionnels

Voici les fonctionnalités qui seront offertes par l'application :
* Un système de gestion d'inscriptions dôté d'une intelligence capable de vérifier chacune des informations entrée et de vous proposer des solutions ;
* Un système de gestion des programmes pédagogiques ;
* Un système de gestion des emplois du temps permettant à chacun de demander une modification et d'avoir en temps réel une réponse de principe.

### Solutions techniques

D'un point de vue technique, nous proposons d'intégrer des technologies éprouvées, performantes et peu onéreuses : 

* Une base de données PostgreSQL pour la gestion et la manipulation des données. PostgreSQL est une base de données libre, sans coût de licence, et elle existe depuis plus de 20 ans
* Serveur Web Apache pour la délivrance des pages Web. Apache est aujourd'hui le serveur le plus populaire et dispose de nombreux modules.
* PHP pour la génération dynamique de pages web. PHP est un Langage simple et rapide à mettre en oeuvre pour la création de site web. Bibliothèques très fournies.
* Docker pour le packaging de l'application dans un environnement maîtrisée et cloisonné.

# Livrables

L'Université Pierre-Marie ne diposant d'aucun système Informatique, nous proposerons une machine "clefs en main" avec l'ensemble des composants déjà installés.

Lors des mises à jours, l'administrateur du système devra suivre la procédure suivante :
- Stopper les services 
```
docker-compose down
```
- Télécharger les mises à jours
```
git pull
```
- Redémarrer les services
```
docker-compose up
```
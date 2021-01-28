
############################################################
#                                                          #                                      
#### ----    Premiers pas avec R: les objets      ----  ####
#                   Caroline Patenaude                     #
#                       Mooc - ISDS                        # 
############################################################


# ==================== Intro: Télécharger et charger les packages utilisés ====================

# Toujours débuter son script par le code d'installation des packages nécessaires.
# Dans Colab, tous les packages sont téléchargés dans l'environnement d'exécution sur le nuage, 
# c'est pourquoi il faut les télécharger à chaque fois (contrairement à RStudio).
# Cette étape peut prendre plusieurs minutes.
# dep=TRUE: assure que tous les modules dépendants nécessaires seront aussi installés.

install.packages("questionr", dep = TRUE)
install.packages("Hmisc", dep = TRUE)
library(questionr)  # ou require()
library(Hmisc)


#* Télécharger des packages de Github ===================

library(devtools)
install_git("https://github.com/hadley/devtools.git") # package devtools 


#*  Gestion de packages ===================

# Voir les modules téléchargés (chargés ou non)
installed.packages()	

# Voir les modules chargés
search()

# Lister les fonctions d'un module chargé
library(help = questionr)

# Détacher un module chargé
detach(package:NomModule)   # pour éviter les conflits entre fonctions du même nom de différents modules

# Documenter les détails de son environnement de travail (système, packages, versions...)
sessionInfo()   # Important à noter pour assurer la reproductibilité des analyses


# ==================== 1. Les objets ====================

# R comme une grosse calculatrice
2+2

# Calcul simple
(12+15+20)/3 

# Créer un objet en utilisant l'opérateur d'assignation "<-" dans lequel on stocke le résultat du calcul
moyenne <- (12+15+20)/3 


# Pour voir le contenu de son objet, tapper son nom
moyenne  # Utilisation implicite de la fonction print() 


# ==================== 2. Les opérateurs ====================

#  Opérateurs d'assignation: **<-**, = , ->
#  Opérateurs de sélection: [], [[]], $, :
#  Opérateurs booléen: !, &, |
#  Opérateurs arithmétiques: +, -, *, /, ^
#  Opérateurs de comparaison: ==, !=, <, >, <=, >= 


# ==================== 3. Les fonctions ====================

#  Permettent d’effectuer des tâches prédéfinies comme des analyses, graphiques, calculs, … 
#  Chaque fonction a un nom et plusieurs fonctions peuvent permettre d'effectuer la même tâche: 
#  par exemple pour faire une correlation, on retrouve entre autres les fonctions cor(), cor.test(), ...
#  On appel une fonction en la nommant et on contrôle son comportement en paramétrant ses arguments.
#  On peut imbriquer les fonctions les unes dans les autres avec des parenthèses.

# Créer un nouvel objet nommé "age" composé d’une série de 5 nombres avec la fonction c() (concaténer)
age <- c(12, 15, 20, 35, 40) 

# Voir le contenu de l'objet 
age 

# Passer cet objet comme 1er argument de la fonction mean()
mean(age)

# Arrondir le résultat sans décimale (argument digits=) en imbriquant la fonction mean() dans la fonction round()
round(mean(age), digits=0) 


# ==================== 4.  Les arguments ====================

# Chaque fonction possède une liste plus ou moins longue d’arguments (paramètres ou options) permettant de paramétrer son fonctionnement
# Certains arguments ont une valeur par défaut. Si ces valeurs nous conviennent, pas besoin de les indiquer.
# Si l’argument n’a pas de valeur par défaut, il FAUT le renseigner.
# Pour modifier la valeur d’un argument, on le nomme et change sa valeur à la suite d’un =.
# La liste d’arguments respecte un ordre. Si on modifie chaque argument dans l’ordre, on peut omettre le nom des arguments. Les arguments peuvent donc être nommés ou non (mais pour assurer la reproductibilité, il est recommandé de toujours les nommer).
# Le premier argument, toujours les données (on ne le nomme généralement pas: x=).
# Comment savoir quels sont les arguments d’une fonction? Taper Help(NomFonction) ou ?NomFonction .


age <- c(25, 36, 47, 58, 69, NA)  # Créer un vecteur composé de 5 chiffres et une valeur manquante

## À noter: lorsque l'on stocke un nouveau contenu dans un  objet existant, le contenu initial est écrasé

mean(age)    # OUPS!

help(mean)  # Pour afficher l'aide d'une fonction (ou ?mean)

mean(age, na.rm=TRUE, trim = 0.05)

# L'argument na.rm=TRUE indique d'exclure les valeurs manquantes
# L'argument trim=.05 indique d'exclure les 5% les plus extrêmes
# Puisque les arguments sont nommés, il n'est pas nécessaire de respecter l'ordre indiqué:
# mean(x, trim = 0, na.rm = FALSE, ...)


# ==================== 5.  Les types d'objets ====================

# Les objets sont caractérisés par **différentes structures**
# On retrouve **5 différents types de contenants** ayant chacun leurs propriétés 

# 1.   **Vecteur**
# 2.   Liste
# 3.   Matrice
# 4.   Arrays (cubes)
# 5.   **Dataframe (tableaux)**


#** 5.1. Vecteurs ========================================

#  La brique élémentaire = série de valeurs.
#  En pratique, c’est une variable (mais qui n’est pas dans un tableau) et ses éléments sont ses valeurs.
#  Objet contenant des valeurs (éléments/composantes) d'un seul **mode**: numérique, textuel, logique. 


# On crée des vecteurs principalement avec la commande c()
poids <- c(70, 65, 60)  # vecteur numérique
sexe <- c("femme", "homme", "femme")  # vecteur textuel
taille <- c(TRUE, FALSE, FALSE, TRUE)  # vecteur booléen


# Pour voir le "format" des éléments stockés dans un objet, utiliser la fonction mode() ou typeof()
mode(poids)


# On peut faire des calculs entre vecteurs - exemple, calcul de l'IMC: poids divisé par taille au carré 

# crée un vecteur nommé "poids" avec la fonction c() composé de 3 éléments numériques
poids <- c(70, 65, 60) 

# crée un vecteur nommé "taille" avec la fonction c() composé de 3 éléments numériques au carré
taille <- c(1.45, 1.60, 1.70) ^ 2  

# diviser l'objet "poids" par l'objet "taille" (Attention! Les vecteurs doivent être de même longueur, sinon le principe de "recyclage" s'applique)
IMC <- poids / taille 

# voir le contenu de l'objet
IMC 

# obtenir la médiane des éléments de l'objet
median(IMC) 

# obtenir les différences à la moyenne des éléments de l'objet
IMC - mean(IMC) 


#** 5.2. Facteurs ========================================

# Vecteur avec des attributs spécifiques, dont la structure correspond aux variables qualitatives.
# Les modalités de la variable correspondent à des "niveaux" (*levels*) uniques et fixes, ie impossible d’assigner une valeur qui n’a pas été préalablement définie comme une des modalités.
# Des étiquettes (*labels*) peuvent être associées aux niveaux.
# Lors de l’importation de données, tout dépendant de la fonction d'importation, les variables qualitatives seront importées sous forme de *vecteur textuel* ou de *facteur*.

# Créer une variable de type facteur à partir d'un vecteur textuel de 4 valeurs de 2 niveaux avec la fonction factor()
sexe <- factor(c("H", "H", "F", "H"), labels = c("Homme", "Femme"))

# L'objet est un facteur avec 2 modalités (niveaux) définies par défaut en fonction des valeurs fournies 
str(sexe)


#** 5.3. Dataframes ========================================

#  Tableau de données pouvant regrouper des vecteurs de différents types (variables numériques et/ou textuelles).

#  Crée un jeu de données avec la fonction data.frame(), mais on le crée rarement manuellement dans R, généralement importé en format .txt, .csv...

# Créer un dataframe avec 3 variables (2 vecteurs numériques et 1 vecteur textuel) avec la fonction data.frame()
age <- c(45,65,22,38,54,31,29,44,56,67) 
poids <- c(150,125,210,175,110,180,130,155,190,120)
sexe <- c("H","F","F","H","H","F","F","H","F","H")
bd <- data.frame(age, sexe, poids)

bd

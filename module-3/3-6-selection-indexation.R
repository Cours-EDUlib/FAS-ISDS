
############################################################
#                                                          #                                       
#### ----               Indexation                 ---- ####
#                   Caroline Patenaude                     #
#                       Mooc - ISDS                        # 
############################################################


# Installation et chargement des modules nécessaires
install.packages("questionr", dep = TRUE) 
library("questionr")


# Téléchargement de la base de données hdv2003 du module questionr
# (Extrait de l'enquête "Histoire de vie" de l'Insee - https://www.insee.fr/fr/statistiques/2532244)
data(hdv2003)

# Copie de la base de données dans un objet (datatable) nommé bd
bd <- hdv2003


# Fonctionnalité permettant d’utiliser des opérateurs afin de sélectionner des variables/observations en fonction de différents critères
#   **Trois types** d'indexation: 1) par *position (directe)*, 2) par *nom*, 3) par *conditions logiques*.
#   Tous reposent sur le même principe: on utilise des **opérateurs** - soit des crochets (**[ ]**, **[[ ]]**) ou le signe **$** (si l’élément est nommé) pour identifier les valeurs spécifiques que l’on souhaite sélectionner ou pas.


# Rappel: un dataframe est composé de deux dimensions: rangées et colonnes
# Chaque élément qui compose ces dimensions (observations/variables) est "indexé", ie est numéroté en fonction de sa position dans la série d'éléments.

dim(bd)


# ==================== 1. Par position (directe)  ====================

#  Indique le rang du ou des éléments à sélectionner
#  **NomObjet[rangée, colonne]**


#* 1.1. Pour sélectionner une ou plusieurs variables ====================

#   NomObjet[rangée, **colonne**] 

bd[ ,2]       # Sélectionner la deuxième variable 

bd[ ,3:6]	    # Sélectionner les variables 3 à 6 (notez l'opérateur `:`, raccourci de la fonction `seq()`)

bd[ ,c(3,6)]	# Sélectionner les variables 3 et 6 (peut aussi sélectionner dans le désordre)

bd[ ,-2]    	# Sélectionner toutes les variables sauf la deuxième 

bd[ ,-(3:6)]	# Toutes les variables sauf 3 à 6 

bd[ ,-c(3,6)]	# Toutes les variables sauf 3 et 6 


#* 1.2. Pour sélectionner une ou plusieurs observations  ====================

#  Même principe, mais de l'autre côté de la virgule:
#  objet[**rangée**, colonne]

bd[3:6, ]       # Sélectionner les observations de 3 à 6


#* 1.3. Pour sélectionner des variables ET des observations  ====================

bd2 <- bd[1:100, c(1:5,10)] # Sélectionner les 100 premières observations et les variables de 1 à 5 et 10

## Pour créer une nouvelle base contenant une sélection de variables/observations, simplement placer la sélection dans un nouvel objet: bd2 <-*


bd2 # voir le contenu de la nouvelle bd2


# ==================== 2. Par nom  ====================

# Indique le nom du ou des éléments à sélectionner


#* 2.1. Avec l'opérateur [ ]  ====================


bd["relig"] # Sélectionner une variable (contenu textuel entre guillemets simples ou doubles)

bd[ ,c("occup", "relig")] # Sélectionner deux variables 


# On peut aussi mélanger les deux types d'indexation

bd[1:100, c("id", "age", "sexe", "nivetud", "relig")] # Sélectionner les 100 premières observations par position et 5 variables par nom


#* 2.2. Avec l'opérateur $ ====================

# $: Symbole "raccourci" pour rapidement sélectionner un seul élément nommé

bd$sexe # Sélectionner la variable sexe

bd$sexe[10:20] # Sélectionner les observations de 10 à 20 par position de la variable sexe

# La virgule n'est plus nécessaire puisque l'on applique notre condition à un élément qui n'a qu'une dimension, ie une variable

length(bd$sexe) # Nombre d'observations

str(bd$sexe) # Structure de la variable 

head(bd$sexe) # Premières observations de la variable


# ==================== 3. Par condition (opération logique)  ====================

# Sélection d'observations qui remplissent une ou des conditions en utilisant les opérateurs: 
# ==, !=, <, >, <=, >=


#* 3.1. Sélectionner selon une valeur de variable  ====================


# *Sélectionner les observations ayant la valeur "Femme" à la variable "sexe"* :

# 1. Créer d'abord une condition qui teste si la valeur de sexe est "Femme" et retourne une liste logique de vrai ou faux

bd$sexe=="Femme"

# ou procéder par la négative avec le sauf "!="

bd$sexe != "Homme" # (ne peut utiliser le "-" comme dans l'indexation directe)


# 2. Appliquer cette condition de sélection entre crochet à l'objet voulu (bd) pour créer une nouvelle base composée du sous-ensemble correspondant à TRUE


bd.f <- bd[bd$sexe=="Femme", ]
bd.m <- bd[bd$sexe=="Homme", ]

bd.m


#* 3.2. Sélectionner selon plusieurs conditions appliquées à une même variable  ====================

# *Sélectionner les répondants à la retraite ou au foyer (variable occup)*

bd[bd$occup == "Retraite" | bd$occup == "Au foyer", ] # avec l'opérateur | (ou)


#* 3.3. Sélectionner selon plusieurs conditions appliquées à plus d'une variable  ====================

# *Sélectionner les répondants âgés de 40 à 60 ans qui aiment la lecture ou le cinema*
  
bd[bd$age >= 40 & bd$age <= 60 & (bd$lecture.bd == "Oui" | bd$cinema == "Oui"), ]

# Mais ATTENTION! Avec l'indexation directe, il faut s'assurer qu'il n'y a pas de NA dans les variables de conditions. 

bd.cadre <-bd[bd$qualif=="Cadre" & bd$age<50, c("id","qualif", "age")] 

# La présence de NA dans une condition fait que la ligne correspondante sera conservée par l’indexation. 
bd.cadre 

# Faut utiliser !is.na()
bd.cadre2 <-bd[bd$qualif=="Cadre" & bd$age<50 & !is.na(bd$qualif) & !is.na(bd$age), c("id","qualif", "age")]

# Il vaut mieux utiliser la fonction subset()


#* 3.4. La fonction subset()  ====================

bd.cadre3 <- subset(bd, qualif=="Cadre" & age<50, select= c(id,qualif, age))

# Indique le nom de notre base en premier - plus besoin de spécifier bd$qualif...
# Pas besoin de guillemets autour des noms de variables
# Argument select= pour sélectionner des variables spécifiques, sans guillemets


# ==================== 4. Les valeurs manquantes  ====================


# Plusieurs fonctions sont à connaitre lorsque l'on travaille avec des données qui incluent des valeurs manquantes:


is.na(bd$age)

# Test logique :  vrai ou faux
# Identifier les cas qui ont une valeur manquante dans une variable sous forme de vecteur logique


which(is.na(bd), arr.ind=TRUE) # Identifier les cas qui ont une valeur manquante dans le jeu de données complet

# is.na()  applique test logique
# which()  retourne les numéros de lignes qui remplissent la condition (TRUE)
# arr.ind= permet d'appliquer le principe sur toutes les colonnes
# Retourne une matrice composée du numéro de l'observation et du numéro de colonne où se trouve les NA
# Pour identifier les cas d'une variable spécifique is.na(bd$occup)


sum(is.na(bd$qualif)) # Compte des valeurs manquantes dans une variable


sum(!is.na(bd$qualif)) # Compte des valeurs non manquantes (! sauf) dans une variable


bd <- na.omit(bd) # Élimiter toutes les lignes ayant au moins une valeur manquante


bd$age[which(is.na(bd$age))] <- mean(bd$age, na.rm=TRUE) # Imputation: remplacer NA par la moyenne


bd.qualif <-bd[complete.cases(bd$qualif), ] # Créer une nouvelle base de données en éliminant tous les cas qui ont au moins une valeur manquante dans la variable qualif


############################################################
#                                                          #                                       
#### ---- Importer et explorer une base de données ---- ####
#                    Caroline Patenaude                    #
#                        Mooc - ISDS                       # 
############################################################


# Installation et chargement des modules nécessaires
install.packages("questionr", dep = TRUE)
library("questionr")


# ==================== 1. Importer une base de données ====================

# Procédures varient selon l'environnement de travail

#** 1.2. Dans R, RStudio, ... --------------------------

#  Il existe plusieurs fonctions (natives R ou de modules divers) pour importer des fichiers de divers formats (.txt, .csv, .sav, .xls, .dta, .sas7bdat, ...). 
#  Chaque fonction a ses particularités (arguments) qui auront un impact sur la conversion des données, par exemple: le traitement des valeurs manquantes, des étiquettes de valeurs, le format des variables qualitatives (facteur ou chaine de caractères), des dates, des décimales.
#  RStudio permet également d'importer un fichier via des fonctions automatisées dans le menu du haut.


### Fichiers csv
read.table("fichier.csv", sep=",", header=TRUE) 


### Fichiers txt
read.table("fichier.txt", header = TRUE, sep = " ", na.strings = c(".", "99"))

# read.table: fonction de base, il faut spécifier les arguments sep et header
# header=TRUE: la première ligne contient le nom des variables
# sep=" ":les données sont séparées par ...
# na.strings=c(".", "99") indique que les valeurs manquantes sont codées par ...

# À noter: tout dépendant de la configuration de votre espace de travail, il se peut qu'il soit nécessaire d'indiquer le chemin complet menant 
# vers l'emplacement du fichier de données (C:/Users/.../.../MonFichier.csv")
# Par souci de reproductibilité, utiliser des chemins relatifs et non absolus.


### Fichier excel
read_excel("fichier.xls") 

# Module readxl (fait partie de tidyverse mais doit être chargé individuellement)


### Fichier SPSS
read_spss("fichier.sav", user_na = TRUE) 

# Module haven (fait partie de tidyverse mais doit être chargé individuellement)
# Pour les codes de valeurs manquantes, utiliser l’option user_na = TRUE    
# Les valeurs manquantes codées ne seront pas converties en NA et conserveront leur statut manquant
# Plusieurs autres fonctions disponibles dans haven: read_sav, read_dta, read_sas, read_csv, read_csv2, ...


#** 1.3 Les bases de données intégrées aux modules --------------------------


# Voir toutes les bases de données intégrées aux modules (installés ou non)

data(package = .packages(all.available = TRUE))


## À noter:, plusieurs modules ont été développés spécifiquement pour importer et travailler avec des données publiques 

#  [WDI](https://cran.r-project.org/web/packages/WDI/index.html) (indicateurs de développement de la Banque mondiale)
#  [cancensus](https://cran.r-project.org/web/packages/cancensus/vignettes/cancensus.html) (recensements canadiens)


# Importer une base de données d'un module chargé

## Voir les bases de données dans un module chargé particulier
data(package="questionr") 

## Importer une base de données dans un module chargé particulier
data(hdv2003)

# Extrait de l'enquête "Histoire de vie" de l'Insee - https://www.insee.fr/fr/statistiques/2532244

# R a automatiquement créé un objet au nom de la base importée dans notre environnement de travail
hdv2003


# ==================== 2. Faire une copie (et renommer) sa base dans un nouvel objet ====================

bd <- hdv2003

# À noter: dans les capsules suivantes, les commandes pour importer et copier la base de données hdv2003 seront intégrées au premier bloc de code (installation des modules) du notebook*.


# ==================== 3. Voir la liste des objets (base de données) présents dans la session ====================

ls() 


# ==================== 4. Supprimer un  objet  ====================

rm(hdv2003)  # Supprimer la base de données originale


rm(aaa, bbb, ccc)  # Supprimer plus d'un objet
rm(list = ls()) # Supprimer tous les objets


# ==================== 5. Afficher le contenu de sa base de données   ====================

bd # visualiser la base de données complète

head(bd) # visualiser les 6 premières observations (modifier le nombre par défaut après une virgule: (bd, 4))

tail(bd) # visualiser les 6 dernières observations


# ==================== 6. Afficher les noms de variables/colonnes   ====================

names(bd) # noms des variables


# ==================== 7. Afficher le nombre de rangées et de colonnes (dimensions)   ====================

length(bd) # nombre de variables

ncol(bd) # nombre de variables

nrow(bd) # nombre d'observations

dim(bd) # nombre de dimensions (colonnes et lignes)


# ============ 8. Examiner les caractéristiques sa base de données: classe, taille, structure   =============

class(bd) # type d'objet

str(bd)    # description plus détaillée de la structure du tableau 

describe(bd) # Module questionr - description plus détaillée des variables du tableau
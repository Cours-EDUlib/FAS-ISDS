
############################################################
#                                                          #                                       
#### ----         Manipuler des variables          ---- ####
#                    Caroline Patenaude                    #
#                        Mooc - ISDS                       # 
############################################################

# Installation et chargement des modules nécessaires
install.packages("questionr", dep = TRUE)
library(questionr)


# Téléchargement de la base de données hdv2003 du module questionr
# (Extrait de l'enquête "Histoire de vie" de l'Insee - https://www.insee.fr/fr/statistiques/2532244)
data(hdv2003)

# Copie de la base de données dans un objet (datatable) nommé bd
bd <- hdv2003


# ==================== 1. Modifier une valeur de variable  ====================


# Sélectionner la première observation de la variable quantitative age 
bd$age[1]

# Modifier la valeur 
bd$age[1] <-  38

# Sélectionner la première observation de la variable qualitative (facteur) sexe 
bd$sexe[1]

# Modifier la valeur (information textuelle entre guillemet)
bd$sexe[1] <- "Homme"

# Modifier avec une autre valeur 
bd$sexe[1] <- "Autre" # NON! Puisque c'est un facteur, la modalité (levels) doit avoir été prévue (ça fonctionnerait pour une variable "caractère")

# Il faut d'abord modifier les niveaux permis avec la fonction factor() et son argument levels=
bd$sexe <- factor(bd$sexe, levels=c("Femme", "Homme", "Autre")) 


# ==================== 2. Renommer une variable  ====================


#* 2.1. Renommer une ou plusieurs variables ====================

# Modifier un ou plusieurs noms de variables avec la fonction names() et l'indexation par position

names(bd)[c(3,4)] <- c("SEXE", "NIVETUD") # On renomme les variables 3 et 4 avec des noms en majuscule 

names(bd) # Lister l'ensemble des noms de variables


#* 2.2. Renommer une seule variable ====================

# Avec la fonction "rename.variable" du module "questionr"

rename.variable(bd, "clso", "Classe")  # (NomObjet, "ancien nom", "nouveau nom")


# ==================== 3. Supprimer une ou plusieurs variables  ====================

bd$cuisine <- NULL # supprimer une variable

bd[ ,c(5,15)] <- NULL # Supprimer plusieurs variables


# ==================== 4.  Renommer des modalités de variables catégorielles  ====================

# La procédure diffère en fonction du format de la variable qualitative: *character* ou *factor*

# Avec l'indexation par condition

# Si la variable qualitative est de type "character", on peut procéder comme suit
# Mais si c'est un "factor", on ne peut en renommer directement les modalités (niveaux) 
bd$sport[bd$sport == "Non"] <- "NON"
bd$sport[bd$sport == "Oui"] <- "OUI"

# On peut d'abord transfomer le facteur en format caractère et ensuite en renommer les modalités
bd$lecture <- as.character(bd$lecture)
bd$lecture[bd$lecture=="Non"]<- "NON"
bd$lecture[bd$lecture=="Oui"]<- "OUI"

str(bd$lecture) # la variable lecture est maintenant en format caractère

# Pour reconvertir la variable caractère en facteur, utiliser la fonction factor
bd$lecture <- factor(bd$lecture)

## À noter: tous les formats de variables peuvent être transformés avec les fonctions: *as.numeric*, *as.character*, *as.factor*.
## Attention, certaines transformations de formats sont plus délicates que d'autres.


# ==================== 5. Redoder/agréger des modalités de variables catégorielles  ====================


#* 5.1. Avec l'indexation par condition ====================

# On procède de la même façon que pour renommer
# L'agrégation se fait donc simplement en attribuant le même nom à différentes catégories
# On peut d'abord transformer la variable en format caractère comme ci-haut avec la fonction as.character()
# On peut également recoder directement dans une nouvelle variable (ici bd$relig.rec) qui sera en format caractère

# Agréger et renommer des catégories de la variable "relig" dans la nouvelle variable bd$relig.rec
bd$relig.rec[bd$relig == "Pratiquant regulier"] <- "Pratiquant"
bd$relig.rec[bd$relig == "Pratiquant occasionnel"] <- "Pratiquant"
bd$relig.rec[bd$relig == "Appartenance sans pratique"] <- "Croyant"
bd$relig.rec[bd$relig == "Ni croyance ni appartenance"] <- "Athée"
bd$relig.rec[bd$relig == "Rejet"] <- "ND"
bd$relig.rec[bd$relig == "NSP ou NVPR"] <- "ND"

str(bd$relig.rec) # Fonction str() pour voir le format de notre nouvelle variable


#* 5.2. Avec la fonction factor() et ses arguments levels= et labels= ====================

# L'option labels de la fonction factor permet aussi de renommer ou agréger les niveaux d'un facteur
bd$relig.rec2 <- factor(bd$relig, levels = c("Pratiquant regulier","Pratiquant occasionnel", "Appartenance sans pratique", "Ni croyance ni appartenance", "Rejet", "NSP ou NVPR"), labels = c("Pratiquant", "Pratiquant", "Croyant", "Athée", "ND", "ND"))

## Argument levels= permet de lister (et réordonner au besoin) les niveaux présents dans le facteur
## Argument labels= permet de spécifier de nouveaux intitulés et d'agréger les niveaux listés selon l'ordre dans l'argument levels
## Pour des facteurs ordonnés (variables ordinales), remplacer la fonction factor() par ordered()


#* 5.3. Avec la fonction ifelse() ====================

# Permet de créer une variable dichotomique sur la base des valeurs d'une ou plusieurs variables 

# Une variable : 
# Créer une variable dichotomique identifiant les "actifs" et "inactifs"
bd$occup.dico <- ifelse(bd$occup=="Exerce une profession", "Actif", "Inactif")  

## Test de condition
## valeur à assigner si le test est vrai ("Actif")
## valeur à assigner si le test est faux ("Inactif")


# Deux variables : 
# Créer une variable identifiant si les répondants sont des femmes retraitées, Oui ou Non:

bd$femme.ret <- ifelse(bd$sexe == "Femme" & bd$occup == "Retraite", "Oui", "Non")

## ifelse() peut aussi être utilisée pour recoder en dichotomique une variable numérique : 
## bd$age >=50 (la variable sera de format caractère)


# ============= 6. Recoder des variables numériques en catégorielles (transformer en facteur)  =============

# Avec la fonction cut(): découpe la variable quantitative

bd$age.cat <- cut(bd$age, breaks=c(0, 20, 40, 60, 80, 100), labels=c("20 ans et moins", "21 à 40", "41 à 60", "61 à 80", "81 et plus"), ordered_result=TRUE)

## breaks=: limites des catégories (peut aussi simplement indiquer le nombre de groupes (breaks=5), mais le résultat n'est pas optimal)
## (40,60]: signifie que 40 est exclu et 60 est inclu, donc 41 à 60
## labels: intitulés
## include.lowest=T: valeur minimale est incluse dans la première classe (par défaut, la borne de gauche des intervalles est ouverte)
## ordered_result=: définir une variable ordinale

str(bd$age.cat)


# ============= 7. Créer/Calculer des variables  =============


bd$annee <- 2003 - bd$age    # année de naissance (enquête date de 2003) 

bd$age.ecart <- bd$age - mean(bd$age, na.rm = TRUE) # écart entre l'âge du répondant et la moyenne

# Calculer un score d'items (moyenne ou somme)
bd$sum <- rowSums (bd[ , c("var1", "var2", "var3")], na.rm=TRUE)
bd$moy<- rowMeans (bd[ , c("var1", "var2", "var3")], na.rm=TRUE)

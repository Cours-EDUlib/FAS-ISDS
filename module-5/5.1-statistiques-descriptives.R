
############################################################
#                                                          #                                       
#### ----         Statistiques descriptives        ---- ####
#                    Caroline Patenaude                    #
#                        Mooc - ISDS                       # 
############################################################


# Installation et chargement des modules nécessaires
install.packages("questionr", dep = TRUE)
install.packages("car", dep = TRUE)
install.packages("psych", dep = TRUE)
install.packages("Hmisc", dep = TRUE)
library(car)
library(questionr)
library(psych)
library(Hmisc)


# Téléchargement de la base de données hdv2003 du module questionr
# (Extrait de l'enquête "Histoire de vie" de l'Insee - https://www.insee.fr/fr/statistiques/2532244)
data(hdv2003)

# Copie de la base de données dans un objet (datatable) nommé bd
bd <- hdv2003


# ==================== 1. Statistiques descriptives univariées  ====================


#* 1.1. Fonction générique summary()  ====================

#   Fournit les principales mesures de tendance centrale et de dispersion d’une distribution avec quartiles 
#   C’est une fonction dont le comportement s’adapte au type d’objet
#   Élimine d'emblée les valeurs manquantes

summary(bd) # Résumé de la base de données 

summary(bd$age) # Résumé d'une variable quantitative

summary(bd$occup) # Résumé d'une variable qualitative


#* 1.2. Autres fonctions pour indicateurs individuels  ====================

# Fonctions diverses permettant d'explorer les indicateurs de centralité et de dispersion pour variable quantitative
# Toujours ajouter na.rm=T en argument

median(bd$heures.tv, na.rm=TRUE)

mean(bd$heures.tv, na.rm=TRUE)

max(bd$heures.tv, na.rm=TRUE)

min(bd$heures.tv, na.rm=TRUE)

sum(bd$heures.tv, na.rm=TRUE)

range(bd$heures.tv, na.rm=TRUE)

var(bd$heures.tv, na.rm=TRUE)

sd(bd$heures.tv, na.rm=TRUE)

quantile(bd$heures.tv, na.rm=TRUE)


## Fonctions de normalité

skew(bd$heures.tv, na.rm=TRUE) # module psych

kurtosi(bd$heures.tv, na.rm=TRUE) # module psych


## Fonctions de transformation: normalité & rang

bd$age.log <- log(bd$age, base=10)     # Logarithme (, base=10)

bd$age.sqrt <- sqrt(bd$age)    # Racine carrée

bd$age.scale <- scale(bd$age, center = TRUE, scale = TRUE)    # Standardisation: centrage et réduction (Zscore)


#* 1.3. La très utile fonction apply() ====================

# Pour appliquer une fonction sur plusieurs variables à la fois
apply(bd[ ,c("age", "heures.tv","freres.soeurs")], na.rm=TRUE, MARGIN=1, FUN=mean)

## c() indique les variables à utiliser dans le calcul
## MARGIN=2: calcul à travers les participants (ici moyenne de colonnes), =1 est à travers les rangées
## FUN=mean: la fonction à appliquer, pourrait être n'importe laquelle comme somme, variance...


#* 1.4. Table de fréquences ====================

# Fonction table() - Tableaux d'effectifs 

table(bd$freres.soeurs)    # var numérique

tb.cat <- table(bd$qualif) # var quali (résultat pareil à summary())

## Exclu NA par défaut, sinon il faut utiliser l’argument useNA ="always" ou "ifany"
## On place la table dans un nouvel objet pour pouvoir lui appliquer d'autres opérations


# Autres fonctions pertinentes

prop.table(tb.cat) # Appliquée à une table pour transformer les valeurs en proportions


# Afficher en % et arrondir

round((prop.table(tb.cat))*100) 


# Fonction freq (module questionr)

freq(bd$qualif) # affiche les NA par défaut


# Fonction freq: nombreux arguments utiles possibles

freq(bd$qualif, cum = TRUE, total = TRUE, sort = "inc", digits = 0, exclude = NA)

## cum: afficher ou non les % cumulés
## total: ajouter les effectifs totaux
## sort: trier le tableau par fréquence croissante (sort="inc") ou décroissante (sort="dec")
## digits: arrondir
## exclude: exclure valeurs manquantes


# ==================== 2. Statistiques descriptives bivariées  ====================


#* 2.1. Tableaux croisées ====================

# Fonction table() et cie.

# 1er argument var en ligne (x), 2e var en colonne (y)

tb <-table(bd$trav.satis, bd$sexe) 

## pour un tableau à plus de deux niveaux, simplement ajouter une virgule puis variable additionnelle


tb # Tableau de distribution de la satisfaction au travail selon le sexe


# Ajouter les totaux des effectifs
addmargins(tb)    

# % Totaux 
prop(tb)       


# % Totaux
prop.table(tb, margin = 2)    

## margin = 1 pour proportion en rangées
## margin 2 = pour proportion en colonnes
## *100


# rprop et cprop de questionr pour %

cprop(tb, percent = TRUE)    # % en colonnes

## Argument percent pour afficher les %

rprop(tb, percent = TRUE, digits = 0)    # % en lignes

## Argument digits pour arrondir


#* 2.2. Comparer des groupes : by() et tapply()  ====================

# Les très pratiques fonctions by() et tapply() (variante de la fonction apply)
# Permettent d'appliquer une fonction sur une variable quantitative (1er) selon les modalités d'une variable catégorielle (2iem)

by(bd$age, bd$sexe, mean, na.rm=TRUE)

tapply(bd$age, bd$sexe, mean, na.rm=TRUE)

tapply(bd$relig, bd$sexe, table) 

tapply(bd$relig, bd$sexe, freq)


#* 2.3. Fonction xtabs - Notation formule  ====================

# Repose sur l'utilisation de la notation formule qui définit les relations entre les variables : NomFonction(VD ~ VI).
# Puisque le tableau croisé n'attribue pas de rôle spécifique aux variables, on place les deux variables après le tilde: ~ x + y.
# On indique le nom du tableau après la virgule.

xtabs (~ sexe + occup, bd)
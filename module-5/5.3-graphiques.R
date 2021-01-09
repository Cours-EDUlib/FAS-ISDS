
############################################################
#                                                          #                                       
#### ----              Les graphiques              ---- ####
#                    Caroline Patenaude                    #
#                        Mooc - ISDS                       # 
############################################################

# Installation et chargement des modules nécessaires
install.packages("questionr", dep = TRUE)
install.packages("car", dep = TRUE)
install.packages("ggplot2", dep = TRUE)
library(questionr)
library(car)
library(ggplot2)


# Téléchargement de la base de données hdv2003 du module questionr
# (Extrait de l'enquête "Histoire de vie" de l'Insee - https://www.insee.fr/fr/statistiques/2532244)
data(hdv2003)

# Copie de la base de données dans un objet (datatable) nommé bd
bd <- hdv2003


# Deux principales familles de fonctions graphiques


# 1.   Fonctions natives
# 2.   Fonctions GGplot2


# ============== 1. Quatre graphiques de base: plot(), hist(), boxplot(), barplot() ==============

#* 1.1. La fonction générique plot()  --------------------------

# le graphique produit dépend du type d'objet fourni


#** 1.1.1. Variable qualitative = Graphique à barres  -----------

plot(bd$trav.satisf) 


#** 1.1.2. Variable quantitative = Nuage de points  -----------

plot(bd$freres.soeurs) 


#** 1.1.3. Table d'effectifs (ou proportions) = Graphique à barres  -----------

plot(table(bd$freres.soeurs))

# Fonctions de base s'accompagnent de nombreux arguments dont plusieurs peuvent être utilisés pour tous les graphiques**

plot(table(bd$freres.soeurs), 
col="red", 
main = "Nombre de frères et soeurs", 
ylab = "Effectif", 
xlab="Nombre de frères et soeurs", 
ylim=c(1, 500),
xlim=c(0, 25),
type="b")

## col=    couleur des barres
## main=   titre du grahique
## ylab=   titre de l'axe y
## xlab=   titre de l'axe x
## ylim=   graduation de l'axe y
## xlim=   graduation de l'axe x
## type=   style de lignes
### h	lignes verticales
### p	points
### l	lignes
### o	et b lignes et points
### s escaliers


#** 1.1.4. Variables quanti/quanti = Nuage de points ------------

plot(bd$age, bd$heures.tv) 

# Modifications possibles parmi tant d'autres: faire varier les points selon les valeurs d'une autre variable par l'ajout de fonctions superposées

plot(bd$age, bd$heures.tv)  # var quanti/quanti
points(bd$age[bd$sexe=="Homme"], bd$heures.tv[bd$sexe=="Homme"], pch=16, col="steelblue")
points(bd$age[bd$sexe=="Femme"], bd$heures.tv[bd$sexe=="Femme"], pch=16, col="orange")
legend("topright", legend=c("Homme","Femme"), col=c("steelblue","orange"), pch=c(16))

## plot()    nuage de points
## points()  création d'une séquence de points colorés superposés en fonction de valeurs de variables sélectionnées par condition
## pch=      style de points
## col=      couleur des points
## legend()  ajout d'une légende et ses arguments de paramétrage


colours() # Voir la liste des couleurs de base


#** 1.1.5. Variables quali/quanti = Boite à moustaches ---------------

plot(bd$sexe, bd$heures.tv) 

## variable indépendante à gauche (x), dépendante à droite (y)
## Notation formule: les formules passent la variable y en premier, donc la notation formule de la fonction générique plot(x, y) est plot(y ~ x)


#** 1.1.6. Variable quantitative = Graphique de densité ---------------

# Ajout de la fonction de densité à la fonction plot()

plot(density(bd$heures.tv, na.rm = TRUE), main = "Heures d'écoute de télé")


# Ajout de la fonction lines() qui permet de superposer plusieurs éléments graphiques

plot(density(bd$age[bd$sexe == "Femme"]),  lwd = 3, col = "red", main = "Titre du graphique")
lines(density(bd$age[bd$sexe == "Homme"]),  lwd = 3, col = "blue")

## lwd=  largeur des lignes


#* 1.2. Diagramme à barres: fonction barplot() --------------------

tb.eff <- table(bd$trav.satis, bd$sexe) # tableau d'effectifs
tb.prop <- cprop(tb.eff, total = FALSE) # tableau de proportions


# Graphique à barres avec table d'effectifs superposés

barplot(tb.eff , legend = levels(bd$trav.satis))

## legend = levels pour faire apparaitre les catégories de la variable choisie


# Graphique à barres avec table de proportions

barplot(tb.prop, beside = TRUE, xlab = "Satisfaction", ylab = "pourcentages", las=2, ylim=c(0, 100),
        col = c("blue", "green", "orange"), legend = levels(bd$trav.satis))

## beside = TRUE  barres côtes à côtes
## las=2          intitulés à la verticale


#* 1.3. Histogramme: fonction hist() ------------------------

hist(bd$age) 


# Histogramme avec quelques arguments

hist(bd$age, main = "Age", col="violetred2", breaks = 8, xlab = "Age", ylab = "Effectif", labels = TRUE)

## main=   titre du grahique
## col=    couleur des barres
## breaks= nombre de "barres"
## xlab=   titre de l'axe x
## ylab=   titre de l'axe y
## labels= affichage des valeurs
## Pour ajouter une ligne de densité:
### argument prob = TRUE affichage de la ligne de densité
### fonction lines(density(bd$age, na.rm = TRUE), lwd = 4, col = "green")


#### La très pratique fonction par()

par(mfrow = c(1, 2), bg="gray", col.axis="green", mar=c(5, 5, 5, 5))
hist(bd$age[bd$sport == "Oui"], main = "Sportif", col = "chartreuse2")
hist(bd$age[bd$sport == "Non"], main = "Non sportif", col = "cyan4")

## par()       disposition des graphiques
## bg=         couleur du "background"
## col.axis=   couleur de la numérotation des axes
## mar=        grosseur des marges


#* 1.4. Boite à moustaches --------------

boxplot(bd$heures.tv, main="Heures d'écoute de la télé", col="green", xlab = "légende horizontale", ylab = "Heures d'écoute" )

# Comparer groupe avec la notation "formule" (y ~ x)

boxplot(age ~ hard.rock, bd)


#* 1.5. Autres graphiques divers ---------------------

#** Graphique mosaique -----

mosaicplot(sport ~ sexe, bd, las = 1, shade = TRUE, main="Niveau de qualification selon le sexe")

## Chaque boite correspond à une cellule
## largeur: pourcentages en colonnes
## hauteur: pourcentages en lignes
## Couleurs: résidus du chi2


#** diagramme Q-Q (Module car) -----

qqPlot(bd$heures.tv, col=colors()[9], col.lines=colors()[30], lwd=4, pch=1) 

## Compare à une distribution normale, quantile par quantile
## Trace en pointillé l'intervalle de confiance à 95%
## Identifie les points les plus éloignés de leur quantile normal
## col=       sélection de couleurs des points par position dans la palette colors()
## col.lines= sélection de couleurs des lignes par position dans la palette colors()
## lwd=       largeur des lignes
## pch=       type de points


#** Nuage de points + ligne de régression non paramétrique et boites à moustache sur les axes (Module car) ----

scatterplot(heures.tv ~ age,  data=bd) 



# ============== 2. Package graphique ggplot2 (grammar of graphics) ==============

# ggplot fonctionnne en superposant des composantes (couches)
# ggplot() spécifie le tableau source des données
# geom(): géométrie, ie choix du graphique (ex:geom_histogram)
# aes(): aestetics, ie propriétés visuelles incluant l’axe des x , des y, la couleur des lignes ( colour ), ...
# Ensuite on peut personnaliser avec des titres, légendes, thèmes, facettes et tout un tas d'options

https://ggplot2.tidyverse.org/reference/ 

  
#* 2.1. geom_histogram = Histogramme ----------------------

ggplot(bd) +                  # objet bd
geom_histogram(aes(x = age))  # histogramme de la variable age

## Argument aes() imbriqué ici dans le geom() mais peut aussi être défini dans le ggplot()


ggplot(bd) + 
geom_histogram(aes(x = age), fill="orchid1", colour = "white", binwidth = 5) +  # arguments de couleurs et largeur des barres
ggtitle("Age des répondants") +   # titre du graphique
xlab("Age") +                     # titre axe x
ylab("Effectifs")                 # titre axe y


#***  Le *faceting* -----------------

# Le "faceting" permet d’effectuer plusieurs fois le même graphique selon les valeurs d’une ou plusieurs 
# variables qualitatives, içi facet_grid(~sexe)

ggplot(bd) +  
geom_histogram(aes(x = age), fill="orchid1", colour = "white", breaks = c(0, 20, 40, 60, 80, 100)) +  # breaks= limites des catégories d'âge
ggtitle("Age des répondants") +   # titre du graphique
  xlab("Age") +                     # titre axe x
  facet_grid(~sexe)                 # variable de groupes


#* 2.2. geom_bar - Graphique en barres --------------------

ggplot(bd) + 
  geom_bar(aes(x = trav.satisf), fill = "thistle3", width = .7) + 
  xlab("Satisfaction") +
  ylab("Effectifs") + 
  ggtitle("Satisfaction au travail") 


#*** Le *mapping* ---------------------

# Pour faire varier la couleur en fonction des valeurs prises par d'une autre variable, on réalise un "mappage"
# on doit alors placer l’attribut graphique (ici fill=) à l’intérieur de aes()

ggplot(bd) + 
  geom_bar(aes(x = occup, fill = sexe))                     # position = "stack" - effectifs de groupes superposés par défaut

ggplot(bd) + 
  geom_bar(aes(x = occup, fill = sexe), position = "dodge") # position = "dodge" - effectifs de groupes  côte à côte

ggplot(bd) + 
  geom_bar(aes(x = occup, fill = sexe), position = "fill")  # position = "fill" - proportions superposées des groupes


#* 2.3. geom_point: Nuage de points -----------------------

ggplot(bd) + 
  geom_point(aes(x = age, y = freres.soeurs, color = sexe), size=3, pch=19) + 
  scale_color_brewer("sexe", palette = "Accent") +
  theme(legend.position = "bottom", legend.box = "vertical") # ou appliquer des thèmes prédéfinis comme theme_dark()


## color= à l'intérieur de aes() permet de faire varier la couleur des points en fonction des valeurs d’une troisième variable 
## Modier la grosseur des points avec size= et le type avec pch=
## Autre répertoire de couleurs scale_color_brewer: RColorBrewer::display.brewer.all()
## theme() fonction permettant de personnaliser l'apparence des graphiques:
### permet d'appliquer des thèmes complets (ex: theme_dark()) ou des composantes spécifiques - voir aide ?theme

ggplot(bd) + 
  geom_point(aes(x = age, y = heures.tv, color=sexe, size=heures.tv), alpha=0.2) +
  scale_size("Heures de télé", range = c(1,10)) +
  scale_x_continuous("Age", limits = c(15,100)) +
  scale_y_continuous("Heures de télé", limits = c(0,15))

## size= déplacé à l'intérieur de eas permet de faire varier la grosseur des points selon une variable quantitative
## alpha= modifier la transparence
## scale() permet de définir les limites des échelles x et y et leur légende respective


### ajouter une droite de régression + lignes de densité
ggplot(bd, aes(x=age, y=freres.soeurs)) +
  geom_point(col="steelblue2") +
  geom_smooth(method="lm", col="thistle3") +
  geom_density2d(color = "orange") + 
  scale_x_log10()


#* 2.4. geom_boxplot - boite à moustache ---------------

# On passe en y la variable quanti et en x la variable quali
ggplot(bd) + 
geom_boxplot(aes(x = trav.satisf, y =age), varwidth = TRUE, fill = "midnightblue", color = "chartreuse1") + # varwidth = largeur de la boite selon les effectifs de groupes
ggtitle("Pratique de la religion")


# On fait varier la couleur selon une variable sexe et on "flip" le tout
ggplot(bd, aes(x = sexe, y = freres.soeurs, color = sexe)) + geom_boxplot() + coord_flip()

#* 2.5. geom_density - densité ---------------------

# Distribution de l'âge selon le sexe - densité superposée avec transparence

ggplot(bd, aes(x = age, color = sexe, fill=sexe)) + 
  geom_density(alpha=0.55)
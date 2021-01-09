
############################################################
#                                                          #                                       
#### ----          Analyses statistiques           ---- ####
#                   Caroline Patenaude                     #
#                       Mooc - ISDS                        # 
############################################################


# Installation et chargement des modules nécessaires
install.packages("car", dep = TRUE)
install.packages("questionr", dep = TRUE)
install.packages("effects", dep = TRUE)
library(effects)
library(car)
library(questionr)


# Téléchargement de la base de données hdv2003 du module questionr
# (Extrait de l'enquête "Histoire de vie" de l'Insee - https://www.insee.fr/fr/statistiques/2532244)
data(hdv2003)

# Copie de la base de données dans un objet (datatable) nommé bd
bd <- hdv2003


# ==================== 1. Les tests statistiques ====================


# On retrouve une multitude de modules dédiés aux méthodes statistiques (comme stats, MASS, FactoMineR, plm, glm). 
# La même méthode peut se trouver avec variantes dans plusieurs modules. 
# Les exemples ci-dessous proviennent principalement du module stats (module par défaut) où l'on retrouve de nombreuses fonctions pour différents types d'analyse.


#* 1.1. Notation formule et objet modèle --------------------------

mod <- nom.test(VD ~ VI)

# Souvent utilisé dans les modèles d'analyse (régressions...) et les graphiques.
# Peut s'interpréter comme en "fonction de...": variable dépendante (effet) en fonction (~) de la var indépendante (cause).
# Toutes les fonctions n'acceptent pas la notation formule, mais elle est utilisée dans la plupart des modèles d'analyse.
# On stocke l'analyse dans un objet qui contiendra les résultats qui, selon l'analyse, inclueront un ensemble d'éléments d'information auxquels on pourra accéder de deux façons:
  
# En passant notre objet-modèle à différentes fonctions génériques (selon le type de test):
  
mod <- lm(y ~ x, data=NomObjet) # Créer son objet modèle
mod                             # Tappe le nom de l'objet pour voir un résumé des résultats
summary(mod)                    # ensemble des résultats détaillés
coef(mod)                       # coefficients et erreurs standards
residuals(mod)                  # résidus
confint(mod)                    # intervalles de confiance
fitted(mod)                     # valeurs ajustées
anova(mod)                      # appliquer analyse de variance sur modèle
predict(mod)                    # calculer des valeurs prédites à partir d'un modèle
plot(mod)                       # et nombreuses autres fonctions graphiques  


# En utilisant la fonction names(NomObjet) et en sélectionnant individuellement le nom de l'élément avec l'opérateur $:
  
mod <- lm(y ~ x)                # Créer son objet modèle
names(mod)                      # Voir les éléments du résultat
mod$coefficients                # Sélectionner l'élément individuel

## À noter: par défaut les résultats sont présentés selon la **notation scientifique**. Pour la désactiver, utiliser l'instruction: options(scipen = 999). Pour la réactiver: options(scipen = 0)*


#* 1.2. Les modalités de référence --------------------------

# Dans R, il n'est pas nécessaire de recoder ses variables en "dummy", les analyses s'en chargent par défaut lorsqu'on utilise des variables qualitatives.
# Mais attention à la **modalité de référence** des facteurs définie par défaut: la première dans la liste des niveaux.


# Pour voir la modalité de référence

levels(bd$sport) # "Non"


# Pour modifier la catégorie de référence - fonction relevel()

bd$sport <- relevel(bd$sport, ref = "Oui")


# ==================== 2.  Intervalle de confiance ====================

#* 2.1. Intervalle de confiance d’une proportion --------------------------


# fonction prop.test

prop.test(table(bd$sport))

## Calcul l'intervalle pour la première catégorie du tableau


options(scipen = 999) # désactiver la notation scientifique


# Modifier la catégorie de référence avec la fonction relevel directement dans la fonction table()

prop.test(table(relevel(bd$sport, "Oui")))


#* 2.2. Intervalle de confiance d'une moyenne --------------------------


# Fonction t.test

t.test(bd$age, conf.level=.99)

## Changer le niveau de confiance avec l'argument (bd$age, conf.level=.x)


# ==================== 3.  Test du Khi-carré ====================

# Passe la table comme argument à la fonction chisq.test() (Module questionr)

mod.chi <- chisq.test(bd$sport, bd$sexe) 

## Applique correction par défaut, sinon ajouter argument: ,correct=FALSE


# Résumé des résultats

mod.chi 


# Fonction names() pour voir les éléments d'information de nos résultats

names(mod.chi)


# Voir les valeurs attendues

mod.chi$expected


# Fonction chisq.residuals() du module questionr pour les résidus

tab <- table(bd$sport, bd$sexe)
chisq.residuals(tab) 


# ==================== 4. Test de fisher ====================

fisher.test(bd$sport, bd$sexe)


# ==================== 5. Différence de moyennes entre deux groupes (Test T) ====================

# *Vérifier si les moyennes d'une variable quantitative de deux groupes sont statistiquement différentes*


#* Explorer les statistiques descriptives selon les groupes avec la fonction by() ==========

by(bd$age, bd$sport, FUN=summary)
by(bd$age, bd$sport, FUN=var)


#* Normalité des distributions - Test de Shapiro-Wilk ==========

## Avec la fonction by

by(bd$age, bd$sport, FUN=shapiro.test)


#* Égalité des variances - test F ==========

var.test(age ~ sport, data = bd)


#* Test de Levene (module car) ==========

leveneTest(bd$age, bd$sport) # Accepte aussi notation formule


#* Test T  ==========

t.test(age ~ sport, data = bd)

## Par défaut, la fonction t.test est un test de Welsh qui ne suppose pas égalité des variances

# Pour un test t classique, ajouter l'argument var.equal = TRUE

t.test(age ~ sport, data=bd, var.equal= TRUE)

## Pour un test d'échantillons appariés (mesures répétées), ajouter argument paired=TRUE (sans notation formule)


# ==================== 6. Test Wilcoxon/Mann-Whitney ====================

# test non-paramétrique parmi d'autres

wilcox.test(age ~ sport, data = bd)


########## À NOTER - erreur de numérotation: 7. ANOVA et 7. Corrélations ###########


# ==================== 7. Différence de moyenne pour plus de deux groupes (ANOVA) ===================

# *Évaluer la relation entre une variable quantitative et une variable qualitative avec plus de deux modalités*


#* Explorer les statistiques descriptives avec la fonction tapply() ==========

tapply(bd$heures.tv, bd$occup, mean, na.rm=T)

## Vérifier si les moyennes semblent différentes entre les groupes


#* Fonction aov ==========

mod.aov <- aov(heures.tv ~ occup, data=bd)

## Créé un objet contenant le modèle
## Pour voir effet combiné entre facteurs mod.aov <- aov(heures.tv ~ occup*sexe, bd)


#* Voir un résumé du modèle ==========

mod.aov


#* Fonction summary ==========

summary(mod.aov)

## Applique la fonction summary à l'objet modèle pour voir résultats détaillés


#* Fonction lm ==========

mod.lm <- lm(heures.tv ~ occup, bd)

## Peut également utiliser fonction de régression linéaire pour analyse de variance
## Permet de voir les contrastes entre les différents groupes
## La modalité de référence est "Exerce une profession" (levels(bd$occup))
## Pour changer modalité de référence, utiliser la commande relevel: mod.lm <- lm(heures.tv ~ relevel(occup, ref="Etudiant, eleve"), data=bd)
## Possède aussi un argument subset= permettant de sélectionner des modalités. Par exemple: 
## mod2.lm <- lm(heures.tv ~ occup, bd, subset = occup %in% c("Exerce une profession", "Chomeur", "Etudiant, eleve"))


# Résumé des coefficients

mod.lm


# Résultats détaillés

summary(mod.lm)

## Applique la fonction summary à l'objet modèle -> Coefficients + Tests associés (Test t, degré de significativité)


#* Fonction anova ==========

anova(mod.lm)

## Peut aussi obtenir des résultats d'analyse de variance (somme des carrés, degré de liberté,  valeur de F...) en appliquant anova à l'objet modèle
## À noter: Les fonctions aov() et anova() retourne la somme des carrés de type I


# ==================== 7. Corrélations ====================

# Fonction cor()

cor(bd$age, bd$heures.tv, use="pairwise")

## Matrice de corrélations pour deux variables quanti ou plus
## pairwise: n'utiliser que les paires d'observations complètes
## pour Spearman, rajouter argument ,method = "spearman"
## instruction suivante si plus de deux variables: cor(bd[ ,c("age", "heures.tv", "freres.soeurs")], use='pairwise')


# Fonction cor.test()

cor.test(bd$age, bd$heures.tv)

## Ou notation formule cor.test( ~ age + heures.tv, bd)


# ==================== 8. Régression linéaire ====================

# *Prédire la valeur d'une variable dépendante continue sur la base des valeurs de variables indépendantes*


# Fonction lm()

# Quelles variables prédisent les heures de télé écoutées?

mod1.lm <- lm(heures.tv ~ occup + nivetud + sexe, data=bd) 

## On stocke le résultat dans un objet modèle pour pouvoir le manipuler avec d'autres fonctions
## Pour limiter à un sous-groupe: argument ( , subset= age > 50")


# Passe notre objet modèle à la fonction summary pour voir le tableau des coefficients et leur test de significativité

summary(mod1.lm)


# La fonction coef présente les coefficients du modèle de régression et peut s'appliquer individuellement 

coef(mod1.lm)


# la fonction confint présente les intervalles de confiance (95% par défaut)

confint(mod1.lm)


# Pour le tableau ANOVA appliqué au modèle de régression

anova(mod1.lm)


# La fonction fitted fournit les valeurs ajustées

head(fitted(mod1.lm))


# La fonction resid() founit les résidus de la régression

head(resid(mod1.lm))


# ==================== 9. Régression logistique binaire ====================

# *Prédire une variable dépendante dichotomique sur la base des valeurs de variables indépendantes*
  

# Fonction glm
  
mod.reg <- glm(sport ~ sexe + nivetud + qualif, bd, family = binomial(logit))

## La fonction glm permet de calculer plusieurs modèles statistiques que l'on indique avec l’argument family=binomial(logit) 


# Applique fonction summary au modèle pour voir les résultats 

summary(mod.reg)


# La fonction coef permet aussi de sélectionner les coefficients individuellement

coef(mod.reg)[1]


# La fonction exp pour les odds ratio et leurs intervalles de confiance

exp(coef(mod.reg))

## Aussi la fonction odds.ratio(mod.reg) du module questionr


# ==================== 10. Visualiser les résultats d'un modèle ====================


# Exemple du module effects

# Résultat de l'ANOVA

plot(allEffects(mod.aov))


# Résultat de la régression linéaire - effet de tous les prédicteurs

plot(allEffects(mod1.lm))


# Résultat de la régression linéaire - effet d'un seul prédicteur

plot(Effect("occup", mod=mod1.lm))
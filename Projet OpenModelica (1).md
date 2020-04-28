Projet OpenModelica
===================

*Réalisé par :* **NAGIHI Achraf**

I-Introduction
--------------

**Modelica** est un langage de modélisation orienté objet destiné à la
modélisation pratique de systèmes complexes ; par exemple, des systèmes
comportant des composantes mécaniques, électriques, hydrauliques ou thermiques.
Son usage se rapproche des langages VHDL-AMS et Verilog-A (tous deux issus de
l'industrie électronique) dans le sens où il décrit un système sous la forme
d'un ensemble d'équations. Le simulateur associé a pour tâche de résoudre le
système d'équations à chaque pas temporel.

**OPENMODELICA** est un environnement de modélisation et de simulation open
source basé sur Modelica destiné à un usage industriel et académique. Son
développement à long terme est soutenu par une organisation à but non lucratif -
l'Open Source Modelica Consortium (OSMC)

II-Exemple 1 : Marslanding
--------------------------

### A-Cadrage du projet

#### 1-Définition de l'objectif

**MarsLanding** est un modèle pour but de simuler un atterrissage réussi de
Curiosity sur Mars.

#### 2-Définition des paramètres et variables utilisés

| **Paramètre et variable** | **Valeur**                   | **Description**                                        |
|---------------------------|------------------------------|--------------------------------------------------------|
| Curiosity.mass            | Start (1038.358 kg)          | La masse de la rocket Curiosity.                       |
| Mars.mass\*               | 6.39 × 10\^23 kg             | La masse de la planète Mars.                           |
| Mars.raduis\*             | 3.389.5 × 10\^6 m            | Le rayon de la planète Mars.                           |
| curiosity.thrust          | (L'objectif de la recherche) | La poussée de curiosité.                               |
| Curiosity.altitude        | start ( 59404 m)             | L'altitude de la rocket Curiosity.                     |
| Curiosity.velocity        | start (-2003 m/s)            | La vitesse de la rocket Curiosity.                     |
| Curiosity.acceleration    | \----------                  | L'accélération de la rocket Curiosity.                 |
| g                         | 6,674 × 10−11 m3 kg−1 s−2    | la constante gravitationnelle                          |
| Gravity                   | \-------                     | champ de force gravitationnelle.                       |
| massLossRate              | 0.000277                     | taux de perte de masse (car le carburant est consommé) |
| thrustEndTime             | 210 s                        | La duré de poussée.                                    |
| thrustDecreaseTime        | 43.2 s                       | Le temps de diminution de la poussée.                  |

**Note :** « \* » signifie qu'on a changé la valeur du paramètre par rapport à
l'exemple moonlanding.

#### 3-Définition des équations :

**a-Selon la 2-ème loi de newton la rocket est sous la force de gravité et la
force de poussée de son moteur :**

Acceleration=(thrust-mass•gravity)/mass

**b-Les équations différentielles de premier ordre du mouvement entre
l'altitude, la vitesse et l'accélération :**

mass' = -massLossRate • abs (thrust)

altitude' = velocity

velocity' = acceleration

**c-La force du champ de force gravitationnelle :**

gravity=(G.mars\*mass.mars)/(altitude.curiosity+radius.mars)\^2

###  B-Partie code 

#### 1-La classe Body

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
model Body "generic body"
Real mass;
String name;
end Body;
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#### 2-La classe CelestialBody

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
model CelestialBody "celestial body"
extends Body;
constant Real g = 6.672e-11;
parameter Real radius;
end CelestialBody;
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#### 3 -La classe Rocket

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
model Rocket "generic rocket class"
extends Body;
parameter Real massLossRate=0.000277;
Real altitude(start= 59404);
Real velocity(start= -2003);
Real acceleration;
Real thrust;
Real gravity;
Real thrust2;
equation
thrust - mass * gravity = mass * acceleration;
der(mass) = -massLossRate * abs(thrust);
der(altitude) = velocity;
der(velocity) = acceleration;
end Rocket;
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#### 4 -La classe MarsLanding

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
model MarsLanding
parameter Real force1 = 37845; // Résultat de l’étude paramétrique
parameter Real force2 = 2250; // Résultat de l’étude paramétrique
parameter Real thrustEndTime = 210;
parameter Real thrustDecreaseTime = 43.2;
Rocket curiosity(name="curiosity", mass(start=1038.358) );
CelestialBody mars(mass=6.39e23,radius=3.3895e6,name="mars");
equation
curiosity.thrust = if (time<thrustDecreaseTime) then force1
else if (time<thrustEndTime) then force2
else 0;
curiosity.thrust2=force1*1;
curiosity.gravity = mars.g*mars.mass /(curiosity.altitude+mars.radius)^2;
when (curiosity.altitude < 0 or curiosity.altitude >59405 ) then // termination condition
terminate("Curiosity touches the ground of Mars");
end when;
end MarsLanding;
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

### C-Étude paramétrique


En premier lieu on a créé un script pour faire plusieurs simulations en même
temps, le script va faire un balayage des paramètres (parameter sweep),
c'est-à-dire mettre à jour les paramètres **(force1,force2)** et et relancer la
simulation sans compiler le modèle,et enregistrer les résultats dans différents
fichiers .csv.

[Exemple d'une base de données contenant les résultats d'une
simulation](https://drive.google.com/open?id=1O-cMrdF-8jB8pz29e40YelPIL6tGXmsw)


Le script est créé dans un Bloc-note avec l'extension .mos (ouvert avec OMC un
compilateur de OpenModelica)

#### 1-Script généré par OMC (un compilateur de OpenModelica)

Ce script génère 2500 fichiers .csv sous forme des bases de données contenant
les résultats de chaque simulation,ces fichiers peuvent être ouverts avec Excel,
on va donc traiter ces bases données avec VBA Excel pour trouver le bon couple
des forces (force1, force2).

On a commencé par les intervalles suivant (force1 [36000 , 38000] avec un pas de
50, et force2[1000,3000] avec un pas de 50) et après après avoir traité les
données (partie suivante) on a limité les intervalles à (force1[37800,37900],
avec un pas de 5, et force2[2200 ,2300] avec un pas de 5).

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
cd();
loadModel(Modelica);
getErrorString();
loadFile("Body.mo");
getErrorString();
loadFile("CelestialBody.mo");
getErrorString();
loadFile("Rocket.mo");
getErrorString();
loadFile("MarsLanding.mo");
getErrorString();
buildModel(MarsLanding,stopTime=210,outputFormat="csv");
getErrorString();
for j in 0:49 loop
       force1 := 36000+ j*50;
for i in 1:50 loop
force2 := 1000 + i*50;
system("MarsLanding -override=force2="+String(force2)+",force1="+String(force1)+" -r=MarsLanding" +String(i+j*50) + "_res.csv");
  getErrorString();
end for;
end for;
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#### Traitement des bases de données

#### 2-Code Vba combiner les fichiers

On a d'abord combiné tous les fichiers .csv dans un seul classeur(workbook)
c'est-à-dire copier les données de chaque fichier .csv dans différentes feuille
(sheet) du même classeur (workbook) avec un code Vba.

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Sub Combination()
    Dim FolderPath As String
    Dim Filename As String
    Dim Sheet As Worksheet
Application.ScreenUpdating = False
FolderPath = Environ("userprofile") & "\Desktop\modelica\Curioisity-final - 2\"
Filename = Dir(FolderPath & "*.csv*")
    Do While Filename <> ""
    Workbooks.Open Filename:=FolderPath & Filename, ReadOnly:=True
        For Each Sheet In ActiveWorkbook.Sheets
        Sheet.Copy After:=ThisWorkbook.Sheets(1)
        Next Sheet
    Workbooks(Filename).Close
    Filename = Dir()
    Loop
Application.ScreenUpdating = True
End Sub
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#### 3-Code Vba collecter les dernières lignes

Puisque la simulation se termine lorsque la rocket touche Mars donc on
s'intéresse qu'à la dernière ligne de chaque résultat pour évaluer la vitesse
d'atterrissage.

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Sub Collect()
    Dim arr()   As Variant
    Dim ws      As Worksheet
    Dim wMast   As Worksheet
    Dim x       As Long
    Dim y       As Long
 Set wMast = Sheets("data")
 Application.ScreenUpdating = False
       For Each ws In ActiveWorkbook.Worksheets
            With ws
If .Name <> wMast.Name Then
x = .Cells(.Rows.Count, 1).End(xlUp).Row
y = .Cells(x, .Columns.Count).End(xlToLeft).Column
arr = .Cells(x, 1).Resize(, y).Value
wMast.Cells(Rows.Count, 1).End(xlUp).Offset(1).Resize(, UBound(arr, 2)).Value = arr
Erase arr
End If
           End With
     Next ws
     Application.ScreenUpdating = True 
     Set wMast = Nothing
End Sub
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

### D-Résultats de l'étude paramétrique :

On présente Les résultats des intervalles suivants : force
1[37800,37900], avec un pas de 5, et la force2[2200 ,2300] avec un pas de 5. On
a filtré sur Curiosity.altitude pour afficher seulement les tests où la rocket à
toucher mars.

[Résultats de l'étude paramétrique](https://drive.google.com/open?id=1evMTxw0d4F-6IiMErCR6CjCTgmh3XCbY)

Donc la force2 idéale pour un atterrissage réussi est ( **2250** ) qui
correspond à la force 1 ( **37845** ).

### E-Vérification du couple (2250, 37845) sur OMEdit :

[Vérification du couple (2250, 37845) sur OMEdit](https://drive.google.com/open?id=1QFzvrT8-mpddHnw_sOQzsqXI0AmObBQT)

### F-Conclusion :

Dans ce rapport, l'étude paramétrique devrait faire l'objet d'un problème
d'optimisation, on a donc d'abord essayé d'utiliser l'outil OMOptim
(OpenModelica Optimization Editor), mais il ne fonctionne pas correctement et
présente plusieurs bugs.

III-Exemple 2 : FluidExample
----------------------------

### 1-Objectif :

**FluidExample** est un package contenant 2 exemples de modèles fluides,
l'objectif est de modifier le modèle Exemple2 pour ajouter une quatrième pipe
(pipe4) reliant la sortie de Pipe1 à boundary2.

**2-Modèle Exemple 2 (après la modification)**

[Modèle Exemple 2 (après la modification)](https://drive.google.com/open?id=1ezVKFBAsBvI3q2mHp3AtWuR0V3GHbxT7)

### 3-Tests de validation

##### **Paramètre**

| **Variable**                   | **Unit**                                         | **Description**                   |
|--------------------------------|--------------------------------------------------|-----------------------------------|
| **T**                          | K                                                | Température                       |
| **u**                          | J/kg                                             | Energie interne                   |
| **d**                          | kg/m\^3                                          | Densité                           |
| **p**                          | Pa                                               | Pression                          |
| **h**                          | J/kg                                             | Enthalpie spécifique              |
| **Nom**                        | Default                                          | Description                       |
| **replaceable package Medium** | Modelica.Media.Water.ConstantPropertyLiquidWater | Water: Simple liquid water medium |


**a-Pressure port-a :**

[a-Pressure port-a ](https://drive.google.com/open?id=1p5vsZ_qOcJPvewsVQZjYZ-SPgjr04qF1)

**b-Pressure port-b :**

[Pressure port-b](https://drive.google.com/open?id=1PnuogPNEVweTJexbKef_vb6cF3QKdspu)

**c-Mass-flow port-a**

[Mass-flow port-a](https://drive.google.com/open?id=1-QkhNQaxVyMzOu4FPtFyag7-L9Db87JJ)

**d-Mass-flow port-b :**

[Mass-flow port-b](https://drive.google.com/open?id=1w66fQWHnLWALqV9coidA9lvqIkV8Fmmo)

### 4-Conclusion :

###  Tous les paramètres restent constants pendant toute la simulation, et cela en raison des conditions aux limites statiques (Static Boundaries).

### Références :

[https://www.openmodelica.org](https://www.openmodelica.org/)

[https://en.wikipedia.org/wiki/OpenModelica](https://en.wikipedia.org/wiki/OpenModelica)

[https://en.wikipedia.org/wiki/Mars]( https://en.wikipedia.org/wiki/Mars)

[https://en.wikipedia.org/wiki/Modelica](https://en.wikipedia.org/wiki/Modelica)

[https://openmodelica.org/images/docs/tutorials/modelicatutorialfritzson.pdf](https://openmodelica.org/images/docs/tutorials/modelicatutorialfritzson.pdf)

[https://www.openmodelica.org](https://www.openmodelica.org)


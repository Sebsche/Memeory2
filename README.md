# memeory
Play Memeory!

![Memorykarte](https://github.com/GBBasel/Memeory2/blob/master/src/card/back.png)

[A memory with memes.](https://gbbasel.github.io/Memeory2/)

Das Ziel dieses Projektes ist es, ein Memory zu erstellen, das Memes (Bilder aus dem Internet, die verwendet werden, um eine Meinung oder einen Sachverhalt humorvoll darzustellen) als Kartenbilder verwendet. Diese können durch anklicken aufgedeckt werden. Wenn zwei Karten aufgedeckt wurden, wird kontrolliert, ob es sich um die Gleichen handelt. Ist dies der Fall, bleiben die Karten aufgedeckt, wenn nicht, drehen sie sich wieder um. Wenn man ein paar gefunden hat, darf man nochmals spielen. Man kann gegen eine andere Person spielen.

Während der Arbeit sind wir auf folgende, grosse Aufgaben gestossen:

* Randomized Gitter (Funktionelle Programmierung und Zufallszahlen sind nicht die besten Freunde)
* Wie müssen Bilder eingefügt werden? (Vor allem ein Problem in Hinsicht auf Aufgabe 1)
* on-Click Events ( Wiederum in Hinsicht auf Aufgaben 1 und 2)
* Richtige Antwort erkennen (Komplett andere Syntax im Vergleich zu Python)


## Randomized Gitter
Zunächst wird das Gitter mit den Funktionen initialModel (wie viele Karten?) und createBoard erstellt. Das Gameboard besteht aus Rows, diese aus Cards. Jede Karte besitzt drei Typen, die id, die Bildnummer und einen Status (Hidden, Visible, Found). Die id ist ein Integer zwischen 0 und 15. Die Bildnummer (pic) wird bei initialModel erzeugt. Es werden zwei Listen von 0 bis 7 erzeugt, zusammengehängt, und mit `shuffle` durcheinandergemischt. So entsteht ein Gitter, in welchem man die Zahlen aus den beiden Listen findet.

## Bilder einf�gen
Die Bilder werden mit einer einzigen Zeile hinzugefügt: `img [ src ("src/card/" ++ String.fromInt le_cell.pic ++ ".png")] []` Hier werden die zufällig erzeugten Zahlen in die Mitte der Bildadresse eingefügt. Diese Methode ist zwar einfach, benötigte aber einiges an Zeit für die Recherche.

## on-Click Events (Karten aufdecken)
Die Bilder werden beim Anklicken von verdeckten Karten angezeigt. Dabei wird der Status von Hidden auf Visible geändert. Nachdem zwei Karten ausgewählt wurden, können keine weiteren Karten aufgedeckt werden, es sei denn, es ist ein Kartenpaar. Unstimmige Kartenpaare können wieder angeklickt werden um wieder zugedeckt zu werden. übereinstimmende Kartenpaare bleiben aufgedeckt.

## Diskussion
Zu Beginn des Projektes hatten wir grosse Schwierigkeiten, uns in Elm hineinzuversetzen. Dies lag vor allem daran, dass es nicht so viel Informationsmaterial und Beispiele gab, wie das bei anderen Programmiersprachen der Fall ist. Wir wussten schlicht nicht, was wir wie tun sollten. Ziemlich zuletzt hat es jedoch geklickt und es war uns doch noch möglich, das Programm in einen funktionellen Zustand zu bringen. Somit haben wir das Ziel, ein Memoryspiel zu kreieren, erreicht. Mit dem Ergebnis sind wir zufrieden. Wir haben uns jedoch noch Gedanken darüber gemacht, was man noch verbessern könnte:

### M�gliche Erweiterungen
* Hintergrundmusik
* Resetknopf anstatt Seite neu laden
* Gefundene Karten werden farbig markiert
* Ästhetische Veränderungen
* Mehr Karten

# memeory
Play Memeory!

![Memorykarte](https://github.com/GBBasel/Memeory2/blob/master/src/card/back.png)

A memory with memes.

Das Ziel dieses Projektes ist es, ein Memory zu erstellen, das Memes (Bilder aus dem Internet, die verwendet werden, um eine Meinung oder einen Sachverhalt humorvoll darzustellen) als Kartenbilder verwendet. Diese k�nnen durch anklicken aufgedeckt werden. Wenn zwei Karten aufgedeckt wurden, wird kontrolliert, ob es sich um die Gleichen handelt. Ist dies der Fall, bleiben die Karten aufgedeckt, wenn nicht, drehen sie sich wieder um. Wenn man ein paar gefunden hat, darf man nochmals spielen. Man kann gegen eine andere Person spielen.

W�hrend der Arbeit sind wir auf folgende, grosse Aufgaben gestossen:

* Randomized Gitter (Funktionelle Programmierung und Zufallszahlen sind nicht die besten Freunde)
* Wie m�ssen Bilder eingef�gt werden? (Vor allem ein Problem in Hinsicht auf Aufgabe 1)
* on-Click Events ( Wiederum in Hinsicht auf Aufgaben 1 und 2)
* Richtige Antwort erkennen (Komplett andere Syntax im Vergleich zu Python)


## Randomized Gitter
Zun�chst wird das Gitter mit den Funktionen initialModel und createBoard erstellt. In initialModel werden mit einem Random-Befehl die Listen mit der Karteninformation durchgemischt und in das Gitter gesetzt.

## Bilder einf�gen
Die Bilder werden mit einer einzigen Zeile hinzugef�gt: `img [ src ("src/card/" ++ String.fromInt le_cell.pic ++ ".png")] []` Hier werden die zuf�llig erzeugten Zahlen in die Mitte der Bildadresse eingef�gt. Diese Methode ist zwar einfach, ben�tigte aber einiges an Zeit f�r die Recherche.

## on-Click Events (Karten aufdecken)
Die Bilder werden beim Anklicken von verdeckten Karten angezeigt. Dabei wird der Status von Hidden auf Visible ge�ndert. Nachdem zwei Karten ausgew�hlt wurden, k�nnen keine weiteren Karten aufgedeckt werden, es sei denn, es ist ein Kartenpaar. Unstimmige Kartenpaare k�nnen wieder angeklickt werden um wieder zugedeckt zu werden. �bereinstimmende Kartenpaare bleiben aufgedeckt.

## Diskussion
Zu Beginn des Projektes hatten wir grosse Schwierigkeiten, uns in Elm hineinzuversetzen. Dies lag vor allem daran, dass es nicht so viel Informationsmaterial und Beispiele gab, wie das bei anderen Programmiersprachen der Fall ist. Wir wussten schlicht nicht, was wir wie tun sollten. Ziemlich zuletzt hat es jedoch geklickt und es war uns doch noch m�glich, das Programm in einen funktionellen Zustand zu bringen. Somit haben wir das Ziel, ein Memoryspiel zu kreieren, erreicht. Mit dem Ergebnis sind wir zufrieden. Wir haben uns jedoch noch Gedanken dar�ber gemacht, was man noch verbessern k�nnte:

### M�gliche Erweiterungen
* Hintergrundmusik
* Resetknopf anstatt Seite neu laden
* Gefundene Karten werden farbig markiert
* �sthetische Ver�nderungen
* Mehr Karten

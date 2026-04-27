# =============================================================
#  PasswortManager_Einfach.ps1
#
#  Ein einfacher Passwort-Manager mit Fenster (GUI).
#  Geschrieben für Anfänger - mit vielen Kommentaren erklärt.
#
#  Starten:
#    powershell -ExecutionPolicy Bypass -File PasswortManager_Einfach.ps1
# =============================================================


# --- Diese zwei Zeilen laden Windows-Funktionen für Fenster und Grafik ---
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing


# =============================================================
#  DATEI-PFAD
#  Hier wird festgelegt, wo die Passwörter gespeichert werden.
#  Der Ordner "Dokumente" wird automatisch gefunden.
# =============================================================

$DateiPfad = "$env:USERPROFILE\Documents\meine_passwoerter.csv"


# =============================================================
#  FUNKTION: Passwörter aus Datei laden
#
#  Eine Funktion ist ein Codeblock den man immer wieder
#  aufrufen kann. Diese hier liest die CSV-Datei ein.
# =============================================================

function Lade-Passwoerter {

    # Prüfen ob die Datei schon existiert
    if (Test-Path $DateiPfad) {

        # Datei einlesen und als Tabelle (CSV) zurückgeben
        $daten = Import-Csv -Path $DateiPfad -Delimiter ";"
        return $daten

    } else {

        # Datei existiert noch nicht - leere Liste zurückgeben
        return @()
    }
}


# =============================================================
#  FUNKTION: Passwörter in Datei speichern
#
#  Diese Funktion schreibt alle Daten in die CSV-Datei.
#  CSV = Tabelle mit Semikolon getrennt (wie Excel)
# =============================================================

function Speichere-Passwoerter {

    # $liste wird als Parameter übergeben (die Daten die gespeichert werden sollen)
    param($liste)

    # Wenn die Liste leer ist, trotzdem eine leere Datei erstellen
    if ($liste.Count -eq 0) {

        # Leere Datei mit Kopfzeile anlegen
        "Dienst;Benutzername;Passwort;Notiz" | Out-File -FilePath $DateiPfad -Encoding UTF8

    } else {

        # Daten als CSV-Datei speichern
        $liste | Export-Csv -Path $DateiPfad -Delimiter ";" -NoTypeInformation -Encoding UTF8
    }
}


# =============================================================
#  FUNKTION: Zufälliges Passwort generieren
#
#  Hier wird ein Passwort aus zufälligen Zeichen erstellt.
# =============================================================

function Erstelle-Passwort {

    # Länge des Passworts als Parameter, Standardwert = 12
    param($laenge = 12)

    # Alle erlaubten Zeichen in einer langen Zeichenkette
    $zeichen = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%&*"

    # Leeres Passwort zum Befüllen
    $passwort = ""

    # Schleife: so oft wiederholen wie die gewünschte Länge
    for ($i = 0; $i -lt $laenge; $i++) {

        # Zufällige Zahl zwischen 0 und Anzahl der Zeichen
        $zufallsZahl = Get-Random -Minimum 0 -Maximum $zeichen.Length

        # Das Zeichen an der Zufallsposition zum Passwort hinzufügen
        $passwort += $zeichen[$zufallsZahl]
    }

    return $passwort
}


# =============================================================
#  HAUPT-FENSTER erstellen
#
#  Hier beginnt die Oberfläche (GUI).
#  Alles wird Schritt für Schritt zusammengebaut.
# =============================================================

# Das Hauptfenster (Form) erstellen
$Fenster = New-Object System.Windows.Forms.Form

# Titel oben in der Titelleiste
$Fenster.Text = "Passwort-Manager"

# Größe des Fensters: Breite x Höhe in Pixel
$Fenster.Size = New-Object System.Drawing.Size(700, 550)

# Fenster in der Mitte des Bildschirms öffnen
$Fenster.StartPosition = "CenterScreen"

# Fenstergröße nicht veränderbar machen
$Fenster.FormBorderStyle = "FixedSingle"
$Fenster.MaximizeBox = $false


# =============================================================
#  GRUPPE: Eintrag hinzufügen / bearbeiten
#
#  GroupBox = ein Rahmen mit Beschriftung der Felder gruppiert
# =============================================================

$GruppeEingabe = New-Object System.Windows.Forms.GroupBox
$GruppeEingabe.Text     = "Neuen Eintrag anlegen"
$GruppeEingabe.Location = New-Object System.Drawing.Point(10, 10)
$GruppeEingabe.Size     = New-Object System.Drawing.Size(670, 160)
$Fenster.Controls.Add($GruppeEingabe)


# --- Label = Beschriftungstext ---

$LabelDienst = New-Object System.Windows.Forms.Label
$LabelDienst.Text     = "Dienst / Website:"
$LabelDienst.Location = New-Object System.Drawing.Point(10, 25)
$LabelDienst.Size     = New-Object System.Drawing.Size(130, 20)
$GruppeEingabe.Controls.Add($LabelDienst)

# --- TextBox = Eingabefeld ---

$EingabeDienst = New-Object System.Windows.Forms.TextBox
$EingabeDienst.Location = New-Object System.Drawing.Point(145, 22)
$EingabeDienst.Size     = New-Object System.Drawing.Size(200, 23)
$GruppeEingabe.Controls.Add($EingabeDienst)


# Benutzername
$LabelUser = New-Object System.Windows.Forms.Label
$LabelUser.Text     = "Benutzername:"
$LabelUser.Location = New-Object System.Drawing.Point(10, 55)
$LabelUser.Size     = New-Object System.Drawing.Size(130, 20)
$GruppeEingabe.Controls.Add($LabelUser)

$EingabeUser = New-Object System.Windows.Forms.TextBox
$EingabeUser.Location = New-Object System.Drawing.Point(145, 52)
$EingabeUser.Size     = New-Object System.Drawing.Size(200, 23)
$GruppeEingabe.Controls.Add($EingabeUser)


# Passwort
$LabelPasswort = New-Object System.Windows.Forms.Label
$LabelPasswort.Text     = "Passwort:"
$LabelPasswort.Location = New-Object System.Drawing.Point(10, 85)
$LabelPasswort.Size     = New-Object System.Drawing.Size(130, 20)
$GruppeEingabe.Controls.Add($LabelPasswort)

$EingabePasswort = New-Object System.Windows.Forms.TextBox
$EingabePasswort.Location = New-Object System.Drawing.Point(145, 82)
$EingabePasswort.Size     = New-Object System.Drawing.Size(200, 23)
$GruppeEingabe.Controls.Add($EingabePasswort)


# Notiz
$LabelNotiz = New-Object System.Windows.Forms.Label
$LabelNotiz.Text     = "Notiz:"
$LabelNotiz.Location = New-Object System.Drawing.Point(10, 115)
$LabelNotiz.Size     = New-Object System.Drawing.Size(130, 20)
$GruppeEingabe.Controls.Add($LabelNotiz)

$EingabeNotiz = New-Object System.Windows.Forms.TextBox
$EingabeNotiz.Location = New-Object System.Drawing.Point(145, 112)
$EingabeNotiz.Size     = New-Object System.Drawing.Size(200, 23)
$GruppeEingabe.Controls.Add($EingabeNotiz)


# =============================================================
#  GRUPPE: Passwort-Generator
#  (rechts neben den Eingabefeldern)
# =============================================================

$GruppeGenerator = New-Object System.Windows.Forms.GroupBox
$GruppeGenerator.Text     = "Passwort-Generator"
$GruppeGenerator.Location = New-Object System.Drawing.Point(370, 20)
$GruppeGenerator.Size     = New-Object System.Drawing.Size(285, 130)
$GruppeEingabe.Controls.Add($GruppeGenerator)


# Label für Länge
$LabelLaenge = New-Object System.Windows.Forms.Label
$LabelLaenge.Text     = "Länge:"
$LabelLaenge.Location = New-Object System.Drawing.Point(10, 25)
$LabelLaenge.Size     = New-Object System.Drawing.Size(60, 20)
$GruppeGenerator.Controls.Add($LabelLaenge)

# NumericUpDown = Zahlen-Eingabefeld mit Pfeil rauf/runter
$EingabeLaenge = New-Object System.Windows.Forms.NumericUpDown
$EingabeLaenge.Location = New-Object System.Drawing.Point(75, 22)
$EingabeLaenge.Size     = New-Object System.Drawing.Size(60, 23)
$EingabeLaenge.Minimum  = 4    # Mindestlänge
$EingabeLaenge.Maximum  = 64   # Maximallänge
$EingabeLaenge.Value    = 12   # Standardwert
$GruppeGenerator.Controls.Add($EingabeLaenge)

# Button: Passwort generieren
$ButtonGenerieren = New-Object System.Windows.Forms.Button
$ButtonGenerieren.Text     = "Generieren"
$ButtonGenerieren.Location = New-Object System.Drawing.Point(10, 55)
$ButtonGenerieren.Size     = New-Object System.Drawing.Size(100, 28)
$GruppeGenerator.Controls.Add($ButtonGenerieren)

# Textfeld das das generierte Passwort anzeigt
$AnzeigeGeneriert = New-Object System.Windows.Forms.TextBox
$AnzeigeGeneriert.Location = New-Object System.Drawing.Point(10, 90)
$AnzeigeGeneriert.Size     = New-Object System.Drawing.Size(260, 23)
$AnzeigeGeneriert.ReadOnly = $true   # Nur lesen, nicht tippen
$GruppeGenerator.Controls.Add($AnzeigeGeneriert)

# Button: Generiertes Passwort ins Passwort-Feld übernehmen
$ButtonUebernehmen = New-Object System.Windows.Forms.Button
$ButtonUebernehmen.Text     = "Übernehmen"
$ButtonUebernehmen.Location = New-Object System.Drawing.Point(120, 55)
$ButtonUebernehmen.Size     = New-Object System.Drawing.Size(100, 28)
$GruppeGenerator.Controls.Add($ButtonUebernehmen)


# =============================================================
#  BUTTONS: Eintrag speichern / löschen
# =============================================================

$ButtonSpeichern = New-Object System.Windows.Forms.Button
$ButtonSpeichern.Text     = "Eintrag speichern"
$ButtonSpeichern.Location = New-Object System.Drawing.Point(10, 175)
$ButtonSpeichern.Size     = New-Object System.Drawing.Size(150, 30)
$Fenster.Controls.Add($ButtonSpeichern)

$ButtonLoeschen = New-Object System.Windows.Forms.Button
$ButtonLoeschen.Text     = "Eintrag löschen"
$ButtonLoeschen.Location = New-Object System.Drawing.Point(170, 175)
$ButtonLoeschen.Size     = New-Object System.Drawing.Size(150, 30)
$Fenster.Controls.Add($ButtonLoeschen)

$ButtonFelder = New-Object System.Windows.Forms.Button
$ButtonFelder.Text     = "Felder leeren"
$ButtonFelder.Location = New-Object System.Drawing.Point(330, 175)
$ButtonFelder.Size     = New-Object System.Drawing.Size(120, 30)
$Fenster.Controls.Add($ButtonFelder)

# Button: Passwort in die Zwischenablage kopieren
$ButtonKopieren = New-Object System.Windows.Forms.Button
$ButtonKopieren.Text     = "PW kopieren"
$ButtonKopieren.Location = New-Object System.Drawing.Point(460, 175)
$ButtonKopieren.Size     = New-Object System.Drawing.Size(120, 30)
$Fenster.Controls.Add($ButtonKopieren)


# =============================================================
#  LISTE: Alle gespeicherten Passwörter anzeigen
#
#  ListView = eine Tabelle die Einträge anzeigt
# =============================================================

$LabelListe = New-Object System.Windows.Forms.Label
$LabelListe.Text     = "Gespeicherte Einträge:"
$LabelListe.Location = New-Object System.Drawing.Point(10, 215)
$LabelListe.Size     = New-Object System.Drawing.Size(200, 20)
$Fenster.Controls.Add($LabelListe)

$Liste = New-Object System.Windows.Forms.ListView
$Liste.Location      = New-Object System.Drawing.Point(10, 235)
$Liste.Size          = New-Object System.Drawing.Size(670, 230)
$Liste.View          = "Details"    # Tabellenansicht
$Liste.FullRowSelect = $true        # Ganze Zeile markieren
$Liste.GridLines     = $true        # Gitterlinien anzeigen
$Liste.MultiSelect   = $false       # Nur einen Eintrag auswählen

# Spalten der Tabelle hinzufügen
$Liste.Columns.Add("Dienst / Website", 160) | Out-Null
$Liste.Columns.Add("Benutzername",     150) | Out-Null
$Liste.Columns.Add("Passwort",         150) | Out-Null
$Liste.Columns.Add("Notiz",            190) | Out-Null

$Fenster.Controls.Add($Liste)


# =============================================================
#  STATUSLEISTE unten im Fenster
#
#  Zeigt kurze Hinweistexte an (z.B. "Gespeichert!")
# =============================================================

$Statusleiste = New-Object System.Windows.Forms.StatusStrip
$Fenster.Controls.Add($Statusleiste)

$StatusText = New-Object System.Windows.Forms.ToolStripStatusLabel
$StatusText.Text = "Bereit."
$Statusleiste.Items.Add($StatusText) | Out-Null


# =============================================================
#  HILFSFUNKTION: Liste neu laden und anzeigen
#
#  Diese Funktion wird immer aufgerufen wenn sich etwas
#  geändert hat, damit die Tabelle aktuell ist.
# =============================================================

function Aktualisiere-Liste {

    # Tabelle zuerst leeren
    $Liste.Items.Clear()

    # Alle Passwörter aus der Datei laden
    $alle = Lade-Passwoerter

    # Jeden Eintrag als neue Zeile in die Tabelle einfügen
    foreach ($eintrag in $alle) {

        # Neue Zeile erstellen mit dem Dienst-Namen als erste Spalte
        $zeile = New-Object System.Windows.Forms.ListViewItem($eintrag.Dienst)

        # Weitere Spalten anhängen
        $zeile.SubItems.Add($eintrag.Benutzername) | Out-Null
        $zeile.SubItems.Add($eintrag.Passwort)     | Out-Null
        $zeile.SubItems.Add($eintrag.Notiz)        | Out-Null

        # Zeile zur Tabelle hinzufügen
        $Liste.Items.Add($zeile) | Out-Null
    }

    # Status aktualisieren
    $StatusText.Text = "$($Liste.Items.Count) Einträge gespeichert  |  Datei: $DateiPfad"
}


# =============================================================
#  HILFSFUNKTION: Eingabefelder leeren
# =============================================================

function Leere-Felder {
    $EingabeDienst.Text   = ""
    $EingabeUser.Text     = ""
    $EingabePasswort.Text = ""
    $EingabeNotiz.Text    = ""
}


# =============================================================
#  EVENTS (Ereignisse)
#
#  Ein Event = Was passiert wenn man einen Button klickt.
#  Add_Click = "Wenn geklickt wird, führe diesen Code aus"
# =============================================================


# --- KLICK: Passwort generieren ---

$ButtonGenerieren.Add_Click({

    # Gewünschte Länge aus dem Zahlenfeld auslesen
    $laenge = [int]$EingabeLaenge.Value

    # Passwort erstellen mit unserer Funktion von oben
    $neuesPasswort = Erstelle-Passwort -laenge $laenge

    # Passwort im Anzeigefeld anzeigen
    $AnzeigeGeneriert.Text = $neuesPasswort

    $StatusText.Text = "Passwort generiert!"
})


# --- KLICK: Generiertes Passwort ins Eingabefeld übernehmen ---

$ButtonUebernehmen.Add_Click({

    # Prüfen ob schon ein Passwort generiert wurde
    if ($AnzeigeGeneriert.Text -eq "") {
        [System.Windows.Forms.MessageBox]::Show("Bitte zuerst ein Passwort generieren!", "Hinweis")
        return
    }

    # Passwort ins Eingabefeld kopieren
    $EingabePasswort.Text = $AnzeigeGeneriert.Text
    $StatusText.Text = "Passwort übernommen."
})


# --- KLICK: Eintrag speichern ---

$ButtonSpeichern.Add_Click({

    # Prüfen ob Dienst ausgefüllt ist (Pflichtfeld)
    if ($EingabeDienst.Text -eq "") {
        [System.Windows.Forms.MessageBox]::Show("Bitte einen Dienst / Website eingeben!", "Pflichtfeld fehlt")
        return
    }

    # Alle vorhandenen Einträge laden
    $alleDaten = Lade-Passwoerter

    # Neuen Eintrag als Objekt erstellen
    # PSCustomObject = ein einfaches Objekt mit eigenen Feldern
    $neuerEintrag = [PSCustomObject]@{
        Dienst       = $EingabeDienst.Text
        Benutzername = $EingabeUser.Text
        Passwort     = $EingabePasswort.Text
        Notiz        = $EingabeNotiz.Text
    }

    # Neuen Eintrag zur Liste hinzufügen
    # += bedeutet: zur bestehenden Liste hinzufügen
    $alleDaten += $neuerEintrag

    # Alle Daten speichern
    Speichere-Passwoerter -liste $alleDaten

    # Felder leeren nach dem Speichern
    Leere-Felder

    # Tabelle neu laden
    Aktualisiere-Liste

    $StatusText.Text = "Eintrag gespeichert!"
})


# --- KLICK: Eintrag löschen ---

$ButtonLoeschen.Add_Click({

    # Prüfen ob etwas in der Tabelle ausgewählt ist
    if ($Liste.SelectedItems.Count -eq 0) {
        [System.Windows.Forms.MessageBox]::Show("Bitte zuerst einen Eintrag in der Liste auswählen!", "Nichts ausgewählt")
        return
    }

    # Den ausgewählten Dienst-Namen merken
    $ausgewaehlt = $Liste.SelectedItems[0].Text

    # Sicherheitsfrage anzeigen
    $antwort = [System.Windows.Forms.MessageBox]::Show(
        "Eintrag '$ausgewaehlt' wirklich löschen?",
        "Löschen bestätigen",
        [System.Windows.Forms.MessageBoxButtons]::YesNo
    )

    # Nur löschen wenn "Ja" geklickt wurde
    if ($antwort -eq "Yes") {

        # Alle Einträge laden
        $alleDaten = Lade-Passwoerter

        # Alle Einträge behalten AUSSER den ausgewählten
        # Where-Object = Filter: "behalte nur wenn Bedingung wahr"
        $alleDaten = $alleDaten | Where-Object { $_.Dienst -ne $ausgewaehlt }

        # Gefilterte Liste speichern
        Speichere-Passwoerter -liste $alleDaten

        # Tabelle neu laden
        Aktualisiere-Liste

        $StatusText.Text = "Eintrag '$ausgewaehlt' gelöscht."
    }
})


# --- KLICK: Felder leeren ---

$ButtonFelder.Add_Click({
    Leere-Felder
    $StatusText.Text = "Felder geleert."
})


# --- KLICK: Passwort kopieren ---

$ButtonKopieren.Add_Click({

    # Prüfen ob etwas ausgewählt ist
    if ($Liste.SelectedItems.Count -eq 0) {
        [System.Windows.Forms.MessageBox]::Show("Bitte zuerst einen Eintrag in der Liste auswählen!", "Nichts ausgewählt")
        return
    }

    # Das Passwort aus Spalte 3 (Index 2) auslesen
    # SubItems[0] = Dienst, [1] = User, [2] = Passwort, [3] = Notiz
    $passwort = $Liste.SelectedItems[0].SubItems[2].Text

    # Passwort in die Zwischenablage kopieren
    [System.Windows.Forms.Clipboard]::SetText($passwort)

    $StatusText.Text = "Passwort in Zwischenablage kopiert!"
})


# --- KLICK auf Listeneintrag: Felder automatisch befüllen ---

$Liste.Add_SelectedIndexChanged({

    # Nur ausführen wenn wirklich etwas ausgewählt ist
    if ($Liste.SelectedItems.Count -eq 0) { return }

    # Werte aus der ausgewählten Zeile in die Felder eintragen
    $EingabeDienst.Text   = $Liste.SelectedItems[0].SubItems[0].Text
    $EingabeUser.Text     = $Liste.SelectedItems[0].SubItems[1].Text
    $EingabePasswort.Text = $Liste.SelectedItems[0].SubItems[2].Text
    $EingabeNotiz.Text    = $Liste.SelectedItems[0].SubItems[3].Text
})


# =============================================================
#  PROGRAMM STARTEN
#
#  Diese zwei Zeilen müssen am Ende stehen.
#  Sie laden zuerst die Daten und öffnen dann das Fenster.
# =============================================================

# Tabelle beim Start befüllen
Aktualisiere-Liste

# Fenster anzeigen und auf Eingaben warten
[System.Windows.Forms.Application]::Run($Fenster)

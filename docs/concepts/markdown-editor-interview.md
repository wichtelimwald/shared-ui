# Product Discovery Interview — AssistanceKit Markdown Editor

**Purpose:** Dieses Interview dient dazu, den Featureumfang und die UX des
AssistanceKit Markdown Editors festzulegen. Die Antworten fließen in Konzepte,
Designentscheidungen (ADRs) und die Produkt-Roadmap ein.

**Anleitung:** Bitte beantworte jede Frage so ausführlich wie nötig. Kurze
Stichpunkte reichen — wir können bei Bedarf vertiefen. Fragen mit ⭐ sind
besonders wichtig für die nächste Entwicklungsphase.

**Kontext:** Der Markdown Editor existiert bereits als funktionaler Prototyp in
AssistanceKit (7 Swift-Dateien, ~1.600 Zeilen Production Code, 67+ Tests). Er
wird aktuell in toogether-app produktiv genutzt. Dieses Interview soll helfen,
ihn als eigenständiges, wiederverwendbares "internes Produkt" weiterzuentwickeln.

---

## 1 — Nutzungskontext & Zielgruppe

### 1.1 ⭐ Welche Apps sollen den Editor nutzen?

> Aktuell: toogether-app (produktiv), studienmap-app (eigene Implementierung),
> mosQuit-app (nur Inline-Rendering). Welche weiteren Apps sind geplant?

**Antwort:**

### 1.2 ⭐ Wer sind die Endnutzer des Editors?

> Sind es technik-affine Nutzer, die Markdown kennen? Oder soll der Editor auch
> für Nutzer funktionieren, die noch nie Markdown geschrieben haben?

**Antwort:**

### 1.3 In welchen Kontexten wird der Editor eingesetzt?

> Beispiele: Notizen, Aktivitätsbeschreibungen, Studienpläne, Rezepte, Tagebuch...
> Kurze Texte (1–5 Zeilen) oder lange Dokumente (mehrere Bildschirmseiten)?

**Antwort:**

### 1.4 Soll der Editor als Vollbild-Editor oder als eingebettetes Element funktionieren?

> Oder beides? Beispiel: In toogether-app ist er in einer ScrollView eingebettet.
> Soll es auch einen Fullscreen-Modus geben?

**Antwort:**

---

## 2 — Feature-Umfang (Editing)

### 2.1 ⭐ Welche Markdown-Features sind Must-Have für den Editor?

> Aktuell unterstützt:
> - [x] Headings (H1, H2, H3)
> - [x] **Bold**, *Italic*, ~~Strikethrough~~, `Code`
> - [x] Links `[text](url)`
> - [x] Ungeordnete Listen (`- `, `* `, `+ `)
> - [x] Geordnete Listen (`1. `, `2. `)
> - [x] Blockquotes (`> `)
> - [x] Bilder `![alt](url)` (nur im Renderer)
> - [x] Horizontale Linien (`---`)
> - [x] Live-Syntax-Highlighting
> - [x] Kontextmenü-Formatierung (7 Aktionen)
>
> Was fehlt? Was ist überflüssig?

**Antwort:**

### 2.2 ⭐ Soll es eine Formatierungs-Toolbar geben?

> Aktuell wird über das iOS-Kontextmenü (Long-Press → "Format") formatiert.
> Alternativen:
> - Feste Toolbar über der Tastatur (wie Bear, iA Writer)
> - Floating Toolbar bei Textselektion (wie Notion)
> - Swipe-Gesten für schnelle Formatierung
> - Tastaturkürzel (für externe Tastaturen / iPad)
>
> Welche Variante(n) bevorzugst du?

**Antwort:**

### 2.3 Soll der Editor Tabellen unterstützen?

> Markdown-Tabellen sind komplex in der Bearbeitung. Optionen:
> - Keine Tabellen (einfachster Weg)
> - Nur Rendering (Tabellen anzeigen, aber nicht im Editor erstellen)
> - Volles Tabellen-Editing (aufwändig, aber mächtig)

**Antwort:**

### 2.4 Soll es Task-Listen geben?

> `- [ ] Aufgabe` / `- [x] Erledigt` — mit Tap-to-Toggle im Renderer?

**Antwort:**

### 2.5 Wie soll das Einfügen von Bildern funktionieren?

> Aktuell: Bilder werden im Renderer über `MarkdownImageDataProvider` aufgelöst
> (z.B. `local://` URLs für gecachte Bilder). Im Editor ist kein Bild-Einfügen möglich.
>
> Optionen:
> - Bild aus Fotobibliothek einfügen
> - Kamera-Aufnahme direkt einfügen
> - Drag & Drop (iPad)
> - Nur URL-basiert (manuell Markdown-Syntax eingeben)

**Antwort:**

### 2.6 Sollen Hashtags/Tags unterstützt werden?

> Der Parser erkennt bereits Tag-Zeilen (`#tag1 #tag2`) und überspringt sie.
> Sollen Tags:
> - Im Editor farblich hervorgehoben werden?
> - Autovervollständigung bekommen?
> - Klickbar sein (→ Filter/Suche)?

**Antwort:**

---

## 3 — Feature-Umfang (Rendering / Dokumentansicht)

### 3.1 ⭐ Welcher Rendering-Stil ist gewünscht?

> Aktuell: Obsidian-ähnliche Block-Darstellung (Headings, Listen, Blockquotes,
> Bilder). Soll das beibehalten werden oder gibt es andere Vorbilder?

**Antwort:**

### 3.2 Soll der Renderer interaktiv sein?

> Beispiel: Links antippen → öffnen, Task-Listen abhaken, Bilder vergrößern,
> Sections ein-/ausklappen...

**Antwort:**

### 3.3 Soll es einen "Split View" geben (Editor + Preview nebeneinander)?

> Oder reicht Live-Syntax-Highlighting als Feedback?

**Antwort:**

### 3.4 Wie sollen Code-Blöcke dargestellt werden?

> Aktuell: Farblich hervorgehobener Hintergrund, Monospace-Font.
> Soll es Syntax-Highlighting für Programmiersprachen geben?

**Antwort:**

---

## 4 — Theming & Anpassung

### 4.1 ⭐ Wie wichtig ist Theming-Flexibilität?

> Aktuell: `MarkdownTheme` mit 4 Hex-Farben (accent, syntax, codeForeground,
> codeBackground) + Light/Dark Presets. Reicht das oder brauchen Apps mehr
> Kontrolle (z.B. Font-Größe, Font-Familie, Zeilenabstand, Absatzabstand)?

**Antwort:**

### 4.2 Sollen Apps eigene Themes definieren können?

> Z.B. toogether-app benutzt Blau, studienmap-app möchte Grün, org-spirits-app
> möchte Gold. Über `MarkdownTheme` oder ein umfassenderes System?

**Antwort:**

### 4.3 Dark Mode — reicht automatischer Wechsel oder braucht es mehr?

> Aktuell: `.defaultLight` / `.defaultDark` Presets, die automatisch wechseln.

**Antwort:**

---

## 5 — Plattform & Integration

### 5.1 ⭐ Welche Plattformen soll der Editor unterstützen?

> Aktuell: nur iOS (UITextView-basiert).
> Mögliche Erweiterungen:
> - iPad (gleicher Code, aber Keyboard-Shortcuts?)
> - macOS (NSTextView-Variante)
> - visionOS
> - watchOS (nur Rendering?)

**Antwort:**

### 5.2 Wie soll der Editor in die Host-App integriert werden?

> Aktuell: SwiftUI View mit `@Binding<String>`. Reicht das oder brauchen Apps:
> - Delegate/Callback-basierte Events (onChange, onFocus, onSubmit)?
> - Programmatische Steuerung (Focus, Scroll-to-Position)?
> - Zustandsabfragen (isEmpty, hasChanges, wordCount)?

**Antwort:**

### 5.3 Soll der Editor mit SwiftData / Core Data integrierbar sein?

> Z.B. automatisches Speichern bei Textänderung, Undo/Redo-Integration mit
> dem Persistenz-Stack?

**Antwort:**

### 5.4 Soll studienmap-app auf AssistanceKit Markdown migriert werden?

> studienmap-app hat eine eigene Markdown-Implementierung (MarkdownParser +
> LiveMarkdownView). Soll diese durch AssistanceKit ersetzt werden?
> Was sind die Unterschiede/Anforderungen?

**Antwort:**

---

## 6 — UX & Accessibility

### 6.1 ⭐ Wie wichtig ist VoiceOver-Unterstützung?

> Aktuell: Basic Accessibility-Labels ("Markdown editor", "Edit formatted text").
> Soll der Editor vollständig VoiceOver-kompatibel sein (Formatierung per
> Rotor, Block-Navigation, etc.)?

**Antwort:**

### 6.2 Soll Dynamic Type unterstützt werden?

> Aktuell: Feste Font-Größe. Soll der Editor die iOS-Systemschriftgröße
> respektieren?

**Antwort:**

### 6.3 Welche Sprachen soll der Editor unterstützen?

> Aktuell: RTL (Right-to-Left) wird nicht explizit unterstützt. Deutsche Umlaute
> funktionieren (getestet). Brauchen wir:
> - Arabisch/Hebräisch (RTL)?
> - CJK (Chinesisch/Japanisch/Koreanisch)?
> - Emoji in Headings/Tags?

**Antwort:**

### 6.4 Wie soll Undo/Redo funktionieren?

> Aktuell: iOS-Standard-Undo (Schütteln oder Drei-Finger-Swipe). Reicht das
> oder soll es explizite Undo/Redo-Buttons geben?

**Antwort:**

---

## 7 — Performance & Limits

### 7.1 Wie lang werden Dokumente typischerweise?

> Aktuell: Syntax-Highlighting läuft bei jedem Tastendruck über den gesamten
> sichtbaren Absatz. Ab ~10.000 Zeichen könnte das spürbar werden.
> Erwartete Dokumentgrößen?

**Antwort:**

### 7.2 Gibt es Performance-kritische Szenarien?

> Z.B. schnelles Tippen, große Paste-Operationen, viele Bilder im Renderer?

**Antwort:**

---

## 8 — Zukunftsvision

### 8.1 Was würde den Markdown Editor in v2/v3 wirklich großartig machen?

> Träum groß — unabhängig von aktuellem Aufwand. Beispiele:
> - AI-gestützte Textvorschläge / Autokorrektur
> - Markdown-Templates (vordefinierte Strukturen)
> - Export als PDF / HTML
> - Kollaboratives Editing (wie Google Docs)
> - Plugin-System für erweiterte Syntax (Mermaid-Diagramme, Mathe-Formeln)
> - Verknüpfung mit anderen Dokumenten (Wiki-Links `[[page]]`)

**Antwort:**

### 8.2 Gibt es andere Markdown-Editoren, die als Vorbild dienen?

> Beispiele: Bear, iA Writer, Obsidian, Notion, Typora, Ulysses, Byword...
> Was gefällt dir an deren UX? Was nicht?

**Antwort:**

### 8.3 Soll der Editor irgendwann als eigenständige App veröffentlicht werden?

> Oder bleibt er immer ein eingebettetes Modul in anderen Apps?

**Antwort:**

---

## 9 — Designentscheidungen (ADRs)

### 9.1 Welche Architektur-Entscheidungen sollten vor der Weiterentwicklung als ADR dokumentiert werden?

> Vorschlag für initiale ADRs:

| # | Entscheidung | Optionen | Auswirkung |
|---|-------------|----------|------------|
| 1 | Formatting UI: Toolbar vs. Kontextmenü vs. Swipe-Gesten | Context Menu (aktuell), Keyboard Toolbar, Floating Toolbar | UX des gesamten Editors |
| 2 | Plattformstrategie: iOS-only vs. Cross-Platform | UIKit-only, AppKit+UIKit, SwiftUI-only (TextEditor) | Architektur der View-Schicht |
| 3 | Tabellen-Support: Ja/Nein/Nur-Rendering | Kein Support, Nur Rendering, Volles Editing | Parser- und Editor-Komplexität |
| 4 | Theme-System: Minimal (4 Farben) vs. Umfassend (Font, Spacing, etc.) | Aktuelles System erweitern, Neues System | Flexibilität vs. Einfachheit |
| 5 | studienplan-Migration: Unifizieren vs. Eigene Implementierung behalten | Migration zu AssistanceKit, Parallel weiterführen | Wartungsaufwand |

**Antwort:**

---

## 10 — Offene Ergänzungen

### 10.1 Gibt es etwas, das wir nicht gefragt haben, das aber wichtig ist?

**Antwort:**

### 10.2 Was ist die eine Sache, die der Editor unbedingt richtig machen muss?

> (Z.B. "Er muss sich so schnell anfühlen wie native iOS Notes" oder
> "Er muss auch ohne Markdown-Kenntnisse intuitiv nutzbar sein")

**Antwort:**

---

*Interview erstellt als Teil der Product Discovery für AssistanceKit Markdown Editor.
Antworten fließen ein in: Konzeptdokumente, ADRs, Backlog (`shared-ui/docs/todo.md`)
und Implementierungspläne (`shared-ui/docs/plans/`).*

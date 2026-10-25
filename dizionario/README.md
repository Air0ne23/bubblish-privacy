# Elenco di parole di Bubblish — sorgente (GNU GPL 3.0)

Questa cartella contiene il **sorgente** di `parole.txt`, l'elenco di 766.090
parole italiane con cui il gioco **Bubblish** (Airone Games, Android) controlla le
parole che il giocatore compone.

`parole.txt` deriva dal dizionario italiano `it_IT` dell'**Estensione linguistica
italiana** di LibreOffice ed e' distribuito, come quello, sotto la **GNU General
Public License versione 3** (vedi `COPYING`).

## Origine

- Dizionario `it_IT`, **versione 5.1.1 (7 novembre 2022)**, dal tag
  `libreoffice-24.2.1.2` del repository
  [LibreOffice/dictionaries](https://github.com/LibreOffice/dictionaries/tree/libreoffice-24.2.1.2/it_IT)
  — gli stessi file del pacchetto Ubuntu `hunspell-it 1:24.2.1-1`.
- L'intestazione di `it_IT.aff` riporta ancora «Version 5.1.0 (13/10/2020)»: non e'
  stata aggiornata con la 5.1.1. La versione vera e' quella di `README_it_IT.txt`.
- `README_it_IT.txt` e la cartella `legacy/` sono le note di copyright originali,
  inalterate.

## Titolari

- Copyright (C) 2001, 2002 Gianluca Turconi
- Copyright (C) 2002, 2003, 2004 Gianluca Turconi e Davide Prina
- Copyright (C) 2004, 2005, 2006, 2007 Davide Prina
- Copyright (C) 2010, 2011, 2013, 2014, 2015 Andrea Pescetti
- Copyright (C) 2020-2022 LibreItalia - Marina Latini

con il contributo di Paolo Mantovani, Carlo Strata, Diego Favaro, Renzo Bianchi,
della comunita' di OpenOffice.org e del PLIO (vedi `README_it_IT.txt` e
`legacy/it_IT_AUTHORS`).

## Modifiche

Avviso ai sensi della sezione 5(a) della GPL 3: **modificato da Airone Games il
1 agosto 2026**.

1. le forme sono espanse dalle regole di affisso di `it_IT.aff` con `unmunch`
   (lo strumento di Hunspell);
2. gli accenti sono traslitterati in ASCII (`perché` -> `perche`), perche' il gioco
   ha solo le lettere dalla A alla Z;
3. restano solo le forme fatte di lettere dalla `a` alla `z`, lunghe al massimo
   11 lettere, in minuscolo;
4. l'elenco e' ordinato in ordine di byte (`LC_ALL=C`) e senza duplicati.

## Come si rigenera

Servono `bash`, `iconv`, `awk`, `sort`, `sha256sum` e `unmunch` (pacchetto
`hunspell-tools`; se manca, lo script lo scarica con `apt-get download`).

```sh
FONTE=. OUT=parole.txt bash make_dictionary.sh
```

Lo script controlla prima le impronte dei due file di partenza (`SHA256SUMS`) e alla
fine confronta `parole.txt` con quella registrata: il risultato e' identico byte per
byte all'elenco che il gioco contiene.

## Contenuto

| File | Che cos'e' |
|---|---|
| `it_IT.dic`, `it_IT.aff` | il dizionario originale, inalterato |
| `README_it_IT.txt`, `legacy/` | note di copyright e licenza originali, inalterate |
| `COPYING` | il testo della GNU GPL 3 |
| `make_dictionary.sh` | lo script che produce `parole.txt` |
| `parole.txt` | l'elenco che il gioco usa |
| `SHA256SUMS` | le impronte dei file di partenza e dell'elenco |

## Il gioco

La GPL vale per questo elenco di parole. Bubblish e' un programma separato che
legge `parole.txt` come file di dati, e non e' distribuito sotto GPL.

Nessuna garanzia: vedi le sezioni 15 e 16 della licenza.
Contatti: airone23games@gmail.com

---

**English.** `parole.txt` is a modified version of the LibreOffice Italian
dictionary `it_IT` 5.1.1 (copyright the authors listed above), distributed under the
GNU General Public License version 3, without any warranty. It was modified by
Airone Games on 1 August 2026: affixes expanded with `unmunch`, accents
transliterated to ASCII, only a-z forms of at most 11 letters, lowercase, sorted and
deduplicated. `FONTE=. OUT=parole.txt bash make_dictionary.sh` regenerates it
byte for byte. Bubblish itself is a separate program that reads the list as data
and is not covered by the GPL.

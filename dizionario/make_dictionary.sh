#!/usr/bin/env bash
# Rigenera assets/data/parole.txt, il dizionario italiano che valida le parole.
#
# PERCHE' UNO SCRIPT E NON UN FILE A MANO: il dizionario del gioco arrivava dalla
# app Corona del 2014 (vedi ../BubbleWords_recovered/) ed era fermo li' — niente
# "email", "smartphone", "selfie", "tablet", "blog", "streaming", "podcast".
# Qui la provenienza e' dichiarata e il risultato si rifa' con un comando, invece
# di essere un blob di cui nessuno sa piu' da dove venga. (Quel file del 2014,
# si e' poi scoperto, e' identico byte per byte a un elenco pubblicato su GitHub
# nel 2014 senza nessuna licenza: di provenienza ignota, non «pulito».)
#
# ⚠️ LA FONTE E' GPL 3.0, E QUESTO SCRIPT FA PARTE DEL SUO SORGENTE.
# I file di partenza sono il dizionario it_IT dell'«Estensione linguistica
# italiana» di LibreOffice, versione 5.1.1 (7 novembre 2022), cosi' come la
# distribuisce LibreOffice 24.2.1 (tag libreoffice-24.2.1.2 del repository
# LibreOffice/dictionaries, identici al pacchetto Ubuntu hunspell-it 1:24.2.1-1).
# ⚠️ L'intestazione di it_IT.aff dice ancora «5.1.0 (13/10/2020)»: non e' stata
# aggiornata con la 5.1.1, e la versione vera e' quella del README_it_IT.txt.
# Licenza GNU GPL 3 «only» (dal 2010), titolari: Gianluca Turconi, Davide Prina,
# Andrea Pescetti, LibreItalia - Marina Latini. parole.txt e' quindi una VERSIONE
# MODIFICATA di un'opera GPL e il gioco la distribuisce dentro l'apk: si puo'
# fare tenendo il codice del gioco chiuso (il gioco la legge come file di dati:
# e' un «aggregato», GPL 3 sezione 5), a TRE condizioni, che questo progetto
# rispetta cosi':
#   1. il «sorgente corrispondente» pubblico: docs/dizionario/ (i due file di
#      partenza, le note di copyright originali, la licenza) piu' questo script,
#      pubblicati nella cartella dizionario/ del repository dell'informativa
#      (github.com/Air0ne23/bubblish-privacy/tree/main/dizionario;
#      tools/pacchetto_dizionario.sh li raccoglie e verifica che rigenerino
#      parole.txt identico);
#   2. l'avviso di modifica con la data, accanto all'elenco:
#      assets/data/parole_LEGGIMI.txt (entra nell'apk con include_filter *.txt);
#   3. titolari, licenza e indirizzo del sorgente nei Riconoscimenti del gioco
#      (scripts/impostazioni_pannello.gd) e nella scheda dello store.
# ⚠️ Quindi SE parole.txt CAMBIA (fonte nuova, MAXLEN diverso, regole diverse)
# va ripubblicato il sorgente: SHA256SUMS di docs/dizionario porta l'impronta di
# parole.txt, tests/dizionario_check.gd fallisce se non coincide, e questo script
# avvisa in fondo. Vedi CLAUDE.md, «The dictionary is generated».
#
# PERCHE' I FILE DI PARTENZA SONO NEL REPOSITORY e non si scaricano piu' a ogni
# giro (fino al 25 ottobre 2026 si faceva `apt-get download hunspell-it`): cosi'
# il risultato e' riproducibile — e il sorgente pubblicato e' davvero quello che
# ha prodotto l'elenco nel gioco, non l'ultima versione disponibile quel giorno.
# Aggiornare il dizionario e' quindi un passo DICHIARATO: si sostituiscono
# it_IT.dic/it_IT.aff/README_it_IT.txt in docs/dizionario con quelli nuovi,
# si rifa' SHA256SUMS, si rilancia questo script, si aggiornano data e versione
# nell'avviso e nei Riconoscimenti, e si ripubblica il sorgente.
#
# COME: si espandono gli affissi con unmunch (il .dic contiene 95mila radici +
# le regole per declinarle: espanse fanno 36 milioni di forme) e si riduce a
# quello che il gioco puo' davvero usare. unmunch e' lo strumento di hunspell
# (pacchetto hunspell-tools): uno strumento d'uso generale, non parte del
# sorgente; se non e' installato lo script se lo scarica.
#
# Per un po' il file e' stato l'UNIONE fra questo e l'elenco del 2014, per non
# perdere niente per strada. E' stata tolta su richiesta ("non mi piace avere piu'
# sorgenti, il gioco e' in sviluppo, userei solo il vocabolario piu' recente") ed
# e' una scelta difendibile: delle 279894 parole del 2014 solo 25472 non stanno
# nel dizionario di LibreOffice, e sono il fondo di coda (bosinate, attuffino,
# lagidi, perfino non-italiane come polonaises). In cambio si guadagna un lessico
# mantenuto e una fonte sola da spiegare — e, si e' visto dopo, una fonte con una
# licenza dichiarata, che l'elenco del 2014 non aveva.
#
# TRE REGOLE DI RIDUZIONE, tutte con un motivo di gioco:
#  1. accenti TRASLITTERATI, non scartati: il sacchetto delle lettere e' A-Z
#     (vedi G.LETTER_BAG_COUNTS), quindi "perche'" si puo' comporre solo come
#     "perche". Lo faceva gia' il dizionario del 2014 ("esultero" per la forma
#     accentata) e va conservato, altrimenti si perdono migliaia di parole.
#  2. solo [a-z]: apostrofi e trattini non sono componibili.
#  3. lunghezza massima MAXLEN. L'espansione contiene forme lunghissime (verbi
#     con i pronomi attaccati, "portandogliene"), che nessuno comporra' mai
#     trascinando il dito, e il testo cresce in fretta.
#
# MAXLEN 11 E' UNA MISURA, non un gusto. Il testo pesa ~7,9MB e l'apk di rilascio
# veniva 29,4MB, sotto il tetto pratico dei 30MB di allora (vedi CLAUDE.md: era
# il limite per spedirla come allegato, NON un limite di Android). Gli altri
# scalini sono gia' misurati:
#     <=10   458k parole   4,4MB   apk ~28,7MB
#     <=11   766k parole   7,9MB   apk ~29,4MB
#     <=12  1164k parole    13MB   apk ~30,3MB
#     <=13  1629k parole    20MB   apk ~31,4MB
#
# Le parole sotto le 3 lettere restano dentro apposta: il dizionario risponde
# a una domanda sul LESSICO, la lunghezza minima giocabile e' una regola di gioco
# e vive in G.MIN_WORD_LEN / is_word_playable() (vedi CLAUDE.md e
# tests/bonus_check.gd, che verifica proprio che check_word("ho") resti vero).
# Sono 150 parole, 424 byte: toglierle non fa risparmiare niente e confonde i due
# piani.
#
# Il file prodotto DEVE restare ordinato in ordine di byte (LC_ALL=C), terminato
# da LF e tutto minuscolo: check_word() ci fa una ricerca binaria sul testo, e un
# file fuori ordine le fa mancare parole in silenzio (vedi CLAUDE.md).
#
#   bash tools/make_dictionary.sh                       # rigenera in place
#   MAXLEN=12 bash tools/make_dictionary.sh             # piu' ricco (poi va ripubblicato il sorgente)
#   FONTE=. OUT=parole.txt bash make_dictionary.sh      # nel repository del sorgente pubblicato
set -euo pipefail

MAXLEN="${MAXLEN:-11}"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
FONTE="${FONTE:-$ROOT/docs/dizionario}"
OUT="${OUT:-$ROOT/assets/data/parole.txt}"
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

echo "== controllo i file di partenza (SHA256SUMS) =="
# Solo le due righe dei file di partenza: quella di parole.txt e' il RISULTATO,
# che si confronta alla fine.
(cd "$FONTE" && grep ' it_IT\.' SHA256SUMS | sha256sum -c -)

UNMUNCH="$(command -v unmunch || true)"
if [ -z "$UNMUNCH" ]; then
	echo "== scarico hunspell-tools (unmunch) =="
	(cd "$WORK" && apt-get download hunspell-tools >/dev/null && dpkg-deb -x hunspell-tools_*.deb tools)
	UNMUNCH="$WORK/tools/usr/bin/unmunch"
	chmod +x "$UNMUNCH"
fi

echo "== espando gli affissi (36 milioni di forme, ~3s) =="
"$UNMUNCH" "$FONTE/it_IT.dic" "$FONTE/it_IT.aff" > "$WORK/expanded.txt" 2>/dev/null

echo "== traslittero, filtro, taglio a $MAXLEN lettere =="
LC_ALL=C.UTF-8 iconv -f utf-8 -t ascii//TRANSLIT "$WORK/expanded.txt" 2>/dev/null \
	| LC_ALL=C tr 'A-Z' 'a-z' \
	| LC_ALL=C grep -x '[a-z][a-z]*' \
	| LC_ALL=C awk -v n="$MAXLEN" 'length($0) <= n' \
	| LC_ALL=C sort -u > "$WORK/parole.txt"

# Controlli prima di sostituire: un dizionario rotto non da' errori, semplicemente
# smette di riconoscere le parole (la falsa "regressione del punteggio").
LC_ALL=C sort -c "$WORK/parole.txt"
test "$(LC_ALL=C grep -cv '^[a-z][a-z]*$' "$WORK/parole.txt" || true)" -eq 0
after="$(wc -l < "$WORK/parole.txt")"
# Rete di sicurezza sul risultato: se l'espansione fallisse a meta' (fonte
# cambiata, unmunch diverso) uscirebbe un file piccolo e plausibile, e il gioco
# smetterebbe di riconoscere le parole senza un solo errore a video.
test "$after" -ge 400000
# Parole comuni e parole moderne: le prime dicono che il lessico di base c'e',
# le seconde che la fonte e' davvero quella nuova.
for w in casa mangiare bellissime perche email smartphone podcast; do
	LC_ALL=C grep -qx "$w" "$WORK/parole.txt" || { echo "manca '$w'"; exit 1; }
done
mv "$WORK/parole.txt" "$OUT"
echo "== fatto: $after parole, $(du -h "$OUT" | cut -f1) =="

# L'elenco e' lo stesso di cui e' pubblicato il sorgente? Se no, la GPL chiede di
# ripubblicarlo (vedi l'intestazione).
atteso="$(grep ' parole\.txt$' "$FONTE/SHA256SUMS" | cut -d' ' -f1)"
ottenuto="$(sha256sum "$OUT" | cut -d' ' -f1)"
if [ "$atteso" = "$ottenuto" ]; then
	echo "   identico a quello di SHA256SUMS: il sorgente pubblicato resta valido"
else
	echo "⚠️ parole.txt e' CAMBIATO ($ottenuto): aggiorna SHA256SUMS, la data nell'avviso"
	echo "   (assets/data/parole_LEGGIMI.txt) e nei Riconoscimenti, e RIPUBBLICA il sorgente"
fi
echo "   ora: godot --headless --script res://tools/dict_bench.gd  (verifica la bisezione)"

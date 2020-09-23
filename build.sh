#!/bin/bash

cd "$( dirname "${BASH_SOURCE[0]}" )" || exit
RAWSVGS_LIGHT="src/light/svgs"
INDEX_LIGHT="src/light/cursor.theme"
RAWSVGS_DARK="src/dark/svgs"
INDEX_DARK="src/dark/cursor.theme"
ALIASES="src/cursorList"


echo -ne "Checking Requirements...\\r"
if [ ! -f $INDEX_LIGHT ] ; then
    echo -e "\\nFAIL: '$INDEX_LIGHT' missing"
    exit 1
elif [ ! -f $INDEX_LIGHT ] ; then
    echo -e "\\nFAIL: '$INDEX_DARK' missing"
    exit 1
elif ! type "inkscape" > /dev/null ; then
    echo -e "\\nFAIL: inkscape must be installed"
    exit 1
elif ! type "xcursorgen" > /dev/null ; then
    echo -e "\\nFAIL: xcursorgen must be installed"
    exit 1
fi
echo -e "Checking Requirements... DONE"


echo -ne "Making Folders... $BASENAME\\r"
DIR2X_LIGHT="build/light/x2"
DIR1X_LIGHT="build/light/x1"
DIR2X_DARK="build/dark/x2"
DIR1X_DARK="build/dark/x1"
OUTPUT_LIGHT="$(grep --only-matching --perl-regex "(?<=Name\\=).*$" $INDEX_LIGHT)"
OUTPUT_LIGHT=${OUTPUT_LIGHT// /_}
OUTPUT_DARK="$(grep --only-matching --perl-regex "(?<=Name\\=).*$" $INDEX_DARK)"
OUTPUT_DARK=${OUTPUT_DARK// /_}
mkdir -p "$DIR2X_DARK"
mkdir -p "$DIR1X_DARK"
mkdir -p "$DIR2X_LIGHT"
mkdir -p "$DIR1X_LIGHT"
mkdir -p "$OUTPUT_LIGHT/cursors"
mkdir -p "$OUTPUT_DARK/cursors"
echo 'Making Folders... DONE';


for CUR in src/config/*.cursor; do
    BASENAME=$CUR
    BASENAME=${BASENAME##*/}
    BASENAME=${BASENAME%.*}

    echo -ne "\\033[0KGenerating simple cursor pixmaps... $BASENAME\\r"

    inkscape -w 32  --file=$RAWSVGS_LIGHT/"$BASENAME".svg --export-png="$DIR1X_LIGHT/$BASENAME.png" > /dev/null
    inkscape -w 64 --file=$RAWSVGS_LIGHT/"$BASENAME".svg --export-png="$DIR2X_LIGHT/$BASENAME.png" > /dev/null
    inkscape -w 32  --file=$RAWSVGS_DARK/"$BASENAME".svg --export-png="$DIR1X_DARK/$BASENAME.png" > /dev/null
    inkscape -w 64 --file=$RAWSVGS_DARK/"$BASENAME".svg --export-png="$DIR2X_DARK/$BASENAME.png" > /dev/null
done
echo -e "\\033[0KGenerating simple cursor pixmaps... DONE"


for i in 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24
do
    echo -ne "\\033[0KGenerating animated cursor pixmaps... $i / 24 \\r"

    inkscape -w 32  --file=$RAWSVGS_LIGHT/progress-$i.svg --export-png="$DIR1X_LIGHT/progress-$i.png" > /dev/null
    inkscape -w 64 --file=$RAWSVGS_LIGHT/progress-$i.svg --export-png="$DIR2X_LIGHT/progress-$i.png" > /dev/null
    inkscape -w 32  --file=$RAWSVGS_DARK/progress-$i.svg --export-png="$DIR1X_DARK/progress-$i.png" > /dev/null
    inkscape -w 64 --file=$RAWSVGS_DARK/progress-$i.svg --export-png="$DIR2X_DARK/progress-$i.png" > /dev/null

    inkscape -w 32  --file=$RAWSVGS_LIGHT/wait-$i.svg --export-png="$DIR1X_LIGHT/wait-$i.png" > /dev/null
    inkscape -w 64 --file=$RAWSVGS_LIGHT/wait-$i.svg --export-png="$DIR2X_LIGHT/wait-$i.png" > /dev/null
    inkscape -w 32  --file=$RAWSVGS_DARK/wait-$i.svg --export-png="$DIR1X_DARK/wait-$i.png" > /dev/null
    inkscape -w 64 --file=$RAWSVGS_DARK/wait-$i.svg --export-png="$DIR2X_DARK/wait-$i.png" > /dev/null
done
echo -e "\\033[0KGenerating animated cursor pixmaps... DONE"


echo -ne "Generating cursor theme...\\r"
for CUR in src/config/*.cursor; do
    BASENAME=$CUR
    BASENAME=${BASENAME##*/}
    BASENAME=${BASENAME%.*}

    if ! ERR="$( xcursorgen -p build/light "$CUR" "$OUTPUT_LIGHT/cursors/$BASENAME" 2>&1 )"; then
        echo "FAIL: $CUR $ERR"
    fi

    if ! ERR="$( xcursorgen -p build/dark "$CUR" "$OUTPUT_DARK/cursors/$BASENAME" 2>&1 )"; then
        echo "FAIL: $CUR $ERR"
    fi
done
echo -e "Generating cursor theme... DONE"


echo -ne "Generating shortcuts...\\r"
while read -r ALIAS ; do
    FROM=${ALIAS% *}
    TO=${ALIAS#* }
    if [ -e "$OUTPUT_LIGHT/cursors/$FROM" ] ; then
        continue
    fi
    ln -sf "$TO" "$OUTPUT_LIGHT/cursors/$FROM"

    if [ -e "$OUTPUT_DARK/cursors/$FROM" ] ; then
        continue
    fi
    ln -sf "$TO" "$OUTPUT_DARK/cursors/$FROM"
done < $ALIASES
echo -e "\\033[0KGenerating shortcuts... DONE"


echo -ne "Copying Theme Index...\\r"
    if ! [ -e "$OUTPUT_LIGHT/$INDEX_LIGHT" ] ; then
        cp $INDEX_LIGHT "$OUTPUT_LIGHT/cursor.theme"
    fi
    if ! [ -e "$OUTPUT_DARK/$INDEX_DARK" ] ; then
        cp $INDEX_DARK "$OUTPUT_DARK/cursor.theme"
    fi
echo -e "\\033[0KCopying Theme Index... DONE"


echo "COMPLETE!"

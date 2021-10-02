#!/usr/bin/env bash

# colourful messages for debugging
function fail { echo -e "\033[0;31mFAILED:\033[0m $1"; exit 1; }  # red, fatal
function warn { echo -e "\033[0;33mFAILED:\033[0m $1"; }          # orange, issue
function success { echo -e "\033[0;32mDONE!\033[0m"; }            # green, success


cd "$( dirname "${BASH_SOURCE[0]}" )" || exit
RAWSVGS_LIGHT="src/light/svgs"
INDEX_LIGHT="src/light/cursor.theme"
RAWSVGS_DARK="src/dark/svgs"
INDEX_DARK="src/dark/cursor.theme"
ALIASES="src/cursorList"


echo -ne "Checking Requirements..."
if [ ! -f $INDEX_LIGHT ]; then
    fail "'$INDEX_LIGHT' missing"
elif [ ! -f $INDEX_DARK ]; then
    fail "'$INDEX_DARK' missing"
elif ! type "inkscape" > /dev/null; then
    fail "Inkscape v1.1+ must be installed"
elif ! type "xcursorgen" > /dev/null; then
    fail "xcursorgen must be installed"
fi
success


echo -ne "Making Folders... $BASENAME"
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
success


# export SVG as PNG, ran using `render $FILENAME $INPUTDIR $OUTPUTDIR $SIZE`
function render { inkscape "$2"/"$1".svg -o "$3"/"$1".png -w "$4" 2> /dev/null; }


for CUR in src/config/*.cursor; do
    BASENAME=$CUR
    BASENAME=${BASENAME##*/}
    BASENAME=${BASENAME%.*}

    echo -ne "\\033[0KGenerating simple cursor pixmaps... $BASENAME\\r"

    render "$BASENAME" "$RAWSVGS_LIGHT" "$DIR1X_LIGHT" 32
    render "$BASENAME" "$RAWSVGS_LIGHT" "$DIR2X_LIGHT" 64
    render "$BASENAME" "$RAWSVGS_DARK" "$DIR1X_DARK" 32
    render "$BASENAME" "$RAWSVGS_DARK" "$DIR2X_DARK" 64
done
echo -ne "\\033[0KGenerating simple cursor pixmaps... "; success


for i in {01..24}; do
    echo -ne "\\033[0KGenerating animated cursor pixmaps... $i/24 \\r"

    render "progress-$i" "$RAWSVGS_LIGHT" "$DIR1X_LIGHT" 32
    render "progress-$i" "$RAWSVGS_LIGHT" "$DIR2X_LIGHT" 64
    render "progress-$i" "$RAWSVGS_DARK" "$DIR1X_DARK" 32
    render "progress-$i" "$RAWSVGS_DARK" "$DIR2X_DARK" 64

    render "wait-$i" "$RAWSVGS_LIGHT" "$DIR1X_LIGHT" 32
    render "wait-$i" "$RAWSVGS_LIGHT" "$DIR2X_LIGHT" 64
    render "wait-$i" "$RAWSVGS_DARK" "$DIR1X_DARK" 32
    render "wait-$i" "$RAWSVGS_DARK" "$DIR2X_DARK" 64
done
echo -ne "\\033[0KGenerating animated cursor pixmaps... "; success


echo -ne "Generating cursor theme... "
for CUR in src/config/*.cursor; do
    BASENAME=$CUR
    BASENAME=${BASENAME##*/}
    BASENAME=${BASENAME%.*}

    if ! ERR="$( xcursorgen -p build/light "$CUR" "$OUTPUT_LIGHT/cursors/$BASENAME" 2>&1 )"; then
        warn "$CUR $ERR"
    fi

    if ! ERR="$( xcursorgen -p build/dark "$CUR" "$OUTPUT_DARK/cursors/$BASENAME" 2>&1 )"; then
        warn "$CUR $ERR"
    fi
done
success


echo -ne "Generating shortcuts... "
while read -r ALIAS; do
    FROM=${ALIAS% *}
    TO=${ALIAS#* }
    if [ -e "$OUTPUT_LIGHT/cursors/$FROM" ]; then
        continue
    fi
    ln -sf "$TO" "$OUTPUT_LIGHT/cursors/$FROM"

    if [ -e "$OUTPUT_DARK/cursors/$FROM" ]; then
        continue
    fi
    ln -sf "$TO" "$OUTPUT_DARK/cursors/$FROM"
done < $ALIASES
success


echo -ne "Copying Theme Index... "
    if ! [ -e "$OUTPUT_LIGHT/$INDEX_LIGHT" ]; then
        cp $INDEX_LIGHT "$OUTPUT_LIGHT/cursor.theme"
    fi
    if ! [ -e "$OUTPUT_DARK/$INDEX_DARK" ]; then
        cp $INDEX_DARK "$OUTPUT_DARK/cursor.theme"
    fi
success

echo "Build complete!"

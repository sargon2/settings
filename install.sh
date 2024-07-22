#!/bin/bash -e

cd "$(dirname "$0")"
THIS="$(basename "$0")"

# Define the files to skip
SKIP_FILES=("." ".." ".git" ".gitignore" "bin" ".ssh" "$THIS")

# Iterate over files in the directory, including dotfiles
shopt -s dotglob nullglob
for FILE in *; do
    # Check if the file is in the skip list
    SKIP=false
    for SKIP_FILE in "${SKIP_FILES[@]}"; do
        if [[ "$FILE" == "$SKIP_FILE" ]]; then
            SKIP=true
            break
        fi
    done

    # If the file is not to be skipped, do something with it
    if [[ "$SKIP" == false ]]; then
	SOURCE="$(realpath $FILE)"
        DEST="$(realpath ~)/$FILE"
        if [ -e "$DEST" ] || [ -h "$DEST" ]; then
            if [ -e "${DEST}.old" ] || [ -h "${DEST}.old" ]; then
                echo "${DEST}.old already exists, aborting!"
                exit 1
            fi
            echo "Moving $DEST to ${DEST}.old"
            mv "$DEST" "${DEST}.old"
        fi
        echo "Linking $SOURCE to $(realpath ~)/$FILE"
        ln -s "$SOURCE" "$DEST"
    fi
done
shopt -u dotglob nullglob # not sure this is needed

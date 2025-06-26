#!/bin/bash

REPO_FILE="/opt/tagsnooper/repositories.txt"
REPO_FILE_CHECK="/opt/tagsnooper/repositories_check.txt"

inotifywait -m -e modify "$REPO_FILE" | while read -r directory events filename; do
    
    if ! cmp -s "$REPO_FILE" "$REPO_FILE_CHECK"; then
        echo "Modifica rilevata in $REPO_FILE. Controllo repository aggiunti o aggiornati..."
        cat  "$REPO_FILE" > "$REPO_FILE_CHECK"
        sh /opt/tagsnooper/bin/check_tags.sh
    fi

done

#!/bin/sh

REPO_FILE_CHECK="/opt/tagsnooper/repositories_check.txt"

if [ -z "$RECIPIENT" ]; then
    echo "Error: RECIPIENT environment variable not set."
    exit 1
fi

EMAIL="${RECIPIENT}"

REPO_FILE="/opt/tagsnooper/repositories.txt"

while IFS= read -r line || [ -n "$line" ]; do
    [[ "$line" =~ ^#.*$ || -z "$line" ]] && continue

    REPO=$(echo "$line" | cut -d' ' -f1)
    CURRENT_TAG=$(echo "$line" | cut -d' ' -f2)

    LATEST_TAG=$(curl -s "https://github.com/$REPO/releases" | grep -oP 'href="/'"$REPO"'/releases/tag/[^"]*' | head -n 1 | awk -F'/tag/' '{print $2}')

    if [[ "$LATEST_TAG" != "$CURRENT_TAG" ]]; then
        echo "Nuovo tag trovato per $REPO: $LATEST_TAG (precedente: $CURRENT_TAG)"

        # Update the file with the new tag
        sed -i "s|$REPO $CURRENT_TAG|$REPO $LATEST_TAG|" "$REPO_FILE_CHECK"

        echo -e "Nuovo tag per $REPO: $LATEST_TAG (precedente: $CURRENT_TAG)" | \
            mutt -s "Nuovo tag per $REPO" "$EMAIL"
    fi

done < "$REPO_FILE_CHECK"

cat  "$REPO_FILE_CHECK" > "$REPO_FILE"


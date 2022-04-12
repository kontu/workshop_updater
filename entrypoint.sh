#!/bin/bash
apt update && apt install -y git
files=($(git diff-tree --no-commit-id --name-only -r $GITHUB_SHA | xargs))
mods=$(printf '%s\n' "${files[@]}" | cut -f1-2 -d '/' | uniq)

echo "GithubSHA:: $GITHUB_SHA"
echo "Files:: $files"
echo "Path:: $INPUT_PATH"
echo "SteamAcct:: $INPUT_STEAMACCT"
echo "$INPUT_SSFNCONTENTS" | base64 -d 

echo "List of changed files: "
for i in $files
do
    echo "$files"
done

# Run through updating the mods if the above parsed correctly
for item in $mods
do
    echo "Mod:: $item"
    if [[ $item == $INPUT_PATH* ]]; 
    then 
        upload=$(find $GITHUB_WORKSPACE/$item -name "*.vdf" )
        echo "Upload:: $upload"
        #steamcmd +login "$INPUT_STEAMACCT" "$INPUT_STEAMPASSWD" +workshop_build_item "$upload" +quit
    fi
done
#!/bin/bash
apt update && apt install -y git
git config --global --add safe.directory /github/workspace
cd $GITHUB_WORKSPACE
files=$(git diff-tree --no-commit-id --name-only -r $GITHUB_SHA | xargs)
mods=$(printf '%s\n' "${files[@]}" | cut -f1-2 -d '/' | uniq)
mkdir -p "/root/.steam/config/""

echo "GithubSHA:: $GITHUB_SHA"
echo "Files:: $files"
echo "Path:: $INPUT_PATH"
echo "SteamAcct:: $INPUT_STEAMACCT"
echo "$INPUT_SSFNCONTENTS" | base64 -d "/root/.steam/$INPUT_SSFNFILENAME"
echo "$INPUT_STEAMCONFIGVDF" | base64 -d "/root/.steam/config/config.vdf"


echo "List of changed files: "
for i in $files
do
    echo $i
done

# Run through updating the mods if the above parsed correctly
for item in $mods
do
    if [[ $item == $INPUT_PATH* ]]; 
    then 
        echo "Mod:: $item"
        upload=$(find $GITHUB_WORKSPACE/$item -name "*.vdf" )
        echo "Upload:: $upload"
        #steamcmd +login "$INPUT_STEAMACCT" "$INPUT_STEAMPASSWD" +workshop_build_item "$upload" +quit
    fi
done
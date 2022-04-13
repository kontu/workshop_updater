#!/bin/bash
#set -x # echo on for debug
apt -qq update && apt -qq install -y git
git config --global --add safe.directory /github/workspace
cd $GITHUB_WORKSPACE
list=$(git diff-tree --no-commit-id --name-only -r $GITHUB_SHA | xargs)
# Turns list of files to an array bc it didn't want to do it in one operation
files=($list)
mods=$(printf '%s\n' "${files[@]}" | cut -f1-2 -d '/' | uniq)
mkdir -p "/root/.steam/config/"

echo "GithubSHA:: $GITHUB_SHA"
echo "Files:: $files"
echo "Path:: $INPUT_PATH"
echo "SteamAcct:: $INPUT_STEAMACCT"
echo "SSFN Filename:: $INPUT_SSFN_FILENAME"
echo "$INPUT_SSFNCONTENTS" | base64 -d > "/root/.steam/$INPUT_SSFN_FILENAME"
echo "$INPUT_STEAMCONFIGVDF" | base64 -d > "/root/.steam/config/config.vdf"
echo "Contents of config.vdf"
cat "/root/.steam/config/config.vdf"
echo "Contents of ssfn (not human legible) named:: $INPUT_SSFN_FILENAME"
cat "/root/.steam/$INPUT_SSFN_FILENAME"



# Run through updating the mods if the above parsed correctly
for mod in $mods
do
    if [[ $mod == $INPUT_PATH* ]]; 
    then 
        echo "Mod to upload:: $mod"
        upload=$(find $GITHUB_WORKSPACE/$item -name "*.vdf" )
        echo "Upload VDF File:: $upload"
        steamcmd +login "$INPUT_STEAMACCT" "$INPUT_STEAMPASSWD" +workshop_build_item "$upload" +quit
    fi
done
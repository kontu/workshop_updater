#!/bin/bash
#set -x # echo on for debug

apt -qq update && apt -qq install -y git --no-install-recommends
git config --global --add safe.directory /github/workspace
cd $GITHUB_WORKSPACE
list=$(git diff-tree --no-commit-id --name-only -r $GITHUB_SHA | xargs)
# Turns list of files to an array bc it didn't want to do it in one operation
files=($list)
mods=$(printf '%s\n' "${files[@]}" | cut -f1-2 -d '/' | uniq)
mkdir -p "/github/home/Steam/config/"
mkdir -p "/github/home/.steam/config/"

echo "GithubSHA:: $GITHUB_SHA"
echo "Changed Files:: $list"
echo "Path:: $INPUT_PATH"
echo "SteamAcct:: $INPUT_STEAMACCT"
echo "SSFN Filename:: $INPUT_SSFNFILENAME"
echo "$INPUT_SSFNCONTENTS" | base64 -d > "/github/home/Steam/$INPUT_SSFNFILENAME"
echo "$INPUT_STEAMCONFIGVDF" | base64 -d > "/github/home/Steam/config/config.vdf"
ln -s "/github/home/Steam/$INPUT_SSFNFILENAME" "/github/home/.steam/$INPUT_SSFNFILENAME"
ln -s "/github/home/Steam/config/config.vdf" "/github/home/.steam/config/config.vdf"

echo "List of env variables::"
printenv

# Run through updating the mods if the above parsed correctly
for mod in $mods
do
    if [[ $mod == $INPUT_PATH* ]]; 
    then 
        echo "Mod to upload:: $mod"
        upload=$(find $GITHUB_WORKSPACE/$mod -name "*.vdf" )
        echo "Upload VDF File:: $upload"
        steamcmd +login "$INPUT_STEAMACCT" "$INPUT_STEAMPASSWD" +workshop_build_item "$upload" +quit
    fi
done
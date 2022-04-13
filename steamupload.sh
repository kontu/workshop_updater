#!/bin/bash
#set -x # echo on for debug

apt -qq update && apt -qq install -y git --no-install-recommends
git config --global --add safe.directory /github/workspace
cd $GITHUB_WORKSPACE
list=$(git diff-tree --no-commit-id --name-only -r $GITHUB_SHA | xargs)
# Turns list of files to an array bc it didn't want to do it in one operation
files=($list)
mods=$(printf '%s\n' "${files[@]}" | cut -f1-2 -d '/' | uniq)

echo "GithubSHA:: $GITHUB_SHA"
echo "Changed Files:: $list"
echo "Path:: $path"
echo "SteamAcct:: $steamAcct"
echo "SSFN Filename:: $ssfnFileName"
echo ""
echo "#################################"
echo "#    Copying SteamGuard Files   #"
echo "#################################"
echo ""

mkdir -p "$STEAM_HOME/config"
mkdir -p "/home/runner/Steam/config"

echo "Copying $STEAM_HOME/config/config.vdf..."
echo "$configVdf" | base64 -d > "$STEAM_HOME/config/config.vdf"
chmod 777 "$STEAM_HOME/config/config.vdf"

echo "Copying /home/runner/Steam/config/config.vdf..."
echo "$configVdf" | base64 -d > "/home/runner/Steam/config/config.vdf"
chmod 777 "/home/runner/Steam/config/config.vdf"

echo "Copying $STEAM_HOME/ssfn..."
echo "$ssfnFileContents" | base64 -d > "$STEAM_HOME/$ssfnFileName"
chmod 777 "$STEAM_HOME/$ssfnFileName"

echo "Copying /home/runner/Steam/ssfn..."
echo "$ssfnFileContents" | base64 -d > "/home/runner/Steam/$ssfnFileName"
chmod 777 "/home/runner/Steam/$ssfnFileName"

echo "Finished Copying SteamGuard Files!"
echo ""


# Run through updating the mods if the above parsed correctly
for mod in $mods
do
    if [[ $mod == $path* ]]; 
    then 
        echo "Mod to upload:: $mod"
        upload=$(find $GITHUB_WORKSPACE/$mod -name "*.vdf" )
        echo "Upload VDF File:: $upload"
        # $STEAM_CMD +login "$steamAcct" "$steamPasswd" +workshop_build_item "$upload" +quit || (
        #     echo ""
        #     echo "#################################"
        #     echo "#             Errors            #"
        #     echo "#################################"
        #     echo ""
        #     echo "Listing current folder and rootpath"
        #     echo ""
        #     ls -alh
        #     echo ""
        #     ls -alh $rootPath
        #     echo ""
        #     echo "Listing logs folder:"
        #     echo ""
        #     ls -Ralph "/home/runner/Steam/logs/"
        #     echo ""
        #     echo "Displaying error log"
        #     echo ""
        #     cat "/home/runner/Steam/logs/stderr.txt"
        #     echo ""
        #     echo "Displaying bootstrapper log"
        #     echo ""
        #     cat "/home/runner/Steam/logs/bootstrap_log.txt"
        #     echo ""
        #     echo "#################################"
        #     echo "#             Output            #"
        #     echo "#################################"
        #     echo ""
        #     ls -Ralph BuildOutput
        #     exit 1
#   )
    fi
done
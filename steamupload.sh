#!/bin/bash
#set -x # echo on for debug

cd $GITHUB_WORKSPACE
list=$(git diff-tree --no-commit-id --name-only -r $GITHUB_SHA | xargs)
# Turns list of files to an array bc it didn't want to do it in one operation
files=($list)
mods=$(printf '%s\n' "${files[@]}" | cut -f1-2 -d '/' | uniq)

echo "GithubWorkspace:: $GITHUB_WORKSPACE"
echo "GithubSHA:: $GITHUB_SHA"
echo "Changed Files:: $list"
echo "Path:: $path"
echo "SteamAcct:: $steamAcct"
echo "SSFN Filename:: $ssfnFileName"
echo "Steam_Home:: $STEAM_HOME"
echo "Steam_executable:: $STEAM_CMD"
echo ""
echo "#################################"
echo "#    Copying SteamGuard Files   #"
echo "#################################"
echo ""

mkdir -p "$STEAM_HOME/config"
mkdir -p "/home/runner/Steam/config"

# echo "Copying $STEAM_HOME/config/config.vdf"
# echo "$SteamConfigVDF" > "$STEAM_HOME/config/config.vdf"
# chmod 777 "$STEAM_HOME/config/config.vdf"

echo "Copying /home/runner/Steam/config/config.vdf"
echo "$SteamConfigVDF" > "/home/runner/Steam/config/config.vdf"
chmod 777 "/home/runner/Steam/config/config.vdf"

# echo "Copying $STEAM_HOME/ssfn"
# echo "$ssfnContents" | base64 -d > "$STEAM_HOME/$ssfnFileName"
# chmod 777 "$STEAM_HOME/$ssfnFileName"

echo "Copying /home/runner/Steam/ssfn"
echo "$ssfnContents" | base64 -d > "/home/runner/Steam/$ssfnFileName"
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
        sed -i "s/\"contentfolder\"\ \"/\"contentfolder\"\ \"$GITHUB_WORKSPACE\\/g" $upload
        cat $upload
        echo ""
        $STEAM_CMD +login "$steamAcct" "$steamPasswd" +workshop_build_item "$upload" +quit || (
            cat "/home/runner/Steam/logs/stderr.txt"
        )
        #  || (
        #     echo ""
        #     echo "#################################"
        #     echo "#             Errors            #"
        #     echo "#################################"
        #     echo ""
        #     echo "Listing steam home contents"
        #     ls -Ralph $STEAM_HOME
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
        #     exit 1
        # )
    fi
done
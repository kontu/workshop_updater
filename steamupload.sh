#!/bin/bash

cd $GITHUB_WORKSPACE
# Checks what files were modified
list=$(git diff-tree --no-commit-id --name-only -r $GITHUB_SHA | xargs)

# Turns list of files to an array bc it didn't want to do it in one operation
files=($list)
mods=$(printf '%s\n' "${files[@]}" | cut -f1-2 -d '/' | uniq)


echo "### Environment Information ###"
echo "GithubWorkspace:: $GITHUB_WORKSPACE"
echo "GithubSHA:: $GITHUB_SHA"
echo "Changed Files:: $list"
echo "Path:: $path"
echo "SteamAcct:: $steamAcct"
echo "SSFN Filename:: $ssfnFileName"
echo "Steam_executable:: $STEAM_CMD"
echo ""

echo "#################################"
echo "#    Copying SteamGuard Files   #"
echo "#################################"
echo ""
mkdir -p "/home/runner/Steam/config"

echo "Copying /home/runner/Steam/config/config.vdf"
echo "$SteamConfigVDF" > "/home/runner/Steam/config/config.vdf"
echo "Copying /home/runner/Steam/ssfn"
echo "$ssfnContents" | base64 -d > "/home/runner/Steam/$ssfnFileName"
chmod 777 "/home/runner/Steam/$ssfnFileName"
chmod 777 "/home/runner/Steam/config/config.vdf"
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
        var=$(echo "$GITHUB_WORKSPACE" | sed 's/\\/\\\\/g')
        sed -i "s|\\\|\/|g" $upload
        sed -i  "s|\"contentfolder\" \"|\"contentfolder\" \"$var\\/|g" $upload
        sed -i  "s|\"previewfile\" \"|\"previewfile\" \"$var\\/|g" $upload
        
        cat $upload
        echo ""
        $STEAM_CMD +login "$steamAcct" "$steamPasswd" +workshop_build_item "$upload" +quit || (
            echo ""
            echo "#################################"
            echo "#             Error             #"
            echo "#################################"
            echo ""
            echo "MOD failed to upload please review output above"
            )
    fi
done
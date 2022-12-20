#!/bin/bash

cd $GITHUB_WORKSPACE

workspace=$(echo "$GITHUB_WORKSPACE" | sed 's/\\/\\\\/g')

echo "### Environment Information ###"
echo "GithubWorkspace:: $GITHUB_WORKSPACE"
echo "GithubSHA:: $GITHUB_SHA"
echo "Path:: $path"
echo "SteamAcct:: $steamAcct"
echo "SSFN Filename:: $ssfnFileName"
echo "Steam_executable:: $STEAM_CMD"
echo "modNames:: $modNames"
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


# Make sure the config.vdf has the right path for sentryfile
sed -i "s|\"SentryFile\".*\".*\"|\"SentryFile\"            \"$workspace\\/$ssfnFileName\"|g" "/home/runner/Steam/config/config.vdf"

# Run through updating the mods if the above parsed correctly
IFS=' '
read -a mods <<< $modNames

echo "Mods here: $mods"
for mod in $mods
do
    if [[ $(echo $mod | grep -i ".vdf$") ]];
    then
        mod=$(echo $mod | rev | cut -c4- | rev)
    fi

    echo "Mod to upload:: $mod"
    upload=$(find $GITHUB_WORKSPACE -type f -iname "$mod.vdf" )
    echo "Upload VDF File:: $upload"

    sed -i "s|\\\|\/|g" $upload
    sed -i  "s|\"contentfolder\" \"|\"contentfolder\" \"$workspace\\/|g" $upload
    sed -i  "s|\"previewfile\" \"|\"previewfile\" \"$workspace\\/|g" $upload

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
done
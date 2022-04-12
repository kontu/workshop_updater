#!/bin/bash
#steamAcct="AccountName"
#steamPasswd="Password"
#path="Mods"
#files=$(<filelist.txt)
#echo "$files"
#echo "$path"

## Debug
echo "Files:: $INPUT_FILES"
echo "Path:: $INPUT_PATH"
echo "SteamAcct:: $INPUT_STEAMACCT"
what=($INPUT_FILES)
mods=$(printf '%s\n' "${what[@]}" | cut -f1-2 -d '/' | uniq)


for item in $mods
do
    echo "Item:: $item"
    if [[ $item == $INPUT_PATH* ]]; 
    then 
        upload=$(find $GITHUB_WORKSPACE/$item -name "*.vdf" )
        echo "Upload:: $upload"
        #steamcmd +login "$INPUT_STEAMACCT" "$INPUT_STEAMPASSWD" +workshop_build_item "$upload" +quit
    fi
done
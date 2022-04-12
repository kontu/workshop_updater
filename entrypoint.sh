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
echo "SteamAcct:: $steamAcct"

mods=$(printf '%s\n' "${INPUT_FILES[@]}" | cut -f1-2 -d '/' | uniq)

for item in $mods
do
    if [[ $item == $INPUT_PATH* ]]; 
    then 
        upload=$(find /mnt/c/Users/kontu/scripts/workshop_updater_test/$item -name "*.vdf" )
        steamcmd +login "$INPUT_STEAMACCT" "$INPUT_STEAMPASSWD" +workshop_build_item "$upload" +quit
    fi
done
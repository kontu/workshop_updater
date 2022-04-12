#!/bin/bash
#steamAcct="AccountName"
#steamPasswd="Password"
#path="Mods"
#files=$(<filelist.txt)
#echo "$files"
#echo "$path"

## Debug
echo "Files:: $4"
echo "Path:: $1"
echo "SteamAcct:: $2"

mods=$(printf '%s\n' "${INPUT_FILES[@]}" | cut -f1-2 -d '/' | uniq)


for item in $mods
echo "Item:: $item"
do
    if [[ $item == $1* ]]; 
    then 
        upload=$(find /mnt/c/Users/kontu/scripts/workshop_updater_test/$item -name "*.vdf" )
        echo "Upload:: $upload"
        steamcmd +login "$2" "$3" +workshop_build_item "$upload" +quit
    fi
done
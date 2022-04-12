#!/bin/bash
#steamAcct="AccountName"
#steamPasswd="Password"
#path="Mods"
#files=$(<filelist.txt)
#echo "$files"
#echo "$path"

## Debug
echo "Files:: $files"
echo "Path:: $path"
echo "SteamAcct:: $steamAcct"

mods=$(printf '%s\n' "${files[@]}" | cut -f1-2 -d '/' | uniq)

for item in $mods
do
    if [[ $item == $path* ]]; 
    then 
        upload=$(find /mnt/c/Users/kontu/scripts/workshop_updater_test/$item -name "*.vdf" )
        steamcmd +login "$steamAcct" "$steamPasswd" +workshop_build_item "$upload" +quit
    fi
done
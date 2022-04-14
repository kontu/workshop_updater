# workshop
A GitHub Action to update Steam Workshop items

## Use it
You'll need to upload your addon using the Workshop tools of the game/app you're looking to submit to first. Then, create a `.github/workflows/main.yml` with something that resembles the following:

```yaml
name: update_steamWorkshop

on:
  push:
    paths:
    # Only triggers the action if a file is edited which exists somewhere beneath this path.
    # Should match it to what you set "path" to
      - 'Mods/**'

jobs:
  updateWorkshop:
    runs-on: [ubuntu-latest]
    steps:
      - name: checkout
        uses: actions/checkout@v2
        with:
          fetch-depth: 0
      - name: "Workshop update"
        uses: kontu/workshop_updater@v1.0
        with:
          path: 'Mods'
          steamAcct: ${{ secrets.steamAcct }}
          steamPasswd: ${{ secrets.steamPasswd }}
          ssfnContents: ${{ secrets.ssfnContents }} # base64 encoded - see readme
          ssfnFileName: 'ssfn1098596842295311902'
          steamConfigVdf: ${{ secrets.steam_config_vdf }}
```
## Example mod repo layout:
![Repo layout image](https://i.imgur.com/T9uuO3A.png)

## Mod folder
You will need to construct a vdf configuration file for each mod prior to using this action. Pathing relative to repository root are required.
Example vdf file:
```json
"workshopitem"
{
 "appid" "244850"
 "publishedfileid" "2793886717" 
 "contentfolder" "Mods/mod_one"
 "previewfile" "Mods/mod_one/thumb.png"
 "visibility" "0"
 "title" "mod_one"
 "description" "A demo mod named mod_one"
 "changenote" "Version 1.2"
}
```

Full steamworks documentation  https://partner.steamgames.com/doc/features/workshop/implementation?l=finnish&language=english

## Arguments
See action.yml list of inputs

## How to create MFA secrets : 
#### configVdf, ssfnFileName, and ssfnFileContents

Deploying to Steam requires using Multi-Factor Authentication (MFA) through Steam Guard. 
This means that simply using username and password isn't enough to authenticate with Steam. 
However, it is possible to go through the MFA process only once by setting up GitHub Secrets for configVdf, ssfnFileName, and ssfnFileContents with these steps:
1. Install [Valve's offical steamcmd](https://partner.steamgames.com/doc/sdk/uploading#1) on your local machine. All following steps will also be done on your local machine.
1. Try to login with `steamcmd +login <username> <password> +quit`, which may prompt for the MFA code. If so, type in the MFA code that was emailed to your builder account's email address.
1. Validate that the MFA process is complete by running `steamcmd +login <username> <password> +quit` again. It should not ask for the MFA code again.
1. The folder from which you run `steamcmd` will now contain an updated `config/config.vdf` file. Open the file and find the entry near the bottom for "SentryFile". Edit this Use `cat config/config.vdf > config_base64.txt` to encode the file. Copy the contents of `config_base64.txt` to a GitHub Secret `steamConfigVdf`.
1. That folder will also contain two files whose names look like `ssfn<numbers>`, **but one of them is a hidden file if on Windows**. [Find the hidden one](https://support.microsoft.com/en-us/windows/view-hidden-files-and-folders-in-windows-97fbc472-c603-9d90-91d0-1166d1d9f4b5), then copy the name of that file to a the `ssfnFileName` argument
1. Use `cat <ssfnFileName> | base64 > ssfn_base64.txt` to encode the contents of the hidden ssfn file. Copy the contents of `ssfn_base64.txt` to a GitHub Secret `ssfnContents`.

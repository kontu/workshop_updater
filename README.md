# Workshop Updater
A GitHub Action to update Steam Workshop items

## Using it
You'll need to upload your addon using the Workshop tools of the game/app you're looking to submit to first. Then, create a `.github/workflows/main.yml` with something that resembles the following:

```yaml
name: update_steamWorkshop

on:
  workflow_dispatch:
    inputs:
      modNames:
        Description: 'Full name of mod vdf to upload. Doesnt matter if you include the .vdf extension. If uploading multiple mods, separate with a space. Eg: `DraconisDIE_Nebula.vdf DraconisDIE_Tiers`'
        required: true

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

Full steamworks documentation  https://partner.steamgames.com/doc/features/workshop/implementation

## Arguments
See list of inputs in [action.yml](https://github.com/kontu/workshop_updater/blob/master/action.yml)

## How to create MFA secrets :
#### configVdf, ssfnFileName, and ssfnFileContents

Deploying to Steam often requires using Multi-Factor Authentication (MFA) through Steam Guard. This means that simply using username and password isn't enough to authenticate with Steam.

However, it is possible to go through the MFA process only once by setting up GitHub Secrets for configVdf with these steps:
1. Install [Valve's offical steamcmd](https://partner.steamgames.com/doc/sdk/uploading#1) on your local machine. All following steps will also be done on your local machine.
1. Try to login with `steamcmd +login <username> <password> +quit`, which may prompt for the MFA code. If so, type in the MFA code that was emailed to your builder account's email address.
1. Validate that the MFA process is complete by running `steamcmd +login <username> +quit` again. It should not ask for the MFA code again.
1. The folder from which you run `steamcmd` will now contain an updated `config/config.vdf` file. This is the file we want to store in secrets.steam_config_vdf, it contains the authentication information at the bottom.

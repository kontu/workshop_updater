FROM steamcmd/steamcmd

COPY entrypoint.sh /entrypoint.sh

ENV STEAM_ACCOUNT_NAME= ${{ secrets.steamAcct }}
ENV STEAM_PASSWORD= ${{ secrets.steamPasswd }}

ENTRYPOINT ["/entrypoint.sh"]
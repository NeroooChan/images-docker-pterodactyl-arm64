#!/bin/bash

# Vérifier si l'UUID est défini
if [ -z "$P_SERVER_UUID" ]; then
  echo "Erreur: l'UUID du serveur n'est pas défini."
  exit 1
fi

# Vérifier si le port est défini
if [ -z "$SERVER_PORT" ]; then
  echo "Erreur: le port du serveur FiveM n'est pas défini."
  exit 1
fi

# Lancer QEMU pour émuler x86_64 sur ARM64 et démarrer le serveur FiveM dans le sous-dossier
echo "Démarrage du serveur FiveM..."
exec qemu-x86_64-static /mnt/${USERNAME}/${P_SERVER_UUID}/alpine/opt/cfx-server/ld-musl-x86_64.so.1 \
  --library-path "/mnt/${USERNAME}/${P_SERVER_UUID}/alpine/usr/lib/v8/:/mnt/${USERNAME}/${P_SERVER_UUID}/alpine/lib/:/mnt/${USERNAME}/${P_SERVER_UUID}/alpine/usr/lib/" \
  -- /mnt/${USERNAME}/${P_SERVER_UUID}/alpine/opt/cfx-server/FXServer \
  +set citizen_dir /mnt/${USERNAME}/${P_SERVER_UUID}/alpine/opt/cfx-server/citizen/ \
  +set sv_licenseKey "$FIVEM_LICENSE" \
  +set steam_webApiKey "$STEAM_WEBAPIKEY" \
  +set sv_maxplayers "$MAX_PLAYERS" \
  +set serverProfile default \
  +set txAdminPort "$TXADMIN_PORT" \
  $( [ "$TXADMIN_ENABLE" == "0" ] && echo '+exec server.cfg' )

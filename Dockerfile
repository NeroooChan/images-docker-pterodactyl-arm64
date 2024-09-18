FROM python:3.10-bookworm

# Installer QEMU pour émuler x86_64 sur ARM64
RUN apt-get update && \
    apt-get install -y qemu-user-static

# Ajouter un utilisateur et un groupe 'container'
RUN useradd -m -d /home/container -s /bin/bash container

# Définir la variable d'environnement USERNAME
ENV USERNAME=container

# Créer les répertoires nécessaires et ajuster les permissions
RUN mkdir -p /mnt/container && \
    mkdir -p /mnt/container/${P_SERVER_UUID} && \
    chown -R ${USERNAME}:${USERNAME} /mnt/container && \
    chmod -R u+rwX /mnt/container && \
    chown -R ${USERNAME}:${USERNAME} /mnt/container/${P_SERVER_UUID} && \
    chmod -R u+rwX /mnt/container/${P_SERVER_UUID}

# Copier le script d'entrypoint
COPY entrypoint.sh /mnt/container/entrypoint.sh
RUN chmod +x /mnt/container/entrypoint.sh

# Exposer une plage de ports pour le serveur FiveM
EXPOSE 11000-12999

# Définir le point d'entrée du conteneur
ENTRYPOINT ["/mnt/container/entrypoint.sh"]

# Définir le répertoire de travail
WORKDIR /mnt/container


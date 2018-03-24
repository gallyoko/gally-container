# nodejs / npm / ionic / cordova sous ubuntu
#
# VERSION               0.0.1
#

FROM     ubuntu:artful
MAINTAINER Gallyoko "yogallyko@gmail.com"

# Definition des constantes
ENV login_ssh="gallyoko"
ENV password_ssh="gallyoko"

# Mise a jour des depots
RUN (apt-get update && apt-get upgrade -y -q && apt-get -y -q autoclean && apt-get -y -q autoremove)

# Installation des paquets necessaires
RUN apt-get install -y -q wget nano openssh-server git

# nodejs / npm
RUN apt-get install -y -q nodejs npm

# Ajout des liens symboliques pour nodejs / npm
RUN ln -s /usr/bin/nodejs /usr/local/bin/node
RUN ln -s /usr/bin/npm /usr/local/bin/npm

# ionic / cordova
RUN npm install -g ionic cordova

# Ajout utilisateur "${login_ssh}"
RUN adduser --quiet --disabled-password --shell /bin/bash --home /home/${login_ssh} --gecos "User" ${login_ssh}

# Modification du mot de passe pour "${login_ssh}"
RUN echo "${login_ssh}:${password_ssh}" | chpasswd

# Installation de Gally
RUN git clone -b v1.0 https://github.com/gallyoko/Gally.git /home/${login_ssh}/Gally
RUN chmod -Rf 777 /home/${login_ssh}/Gally
RUN chown -R ${login_ssh}:${login_ssh} /home/${login_ssh}/Gally
RUN sh /home/${login_ssh}/Gally/commands/install

EXPOSE 22 8100

# script de lancement des services et d affichage de l'accueil
COPY services.sh /root/services.sh
RUN chmod -f 755 /root/services.sh

# Ajout du script services.sh au demarrage
RUN echo "sh /root/services.sh" >> /root/.bashrc

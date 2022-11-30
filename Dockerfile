#FROM jupyter/base-notebook:python-3.7.6
FROM docker.io/ubuntu:22.04

USER root

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get -y update \
 && apt-get install -y dbus-x11 \
   wget \
   firefox \
   xfce4 \
   xfce4-panel \
   xfce4-session \
   xfce4-settings \
   xorg \
   xubuntu-icon-theme \
   python3 

# Remove light-locker to prevent screen lock
RUN wget 'https://sourceforge.net/projects/turbovnc/files/2.2.5/turbovnc_2.2.5_amd64.deb/download' -O turbovnc_2.2.5_amd64.deb && \
   apt-get install -y -q ./turbovnc_2.2.5_amd64.deb && \
   apt-get remove -y -q light-locker && \
   rm ./turbovnc_2.2.5_amd64.deb && \
   ln -s /opt/TurboVNC/bin/* /usr/local/bin/

# apt-get may result in root-owned directories/files under $HOME
RUN chown -R $NB_UID:$NB_GID $HOME

RUN apt-get install -y python3-pip

RUN \
    echo "**** install jupyter-hub native proxy ****" && \
    pip3 install jhsingle-native-proxy>=0.0.9 websockify


ENV USER=jovyan \
    UID=1001 \
    GID=100 \
    HOME=/workspace \
    PATH=/opt/conda/bin:/app/code-server/bin/:$PATH:/app/code-server/

RUN \
    echo "**** adds user jovyan ****" && \
    useradd -m -s /bin/bash -N -u $UID $USER 

ENTRYPOINT ["/opt/entrypoint.sh"]

ADD . /opt/install

COPY entrypoint.sh /opt/entrypoint.sh

RUN chmod +x /opt/entrypoint.sh

EXPOSE 8888

USER jovyan

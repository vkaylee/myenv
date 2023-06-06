FROM ubuntu:latest AS ubuntu
ARG myuser=docker
USER root
RUN apt-get update && \
    apt-get -y install sudo

RUN useradd --system -d "/home/${myuser}" -c ${myuser} -ms $(which bash) "${myuser}" && \
    echo "${myuser}:${myuser}" | chpasswd && \
    adduser ${myuser} sudo
# Allow sudo with no password
RUN echo "${myuser} ALL=(ALL) NOPASSWD:ALL" | tee -a "/etc/sudoers" > /dev/null
USER "${myuser}:${myuser}"
WORKDIR "/home/${myuser}"
# USER directive is not fully running in a user
# use: sudo su -i <user>. Ex: sudo su -i docker
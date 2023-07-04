# https://www.thegeekdiary.com/su-command-not-found/

ARG OS_NAME=ubuntu

FROM debian:latest AS debian
USER root
ARG SUDO_G=sudo
RUN apt-get update && \
    apt-get -y install util-linux sudo curl

FROM ubuntu:latest AS ubuntu
USER root
ARG SUDO_G=sudo
RUN apt-get update && \
    apt-get -y install util-linux sudo curl

FROM fedora:latest AS fedora
USER root
ARG SUDO_G=wheel
RUN dnf -y update && \
    dnf -y install util-linux which sudo curl

FROM ${OS_NAME} AS os
ARG myuser=docker

RUN useradd --system -d "/home/${myuser}" -c ${myuser} -ms $(which bash) "${myuser}" && \
    echo "${myuser}:${myuser}" | chpasswd && \
    usermod -aG ${SUDO_G} ${myuser}
# Allow sudo with no password
RUN echo "${myuser} ALL=(ALL) NOPASSWD:ALL" | tee -a "/etc/sudoers" > /dev/null
USER "${myuser}:${myuser}"
WORKDIR "/home/${myuser}"
# USER directive is not fully running in a user, test by: echo $USER
# use: sudo su - <user>. Ex: sudo su - docker
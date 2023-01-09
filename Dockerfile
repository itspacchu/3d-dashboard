FROM ubuntu:latest

LABEL maintainer="prashantn@riseup.net"
LABEL description="Godot build system"

ARG GODOT_VERSION
ENV GODOT_VERSION=${GODOT_VERSION}

# install updates
RUN apt update
RUN apt install -y wget unzip 

# install godot
RUN wget https://downloads.tuxfamily.org/godotengine/${GODOT_VERSION}/Godot_v${GODOT_VERSION}-stable_linux_headless.64.zip && \
    unzip Godot_v${GODOT_VERSION}-stable_linux_headless.64.zip && \
    mv Godot_v${GODOT_VERSION}-stable_linux_headless.64 /usr/bin/godot && \
    rm Godot_v${GODOT_VERSION}-stable_linux_headless.64.zip

# install godot export files
RUN wget https://downloads.tuxfamily.org/godotengine/${GODOT_VERSION}/Godot_v${GODOT_VERSION}-stable_export_templates.tpz && \
    unzip Godot_v${GODOT_VERSION}-stable_export_templates.tpz && \
    mkdir -p ~/.local/share/godot/templates/${GODOT_VERSION}.stable/ && \
    cp -r ./templates/* ~/.local/share/godot/templates/${GODOT_VERSION}.stable/ && \
    rm -rf ./templates Godot_v${GODOT_VERSION}-stable_export_templates.tpz

WORKDIR /godotapp
COPY . .

# compile for HTML5
RUN mkdir -p /godotapp/Exports/web/
RUN godot --path /godotapp --export HTML5
RUN ls /godotapp/Exports/web/
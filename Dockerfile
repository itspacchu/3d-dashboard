FROM ubuntu:latest as builder

LABEL maintainer="prashantn@riseup.net"
LABEL description="Godot build system"

ARG GODOT_VERSION="3.5.1"
ENV GODOT_VERSION=${GODOT_VERSION}

ARG GODOT_EXPORT_TYPE="HTML5"
ENV GODOT_EXPORT_TYPE=${GODOT_EXPORT_TYPE}

ARG GIT_REPO_URL="https://github.com/itspacchu/3d-dashboard"
ENV GIT_REPO_URL=${GIT_REPO_URL}

# install updates
RUN apt update
RUN apt install -y wget unzip git

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
#RUN git clone ${GIT_REPO_URL} ./

# compile for ${GODOT_EXPORT_TYPE}
RUN mkdir -p /godotapp/Exports/web/

RUN godot --path /godotapp --export ${GODOT_EXPORT_TYPE}

RUN ls /godotapp/Exports/web/

# === Final Stage ===
FROM nginx:latest

# Copy the exported files from the builder stage to the Nginx web root
COPY --from=builder /godotapp/Exports/web/ /var/www/html/

# COPY ./nginx/nginx.conf /etc/nginx/nginx.conf
RUN chmod 777 /var/www/html/

EXPOSE 80
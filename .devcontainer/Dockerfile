FROM node:20-slim

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        iptables \
        dnsutils \
        git \
        curl \
        ca-certificates \
        sudo \
    && rm -rf /var/lib/apt/lists/*

RUN echo "node ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/node

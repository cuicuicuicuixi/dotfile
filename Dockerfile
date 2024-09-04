FROM docker.io/library/debian:unstable-slim

RUN mkdir -p /workspace \
    && cp ../dotfile /workspace/ \
    && sh ./install_nix.sh

FROM i386/debian:bullseye

RUN dpkg --add-architecture i386 && \
    apt update && \
    apt install -y grub-pc-bin grub-common xorriso mtools gcc make

WORKDIR /project
CMD ["/bin/bash"]

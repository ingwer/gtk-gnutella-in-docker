FROM ubuntu:20.04 as builder

ARG VERSION=1.1.15

RUN apt-get update -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install make gcc libglib2.0-dev zlib1g-dev libgtk2.0-dev wget xz-utils tar gettext checkinstall -y --no-install-recommends && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/* && \
    wget --no-check-certificate https://sourceforge.net/projects/gtk-gnutella/files/gtk-gnutella/$VERSION/gtk-gnutella-$VERSION.tar.xz -O /gtk-gnutella-$VERSION.tar.xz && \
    tar -xf /gtk-gnutella-$VERSION.tar.xz -C / && \
    cd /gtk-gnutella-$VERSION && \
    ./build.sh && \
    checkinstall -D --install=no --fstrans=yes --pakdir=/


FROM ubuntu:20.04

ARG VERSION=1.1.15

COPY --from=builder /gtk-gnutella_${VERSION}-1_amd64.deb .

RUN apt-get update -y && \
    dpkg -i /gtk-gnutella_${VERSION}-1_amd64.deb && \
    DEBIAN_FRONTEND=noninteractive apt-get install sudo libgtk2.0-0 -y --no-install-recommends && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/* && \
    mkdir -p /home/user && \
    echo "user:x:1000:1000:user,,,:/home/user:/bin/bash" >> /etc/passwd && \
    echo "user:x:1000:" >> /etc/group && \
    echo "user ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/user && \
    chmod 0440 /etc/sudoers.d/user && \
    chown user:user -R /home/user

USER user
ENV HOME /home/user
WORKDIR /home/user
CMD /usr/local/bin/gtk-gnutella
FROM alpine:latest
MAINTAINER Miao Luo <miaol@vmware.com>

RUN apk --no-cache --no-progress update && apk --no-cache --no-progress upgrade
RUN apk --no-cache --no-progress add samba samba-common-tools supervisor

COPY *.conf /etc/samba/

# add a non-root user vfile with no password
RUN adduser -D -H vfile

# create a samba password for vfile user
RUN echo -e "vfile\nvfile" | smbpasswd -a -s vfile

# exposes samba's default ports
EXPOSE 137/udp 138/udp 139 445

# volume mapping
VOLUME ["/etc/samba"]

ENTRYPOINT ["supervisord", "-c", "/etc/samba/supervisord.conf"]

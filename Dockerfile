FROM alpine:latest
RUN wget -q -O /usr/local/bin/caddy 'https://caddyserver.com/api/download?os=linux&arch=amd64&p=github.com%2Fmholt%2Fcaddy-webdav&idempotency=74738857491080' \
 && chmod 555 /usr/local/bin/caddy

COPY --from=filebrowser/filebrowser:latest /filebrowser /usr/local/bin/filebrowser
COPY filebrowser.yml /home/.filebrowser.yml

COPY start.sh /start

ENV HOME /home
RUN mkdir /home/.config \
 && chmod 770 /home/.config \
 && chgrp 0 /home/.config

COPY Caddyfile /Caddyfile
RUN chmod 660 /Caddyfile \
 && chgrp 0 /Caddyfile

USER 1000
WORKDIR /data
ENTRYPOINT [ "/start" ]

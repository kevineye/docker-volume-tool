#!/bin/sh

caddy start --config /Caddyfile --watch

filebrowser config init --auth.method noauth
filebrowser users add admin '' --commands '.*' --lockPassword
exec filebrowser
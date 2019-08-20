#!/usr/bin/env bash
docker container run -it --rm --name=build-pve-debug-$(date +%s%N) $(docker image ls -q | head -n1) /bin/bash

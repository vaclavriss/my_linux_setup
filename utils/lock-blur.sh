#!/bin/bash
IMG=/tmp/lock.png
IMG_BLURRED=/tmp/lock_blurred.png

grim $IMG
ffmpeg -y -i $IMG -vf "gblur=sigma=5" -update 1 $IMG_BLURRED

swaylock -f -i $IMG_BLURRED --scaling fill

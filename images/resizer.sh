#!/bin/bash

#used brew imagemagick to get squircle shaped transparent corner icon
for size in 16 32 64 128 256 512 1024; do
  sips -z $size $size rounded_icon.png --out AppIcon-${size}x${size}.png
done

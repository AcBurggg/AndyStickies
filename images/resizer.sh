#!/bin/bash
for size in 16 32 64 128 256 512 1024; do
  sips -z $size $size icon.jpg --out AppIcon-${size}x${size}.png
done

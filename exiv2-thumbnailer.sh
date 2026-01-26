#!/usr/bin/env bash
set -euo pipefail

# This script is executed by GnomeDesktopThumbnailFactory inside a bwrap sandbox
# with a private /tmp.

# Typical invocation:
#  /tmp/gnome-desktop-file-to-thumbnail.ARW
#  /tmp/gnome-desktop-thumbnailer.png
#  256

src="${1:-}"
out="${2:-}"
size="${3:-256}"

# validate parameters
if [[ -z "$src" ]] || [[ -z "$out" ]] || [[ ! -f "$src" ]] || [[ -e "$out" ]]; then
  echo "Usage: $0 <input> <output> [size]" >&2
  exit 1
fi

# secure tmp files
umask 077

# create new tmp dir on ramdisk and clean up afterwards
tmpdir="$(mktemp -d /dev/shm/exiv2-thumbnailer.XXXXXX)"
trap 'rm -rf -- "$tmpdir"' EXIT

# extract preview image to tmp dir
exiv2 -l "$tmpdir" --extract p1 "$src"

name="$(basename "$src")"
preview="${tmpdir}/${name%.*}-preview1.jpg"

if [[ ! -f "$preview" ]]; then
  echo "ERROR: No embedded thumbnail found in '$src'" >&2
  exit 1
fi

# rotate and downscale preview image
# WARN: Removing -strip could cause thumbnail generation loop
magick "$preview" \
  -auto-orient \
  -fuzz 5% -trim +repage \
  -thumbnail "${size}x${size}>" \
  -strip \
  "png:$out"

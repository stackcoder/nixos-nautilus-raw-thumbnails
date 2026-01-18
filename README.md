# Nautilus Thumbnailer for RAW Previews for NixOS

A lightweight and fast thumbnailer for Nautilus that generates thumbnails for RAW image files using embedded previews extracted with exiv2.
This thumbnailer should work with most RAW formats that have embedded previews.

Tested on NixOS 25.11 with Nautilus (GNOME Files). Should work also with  Nemo and Caja.

<picture style="align: center; padding-bottom: 3mm;">
  <img alt="" src="./photo_preview/thumbnail_preview.png">
</picture>

## Troubleshooting

If thumbnails are not generated, check that mime type of your RAW files is contained in exiv2raw.thumbnailer.

If you're having issues with the thumbnailer, try these debugging steps:

1. Reset Nautilus and clear the thumbnail cache:
```bash
nautilus -q
rm -rf ~/.cache/thumbnails/*
```

2. Launch Nautilus with debugging enabled:
```bash
G_MESSAGES_DEBUG=all NAUTILUS_DEBUG=Window nautilus
```

3. Check if the script can extract thumbnails manually:
```bash
exiv2-thumbnailer.sh /path/to/your/file.RAW /tmp/test-thumbnail.png
```

4. Verify that your RAW files have embedded previews:
```bash
exiv2 -pp /path/to/your/file.RAW
```

#### Tested Formats

Working
- .ORF, .ARW, .NEF, .RAF, .CR2, .CR3, DNG, .RW2

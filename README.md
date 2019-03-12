# bingwallpaper
Grabs and sets Bing's wallpaper for Ubuntu 

```
Usage: ./bing.sh [--file=FILE] [--new] [--sum] [--help] [CC] 
Downloads and set latest wallpaper background from Bing homepage (www.bing.com).
CC	Two letter country code to give to Bing
--file=FILE	Don't set, save to FILE instead
--new	Attempts the newest wallpaper, not current one
--sum	Don't download image, just summarize
--help	Print this help and exit
Limitations: Only sets wallpaper with GNOME, but others still can use --file.
Copyright (c) 2018-2019 Tuoran (ArcticJieer) Zhang. All rights reserved. Version 2.0
```


Example: 
`./bing.sh --file=/tmp/wallpaper.jpg --new JP`
Grabs tommorrow's wallpaper from Bing Japan and save to /tmp/wallpaper.jpg

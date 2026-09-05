#!/bin/bash

# Configuración de URLs públicas de tus archivos en Cloudflare R2
LOGO_URL="https://pub-f00d5d649500451fb2fe8979f4685eea.r2.dev/logo.png"

# Lista de tus videos .mp4 en R2
VIDEOS=(
  "https://pub-f00d5d649500451fb2fe8979f4685eea.r2.dev/SEPARADOR.mp4"
  "https://pub-f00d5d649500451fb2fe8979f4685eea.r2.dev/benny%20blanco,%20Selena%20Gomez,%20Becky%20G%20-%20Te%20Olvido%20(La%20La).mp4"
  "https://pub-f00d5d649500451fb2fe8979f4685eea.r2.dev/SEPARADOR.mp4"
  "https://pub-f00d5d649500451fb2fe8979f4685eea.r2.dev/Taylor%20Swift%20-%20The%20Fate%20of%20Ophelia%20(Official%20Music%20Video).mp4"
  "https://pub-f00d5d649500451fb2fe8979f4685eea.r2.dev/Ana%20Mena%2C%20Emilia%20-%20CARITA%20TRISTE%20(Video%20Oficial).mp4"
  "https://pub-f00d5d649500451fb2fe8979f4685eea.r2.dev/Mark%20Ambor%20-%20Belong%20Together%20(Official%20Visualizer).mp4"
  "https://pub-f00d5d649500451fb2fe8979f4685eea.r2.dev/SEPARADOR.mp4"
  "https://pub-f00d5d649500451fb2fe8979f4685eea.r2.dev/Feid%20-%20Se%20Lo%20Juro%20Mor%20(Official%20Video).mp4"
  "https://pub-f00d5d649500451fb2fe8979f4685eea.r2.dev/KAROL%20G%2C%20Judeline%2C%20rusowsky%20-%20BbY%20WOW%20(Visualizer).mp4"
)

# Descargar logo
curl -s -o logo.png "$LOGO_URL"

while true; do
  RANDOM_INDEX=$((RANDOM % ${#VIDEOS[@]}))
  VIDEO_URL="${VIDEOS[$RANDOM_INDEX]}"

  echo "Transmitiendo a bajo bitrate: $VIDEO_URL"

  # Bitrate reducido a 1500k y audio a 96k
  ffmpeg -re -i "$VIDEO_URL" -i logo.png \
    -filter_complex \
    "[1:v]scale=80:-1[logo]; \
     [0:v][logo]overlay=main_w-overlay_w-20:20[v1]; \
     [v1]drawtext=fontsize=36:fontcolor=white:box=1:boxcolor=black@0.5:boxborderw=8:x=20:y=20:text='%{localtime\:%H\:%M}'"[v] \
    -map "[v]" -map 0:a \
    -c:v libx264 -preset ultrafast -b:v 1500k -maxrate 1500k -bufsize 3000k \
    -pix_fmt yuv420p -g 50 -c:a aac -b:a 96k -ar 44100 \
    -f flv "$1/$2"
done

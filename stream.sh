#!/bin/bash

LOGO_URL="https://pub-f00d5d649500451fb2fe8979f4685eea.r2.dev/logo.png"



# Lista de tus videos .mp4 en R2
VIDEOS=(
  "https://pub-f00d5d649500451fb2fe8979f4685eea.r2.dev/SEPARADOR.mp4"
  "https://pub-f00d5d649500451fb2fe8979f4685eea.r2.dev/SEPARADOR.mp4"
  "https://pub-f00d5d649500451fb2fe8979f4685eea.r2.dev/SEPARADOR.mp4"
  "https://pub-f00d5d649500451fb2fe8979f4685eea.r2.dev/Sabrina%20Carpenter%20-%20Tears%20(Official%20Video).mp4"
  "https://pub-f00d5d649500451fb2fe8979f4685eea.r2.dev/Ana%20Mena%2C%20Lola%20Indigo%20-%20pa%20ti%20toa%20(Video%20Oficial).mp4"
  "https://pub-f00d5d649500451fb2fe8979f4685eea.r2.dev/Abel%20Pintos%20-%20Ibuprofeno%20(Official%20Video)%20-%20Abel%20Pintos%20(720p).mp4"
  "https://pub-f00d5d649500451fb2fe8979f4685eea.r2.dev/Ariana%20Grande%20-%20hate%20that%20i%20made%20you%20love%20me%20(official%20lyric%20video).mp4"
  "https://pub-f00d5d649500451fb2fe8979f4685eea.r2.dev/Myke%20Towers%20%26%20Quevedo%20-%20SOLEAO%20(Official%20Music%20Video).mp4"
  "https://pub-f00d5d649500451fb2fe8979f4685eea.r2.dev/benny%20blanco,%20Selena%20Gomez,%20Becky%20G%20-%20Te%20Olvido%20(La%20La).mp4"
  "https://pub-f00d5d649500451fb2fe8979f4685eea.r2.dev/BAD%20BUNNY%20-%20ALAMBRE%20P%C3%BAA.mp4"
  "https://pub-f00d5d649500451fb2fe8979f4685eea.r2.dev/Taylor%20Swift%20-%20The%20Fate%20of%20Ophelia%20(Official%20Music%20Video).mp4"
  "https://pub-f00d5d649500451fb2fe8979f4685eea.r2.dev/Ana%20Mena%2C%20Emilia%20-%20CARITA%20TRISTE%20(Video%20Oficial).mp4"
  "https://pub-f00d5d649500451fb2fe8979f4685eea.r2.dev/Mark%20Ambor%20-%20Belong%20Together%20(Official%20Visualizer).mp4"
  "https://pub-f00d5d649500451fb2fe8979f4685eea.r2.dev/Camilo%2C%20Evaluna%20Montaner%20-%20PLIS%20(Official%20Video).mp4"
  "https://pub-f00d5d649500451fb2fe8979f4685eea.r2.dev/Feid%20-%20Se%20Lo%20Juro%20Mor%20(Official%20Video).mp4"
  "https://pub-f00d5d649500451fb2fe8979f4685eea.r2.dev/KAROL%20G%2C%20Judeline%2C%20rusowsky%20-%20BbY%20WOW%20(Visualizer).mp4"
)

# Descargar el logo localmente
curl -s -o logo.png "$LOGO_URL"

while true; do
  RANDOM_INDEX=$((RANDOM % ${#VIDEOS[@]}))
  VIDEO_URL="${VIDEOS[$RANDOM_INDEX]}"

  echo "Transmitiendo: $VIDEO_URL"

  # Transmisión únicamente con el logo al 35% del ancho de pantalla
  ffmpeg -re -i "$VIDEO_URL" -i logo.png \
    -filter_complex \
    "[1:v]scale=iw*0.20:-1[logo]; \
     [0:v][logo]overlay=main_w-overlay_w-20:20[v]" \
    -map "[v]" -map 0:a \
    -c:v libx264 -preset ultrafast -b:v 1500k -maxrate 1500k -bufsize 3000k \
    -pix_fmt yuv420p -g 50 -c:a aac -b:a 96k -ar 44100 \
    -f flv "$1/$2"
done

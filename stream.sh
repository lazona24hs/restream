#!/bin/bash

# Configuración de URLs
AUDIO_RADIO="https://stream.zeno.fm/idqecp6rhbnvv"  # URL del stream de radio
FONDO_VIDEO="https://github.com/lazona24hs/restream/raw/refs/heads/main/fondo.mp4" # Video para el fondo
LOGO_URL="https://github.com/lazona24hs/restream/raw/refs/heads/main/logo.png"

# Descargar video de fondo y logo
curl -s -o fondo.mp4 "$FONDO_VIDEO"
curl -s -o logo.png "$LOGO_URL"

echo "Iniciando retransmisión de Radio IPTV con video de fondo..."

# FFmpeg: Video en bucle (-stream_loop -1) + Audio Radio + Logo al 35%
ffmpeg -stream_loop -1 -re -i fondo.mp4 -i "$AUDIO_RADIO" -i logo.png \
  -filter_complex \
  "[2:v]scale=iw*0.20:-1[logo]; \
   [0:v][logo]overlay=main_w-overlay_w-20:20[v]" \
  -map "[v]" -map 1:a \
  -c:v libx264 -preset ultrafast -b:v 1500k -maxrate 1500k -bufsize 3000k \
  -pix_fmt yuv420p -g 50 -c:a aac -b:a 128k -ar 44100 \
  -f flv "$1/$2"

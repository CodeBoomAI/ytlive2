#!/bin/bash

# Konfigurasi
STREAM_KEY="u2sy-pedp-y0t9-356w-bgj1"  # Ganti dengan stream key Anda
IMAGE_DIR="/c/Users/Administrator/Desktop/ytlive/gambar"
AUDIO_FILE="/c/Users/Administrator/Desktop/ytlive/audio/kiamat.mp3"
DURATION_PER_IMAGE=5                 # Durasi per gambar (detik)

# Generate input gambar dengan durasi tetap
ffmpeg \
  -loop 1 -t $DURATION_PER_IMAGE -i "$IMAGE_DIR/image_001.png" \
  -loop 1 -t $DURATION_PER_IMAGE -i "$IMAGE_DIR/image_002.png" \
  -loop 1 -t $DURATION_PER_IMAGE -i "$IMAGE_DIR/image_003.png" \
  -loop 1 -t $DURATION_PER_IMAGE -i "$IMAGE_DIR/image_004.png" \
  -loop 1 -t $DURATION_PER_IMAGE -i "$IMAGE_DIR/image_005.png" \
  -loop 1 -t $DURATION_PER_IMAGE -i "$IMAGE_DIR/image_006.png" \
  -stream_loop -1 -i "$AUDIO_FILE" \
  -filter_complex "
    [0:v]scale=720:1280:force_original_aspect_ratio=decrease,pad=720:1280:(ow-iw)/2:(oh-ih)/2,setsar=1[v0];
    [1:v]scale=720:1280:force_original_aspect_ratio=decrease,pad=720:1280:(ow-iw)/2:(oh-ih)/2,setsar=1[v1];
    [2:v]scale=720:1280:force_original_aspect_ratio=decrease,pad=720:1280:(ow-iw)/2:(oh-ih)/2,setsar=1[v2];
    [3:v]scale=720:1280:force_original_aspect_ratio=decrease,pad=720:1280:(ow-iw)/2:(oh-ih)/2,setsar=1[v3];
    [4:v]scale=720:1280:force_original_aspect_ratio=decrease,pad=720:1280:(ow-iw)/2:(oh-ih)/2,setsar=1[v4];
    [5:v]scale=720:1280:force_original_aspect_ratio=decrease,pad=720:1280:(ow-iw)/2:(oh-ih)/2,setsar=1[v5];
    [v0][v1][v2][v3][v4][v5]concat=n=6:v=1:a=0[outv]
  " \
  -map "[outv]" \
  -map 6:a \
  -c:v libx264 -preset veryfast -tune stillimage -pix_fmt yuv420p \
  -c:a aac -b:a 128k -ar 44100 -ac 2 \
  -f flv "rtmp://a.rtmp.youtube.com/live2/$STREAM_KEY"
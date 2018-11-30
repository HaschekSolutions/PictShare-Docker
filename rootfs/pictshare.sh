#!/bin/bash
set -euo pipefail

# Usage: _legacyVar OLDVARNAME NEW_VAR_NAME
# Will assign old name to new for backwards compatability
_legacyVar() {
    if [[ -z ${!2:-} && -n ${!1:-} ]]; then
        echo "[w] ENV variable defined as \"$1\" is deprecated and should be defined as \"$2\""
        declare -g "${2}=${!1}"
    fi
}

_maxUploadSize() {
    echo "[i] Setting uploadsize to ${MAX_UPLOAD_SIZE}M"
    sed -i -e "s/100M/${MAX_UPLOAD_SIZE}M/g" /etc/php7/php.ini
    sed -i -e "s/50M/${MAX_UPLOAD_SIZE}M/g" /etc/nginx/conf.d/default.conf

    MAX_RAM=$((MAX_UPLOAD_SIZE + 30)) # 30megs more than the upload size
    echo "[i] Also changing memory limit of PHP to ${MAX_RAM}M"
    sed -i -e "s/128M/${MAX_RAM}M/g" /etc/php7/php.ini
}

_update() {
    echo "[i] Updating installation"
    curl --silent --remote-name https://codeload.github.com/chrisiaut/pictshare/zip/master
    unzip -q master
    cp -r pictshare-master/* .
    rm -r master pictshare-master
    chmod +x bin/ffmpeg
}

_filePermissions() {
    chown -R nginx:nginx /usr/share/nginx/html
}

_buildConfig() {
    echo "<?php"
    echo "define('TITLE', '${TITLE:-PictShare}');"
    echo "define('MASTER_DELETE_CODE', '${MASTER_DELETE_CODE:-}');"
    echo "define('MASTER_DELETE_IP', '${MASTER_DELETE_IP:-}');"
    echo "define('UPLOAD_FORM_LOCATION', '${UPLOAD_FORM_LOCATION:-}');"
    echo "define('LOW_PROFILE', ${LOW_PROFILE:-false});"
    echo "define('UPLOAD_CODE', '${UPLOAD_CODE:-}');"
    echo "define('IMAGE_CHANGE_CODE', '${IMAGE_CHANGE_CODE:-}');"
    echo "define('LOG_UPLOADER', ${LOG_UPLOADER:-false});"
    echo "define('MAX_RESIZED_IMAGES',${MAX_RESIZED_IMAGES:--1});"
    echo "define('ALLOW_BLOATING', ${ALLOW_BLOATING:-false});"
    echo "define('FORCE_DOMAIN', '${FORCE_DOMAIN:-}');"
    echo "define('SHOW_ERRORS', ${SHOW_ERRORS:-false});"
    echo "define('JPEG_COMPRESSION', ${JPEG_COMPRESSION:-90});"
    echo "define('PNG_COMPRESSION', ${PNG_COMPRESSION:-6});"
    echo "define('ALT_FOLDER', '${ALT_FOLDER:-}');"
    echo "define('BACKBLAZE', ${BACKBLAZE:-false});"
    echo "define('BACKBLAZE_ID', '${BACKBLAZE_ID:-}');"
    echo "define('BACKBLAZE_KEY', '${BACKBLAZE_KEY:-}');"
    echo "define('BACKBLAZE_BUCKET_ID', '${BACKBLAZE_BUCKET_ID:-}');"
    echo "define('BACKBLAZE_BUCKET_NAME', '${BACKBLAZE_BUCKET_NAME:-}');"
    echo "define('BACKBLAZE_AUTODOWNLOAD', ${BACKBLAZE_AUTODOWNLOAD:-true});"
    echo "define('BACKBLAZE_AUTOUPLOAD', ${BACKBLAZE_AUTOUPLOAD:-true});"
    echo "define('BACKBLAZE_AUTODELETE', ${BACKBLAZE_AUTODELETE:-true});"
    echo "define('FFMPEG_BINARY', '${FFMPEG_BINARY:-}');"
}

_main() {
    echo 'Setting up PictShare'

    _legacyVar AUTOUPDATE AUTO_UPDATE
    _legacyVar MASTERDELETECODE MASTER_DELETE_CODE
    _legacyVar UPLOADPATH UPLOAD_FORM_LOCATION
    _legacyVar LOWPROFILE LOW_PROFILE
    _legacyVar UPLOADCODE UPLOAD_CODE
    _legacyVar IMAGECHANGECODE IMAGE_CHANGE_CODE
    _legacyVar LOGUPLOADER LOG_UPLOADER
    _legacyVar MAXRESIZEDIMAGES MAX_RESIZED_IMAGES
    _legacyVar MAXUPLOADSIZE MAX_UPLOAD_SIZE
    _legacyVar BLOATING ALLOW_BLOATING
    _legacyVar DOMAIN FORCE_DOMAIN
    _legacyVar SHOWERRORS SHOW_ERRORS
    _legacyVar JPEGCOMPRESSION JPEG_COMPRESSION
    _legacyVar PNGCOMPRESSION PNG_COMPRESSION

    if [[ ${MAX_UPLOAD_SIZE:=100} =~ ^[0-9]+$ ]]; then
        _maxUploadSize
    fi

    if [[ ${AUTO_UPDATE:=true} = true ]]; then
        _update
    fi

    _buildConfig > inc/config.inc.php

    echo '[i] Done! Starting nginx'

    exec /init
}

if [[ $0 = $BASH_SOURCE ]]; then
    _main "$@"
fi

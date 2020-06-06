#!/bin/bash
set -euo pipefail

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
    curl --silent --remote-name https://codeload.github.com/HaschekSolutions/pictshare/zip/master
    unzip -q master
    cp -r pictshare-master/* .
    rm -r master pictshare-master
    chmod +x bin/ffmpeg
    chmod -R 777 data
    chmod -R 777 tmp
}

_filePermissions() {
    chown -R nginx:nginx /usr/share/nginx/html
}

_buildConfig() {
    echo "<?php"
    echo "define('URL', '${URL:-}');"
    echo "define('TITLE', '${TITLE:-PictShare}');"
    echo "define('CONTENTCONTROLLERS', '${CONTENTCONTROLLERS:-}');"
    echo "define('MASTER_DELETE_CODE', '${MASTER_DELETE_CODE:-}');"
    echo "define('MASTER_DELETE_IP', '${MASTER_DELETE_IP:-}');"
    echo "define('UPLOAD_FORM_LOCATION', '${UPLOAD_FORM_LOCATION:-}');"
    echo "define('UPLOAD_CODE', '${UPLOAD_CODE:-}');"
    echo "define('LOG_UPLOADER', ${LOG_UPLOADER:-false});"
    echo "define('MAX_RESIZED_IMAGES',${MAX_RESIZED_IMAGES:--1});"
    echo "define('ALLOW_BLOATING', ${ALLOW_BLOATING:-false});"
    echo "define('SHOW_ERRORS', ${SHOW_ERRORS:-false});"
    echo "define('JPEG_COMPRESSION', ${JPEG_COMPRESSION:-90});"
    echo "define('PNG_COMPRESSION', ${PNG_COMPRESSION:-6});"
    echo "define('ALT_FOLDER', '${ALT_FOLDER:-}');"
    echo "define('S3_BUCKET', '${S3_BUCKET:-}');"
    echo "define('S3_ACCESS_KEY', '${S3_ACCESS_KEY:-}');"
    echo "define('S3_SECRET_KEY', '${S3_SECRET_KEY:-}');"
    echo "define('S3_ENDPOINT', '${S3_ENDPOINT:-}');"
    echo "define('FTP_SERVER', '${FTP_SERVER:-}');"
    echo "define('FTP_PORT', ${FTP_PORT:-21});"
    echo "define('FTP_USER', '${FTP_USER:-}');"
    echo "define('FTP_PASS', '${FTP_PASS:-}');"
    echo "define('FTP_SSL', ${FTP_SSL:-false});"
    echo "define('FTP_BASEDIR', '${FTP_BASEDIR:-}');"
    echo "define('ENCRYPTION_KEY', '${ENCRYPTION_KEY:-}');"
    if [[ "$(uname -m)" = "x86_64" ]]; then
        echo "define('FFMPEG_BINARY', '${FFMPEG_BINARY:-/usr/share/nginx/html/bin/ffmpeg}');"
    else
        echo "define('FFMPEG_BINARY', '${FFMPEG_BINARY:-/usr/bin/ffmpeg}');"
    fi
}

_main() {
    echo 'Setting up PictShare'

    touch /usr/share/nginx/html/data/sha1.csv
    chown nginx:nginx /usr/share/nginx/html/data/sha1.csv

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

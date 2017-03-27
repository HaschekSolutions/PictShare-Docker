#!/bin/bash

echo "Setting up PictShare"

if [ -v ${TITLE} ]; then
		TITLE="PictShare"
fi

if [ -v ${MASTERDELETECODE} ]; then
		MASTERDELETECODE=""
fi

if [ -v ${BLOATING} ]; then
		BLOATING="false"
fi


if [ -v ${UPLOADCODE} ]; then
		UPLOADCODE=""
fi


if [ -v ${UPLOADPATH} ]; then
		UPLOADPATH=""
fi


if [ -v ${LOWPROFILE} ]; then
		LOWPROFILE="false"
fi


if [ -v ${IMAGECHANGECODE} ]; then
		IMAGECHANGECODE=""
fi


if [ -v ${LOGUPLOADER} ]; then
		LOGUPLOADER="false"
fi

if [ -v ${MAXRESIZEDIMAGES} ]; then
		MAXRESIZEDIMAGES="-1"
fi

if [ -v ${DOMAIN} ]; then
		DOMAIN=""
fi

if [ -v ${SHOWERRORS} ]; then
		SHOWERRORS="false"
fi

if [ -v ${PNGCOMPRESSION} ]; then
		PNGCOMPRESSION="6"
fi

if [ -v ${JPEGCOMPRESSION} ]; then
		JPEGCOMPRESSION="90"
fi

if [ -v ${MAXUPLOADSIZE} ]; then
		MAXUPLOADSIZE="100"
fi

re='^[0-9]+$'
if [[ $MAXUPLOADSIZE =~ $re ]]; then
		echo "[i] Setting uploadsize to ${MAXUPLOADSIZE}"
		sed -i -e "s/100M/${MAXUPLOADSIZE}M/g" /etc/php7/php.ini
		sed -i -e "s/50M/${MAXUPLOADSIZE}M/g" /etc/nginx/conf.d/default.conf
	
		MAXRAM=$(($MAXUPLOADSIZE + 30)) #30megs more than the upload size
		sed -i -e "s/128M/${MAXRAM}M/g" /etc/php7/php.ini
		echo "[i] Also changing memory limit of PHP to ${MAXRAM}"
		
fi

if [ -v ${AUTOUPDATE} ]; then
		AUTOUPDATE="true"
fi

if [ ${AUTOUPDATE} = "true" ]; then
		echo "[i] Updating installation"
		cd /usr/share/nginx/html
		curl -O https://codeload.github.com/chrisiaut/pictshare/zip/master
		unzip master
		cp -rf pictshare-master/* .
		rm -rf pictshare-master
		rm master
fi

chown -Rf nginx:nginx /usr/share/nginx/html
chmod -R 777 /usr/share/nginx/html/

echo "<?php " > /usr/share/nginx/html/inc/config.inc.php
echo "define('TITLE', '${TITLE}');" >> /usr/share/nginx/html/inc/config.inc.php
echo "define('MASTER_DELETE_CODE', '${MASTERDELETECODE}');" >> /usr/share/nginx/html/inc/config.inc.php
echo "define('UPLOAD_FORM_LOCATION', '${UPLOADPATH}');" >> /usr/share/nginx/html/inc/config.inc.php
echo "define('LOW_PROFILE', ${LOWPROFILE});" >> /usr/share/nginx/html/inc/config.inc.php
echo "define('UPLOAD_CODE', '${UPLOADCODE}');" >> /usr/share/nginx/html/inc/config.inc.php
echo "define('IMAGE_CHANGE_CODE', '${IMAGECHANGECODE}');" >> /usr/share/nginx/html/inc/config.inc.php
echo "define('LOG_UPLOADER', ${LOGUPLOADER});" >> /usr/share/nginx/html/inc/config.inc.php
echo "define('MAX_RESIZED_IMAGES',${MAXRESIZEDIMAGES});" >> /usr/share/nginx/html/inc/config.inc.php
echo "define('ALLOW_BLOATING', ${BLOATING});" >> /usr/share/nginx/html/inc/config.inc.php
echo "define('FORCE_DOMAIN', '${DOMAIN}');" >> /usr/share/nginx/html/inc/config.inc.php
echo "define('SHOW_ERRORS', ${SHOWERRORS});" >> /usr/share/nginx/html/inc/config.inc.php
echo "define('JPEG_COMPRESSION', ${JPEGCOMPRESSION});" >> /usr/share/nginx/html/inc/config.inc.php
echo "define('PNG_COMPRESSION', ${PNGCOMPRESSION});" >> /usr/share/nginx/html/inc/config.inc.php

echo "[i] Done! Starting nginx"

/init

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

if [ -n ${MAXUPLOADSIZE} ]; then
		sed -i -e "s/50M/${MAXUPLOADSIZE}M/g" /etc/php5/fpm/php.ini
		sed -i -e "s/50M/${MAXUPLOADSIZE}M/g" /etc/nginx/sites-available/default
		sed -i -e "s/50M/${MAXUPLOADSIZE}M/g" /etc/nginx/sites-enabled/default
fi

if [ -v ${AUTOUPDATE} ]; then
		AUTOUPDATE="true"
fi

if [ ${AUTOUPDATE}="true" ]; then
		echo "[i] Updating installation"
		cd /opt/
		curl -O https://codeload.github.com/chrisiaut/pictshare/zip/master
		unzip master
		cp -r pictshare-master/* pictshare/.
		rm -rf pictshare-master
		rm master
fi

echo "<?php " > /opt/pictshare/inc/config.inc.php
echo "define('TITLE', '${TITLE}');" >> /opt/pictshare/inc/config.inc.php
echo "define('MASTER_DELETE_CODE', '${MASTERDELETECODE}');" >> /opt/pictshare/inc/config.inc.php
echo "define('UPLOAD_FORM_LOCATION', '${UPLOADPATH}');" >> /opt/pictshare/inc/config.inc.php
echo "define('LOW_PROFILE', ${LOWPROFILE});" >> /opt/pictshare/inc/config.inc.php
echo "define('UPLOAD_CODE', '${UPLOADCODE}');" >> /opt/pictshare/inc/config.inc.php
echo "define('IMAGE_CHANGE_CODE', '${IMAGECHANGECODE}');" >> /opt/pictshare/inc/config.inc.php
echo "define('LOG_UPLOADER', ${LOGUPLOADER});" >> /opt/pictshare/inc/config.inc.php
echo "define('MAX_RESIZED_IMAGES',${MAXRESIZEDIMAGES});" >> /opt/pictshare/inc/config.inc.php
echo "define('ALLOW_BLOATING', ${BLOATING});" >> /opt/pictshare/inc/config.inc.php
echo "define('FORCE_DOMAIN', '${DOMAIN}');" >> /opt/pictshare/inc/config.inc.php
echo "define('SHOW_ERRORS', ${SHOWERRORS});" >> /opt/pictshare/inc/config.inc.php

echo "[i] Done! Starting nginx"

service php5-fpm start && nginx
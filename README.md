# Official PictShare Docker image - Now based on Alpine Linux and PHP 7
The fastest way to deploy [PictShare](https://www.pictshare.net)

It automatically updates on start unless you supply the env variable AUTOUPDATE=false

[![Docker setup](http://www.pictshare.net/b65dea2117.gif)](https://www.pictshare.net/8a1dec0973.mp4)

## Usage

### Building it
```bash
docker build -t hascheksolutions/pictshare .
```

### Quick start
```bash
docker run -d -p 80:80 --name=pictshare hascheksolutions/pictshare
```

### Persistent data
```bash
mkdir /data/pictshareuploads
chown 1000 -R /data/pictshareuploads
docker run -d -v /data/pictshareuploads:/usr/share/nginx/html/upload -p 80:80 --name=pictshare hascheksolutions/pictshare
```

### Persistent data with increased max upload size
```bash
mkdir /data/pictshareuploads
chown 1000 -R /data/pictshareuploads
docker run -d -e "MAX_UPLOAD_SIZE=1024" -v /data/pictshareuploads:/usr/share/nginx/html/upload -p 80:80 --name=pictshare hascheksolutions/pictshare
```

### Scale PictShare by using Backblaze buckets for persistent storage
```bash
docker run -e "BACKBLAZE=true" -e "BACKBLAZE_ID=yourIDhere" -e "BACKBLAZE_KEY=yourKEYhere" -e "BACKBLAZE_BUCKET_ID=yourbucketIDhere" -e "BACKBLAZE_BUCKET_NAME=yourbucketNAMEhere" -d -p 80:80 hascheksolutions/pictshare
```

## ENV Variables
There are some ENV variables that only apply to the Docker image
- AUTO_UPDATE (true/false | should the container upgrade on every start? default: true)
- MAX_UPLOAD_SIZE (int | size in MB that will be used for nginx. default 50)

Every other variable can be referenced against the [default PictShare configuration file](https://github.com/chrisiaut/pictshare/blob/master/inc/example.config.inc.php).
- TITLE (string | Title of the page)
- PNG_COMPRESSION (int | 0-9 how much compression is used. note that this never affects quality. default: 6)
- JPEG_COMPRESSION (int | 0-100 how high should the quality be? More is better. default: 90)
- MASTER_DELETE_CODE (string | code if added to any url, will delete the image)
- MASTER_DELETE_IP (string | ip which can delete any image)
- ALLOW_BLOATING (true/false | can images be bloated to higher resolutions than the originals)
- UPLOAD_CODE (string | code that has to be supplied to upload an image)
- UPLOAD_FORM_LOCATION (string | absolute path where upload gui will be shown)
- LOW_PROFILE (string | won't display error messages on failed uploads)
- IMAGE_CHANGE_CODE (string | code if provided, needs to be added to image to apply filter/rotation/etc)
- LOG_UPLOADER (true/false | log IPs of uploaders)
- MAX_RESIZED_IMAGES (int | how many versions of a single image may exist? -1 for infinite)
- FORCE_DOMAIN (string | force all URLs to domain)
- SHOW_ERRORS (true/false | show upload/size/server errors?)
- BACKBLAZE (true/false | Enable backblaze B2 support)
- BACKBLAZE_ID (Your Backblaze User ID)
- BACKBLAZE_KEY (Your Backblaze API Key)
- BACKBLAZE_BUCKET_ID (Bucket ID)
- BACKBLAZE_BUCKET_NAME (The name of the bucket - must be same as on backblaze)
- BACKBLAZE_AUTODOWNLOAD (Should images be downloaded from backblaze if they don't exist locally?)
- BACKBLAZE_AUTOUPLOAD (Should newly uploaded images be uploaded  to backblaze?)
- BACKBLAZE_AUTODELETE (Should images be deleted form backblaze if they are deleted on pictshare?)
- ALT_FOLDER (path to a folder where all hashes will be copied to and looked for offsite backup via nfs for example)

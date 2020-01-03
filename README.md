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
docker run -d -v /data/pictshareuploads:/usr/share/nginx/html/data -p 80:80 --name=pictshare hascheksolutions/pictshare
```

### Persistent data with increased max upload size
```bash
mkdir /data/pictshareuploads
chown 1000 -R /data/pictshareuploads
docker run -d -e "MAX_UPLOAD_SIZE=1024" -v /data/pictshareuploads:/usr/share/nginx/html/data -p 80:80 --name=pictshare hascheksolutions/pictshare
```

## ENV Variables
There are some ENV variables that only apply to the Docker image
- AUTO_UPDATE (true/false | should the container upgrade on every start? default: true)
- MAX_UPLOAD_SIZE (int | size in MB that will be used for nginx. default 50)

Every other variable can be referenced against the [default PictShare configuration file](https://github.com/HaschekSolutions/pictshare/blob/master/inc/example.config.inc.php).
- TITLE (string | Title of the page)
- URL (string | URL that will be linked to new uploads)
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
- SHOW_ERRORS (true/false | show upload/size/server errors?)
- ALT_FOLDER (path to a folder where all hashes will be copied to and looked for offsite backup via nfs for example)
- ALLOWED_SUBNET (If set, will only show the upload form and allow to upload via API if request is coming from this subnet)

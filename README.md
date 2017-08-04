# Official PictShare Docker image - Now based on Alpine Linux and PHP 7
The fastest way to deploy [PictShare](https://www.pictshare.net)

It automatically updates on start unless you supply the env variable AUTOUPDATE=false

[![Docker setup](http://www.pictshare.net/b65dea2117.gif)](https://www.pictshare.net/8a1dec0973.mp4)

## Usage
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
docker run -d -e "MAXUPLOADSIZE=1024" -v /data/pictshareuploads:/usr/share/nginx/html/upload -p 80:80 --name=pictshare hascheksolutions/pictshare
```


## ENV Variables
- TITLE (string | Title of the page)
- PNGCOMPRESSION (int | 0-9 how much compression is used. note that this never affects quality. default: 6)
- JPEGCOMPRESSION (int | 0-100 how high should the quality be? More is better. default: 90)
- AUTOUPDATE (true/false | should the container upgrade on every start? default: true)
- MAXUPLOADSIZE (int | size in MB that will be used for nginx. default 50)
- MASTERDELETECODE (string | code if added to any url, will delete the image)
- BLOATING (true/false | can images be bloated to higher resolutions than the originals)
- UPLOADCODE (string | code that has to be supplied to upload an image)
- UPLOADPATH (string | absolute path where upload gui will be shown)
- LOWPROFILE (string | won't display error messages on failed uploads)
- IMAGECHANGECODE (string | code if provided, needs to be added to image to apply filter/rotation/etc)
- LOGUPLOADER (true/false | log IPs of uploaders)
- MAXRESIZEDIMAGES (int | how many versions of a single image may exist? -1 for infinite)
- DOMAIN (string | force all URLs to domain)
- SHOWERRORS (true/false | show upload/size/server errors?)


https://hub.docker.com/r/delfer/alpine-ftp-server

docker run -d \
    -p 21:21 \
    -p 21000-21010:21000-21010 \
    -e USERS="ftpuser|ftp@1234|/home/user/ftpuser" \
    -e ADDRESS=ftp.site.domain \
    delfer/alpine-ftp-server
## MinIO FTP Feature: ftp/sftp

Allows MinIO to serve legacy systems, and upload and download objects.
FTP/SFTP is used for legacy systems that cannot use S3.

### Setup FTP
```bash
minio server --ftp="address=:8021" data
```

Connect to  FTP server with lftp client:
```text
lftp -p 8021 -u ftpuser localhost
ftp> ls 
ftp> cd bucket
ftp> get photo.png
```

Credentials are supported via MinIO Access Management System: i.e. MinIO IDP, LDAP, or OpenID. That means user ftpuser is already setup in MinIO.

### Setup SFTP
If certificates are enabled in minio server we can also use SFTP.
MinIO server uses TLS and lftp client needs to be enabled to use TLS.

```bash
minio server --sftp="address=:8022" --sftp="ssh-private-key=minio-key" data
```

**Note**:
> SFTP is an extension of SSH, then using 9022 port is meaningful! It is actually FTP over SSH. There is also FTPS that is FTP over SSL.
> 
> Given private key is generated by SSH Keygen tool.

Connecting to SFTP by sftp client:

```bash
sftp -P 8022 ftupuser@localhost
```

Generating SSH key example:
```bash
ssh-keygen -f ~/.ssh/sftp-key
```
It creates key-pairs in **_/home/javad/.ssh/sftp-key_** and **_/home/javad/.ssh/sftp-key.pub_** files.

### Limitations
- You cannot access to different versions of an object if the bucket is versioned.
- You cannot rename an object
- The commands that you run over FTP comparing to MinIO Client are limited:  gets, puts, ls, mkdirs, rmdirs, and delete.

Bucket versioning checking with MinIO client.
```bash
mc version info demo/bucket
mc ls --versions demo/bucket
```
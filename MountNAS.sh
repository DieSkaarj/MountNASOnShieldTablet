## Point script to the bash binary 
#!/data/data/com.termux/files/usr/bin/bash

## All the following variables can be hardcoded to the values particular to your setup.
read -p 'Server: ' SERVER
read -p 'Share name: ' SHARE

## Create a mount point in the root filesystem
if ! [ -d /mnt/$SHARE ]; then
  sudo mkdir /mnt/$SHARE
else
  if [ 'mount | grep /mnt/$SHARE > /dev/null' ]; then
    sudo umount /mnt/$SHARE
  fi
fi

## Instead of handling username and password a credentials file can be used.
read -p 'User: ' USER
read -sp 'Password: ' PWD
#read -p 'Credentials: ' CRED

## Use CIFS to mount as 'root' attached to the group 'sdcard_rw'
sudo mount -t cifs -o user=$USER,password=$PWD,uid=0,gid=1015 //$SERVER/$SHARE /mnt/$SHARE
#sudo mount -t cifs -o credentials=$CRED,uid=0,gid=1015 //$SERVER/$SHARE /mnt/$SHARE

if ! [ 'mount | grep /mnt/$SHARE > /dev/null' ]; then
  echo Share not mounted.
  exit 1
fi

# Android 7.0 handles storage functions through folder names.
if ! [ -d /mnt/runtime/{default,read,write}/$SHARE ]; then
  sudo mkdir /mnt/runtime/{default,read,write}/$SHARE
fi

sudo mount -o bind /mnt/$SHARE /mnt/runtime/default/$SHARE
sudo mount -o bind /mnt/$SHARE /mnt/runtime/read/$SHARE
sudo mount -o bind /mnt/$SHARE /mnt/runtime/write/$SHARE

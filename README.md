# kde-service-mount-iso-image
KDE Services menu for mount ISOS and DISK IMG

#Install instruccions.

Dependencies
------------
`sudo apt install fuse3 fuseiso libfuse2:amd64 libfuse3-3:amd64`

Install
-------
``cd /tmp/    
wget https://github.com/kamalmjt/kde-service-mount-iso-image/archive/refs/heads/main.zip -O /tmp/kde-service-mount-iso-image-main.zip  
unzip /tmp/kde-service-mount-iso-image-main.zip  
mkdir ~/bin/  
cp kde-service-mount-iso-image-main/iso_manager-mount-image.sh ~/bin/iso_manager-mount-image.sh  
cp kde-service-mount-iso-image-main/iso_mounter_unmounter.desktop ~/.local/share/kio/servicemenus/iso_mounter_unmounter.desktop  
chmod +x ~/bin/iso_manager-mount-image.sh ~/.local/share/kio/servicemenus/iso_mounter_unmounter.desktop

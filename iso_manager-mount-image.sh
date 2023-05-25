#!/bin/bash

####################################################################################
# For KDE-Services. 2012-2023.                                                     #
# By Geovani Barzaga Rodriguez <igeo.cu@gmail.com>		                   #
# Improved by Victor Guardiola (vguardiola) Jan 5 2014		                   #
#  -Fixed the problem of [dir|file]name with whitespaces.	                   #
# Code rewritten by Kamal Mjt.		                                           #
#  - Added language support Spanish and English.                                   #
#  - Add support for disk images.                                                  #
#  - Fixed a bug that deleted files.                                               #
####################################################################################

PATH=/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin:/home/$USER/bin
MOUNTEXIT=""
lang=$(locale | grep LANGUAGE | cut -d= -f2 | cut -d_ -f1)
fileType=$(mimetype -b "$2")
fuseiso=$(which fuseiso)
fuser=$(which fuser)
fusermount=$(which fusermount)



##############################
############ Main ############
##############################

#Detectamos el idioma para traducir los mensajes de diagnostico.
case $lang in

  es)
    TITLE='Montar Imagen'
    MOUNTMSG='No se puede montar'
    FORMAT_ERROR='Formato de archivo no reconocido.'
    MOUNT_ERROR='No se ha podido montar la imagen.'
    MOUNT_OK='se ha montado correctamente.'
    MOUNT_ERROR2='Ya esta montada o compruebe la integridad de la imagen.'
    NOT_FUSEISO='Instale el comando fuseiso y vuelva a intentarlo.'
    NOT_FUSER='Instale el comando fuser y vuelva a intentarlo.'
    NOT_FUSERMOUNT='Instale el comando fusermount y vuelva a intentarlo.'
    BAD_ARGUMENTS='Error, los parametros de ejecucion no validos para el montaje.'
    FINISH="Terminado correctamente."
    UNMOUNTMSG="Desmonatada."
    ;;

  *)
    TITLE='Mount Image'
    MOUNTMSG='Can''t mount'
    FORMAT_ERROR='Unrecognized file format.'
    MOUNT_ERROR='Failed to mount image.'
    MOUNT_OK='it has been mounted successfully.'
    MOUNT_ERROR2='Already mount or check image integrity.'
    NOT_FUSEISO='Please install fuseiso command and try again.'
    NOT_FUSER='Please install fuser command and try again.'
    NOT_FUSERMOUNT='Please install fusermount command and try again.'
    BAD_ARGUMENTS='Error, invalid execution parameters for mounting.'
    FINISH="Finished"
    UNMOUNTMSG="Unmounted"
    ;;
esac

#comprobamos el comando fuseiso si existe.
if [ ! -f $fuseiso ] || [ ! -x $fuseiso ] || [ -z $fuseiso ]
then
   kdialog --icon=ks-error --title="$TITLE" --passivepopup="[Error] $NOT_FUSEISO"
   exit 1
fi

#comprobamos el comando fuser si existe.
if [ ! -f $fuser ] || [ ! -x $fuser ] || [ -z $fuser ]
then
   kdialog --icon=ks-error --title="$TITLE" --passivepopup="[Error] $NOT_FUSER"
   exit 1
fi

#comprobamos el comando fusermount si existe.
if [ ! -f $fusermount ] || [ ! -x $fusermount ] || [ -z $fusermount ]
then
   kdialog --icon=ks-error --title="$TITLE" --passivepopup="[Error] $NOT_FUSERMOUNT"
   exit 1
fi

echo $fileType

#Comprobamos si el formato de archivo es correcto.
if [ "$fileType" != 'application/x-cd-image'  ] && [ "$fileType" != 'application/x-raw-disk-image' ]
  then
   kdialog --icon=ks-error --title="$TITLE" --passivepopup="Error: $MOUNTMSG ${2##*/} \n $FORMAT_ERROR"
   exit 1
fi





case $1 in

   mount)
      $fuseiso -p "$2" "$2_MOUNT"
      MOUNTEXIT=$?
      if [ "$MOUNTEXIT" = "0" ]; then
         kdialog --icon=ks-media-optical-mount --title="$TITLE" --passivepopup="${2##*/} $MOUNT_OK"
      else
         kdialog --icon=ks-error --title="$TITLE" --passivepopup="Error: $MOUNTMSG ${2##*/} \n $MOUNT_ERROR2"
         exit 1
      fi
      exit 0
      ;;

   unmount)
      $fuser -k "$2_MOUNT"
      $fusermount -u "$2_MOUNT"
      UNMOUNTEXIT=$?
      if [ "$UNMOUNTEXIT" = "0" ]
      then
         kdialog --icon=ks-media-optical-umount --title="$TITLE" --passivepopup="[$FINISH] "$2" $UNMOUNTMSG."
         exit 0
      else
         kdialog --icon=ks-error --title="$TITLE" --passivepopup="Error: $MOUNTMSG "$2" \n $MOUNT_ERROR2"
         exit 1
      fi
   ;;

   *)
      kdialog --icon=ks-error --title="$TITLE" --passivepopup="Error: $MOUNTMSG "$2" \n $BAD_ARGUMENTS"
      exit 1
   ;;
esac

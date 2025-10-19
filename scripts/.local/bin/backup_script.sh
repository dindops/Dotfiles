#!/bin/bash
USER=`whoami`
if [[ -n $1 ]]; then
    DEST=$1
else
    DEST=$(lsblk | grep "/media/$USER" | awk '{print $7}')
    if [[ $(echo $DEST | wc -w) > 1 ]]; then
        echo "Multiple mounted drives detected:"
        echo $DEST.
        echo "Please use the target mountpoint as an argument when running this script."
        exit 1
    fi
fi
echo "Starting backup. Target mountpoint: ${DEST}"
echo
echo "Main backup"
sudo rsync -aAXv --exclude=Videos --exclude=.cache --exclude=.mozilla --exclude=.thunderbird --exclude=.var/app --exclude=Music --exclude=Documents/Ebooks --exclude=Pictures --exclude=Downloads --exclude=.wallpapers /home/$USER/ $DEST/pietad/
echo "Music"
sudo rsync -aAXv --exclude=Audiobooks --exclude=Talks_And_Podcasts /home/$USER/Music/ $DEST/Media/Music/
echo "Pictures"
sudo rsync -aAXv /home/$USER/Pictures/ $DEST/Media/Pictures/
echo "Videos"
sudo rsync -aAXv /home/$USER/Videos/ $DEST/Media/Videos/
echo "Ebooks"
[[ -e /home/$USER/Documents/Ebooks ]] && sudo rsync -aAXv /home/$USER/Documents/Ebooks $DEST/Media/Ebooks_and_pdfs/
echo "Audiobooks and Podcasts"
[[ -e /home/$USER/Music/Audiobooks/ ]] && sudo rsync -aAXv /home/$USER/Music/Audiobooks/ $DEST/Media/Audiobooks/
[[ -e /home/$USER/Music/Talks_And_Podcasts/ ]] && sudo rsync -aAXv /home/$USER/Music/Talks_And_Podcasts/ $DEST/Media/Talks_And_Podcasts/
echo "Done."

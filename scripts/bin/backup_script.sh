#!/bin/bash
USER=`whoami`
echo "Starting backup"
echo
echo "Main backup"
sudo rsync -aAXv --exclude=Videos --exclude=.cache --exclude=.mozilla --exclude=.thunderbird --exclude=.var/app --exclude=Music --exclude=Documents/Ebooks --exclude=Pictures --exclude=Downloads --exclude=.wallpapers /home/$USER/ /run/media/$USER/Backups/pietad/
echo "Music"
sudo rsync -aAXv --exclude=Audiobooks --exclude=Talks_And_Podcasts /home/$USER/Music/ /run/media/$USER/Backups/Media/Music/
echo "Pictures"
sudo rsync -aAXv /home/$USER/Pictures/ /run/media/$USER/Backups/Media/Pictures/
echo "Videos"
sudo rsync -aAXv /home/$USER/Videos/ /run/media/$USER/Backups/Media/Videos/
echo "Ebooks"
[[ -e /home/$USER/Documents/Ebooks ]] && sudo rsync -aAXv /home/$USER/Documents/Ebooks /run/media/$USER/Backups/Media/Ebooks_and_pdfs/
echo "Audiobooks and Podcasts"
[[ -e /home/$USER/Music/Audiobooks/ ]] && sudo rsync -aAXv /home/$USER/Music/Audiobooks/ /run/media/$USER/Backups/Media/Audiobooks/
[[ -e /home/$USER/Music/Talks_And_Podcasts/ ]] && sudo rsync -aAXv /home/$USER/Music/Talks_And_Podcasts/ /run/media/$USER/Backups/Media/Talks_And_Podcasts/
echo "Done."

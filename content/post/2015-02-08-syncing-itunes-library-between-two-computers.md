---
title: Syncing iTunes Library Between two Computers
tags:
  - iTunes
  - Mac
date: 2015-02-08T08:02:51
---

Given:

1. Two family Macs with iTunes 12 installed
2. More than 10GB of audio files

I want to share my media library between these two computers and keep them synchronized. When I add new file on one computer, it should apear on another. When I delete a file on second computer - it should be deleted pn first. When I change iTunes playlists on one computer it should be changed on another.
I don't want to keep my media on Network storage (NAS) or External drive (USB), because it will be impossible to listen to the music on the go, when NAS or external drive is disconnected (e.g. in cafe).

To be able to use the same iTunes media library database on two computers I need to make my media files available by at the same path on disk.<!-- more--> Normally, media files are under the user account folder. But it is possible to [move][moving-itunes-media-folder] them to the location [common for all user accounts][sharing-itunes-between-accounts]. 

Next, I need to keep iTunes media file in sync.

After some research in the Internet I come to following solution.

1. Backup tour iTunes media folder `/Users/user/Music/iTunes`
2. Move iTunes media files to the `/Users/Shared/iTunes Media` folder.
   Set new media files location: ![iTunes Media Settings](/assets/2015/02/itunes-media-settings.png)
   Then run **File > Library > Organize Library** and select **"Consolidate Files"** to copy your files to new location. ![Consoludate Files](/assets/2015/02/itunes-consoludate.png)
3. Remove your old Original files were copied, not moved. You need to remove them (if you have made a backup on step 1):
```bash  
rm -rf /Users/user/Music/iTunes/iTunes\ Media
```
4. Close iTunes and copy your `/Users/user1/Music/iTunes` to `/Users/user2/Music/iTunes` on second compuler
5. Copy `/Users/Shared/iTunes Media` from first to second computer to the same location.
2. Setup media folder synchronization between two computers using [BitTorrent Sync][btsync]. If you have smaller media library that fits into DropBox -- then go for it. It is possible to use any cloud solution, e.g. at the moment (February 2015) [Yandex Disk][yandex-disk] offers 10GB for free.
3. Wait for synchronization complete.

You may start using iTunes on both computers. Keep in mind, that if you modify your media library from both computers simultaneously, you will have only recent changes. You may want to setup one-way synchronization: one computer will be **the Master** where you will manage your library and the second one is for listening only.  


### References 

 * [iTunes: Understanding iTunes Media Organization][understanding-itunes-media]
 * [Shared iTunes Library on Network](http://oyvteig.blogspot.com/2009/01/003-shared-itunes-library-on-network.html)
 * [iTunes: Understanding iTunes Media Organization][understanding-itunes-media]
 * [iTunes for Mac: Moving your iTunes Media folder][moving-itunes-media-folder]
 * [iTunes: How to share music between different user accounts on a single computer][sharing-itunes-between-accounts]

[btsync]: http://www.getsync.com "Sync"
[understanding-itunes-media]: http://support.apple.com/en-us/HT201979 "iTunes: Understanding iTunes Media Organization"
[moving-itunes-media-folder]: http://support.apple.com/en-us/HT201562 "iTunes for Mac: Moving your iTunes Media folder"
[sharing-itunes-between-accounts]: http://support.apple.com/en-us/HT1203 "iTunes: How to share music between different user accounts on a single computer"
[yandex-disk]: http://help.yandex.com/disk/uploading.xml "Yandex Disk Limits"

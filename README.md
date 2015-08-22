# raycic-overlay
Raimonds Cicans personal Gentoo overlay.

## Adding the Overlay
`layman -f -a raycic-overlay -o https://raw.githubusercontent.com/RayCic/raycic-overlay/master/raycic-overlay.xml`

## Kodi 15
How to install:
   1. add overlay as described above
   2. copy `/var/lib/layman/raycic-overlay/distfiles/kodi-15.*-generated-addons.tar.xz` to your distfiles directory (in most cases this is `/usr/portage/distfiles`)
   3. add `=media-tv/kodi-15*` to `/etc/portage/package.keywords`
   4. run `emerge media-tv/kodi`

## Kodi PVR plugins' ebuilds - media-plugins/kodi-pvr-*
Plugins require Kodi 15 or later. I do not plan to support Kodi 14.

WARNING! Plugins are not tested, only compiled.

I use in production only media-plugins/kodi-pvr-vdr-vnsi

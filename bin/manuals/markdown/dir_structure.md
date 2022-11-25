# Enhanced Bash Directory Structure

## Directories

The default directory structure
* Enhanced Bash Root: ```${HOME}/.local/bin/eb3```
* Binary Path: ```${HOME}/.local/bin/eb3/bin``` - System files for the system
* Cache Path: ```${HOME}/.local/bin/eb3/bin/cache``` - Cached files with high changes
* Temporary Path: ```${HOME}/.local/bin/eb3/bin/cache/tmp``` - Temporary files that are deleted
* Libraries Path: ```${HOME}/.local/bin/eb3/bin/libraries``` - Libraries that may be used throughout the system
* Manuals Path: ```${HOME}/.local/bin/eb3/bin/manuals``` - Documents made in different formats
* Modules Path: ```${HOME}/.local/bin/eb3/bin/modules``` - Modules are the end user's functions for use in the OS
* Etc Path: ```${HOME}/.local/bin/eb3/etc``` - Location for Optional and Configuration locations
* Configuration Path: ```${HOME}/.local/bin/eb3/etc/conf``` - Configurations
* Optional Path: ```${HOME}/.local/bin/eb3/etc/opt``` - Optional scripts and utilities
* User Path: ```${HOME}/.local/bin/eb3/usr``` - User themes and overrides
* Fonts Path: ```${HOME}/.local/bin/eb3/usr/fonts``` - Fonts for themes
* Overrides Path: ```${HOME}/.local/bin/eb3/usr/overrides``` - User overrides to extend modules or aliases
* Share Path: ```${HOME}/.local/bin/eb3/usr/share``` - User sharable directory for additional scripts
* Themes Path: ```${HOME}/.local/bin/eb3/usr/themes``` - User themes for prompt and colors
* Variables Path: ```${HOME}/.local/bin/eb3/var``` - Location to store logs, backups and other system information
* Backup Path: ```${HOME}/.local/bin/eb3/var/backup``` - The backup for for any backups
* Directory Jump Path: ```${HOME}/.local/bin/eb3/var/dirjump``` - A location to store directory information
* Logs Path: ```${HOME}/.local/bin/eb3/var/logs``` - The logs folder to store installation and start logs

## Details for directories

The directories are defined in the configuration file located in the ```${HOME}/.local/bin/eb3/etc/conf``` folder in the ```eb3.conf``` file.
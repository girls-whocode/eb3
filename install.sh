#!/usr/bin/env bash
# title					:Enhanced BASH v3
# description			:
# author				:Jessica Brown
# date					:2022-04-21
# version				:3.0.0
# usage					:
# notes					:
# bash_version	:5.1.16(1)-release
# ==============================================================================
scriptLocation="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "${scriptLocation}/etc/conf/collector.shlib"
White='\e[38;5;15m'
Yellow='\e[38;5;11m'
txtReset='\e[38;5;8m'
Cyan='\e[38;5;51m'
txtReset='\e[0m'

export eb3_BinPath=${scriptLocation}$(config_get dirSeparator)$(config_get eb3BinPath)
export eb3_CachePath=${scriptLocation}${eb3_BinPath}$(config_get dirSeparator)$(config_get eb3CachePath)
export eb3_TempPath=${scriptLocation}${eb3_CachePath}$(config_get dirSeparator)$(config_get eb3TempPath)

echo "${eb3_TempPath}"

# [ -f "${scriptLocation}${dirSeparator}${binSubPath}${dirSeparator}log_system.sh" ] && source "${scriptLocation}${dirSeparator}${binSubPath}${dirSeparator}log_system.sh" || echo "Can not continue"
# [ -f "${scriptLocation}${dirSeparator}${libSubPath}${dirSeparator}lib_colors" ] && source "${scriptLocation}${dirSeparator}${libSubPath}${dirSeparator}lib_colors"

# # Define default directories
# export binInstallLocation="${scriptLocation}${dirSeparator}${binSubPath}"
# export libInstallLocation="${scriptLocation}${dirSeparator}${libSubPath}"
# export modInstallLocation="${scriptLocation}${dirSeparator}${modSubPath}"
# export orInstallLocation="${scriptLocation}${dirSeparator}${overrideSubPath}"
# export thmInstallLocation="${scriptLocation}${dirSeparator}${themeSubPath}"
# export logsInstallLocation="${binInstallLocation}${dirSeparator}${logsSubPath}"
# export archiveInstallLocation="${binInstallLocation}${dirSeparator}${archiveSubPath}"
# export backupInstallLocation="${HOME}${dirSeparator}.backup"
# export userHomeLocation=$( getent passwd "${USER}" | cut -d: -f6 )

# export dirJumpFolder="${binInstallLocation}${dirSeparator}${dirJumpPath}"
# export directory_list="${binInstallLocation}${dirSeparator}${dirJumpPath}${dirSeparator}${dirListFile}"
# export defaultInstallationLocation="${HOME}${dirSeparator}.local${dirSeparator}share${dirSeparator}applications${dirSeparator}${installationSubPath}"
# export defaultSourceLocations=("${libInstallLocation}" "${modInstallLocation}" "${overridesInstallLocation}" "${themesInstallLocation}")
# export defaultBackupLocation=("${backupInstallLocation}")
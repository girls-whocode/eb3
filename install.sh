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

scriptLocation="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export scriptLocation

[ -f "${scriptLocation}/etc/conf/collector.shlib" ] && source "${scriptLocation}/etc/conf/collector.shlib" || echo "Error loading ${scriptLocation}/etc/conf/collector.shlib"
[ -f "${scriptLocation}/etc/setdirectories" ] && source "${scriptLocation}/etc/setdirectories" || echo "Error loading ${scriptLocation}/etc/setdirectories"
[ -f "${eb3_BinPath}logprocess" ] && source "${eb3_BinPath}logprocess" || echo "Error loading ${eb3_BinPath}logprocess"
[ ! -f "${eb3_LogsPath}install.log" ] && touch "${eb3_LogsPath}install.log"

# Check for a user font folder, if not create folder
[ ! -d "${eb3_fontPath}" ] && mkdir -p "${eb3_fontPath}"
defaultInstallBaseDirectory=${HOME}$(config_get dirSeparator).local$(config_get dirSeparator)bin$(config_get dirSeparator)$(config_get eb3InstallationPath)$(config_get dirSeparator)

if [ $? -eq 0 ]; then
	success "Installation startup" > "${eb3_LogsPath}install.log"
else 
	error "Installation startup" > "${eb3_LogsPath}install.log"
fi

# Source load each file for testing with in the current environment being installed
for folder in "${eb3_systemFolders[@]}"; do
	if [[ -d ${folder} ]]; then
		for filename in "${folder}"???_*; do
			if [[ -f ${filename} ]]; then
				source "${filename}"
				if [ $? -eq 0 ]; then
					success "Loading ${filename}" >> "${eb3_LogsPath}install.log"
				else
					error "Loading ${filename}" >> "${eb3_LogsPath}install.log"
				fi
			fi
		done
	fi
done

packages_Required=("jq" "git" "curl" "highlight" "most" "wget" "python3" "python3-pip" "zip" "7zip" "rar" "gzip" )

if [ -x "$(command -v apk)" ]; then
	for package in "${packages_Required[@]}"; do
		sudo apk add --no-cache ${package}
		success "Installing ${package}" >> "${eb3_LogsPath}install.log"
	done
elif [ -x "$(command -v apt-get)" ]; then
	for package in "${packages_Required[@]}"; do
		sudo apt-get install ${package} -y
		success "Installing ${package}" >> "${eb3_LogsPath}install.log"
	done
elif [ -x "$(command -v dnf)" ]; then
	for package in "${packages_Required[@]}"; do
		sudo dnf install ${package} -y
		success "Installing ${package}" >> "${eb3_LogsPath}install.log"
	done
elif [ -x "$(command -v zypper)" ]; then
	for package in "${packages_Required[@]}"; do
		sudo zypper install ${package}
		success "Installing ${package}" >> "${eb3_LogsPath}install.log"
	done
elif [ -x "$(command -v pkg)" ]; then
	for package in "${packages_Required[@]}"; do
		sudo pkg install ${package}
		success "Installing ${package}" >> "${eb3_LogsPath}install.log"
	done
else
	error "No package manager was found" >> "${eb3_LogsPath}install.log"
	echo "FAILED TO INSTALL PACKAGE: Package manager not found. You must manually install: ${packages_Required[*]}">&2; 
fi

[ -f "${HOME}$(config_get dirSeparator).bashrc" ] && cp "${HOME}$(config_get dirSeparator).bashrc" "${eb3_ConfPath}"
backup "${HOME}.bashrc"

[ ! -d "${defaultInstallBaseDirectory}" ] && mkdir "${defaultInstallBaseDirectory}"
rsync -aqr "${scriptLocation}" "${defaultInstallBaseDirectory}"

printf "# Created by Enhanced BASH Installer on $(LC_ALL=C date +'%Y-%m-%d %H:%M:%S')\n# Original .bashrc file is located in ${defaultInstallBaseDirectory}$(config_get eb3VarPath)$(config_get dirSeparator)$(config_get eb3BackupPath)\n\ncase \"\$TERM\" in\n\txterm-color|screen|*-256color)\n\t\t. ${defaultInstallBaseDirectory}bash_system.sh;;\nesac\n" > ~/.bashrc

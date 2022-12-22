#!/usr/bin/env bash
# title					:Enhanced BASH v3
# description   :Installation system for EBv3
# author				:Jessica Brown
# date					:2022-11-19
# version				:3.0.1
# usage					:./install.sh
# notes					:Run with the user who will be using EBv3, install will 
#               :prompt for sudo when needed.
# bash_version  :5.1.16(1)-release
# ==============================================================================
# shellcheck disable=SC2046

# Start a timer to evaluate for total time to install
eb3_install_start_time=$(date +%s.%3N)

# Get the current location of this script
scriptLocation="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Load the collector shlib file to source all conf files
if [ -f "${scriptLocation}/etc/conf/collector.shlib" ]; then 
	source "${scriptLocation}/etc/conf/collector.shlib"
else 
	echo "Error loading ${scriptLocation}/etc/conf/collector.shlib"
	exit 128
fi

# set all configured directories
if [ -f "${scriptLocation}/etc/setdirectories" ]; then
	source "${scriptLocation}/etc/setdirectories" 
else 
	echo "Error loading ${scriptLocation}/etc/setdirectories"
	exit 128
fi

# Currently this is a fixed location to install the system
# TODO: Allow user to decide where to install the eb3 system
defaultInstallBaseDirectory=${HOME}/.local/bin/$(config_get eb3InstallationPath)/

# Check for logs folder to place the installation log, if not create folder
# Check for a user font folder, if not create folder
# Make folders, test and load files each step listed below in order
# if the install.log file does not exist, create it
[ ! -d "${defaultInstallBaseDirectory}var/logs" ] && mkdir -p "${defaultInstallBaseDirectory}var/logs"
[ ! -d "${defaultInstallBaseDirectory}${eb3_fontPath}" ] && mkdir -p "${eb3_fontPath}"
[ ! -f "${defaultInstallBaseDirectory}var/logs/install.log" ] && touch "${defaultInstallBaseDirectory}var/logs/install.log"

# load the log process function
if [ -f "${eb3_BinPath}logprocess" ]; then
	source "${eb3_BinPath}logprocess"
else 
	echo "Error loading ${eb3_BinPath}logprocess"
	exit 128
fi

# Source load each file for testing with in the current environment being installed
for folder in "${eb3_systemFolders[@]}"; do
	if [[ -d ${folder} ]]; then
		for filename in "${folder}"???_*; do
			if [[ -f ${filename} ]]; then
				source "${filename}"
				# Check for any errors and tattle on it
				[ $? -eq 0 ] && success "Loading ${filename}" >> "${eb3_LogsPath}install.log" || error "Loading ${filename}" >> "${eb3_LogsPath}install.log"
			fi
		done
	else
		echo -e "${White}Creating folder ${Green}${folder}${txtReset}"
		mkdir -p "${folder}"
	fi
done

# TODO:Build Configuration script
# Run Configuration script
# Configuration Questions to ask
# 1. What is your default editor? [Give list of installed editors]
# 2. What theme would you like to start off with? [Give list of installed themes]
# 3. How many history items to save? [default 10,000]
# 4. How many directories to save in history [default 15]
# 5. Are you a wakatime user [default no]
# 5A. API Key
# 5B. Would you like to enable WakaTime in the Terminal
# 6. ** RHEL Only ** Do you wish to enable the EPEL repo? (Some packages require EPEL) [default yes]
# 6. Screen Fetch Defaults: (Use arrow keys to navigate, enter to toggle, switch, or edit)
# +--------] Neo Screen Fetch [--------------------------------------------------------------------------------------------+
# |   Kernel Settings                           Up Time Settings                    Memory Settings                        |
# |       Kernel Shorthand: On                      Uptime Shorhand: Small              Memory Percetage: Off              |
# |                                                                                                                        |
# |   Distrobution Settings                     Shell Settings                      Public IP Settings                     |
# |       Distrobution Shorthand: Off               Shell Path: Off                     Public IP Host: http://ident.me    |
# |       OS Architechture: Off                     Shell Version: On                   Public IP Timeout: 2               |
# |                                                                                                                        |
# |   CPU Settings                              GPU Settings                        GTK Settings                           |
# |       CPU Brand: On                             GPU Brand: On                       GTK Shorthand: Off                 |
# |       CPU Speed: On                             GPU Type: All                       GTK2: On                           |
# |       CPU Cores: Logical                        Refresh Rate: Off                   GTK 3: On                          |
# |       CPU Temp: Off                                                                                                    |
# |       Speed Shorthand: Off                  Package Manager Settings            MPC Settings                           |
# |       Speed Type: BIOS                          Package Manager Names: Small        MPC Arguments: ()                  |
# |                                                                                                                        |
# |   Disk Settings                             Format Settings                     Color Settings                         |
# |       Disk Root: /                              Bold: On                            Color Blocks Color: (0 7)          |
# |       Disk Subtitle: mount                      Underline: On                       Color Blocks: On                   |
# |                                                 Underline Character: -              Block Width: 3                     |
# |   Miscellanious Settings                        Separator: :                        Block Height: 1                    |                                                                       |
# |       STDOut: Off                                                                   Image Backend: ascii               |
# |                                                                                     Image Source: auto                 |
# |   Audio Player Settings                                                             Ascii Distro: auto                 |
# |       Audio Player: auto                                                            Ascii Colors: distro               |
# |       Song Shorthand: Off                                                                                              |
# |       Song Format: "%artist% - %album% - %title%"                                                                      |
# +------------------------------------------------------------------------------------------------------------------------+
# Help: {Basic description of the item currently on}

# Because we are installing 3rd party applications, we need to ask for sudo
# TODO: if sudo isn't available, we do not install and remove functionality from 3rd party apps
if [[ "$EUID" = 0 ]]; then
	success "Running as {root}" > "${eb3_LogsPath}install.log"
else
	echo -en "${White}To install ${Blue}EBv3${White} files ${Red}sudo${White} is required please enter ${txtReset}"
	sudo -k # make sure to ask for password on next sudo
	if sudo true; then
		success "Sudo password accepted" > "${eb3_LogsPath}install.log"
	else
		error "Sudo password failed" > "${eb3_LogsPath}install.log"
		exit 1
	fi
fi

success "Installation startup" > "${eb3_LogsPath}install.log"

start_spinner "${White}Starting installation of ${Blue}EBv3${txtReset} "
if [ -x "$(command -v apk)" ]; then
	packages_Required=("bc" "jq" "git" "curl" "wget" "zip" "7zip" "rar" "gzip" "python3" "python3-tk" "python3-dev")
	success "Installing with $(command -v apk)" >> "${eb3_LogsPath}install.log"
	for package in "${packages_Required[@]}"; do
		sudo apk add --no-cache "${package}"
		[ $? -eq 0 ] && success "Installing ${filename}" >> "${eb3_LogsPath}install.log" || error "Installing ${filename}" >> "${eb3_LogsPath}install.log"
		success "Installing ${package}" >> "${eb3_LogsPath}install.log"
	done
elif [ -x "$(command -v apt-get)" ]; then
	packages_Required=("bc" "jq" "git" "curl" "wget" "zip" "7zip" "rar" "gzip" "python3" "python3-tk" "python3-dev")
	success "Installing with $(command -v apt-get)" >> "${eb3_LogsPath}install.log"
	for package in "${packages_Required[@]}"; do
		pkg_test=$(dpkg-query -W --showformat='${Status}\n' "${package}" | grep "install ok installed")
		if [ "" = "${pkg_test}" ]; then
			sudo apt-get -yqqq install "${package}"
			[ $? -eq 0 ] && success "Installing ${filename}" >> "${eb3_LogsPath}install.log" || error "Installing ${filename}" >> "${eb3_LogsPath}install.log"
		else
			info "Package ${package} already installed" >> "${eb3_LogsPath}install.log"
		fi
	done
elif [ -x "$(command -v dnf)" ]; then
	sudo subscription-manager repos --enable codeready-builder-for-rhel-9-$(arch)-rpms
	sudo dnf install https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm -yq
	packages_Required=("bc" "jq" "git" "curl" "wget" "zip" "p7zip" "p7zip-plugins" "unrar" "gzip" "python3" "python3-tkinter" "python3-devel")
	success "Installing with $(command -v dnf)" >> "${eb3_LogsPath}install.log"
	for package in "${packages_Required[@]}"; do
		sudo dnf install "${package}" -yq
		[ $? -eq 0 ] && success "Installing ${filename}" >> "${eb3_LogsPath}install.log" || error "Installing ${filename}" >> "${eb3_LogsPath}install.log"
		success "Installing ${package}" >> "${eb3_LogsPath}install.log"
	done
  wget https://bootstrap.pypa.io/get-pip.py
  python3 ./get-pip.py
  rm get-pip.py
elif [ -x "$(command -v zypper)" ]; then
	packages_Required=("bc" "jq" "git" "curl" "wget" "zip" "p7zip" "unrar" "gzip" "python3" "python3-tk")
	success "Installing with $(command -v zypper)" >> "${eb3_LogsPath}install.log"
	for package in "${packages_Required[@]}"; do
		sudo zypper -qn --non-interactive install "${package}"
		[ $? -eq 0 ] && success "Installing ${filename}" >> "${eb3_LogsPath}install.log" || error "Installing ${filename}" >> "${eb3_LogsPath}install.log"
	done
elif [ -x "$(command -v yum)" ]; then
	packages_Required=("bc" "jq" "git" "curl" "wget" "zip" "p7zip" "p7zip-plugins" "unrar" "gzip" "python3" "python3-tk" "python3-dev")
	success "Installing with $(command -v yum)" >> "${eb3_LogsPath}install.log"
	for package in "${packages_Required[@]}"; do
		sudo yum install "${package}" -y
		[ $? -eq 0 ] && success "Installing ${filename}" >> "${eb3_LogsPath}install.log" || error "Installing ${filename}" >> "${eb3_LogsPath}install.log"
		success "Installing ${package}" >> "${eb3_LogsPath}install.log"
	done
elif [ -x "$(command -v pkg)" ]; then
	packages_Required=("bc" "jq" "git" "curl" "wget" "zip" "7zip" "unrar" "gzip" "python3" "python3-tk" "python3-dev")
	success "Installing with $(command -v pkg)" >> "${eb3_LogsPath}install.log"
	for package in "${packages_Required[@]}"; do
		sudo pkg install "${package}"
		[ $? -eq 0 ] && success "Installing ${filename}" >> "${eb3_LogsPath}install.log" || error "Installing ${filename}" >> "${eb3_LogsPath}install.log"
	done
else
	# TODO: I saw somewhere a manual installer, will look into adding that later
	error "No package manager was found" >> "${eb3_LogsPath}install.log"
	echo "FAILED TO INSTALL PACKAGE: Package manager not found. You must manually install: ${packages_Required[*]}">&2; 
fi
stop_spinner

# Install Python packages
start_spinner "${White}Installing ${Blue}Python packages${txtReset} "
python3 -m pip install pyautogui >> "${eb3_LogsPath}install.log"
python3 -m pip install rich >> "${eb3_LogsPath}install.log"
stop_spinner

# Sync this directory with the new installation directory
echo -e "${White}Installing ${Blue}EBv3 system files${txtReset}"
[ ! -d "${defaultInstallBaseDirectory}" ] && mkdir -p "${defaultInstallBaseDirectory}"
start_spinner "${White}Starting installation of ${Blue}EBv3${txtReset} "

# Need to remove old files keep custom files
if [ -d "${defaultInstallBaseDirectory}" ]; then
	rm -rf "${defaultInstallBaseDirectory}${eb3_BinPath}" "${defaultInstallBaseDirectory}${eb3_EtcPath}"
fi

rsync -aqr "${scriptLocation}$(config_get dirSeparator)" "${defaultInstallBaseDirectory}$(config_get dirSeparator)"
stop_spinner

start_spinner "${White}Building ${Blue}Enhanced BASH System${txtReset}"

# Backup the original .bashrc file
backup "${HOME}$(config_get dirSeparator).bashrc"
cp "${HOME}$(config_get dirSeparator).bashrc" "${eb3_BaseDirectory}$(config_get eb3EtcPath)$(config_get dirSeparator)$(config_get eb3ConfPath)$(config_get dirSeparator)"
success "Backup of .bashrc file to ${eb3_BackupPath}.bashrc-${baktimestamp}.backup" >> "${eb3_LogsPath}install.log"

# Create the new .bashrc file
printf "# Created by Enhanced BASH Installer on %s\n# Original .bashrc file is located in %s\n\ncase \"\$TERM\" in\n\txterm-color|screen|*-256color)\n\t\t. %s;;\nesac\n" "$(LC_ALL=C date +'%Y-%m-%d %H:%M:%S')" "${defaultInstallBaseDirectory}$(config_get eb3VarPath)$(config_get dirSeparator)$(config_get eb3BackupPath)" "${defaultInstallBaseDirectory}eb3.sh" > ~/.bashrc
success "New .bashrc creation completed" >> "${eb3_LogsPath}install.log"
stop_spinner

start_spinner "${White}Installing ${Blue}WakaTime System${txtReset}"

python3 -c "$(wget -q -O - https://raw.githubusercontent.com/wakatime/vim-wakatime/master/scripts/install_cli.py)" > /dev/null
arch="amd64"
extract_to="$HOME/.wakatime"

if [[ $(uname -m) == "aarch64" ]]; then
   arch="arm64"
fi

os="unknown"
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
   os="linux"
elif [[ "$OSTYPE" == "darwin"* ]]; then
   os="darwin"
elif [[ "$OSTYPE" == "cygwin" ]]; then
   os="windows"
elif [[ "$OSTYPE" == "msys" ]]; then
   os="windows"
elif [[ "$OSTYPE" == "win32" ]]; then
   os="windows"
elif [[ "$OSTYPE" == "freebsd"* ]]; then
   os="freebsd"
elif [[ "$OSTYPE" == "openbsd"* ]]; then
   os="openbsd"
elif [[ "$OSTYPE" == "netbsd"* ]]; then
   os="netbsd"
fi

zip_file="$extract_to/wakatime-cli-${os}-${arch}.zip"

symlink="$extract_to/wakatime-cli"
extracted_binary="$extract_to/wakatime-cli-${os}-${arch}"
url="https://github.com/wakatime/wakatime-cli/releases/latest/download/wakatime-cli-${os}-${arch}.zip"

# make dir if not exists
if [[ ! -d "${extract_to}" ]]; then
	mkdir -p "${extract_to}"
fi

cd "$extract_to" || exit
curl -L "${url}" -o "${zip_file}"
[[ -f "${zip_file}" ]] || unzip -q -o "${zip_file}"

if [[ -f "${extracted_binary}" ]]; then
	ln -fs "${extracted_binary}" "${symlink}"
	chmod a+x "${extracted_binary}"
else
	printf "%s" "The ${extracted_binary} was not found. Failed to install WakaTime"
fi

[[ -f "${zip_file}" ]] || rm "${zip_file}"
stop_spinner

{
	success "File installation completed"
	info "------------------------------ File Differences ------------------------------"
	info "$(diff -qr "${scriptLocation}$(config_get dirSeparator)" "${defaultInstallBaseDirectory}$(config_get dirSeparator)")"
	info "------------------------------------------------------------------------------"
}  >> "${eb3_LogsPath}install.log"

# Remove files unneeded in the installation folder
rm_files=(".git" ".gitignore" ".shellcheckrc" "install.sh" ".github" ".dist" "${defaultInstallBaseDirectory}bin/cache/.gitkeep" "${defaultInstallBaseDirectory}var/logs/.gitkeep" "${defaultInstallBaseDirectory}usr/overrides/.gitkeep" "${defaultInstallBaseDirectory}var/backup/.gitkeep" "${defaultInstallBaseDirectory}var/dirjump/.gitkeep")

for rm_file in "${rm_files[@]}"; do
	success "Cleanup file ${rm_file}" >> "${eb3_LogsPath}install.log"
	rm -rf "${defaultInstallBaseDirectory}$(config_get dirSeparator)${rm_file}"
done

# Create the logrotate file for each user
printf "%s {\n\tsu %s %s\n\tnotifempty\n\tcopytruncate\n\tweekly\n\trotate 52\n\tcompress\n\tmissingok\n}\n" "${defaultInstallBaseDirectory}var$(config_get dirSeparator)logs$(config_get dirSeparator)startup.log" "${USER}" "${USER}" | sudo tee "$(config_get dirSeparator)etc$(config_get dirSeparator)logrotate.d$(config_get dirSeparator)eb3_${USER}" >/dev/null
if [ $? -eq 0 ]; then
	success "LogRotate Config file created during installation" >> "${eb3_LogsPath}install.log"
else
	warn "LogRotate Config file failed during installation" >> "${eb3_LogsPath}install.log"
fi

# Create the basic eb3.conf file
cp "${defaultInstallBaseDirectory}$(config_get dirSeparator)etc$(config_get dirSeparator)conf$(config_get dirSeparator)eb3.conf.default" "${defaultInstallBaseDirectory}$(config_get dirSeparator)etc$(config_get dirSeparator)conf$(config_get dirSeparator)eb3.conf"
success "Creting the eb3 configuration file during installation" >> "${eb3_LogsPath}install.log"

sudo fc-cache -vf "${eb3_fontPath}" > /dev/null
python3 -m pip install --user powerline-status > /dev/null
success "Installed powerline fonts during installation" >> "${eb3_LogsPath}install.log"

# Get the timer end time
eb3_install_end_time=$(date +%s.%3N)
eb3_elapsed=$(echo "scale=3; $eb3_install_end_time - $eb3_install_start_time" | bc)

# Report the completion of the system install
success "EBv3 system installation has completed in ${eb3_elapsed} seconds" >> "${eb3_LogsPath}install.log"

echo -e "${Red}EBv3${txtReset} system installation has completed in ${Cyan}${eb3_elapsed}${txtReset} seconds"
echo -e "${White}Backed up ${Blue}bashrc${White} file to ${Green}${eb3_BackupPath}.bashrc-${baktimestamp}.backup${txtReset}"
echo -e "Installation is located at ${Cyan}${defaultInstallBaseDirectory}${txtReset}"
exec $SHELL

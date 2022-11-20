#!/bin/bash
# title					:Enhanced BASH v3
# description		    :Installation system for EBv3
# author				:Jessica Brown
# date					:2022-11-19
# version				:3.0.1
# usage					:./install.sh
# notes					:Run with the user who will be using EBv3, install will 
#						:prompt for sudo when needed.
# bash_version		    :5.1.16(1)-release
# ==============================================================================

# Start a timer to evaluate for total time to install
eb3_install_start_time=$(date +%s.%3N)

# Get the currently location of this script
scriptLocation="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export scriptLocation

# Make folders, test and load files each step listed below in order
# Check for logs folder to place the installation log, if not create folder
# Check for a user font folder, if not create folder
# if the install.log file does not exist, create it
# load the collector shlib file to source all conf files
# set all configured directories
# load the log process function

[ ! -d "${scriptLocation}/var/logs" ] && mkdir -p "${scriptLocation}/var/logs"
[ ! -d "${eb3_fontPath}" ] && mkdir -p "${eb3_fontPath}"
[ ! -f "${eb3_LogsPath}install.log" ] && touch "${eb3_LogsPath}install.log"

if [ -f "${scriptLocation}/etc/conf/collector.shlib" ]; then 
	source "${scriptLocation}/etc/conf/collector.shlib"
else 
	echo "Error loading ${scriptLocation}/etc/conf/collector.shlib"
	exit 128
fi

if [ -f "${scriptLocation}/etc/setdirectories" ]; then
	source "${scriptLocation}/etc/setdirectories" 
else 
	echo "Error loading ${scriptLocation}/etc/setdirectories"
	exit 128
fi

if [ -f "${eb3_BinPath}logprocess" ]; then
	source "${eb3_BinPath}logprocess"
else 
	echo "Error loading ${eb3_BinPath}logprocess"
	exit 128
fi

# Because we are installing 3rd party applications, we need to ask for sudo
# TODO: if sudo isn't available, we do not install and remove functionality from 3rd party apps
echo -en "${White}To install ${Blue}EBv3${White} files ${Red}sudo${White} is required please enter ${txtReset}"
if [[ "$EUID" = 0 ]]; then
    success "Running as {root}" > "${eb3_LogsPath}install.log"
else
    sudo -k # make sure to ask for password on next sudo
    if sudo true; then
        success "Sudo password accepted" > "${eb3_LogsPath}install.log"
    else
        error "Sudo password failed" > "${eb3_LogsPath}install.log"
        exit 1
    fi
fi

# Currently this is a fixed location to install the system
# TODO: Allow user to decide where to install the eb3 system
defaultInstallBaseDirectory=${HOME}$(config_get dirSeparator).local$(config_get dirSeparator)bin$(config_get dirSeparator)$(config_get eb3InstallationPath)$(config_get dirSeparator)

success "Installation startup" > "${eb3_LogsPath}install.log"

echo -e "${Green}Installation startup successful${txtReset}"
# Source load each file for testing with in the current environment being installed
echo -e "${White}Loading system files${txtReset}"

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

if [ -x "$(command -v apk)" ]; then
	packages_Required=("bc" "jq" "git" "curl" "wget" "zip" "7zip" "rar" "gzip" "python3" "python3-tk" "python3-dev")
	success "Installing with $(command -v apk)" >> "${eb3_LogsPath}install.log"
	for package in "${packages_Required[@]}"; do
		spinner_pid=
		start_spinner "${White}Starting installation of ${Blue}EBv3${txtReset} "
		sudo apk add --no-cache "${package}"
		stop_spinner
		success "Installing ${package}" >> "${eb3_LogsPath}install.log"
	done
elif [ -x "$(command -v apt-get)" ]; then
	packages_Required=("bc" "jq" "git" "curl" "wget" "zip" "7zip" "rar" "gzip" "python3" "python3-tk" "python3-dev")
	success "Installing with $(command -v apt-get)" >> "${eb3_LogsPath}install.log"

	# Start the installation of the packages_Required
	# TODO: I would like to make this quite and put everything in the logs, turn this into a progress bar for a cleaner look
	for package in "${packages_Required[@]}"; do
		pkg_test=$(dpkg-query -W --showformat='${Status}\n' "${package}" | grep "install ok installed")
		if [ "" = "${pkg_test}" ]; then
			spinner_pid=
			start_spinner "${White}Starting installation of ${Blue}EBv3${txtReset} "
			sudo apt-get -yqqq install "${package}"
			stop_spinner
		else
			info "Package ${package} already installed" >> "${eb3_LogsPath}install.log"
		fi
	done
elif [ -x "$(command -v dnf)" ]; then
	packages_Required=("bc" "jq" "git" "curl" "wget" "zip" "7zip" "unrar" "gzip" "python3" "python3-tk" "python3-dev")
	success "Installing with $(command -v dnf)" >> "${eb3_LogsPath}install.log"
	for package in "${packages_Required[@]}"; do
		spinner_pid=
		start_spinner "${White}Starting installation of ${Blue}EBv3${txtReset} "
		sudo dnf install "${package}" -y
		stop_spinner
		success "Installing ${package}" >> "${eb3_LogsPath}install.log"
	done
elif [ -x "$(command -v zypper)" ]; then
	packages_Required=("bc" "jq" "git" "curl" "wget" "zip" "7zip" "unrar" "gzip" "python3" "python3-tk")
	success "Installing with $(command -v zypper)" >> "${eb3_LogsPath}install.log"
	for package in "${packages_Required[@]}"; do
		spinner_pid=
		start_spinner "${White}Starting installation of ${Blue}EBv3${txtReset} "
		sudo zypper -qn install "${package}"
		stop_spinner
		success "Installing ${package}" >> "${eb3_LogsPath}install.log"
	done
elif [ -x "$(command -v pkg)" ]; then
	packages_Required=("bc" "jq" "git" "curl" "wget" "zip" "7zip" "unrar" "gzip" "python3" "python3-tk" "python3-dev")
	success "Installing with $(command -v pkg)" >> "${eb3_LogsPath}install.log"
	for package in "${packages_Required[@]}"; do
		sudo pkg install "${package}"
		success "Installing ${package}" >> "${eb3_LogsPath}install.log"
	done
else
	# TODO: I saw somewhere a manual installer, will look into adding that later
	error "No package manager was found" >> "${eb3_LogsPath}install.log"
	echo "FAILED TO INSTALL PACKAGE: Package manager not found. You must manually install: ${packages_Required[*]}">&2; 
fi

# Install Python packages
echo -e "${White}Installing ${Blue}Python packages${txtReset}"

spinner_pid=
start_spinner "${White}Starting installation of ${Blue}EBv3${txtReset} "
python3 -m pip install pyautogui >> "${eb3_LogsPath}install.log"
python3 -m pip install rich >> "${eb3_LogsPath}install.log"
stop_spinner

# Create the installation directory and backup the original .bashrc file
[ -f "${HOME}$(config_get dirSeparator).bashrc" ] && cp "${HOME}$(config_get dirSeparator).bashrc" "${eb3_ConfPath}"
backup "${HOME}$(config_get dirSeparator).bashrc"
echo -e "${White}Backed up ${Blue}bashrc${White} file to ${Green}${eb3_BackupPath}.bashrc-${baktimestamp}.backup${txtReset}"
success "Backup of .bashrc completed" >> "${eb3_LogsPath}install.log"

# Create the new .bashrc file
echo -e "${White}Creating new ${Blue}bashrc${White} file${txtReset}"
printf "# Created by Enhanced BASH Installer on %s\n# Original .bashrc file is located in %s\n\ncase \"\$TERM\" in\n\txterm-color|screen|*-256color)\n\t\t. %s;;\nesac\n" "$(LC_ALL=C date +'%Y-%m-%d %H:%M:%S')" "${defaultInstallBaseDirectory}$(config_get eb3VarPath)$(config_get dirSeparator)$(config_get eb3BackupPath)" "${defaultInstallBaseDirectory}eb3.sh" > ~/.bashrc
success "New .bashrc creation completed" >> "${eb3_LogsPath}install.log"

# Sync this directory with the new installation directory
echo -e "${White}Installing ${Blue}EBv3 system files${txtReset}"
[ ! -d "${defaultInstallBaseDirectory}" ] && mkdir -p "${defaultInstallBaseDirectory}"
spinner_pid=
start_spinner "${White}Starting installation of ${Blue}EBv3${txtReset} "
rsync -aqr "${scriptLocation}$(config_get dirSeparator)" "${defaultInstallBaseDirectory}$(config_get dirSeparator)"
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
mv "${defaultInstallBaseDirectory}$(config_get dirSeparator)etc$(config_get dirSeparator)conf$(config_get dirSeparator)eb3.conf.default" "${defaultInstallBaseDirectory}$(config_get dirSeparator)etc$(config_get dirSeparator)conf$(config_get dirSeparator)eb3.conf"

# Get the timer end time
eb3_install_end_time=$(date +%s.%3N)
eb3_elapsed=$(echo "scale=3; $eb3_install_end_time - $eb3_install_start_time" | bc)

# Report the completion of the system install
success "EBv3 system installation has completed in ${eb3_elapsed} seconds" >> "${eb3_LogsPath}install.log"
echo -e "${Red}EBv3${txtReset} system installation has completed in ${Cyan}${eb3_elapsed}${txtReset} seconds"
echo -e "Installation is located at ${Cyan}${defaultInstallBaseDirectory}${txtReset}"
echo -e ""
systeminfo
echo -e ""
echo -e "You ${Red}MUST${txtReset} close and reopen the terminal. The installation log located at: ${eb3_LogsPath}install.log"

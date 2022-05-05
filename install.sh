#!/usr/bin/env bash
# title					:Enhanced BASH v3
# description		:
# author				:Jessica Brown
# date					:2022-04-21
# version				:3.0.0
# usage					:
# notes					:
# bash_version	:5.1.16(1)-release
# ==============================================================================

# Start a timer to evaluate for total time to install
eb3_install_start_time=$(date +%s.%3N)

# Get the currently location of this script
scriptLocation="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export scriptLocation

# Make folders and test for files before we begin
[ ! -d "${scriptLocation}/var/logs" ] && mkdir -p "${scriptLocation}/var/logs"
[ -f "${scriptLocation}/etc/conf/collector.shlib" ] && source "${scriptLocation}/etc/conf/collector.shlib" || echo "Error loading ${scriptLocation}/etc/conf/collector.shlib"
[ -f "${scriptLocation}/etc/setdirectories" ] && source "${scriptLocation}/etc/setdirectories" || echo "Error loading ${scriptLocation}/etc/setdirectories"
[ -f "${eb3_BinPath}logprocess" ] && source "${eb3_BinPath}logprocess" || echo "Error loading ${eb3_BinPath}logprocess"
[ ! -f "${eb3_LogsPath}install.log" ] && touch "${eb3_LogsPath}install.log"

# Check for a user font folder, if not create folder
[ ! -d "${eb3_fontPath}" ] && mkdir -p "${eb3_fontPath}"

# Currently this is a fixed location to install the system
defaultInstallBaseDirectory=${HOME}$(config_get dirSeparator).local$(config_get dirSeparator)bin$(config_get dirSeparator)$(config_get eb3InstallationPath)$(config_get dirSeparator)

# Check for any errors and tattle on it
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
	else
		mkdir -p "${folder}"
	fi
done

packages_Required=("jq" "git" "curl" "wget" "zip" "7zip" "rar" "gzip" "python3" "python-is-python3")

if [ -x "$(command -v apk)" ]; then
	for package in "${packages_Required[@]}"; do
		sudo apk add --no-cache "${package}"
		success "Installing ${package}" >> "${eb3_LogsPath}install.log"
	done
elif [ -x "$(command -v apt-get)" ]; then
	# Make sure the system is up to date
	sudo apt-get -yqqq update
	if [ $? -eq 0 ]; then
		success "APT-GET Update was successfuly during installation" >> "${eb3_LogsPath}install.log"
	else
		error "APT-GET Update failed during installation" >> "${eb3_LogsPath}install.log"
	fi

	# Start the installation of the packages_Required
	# TODO: I would like to make this quite and put everything in the logs, turn this into a progress bar for a cleaner look
	for package in "${packages_Required[@]}"; do
		pkg_test=$(dpkg-query -W --showformat='${Status}\n' "${package}" | grep "install ok installed")
		if [ "" = "${pkg_test}" ]; then
			echo -e "Installing ${package}"
			info "Installing ${package}" >> "${eb3_LogsPath}install.log"
			sudo apt-get -yqqq install "${package}"
			if [ $? -eq 0 ]; then
				success "Installed ${package}" >> "${eb3_LogsPath}install.log"
			else
				error "Failed installing ${package}" >> "${eb3_LogsPath}install.log"
			fi
		else
			info "Package ${package} already installed" >> "${eb3_LogsPath}install.log"
		fi
	done
elif [ -x "$(command -v dnf)" ]; then
	for package in "${packages_Required[@]}"; do
		sudo dnf install "${package}" -y
		success "Installing ${package}" >> "${eb3_LogsPath}install.log"
	done
elif [ -x "$(command -v zypper)" ]; then
	for package in "${packages_Required[@]}"; do
		sudo zypper install "${package}"
		success "Installing ${package}" >> "${eb3_LogsPath}install.log"
	done
elif [ -x "$(command -v pkg)" ]; then
	for package in "${packages_Required[@]}"; do
		sudo pkg install "${package}"
		success "Installing ${package}" >> "${eb3_LogsPath}install.log"
	done
else
	# TODO: I saw somewhere a manual installer, will look into adding that later
	error "No package manager was found" >> "${eb3_LogsPath}install.log"
	echo "FAILED TO INSTALL PACKAGE: Package manager not found. You must manually install: ${packages_Required[*]}">&2; 
fi

python -m pip install pyautogui >> "${eb3_LogsPath}install.log"

# Create the installation directory and backup the original .bashrc file
[ -f "${HOME}$(config_get dirSeparator).bashrc" ] && cp "${HOME}$(config_get dirSeparator).bashrc" "${eb3_ConfPath}"
backup "${HOME}$(config_get dirSeparator).bashrc"
success "Backup of .bashrc completed" >> "${eb3_LogsPath}install.log"

# Create the new .bashrc file
printf "# Created by Enhanced BASH Installer on %s\n# Original .bashrc file is located in %s\n\ncase \"\$TERM\" in\n\txterm-color|screen|*-256color)\n\t\t. %s;;\nesac\n" "$(LC_ALL=C date +'%Y-%m-%d %H:%M:%S')" "${defaultInstallBaseDirectory}$(config_get eb3VarPath)$(config_get dirSeparator)$(config_get eb3BackupPath)" "${defaultInstallBaseDirectory}eb3.sh" > ~/.bashrc
success "New .bashrc creation completed" >> "${eb3_LogsPath}install.log"

# Sync this directory with the new installation directory
[ ! -d "${defaultInstallBaseDirectory}" ] && mkdir -p "${defaultInstallBaseDirectory}"
rsync -aqr "${scriptLocation}$(config_get dirSeparator)" "${defaultInstallBaseDirectory}$(config_get dirSeparator)"

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
echo -e "You may view the installation log located at: ${eb3_LogsPath}install.log"

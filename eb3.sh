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
eb3_start_time=$(date +%s.%3N)
scriptLocation="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export scriptLocation

[ -f "${scriptLocation}/etc/conf/collector.shlib" ] && source "${scriptLocation}/etc/conf/collector.shlib" || echo "Error loading ${scriptLocation}/etc/conf/collector.shlib"
[ -f "${scriptLocation}/etc/setdirectories" ] && source "${scriptLocation}/etc/setdirectories" || echo "Error loading ${scriptLocation}/etc/setdirectories"
[ -f "${eb3_BinPath}logprocess" ] && source "${eb3_BinPath}logprocess" || echo "Error loading ${eb3_BinPath}logprocess"
[ ! -f "${eb3_LogsPath}startup.log" ] && touch "${eb3_LogsPath}startup.log"

if [ $? -eq 0 ]; then
	success "Enhanced BASHv3 startup" > "${eb3_LogsPath}startup.log"
else 
	error "Enhanced BASHv3 startup" > "${eb3_LogsPath}startup.log"
fi

for folder in "${eb3_systemFolders[@]}"; do
	if [[ -d ${folder} ]]; then
		for filename in "${folder}"???_*; do
			if [[ -f ${filename} ]]; then
				source "${filename}"
				if [ $? -eq 0 ]; then
					success "Loading ${filename}" >> "${eb3_LogsPath}startup.log"
				else
					error "Loading ${filename}" >> "${eb3_LogsPath}startup.log"
				fi
			fi
		done
	fi
done

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=${historySize}
HISTFILESIZE=${historyFileSize}

# don't put duplicate lines or lines starting with space in the history.
if [[ ${historyControl} == "" ]]; then
	HISTCONTROL=ignoreboth
else
	HISTCONTROL=${historyControl}
fi

# append to the history file, don't overwrite it
if [[ ${historyControl} == "" ]]; then
	shopt -s histappend
else
	shopt -s ${historyAppend}
fi

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
	xterm-color|*-256color) export color_prompt=yes;;
esac

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
	if [ -f /usr/share/bash-completion/bash_completion ]; then
		. /usr/share/bash-completion/bash_completion
	elif [ -f /etc/bash_completion ]; then
		. /etc/bash_completion
	fi
fi

# Define the session type as Local, then test at the end of the _preload
export SESSION_TYPE="LOCAL"

# Check to see if there is an active SSH or TTY connection and set the SESSION TYPE
[ -z "$SSH_CLIENT" ] || export SESSION_TYPE="SSH"
[ -z "$SSH_TTY" ] || export SESSION_TYPE="SSH"

eb3_end_time=$(date +%s.%3N)
eb3_elapsed=$(echo "scale=3; $eb3_end_time - $eb3_start_time" | bc)

success "EBv3 system preload has completed in ${eb3_elapsed} seconds" >> "${eb3_LogsPath}startup.log"
echo -e "${Aqua} F1${White} -${Silver} Displays available commands and help"
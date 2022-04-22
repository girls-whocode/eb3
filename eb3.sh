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

White='\e[38;5;15m'
Yellow='\e[38;5;11m'
txtReset='\e[38;5;8m'
Cyan='\e[38;5;51m'
txtReset='\e[0m'

[ -f "${scriptLocation}/etc/conf/collector.shlib" ] && source "${scriptLocation}/etc/conf/collector.shlib" || echo "Error loading ${scriptLocation}/etc/conf/collector.shlib"
[ -f "${scriptLocation}/etc/setdirectories" ] && source "${scriptLocation}/etc/setdirectories" || echo "Error loading ${scriptLocation}/etc/setdirectories"
[ -f "${eb3_BinPath}logprocess" ] && source "${eb3_BinPath}logprocess" || echo "Error loading ${eb3_BinPath}logprocess"
[ ! -f "${eb3_LogsPath}install.log" ] && touch "${eb3_LogsPath}install.log"

if [ $? -eq 0 ]; then
	success "Installation startup" > "${eb3_LogsPath}install.log"
else 
	error "Installation startup" > "${eb3_LogsPath}install.log"
fi

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
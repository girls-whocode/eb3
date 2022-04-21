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
White='\e[38;5;15m'
Yellow='\e[38;5;11m'
txtReset='\e[38;5;8m'
Cyan='\e[38;5;51m'
txtReset='\e[0m'

[ -f "${scriptLocation}/etc/conf/collector.shlib" ] && source "${scriptLocation}/etc/conf/collector.shlib" || echo "${scriptLocation}/etc/conf/collector.shlib"
[ -f "${scriptLocation}/etc/etc_set_directories" ] && source "${scriptLocation}/etc/etc_set_directories" || echo "${scriptLocation}/etc/etc_set_directories"
[ -f "${eb3_BinPath}bin_log_process" ] && source "${eb3_BinPath}bin_log_process" || echo "${eb3_BinPath}bin_log_process"
[ -f "${eb3_LibPath}lib_colors" ] && source "${eb3_LibPath}lib_colors" || echo "${eb3_LibPath}lib_colors"


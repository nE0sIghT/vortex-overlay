#!/bin/sh
#
# Author: Yuri <nE0sIghT> Konotopov
# License: GNU GPL v3 or any later version
#

function get_latest_kernel() {
	eselect kernel list | tac | grep -m 1 linux
}

function get_latest_kernel_id() {
	echo $(get_latest_kernel) | awk '{ print $1 }' | tr -d []
}

function get_latest_kernel_version() {
	echo $(get_latest_kernel) | awk '{ print $2 }' | awk 'BEGIN { FS = "-" } ; { print $2 }'
}

function get_current_kernel_version() {
	current=$(eselect kernel show | grep -m 1 linux | awk '{ print $1 }')

	echo "${current}" | awk 'BEGIN { FS = "-" } ; { print $2 }'
}

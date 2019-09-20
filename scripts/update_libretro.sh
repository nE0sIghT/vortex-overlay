#!/bin/bash

# Simple script to bump libretro ebuilds in Vortex overlay
# Author: Yuri Konotopov <ykonotopov@gnome.org>
# Distributed under the terms of the GNU General Public License v2 or (at your opinion) any later version

source /lib/gentoo/functions.sh

PACKAGES=(
	libretro-bsnes
	libretro-citra
	libretro-common-overlays
	libretro-common-shaders
	libretro-database
	libretro-desmume
	libretro-flycast
	libretro-genesis-plus-gx
	libretro-glsl-shaders
	libretro-info
	libretro-mednafen-pcfx
	libretro-mednafen-saturn
	libretro-mgba
	libretro-mupen64plus-next
	libretro-nestopia
	libretro-picodrive
	libretro-sameboy
	libretro-slang-shaders
	libretro-vbam
	retroarch-assets
	retroarch-joypad-autoconfig
)

declare -A REPOS=(
	[libretro-common-overlays]=libretro/common-overlays
	[libretro-common-shaders]=libretro/common-shaders
	[libretro-glsl-shaders]=libretro/glsl-shaders
	[libretro-slang-shaders]=libretro/slang-shaders
	[libretro-info]=libretro/libretro-super
)

ROOT=$(dirname $0)
DATE=$(date +%Y%m%d)

function die() {
	eerror "${1}"
	exit 1
}

function update_package() {
	local PACKAGE_FOLDER="${ROOT}/../games-emulation/${1}"
	local CURRENT_EBUILD=$(basename $(ls -1 "${PACKAGE_FOLDER}"/*.ebuild | tac | head -n1))

	local REPO_NAME=${REPOS[$1]}
	[[ -z "${REPO_NAME}" ]] && REPO_NAME=$(echo $(grep LIBRETRO_REPO_NAME= ${PACKAGE_FOLDER}/${CURRENT_EBUILD}) | awk -F'=' '{ gsub(/"/, "", $2); print $2 }')
	[[ -z "${REPO_NAME}" ]] && REPO_NAME="libretro/${1}"
	REPO_NAME=${REPO_NAME//\$\{PN\}/${1}}

	[[ -z "${REPO_NAME}" ]] && return

	local EBUILD_COMMIT=$(echo $(grep LIBRETRO_COMMIT_SHA= ${PACKAGE_FOLDER}/${CURRENT_EBUILD}) | awk -F'=' '{ gsub(/"/, "", $2); print $2 }')
	local LATEST_COMMIT=$(echo $(git ls-remote https://github.com/${REPO_NAME} master) | awk -F' ' '{ print $1 }')

	[[ -z "${EBUILD_COMMIT}" || -z "${LATEST_COMMIT}" ]] && return

	if [[ "${EBUILD_COMMIT}" != "${LATEST_COMMIT}" ]]; then
		einfo "${1}: new version available at commit ${LATEST_COMMIT}"
		local NEW_EBUILD=$(echo ${CURRENT_EBUILD} | sed -e 's#pre[0-9]\{8\}#pre'${DATE}'#g')

		if [[ "${CURRENT_EBUILD}" == "${NEW_EBUILD}" ]]; then
			ewarn "Skipping upgrade of ${1} because ebuild with current date already exists: '${CURRENT_EBUILD}'"
			return
		fi

		cp "${PACKAGE_FOLDER}/${CURRENT_EBUILD}" "${PACKAGE_FOLDER}/${NEW_EBUILD}" || \
			die "Unable to copy '${PACKAGE_FOLDER}/${CURRENT_EBUILD}' to '${PACKAGE_FOLDER}/${NEW_EBUILD}'"

		sed -i -e "s#${EBUILD_COMMIT}#${LATEST_COMMIT}#g" "${PACKAGE_FOLDER}/${NEW_EBUILD}" || \
			die "Unable to replace commit '${EBUILD_COMMIT}' to '${LATEST_COMMIT}' in '${PACKAGE_FOLDER}/${NEW_EBUILD}'"

		ebuild "${PACKAGE_FOLDER}/${NEW_EBUILD}" digest || \
			die "Unable to create digests for '${PACKAGE_FOLDER}/${NEW_EBUILD}'"
	else
		einfo "${1} is up to date"
	fi
}

for package in ${PACKAGES[@]}; do
	update_package ${package}
done

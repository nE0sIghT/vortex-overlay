#!/bin/bash

# Simple script to bump s25rttr ebuild in Vortex overlay
# Author: Yuri Konotopov <ykonotopov@gnome.org>
# Distributed under the terms of the GNU General Public License v2 or (at your opinion) any later version

shopt -s extglob

source /lib/gentoo/functions.sh

ROOT=$(dirname $0)
DATE=$(date +%Y%m%d)

PACKAGE_FOLDER=$(realpath "${ROOT}/../games-strategy/s25rttr")
CURRENT_EBUILD=$(basename $(ls -1 "${PACKAGE_FOLDER}"/*.ebuild | tac | head -n1))
NEW_EBUILD=$(echo ${CURRENT_EBUILD} | sed -e 's#pre[0-9]\{8\}#pre'${DATE}'#g')

REPO_URL=https://github.com/Return-To-The-Roots/s25client.git

function die() {
	eerror "${1}"
	exit 1
}

create_new_ebuild() {
	if [[ -f "${PACKAGE_FOLDER}/${NEW_EBUILD}" ]]; then
		return
	fi

	cp "${PACKAGE_FOLDER}/${CURRENT_EBUILD}" "${PACKAGE_FOLDER}/${NEW_EBUILD}" || \
		die "Unable to copy '${PACKAGE_FOLDER}/${CURRENT_EBUILD}' to '${PACKAGE_FOLDER}/${NEW_EBUILD}'"

	einfo "Created new ebuild: ${NEW_EBUILD}"
}

EBUILD_COMMITS=$(grep COMMIT_SHA= ${PACKAGE_FOLDER}/${CURRENT_EBUILD});

TMP_DIRECTORY=$(mktemp -d)
git clone --depth=1 ${REPO_URL} ${TMP_DIRECTORY}
pushd ${TMP_DIRECTORY} > /dev/null

for var in ${EBUILD_COMMITS}; do
	REPOSITORY="${var%%?(_)COMMIT_SHA*}"
	REPOSITORY="${REPOSITORY,,}"
	EBUILD_COMMIT="$(echo ${var} | awk -F'=' '{ gsub(/"/, "", $2); print $2 }')"

	REPOSITORY_NAME=${REPOSITORY:-s25rttr}
	einfo "Checking update for module ${REPOSITORY_NAME}. Current commit is ${EBUILD_COMMIT}"

	if [[ -n "${REPOSITORY}" ]]; then
		LATEST_COMMIT=$(git submodule | grep ${REPOSITORY} | awk -F' ' '{ print $1 }')
		LATEST_COMMIT=${LATEST_COMMIT#-}
	else
		LATEST_COMMIT=$(git rev-parse HEAD)
	fi

	if [[ "${EBUILD_COMMIT}" != "${LATEST_COMMIT}" ]]; then
		einfo "New commit ${LATEST_COMMIT} available"
		create_new_ebuild

		sed -i -e "s#${EBUILD_COMMIT}#${LATEST_COMMIT}#g" "${PACKAGE_FOLDER}/${NEW_EBUILD}" || \
			die "Unable to replace commit '${EBUILD_COMMIT}' to '${LATEST_COMMIT}' in '${PACKAGE_FOLDER}/${NEW_EBUILD}'"
	fi
done

popd > /dev/null
rm -r "${TMP_DIRECTORY}"

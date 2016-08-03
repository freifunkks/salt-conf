#!/bin/zsh
# Checks out or clones the gluon repo and
# notifies admins of build status

#
# VARIABLES
#

root_dir="${HOME}"
gluon_dir="${root_dir}/gluon"
site_dir="${gluon_dir}/site"

gluon_repo="https://github.com/freifunk-gluon/gluon.git"
site_repo="https://github.com/freifunkks/site-ffks.git"

gluon_branch="v2016.1.x"
declare -aU site_branches=(beta stable)
declare -aU build_branches=()

build_script="build.sh"

#
# FUNCTIONS
#
die() {
    echo "${@}" 1>&2
    exit 1
}

# Clones a repo, if folder does not exist
#
#   ${1} dir
#   ${2} repo
clone_repo() {
    if [[ "${#}" -lt 2 ]]; then
        die "'clone repo' needs at least 2 arguments."
    fi
    if [[ ! -d "${1}" ]]; then
        if [[ -e "${1}" ]]; then
            die "'${1}' exists but is not a directory"
        else
            git clone -q "${2}" "${1}"
            build_branches=("${site_branches[@]}")
        fi
    fi
}

# Clones a repo, if folder does not exist
#
#   ${1} dir (of clone)
#   ${2} branch
fetch() {
    if [[ "${#}" -lt 2 ]]; then
        die "'fetch_and_build' needs at least 2 arguments."
    fi
    repo_dir="${1}"
    branch="${2}"

    cd "${1}"
    git checkout -q "${branch}"
    git fetch -q
    local_commit=$(git rev-parse HEAD)
    remote_commit=$(git rev-parse origin/${branch})
    if [[ "${local_commit}" == "${remote_commit}" ]]; then
        return 1
    else
        git merge -q --ff-only
        return 0
    fi
}

# Builds a branch of the site via the script
# included in its directory
build() {
    [[ "${#}" -lt 1 ]] && die "'build' needs at least 1 argument."
    branch="${1}"
    cd "${site_dir}"
    [[ -f "${build_script}" ]] || die "Build script '${build_script}' not found."
    git checkout "${branch}"
    "./${build_script}"
    # TODO Check output and notify
}

#
# EXECUTION
#

# Clone repos if dir nonexistent
clone_repo "${gluon_dir}" "${gluon_repo}"
clone_repo "${site_dir}" "${site_repo}"

# Check out and notice changes
# and build on change
if fetch "${gluon_dir}" "${gluon_branch}" "all"; then
    build_branches=("${site_branches[@]}")
fi
for branch in "${site_branches[@]}"; do
    if fetch "${site_dir}" "${branch}"; then
        build_branches+="${branch}"
    fi
done

# Build
if [[ "${#build_branches}" -lt 1 ]]; then
    echo "Everything is up-to-date, no build needed."
    exit 0
fi
for branch in "${build_branches[@]}"; do
    build "${branch}"
    # TODO Check output and notify
done

# Mail on error
# TODO Notify on error
# TODO Notify on successful copying to firmware download server

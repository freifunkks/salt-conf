#!/bin/zsh
# Checks out or clones the gluon repo and
# notifies admins of build status
#
# First argument is taken to choose a branch.
# If no argument given, every branch with updates is built.

#
# VARIABLES
#

root_dir=$(dirname "${0}")
gluon_dir="${root_dir}/gluon"
site_dir="${gluon_dir}/site"
bot_log="/tmp/sopel-build-gluon.log"
build_log="/tmp/build-gluon.log"
branch="${1}"

gluon_repo="https://github.com/freifunk-gluon/gluon.git"
site_repo="https://github.com/freifunkks/site-ffks.git"

declare -aU site_branches
site_branches=(beta stable)

declare -aU build_branches
build_branches=()

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

# Fetches newest commit and fast-forward on changes while returning 0
#
#   ${1} dir (of clone)
#   ${2} branch
fetch_branch() {
    if [[ "${#}" -lt 2 ]]; then
        die "'fetch_branch' needs at least 2 arguments."
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

# Fetches specific tag and ...
#
#   ${1} dir (of clone)
#   ${2} tag
fetch_tag() {
    if [[ "${#}" -lt 2 ]]; then
        die "'fetch_tag' needs at least 2 arguments."
    fi
    repo_dir="${1}"
    tag="${2}"

    cd "${1}"
    git fetch -q
    tag_old=$(git rev-parse HEAD)
    tag_new=$(git rev-parse "${tag}")
    if [[ "${tag_old}" == "${tag_new}" ]]; then
        return 1
    else
        git reset --hard -q "${tag_new}"
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
    git checkout -q "${branch}"
    tag=$(make -f site.mk print_default_release)
    fetch_tag "${gluon_dir}" "${tag}"
    cd "${site_dir}"
    # Start build script with log file
    "./${build_script}" "${bot_log}" > "${build_log}"
    # TODO Check output and notify
}


#
# EXECUTION
#

# Clean bot/build log
echo > "${bot_log}"
echo > "${build_log}"

# Clone repos if dir nonexistent
clone_repo "${gluon_dir}" "${gluon_repo}"
clone_repo "${site_dir}" "${site_repo}"

# If branch selected, force building it and skip detection
if [[ -n "${branch}" ]]; then
    build "${branch}"
    return
elif [[ "${#}" -gt 0 ]]; then
    die "Selected branch could not be built: ${branch}"
fi

# Check out and notice changes
# and build on change
for branch in "${site_branches[@]}"; do
    if fetch_branch "${site_dir}" "${branch}"; then
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

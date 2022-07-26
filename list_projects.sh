#!/bin/bash

function get_virtualenvs_path {
  path=$1
  # Check if filesystem is based on Windows or not.
  if [[ "${path}" =~ ^[a-zA-Z]:.*$ ]] || [[ "${path}" =~ ^\/mnt\/[a-zA-Z]\/.*$ ]]; then
    echo "${USERPROFILE}/.virtualenvs"
  else
    echo "${HOME}/.local/share/virtualenvs"
  fi
}

VIRTUALENVS_PATH=$(get_virtualenvs_path $0)
PROJECT_BASENAME=".project"

project_paths=$(ls ${VIRTUALENVS_PATH}/*/${PROJECT_BASENAME})
echo -e "PROJECT_PATH\tCODE_PATH\tPYTHON_VERSION\tUNLINKED\tVIRTUALENV_SIZE"

for project_path in ${project_paths[@]}; do
  code_path=$(cat $project_path)
  if [ ! -d $code_path ]; then
    unlinked="o"
  else
    unlinked="-"
  fi
  virtualenv_path=${project_path//\/${PROJECT_BASENAME}}
  virtualenv_size=$(du -hs $virtualenv_path | cut -f 1)
  python_version=$(${virtualenv_path}/bin/python --version | cut -d " " -f 2)
  echo -e "$project_path\t$code_path\t$python_version\t$unlinked\t$virtualenv_size"
done


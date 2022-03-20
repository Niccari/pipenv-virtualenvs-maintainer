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

project_paths=$(find ${VIRTUALENVS_PATH} -name ${PROJECT_BASENAME} -type f)
messages="PROJECT_PATH\tCODE_PATH\tUNLINKED\tVIRTUALENV_SIZE"

for project_path in ${project_paths[@]}; do
  code_path=$(cat $project_path)
  if [ ! -d $code_path ]; then
    unlinked="o"
  else
    unlinked="-"
  fi
  virtualenv_path=${project_path//\/${PROJECT_BASENAME}}
  virtualenv_size=$(du -hs $virtualenv_path | cut -f 1)

  messages="$messages\n$project_path\t$code_path\t$unlinked\t$virtualenv_size"
done

echo -e $messages

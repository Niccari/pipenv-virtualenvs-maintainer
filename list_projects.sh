#!/bin/bash

function get_virtualenvs_path {
  local path=$1
  # Check if filesystem is based on Windows or not.
  if [[ "${path}" =~ ^[a-zA-Z]:.*$ ]] || [[ "${path}" =~ ^\/mnt\/[a-zA-Z]\/.*$ ]]; then
    echo "${USERPROFILE}/.virtualenvs"
  else
    echo "${HOME}/.local/share/virtualenvs"
  fi
}

function process_project() {
  local project_path=$1
  local code_path=$(cat $project_path)
  local unlinked="-"
  if [ ! -d $code_path ]; then
    unlinked="o"
  fi
  local virtualenv_path=${project_path//\/${PROJECT_BASENAME}}
  local virtualenv_size=$(du -hs $virtualenv_path | cut -f 1)
  local python_version=$(cat ${virtualenv_path}/pyvenv.cfg | grep version_info | cut -d "=" -f 2)
  echo -e "$project_path\t$code_path\t$python_version\t$unlinked\t$virtualenv_size"
}

VIRTUALENVS_PATH=$(get_virtualenvs_path $0)
PROJECT_BASENAME=".project"

project_paths=$(ls ${VIRTUALENVS_PATH}/*/${PROJECT_BASENAME})
echo -e "PROJECT_PATH\tCODE_PATH\tPYTHON_VERSION\tUNLINKED\tVIRTUALENV_SIZE"

MAX_CONCURRENT_PROCESSES=50
running_processes=0

for project_path in ${project_paths[@]}; do
  while [ $running_processes -ge $MAX_CONCURRENT_PROCESSES ]; do
    wait -n
    running_processes=$((running_processes - 1))
  done

  process_project "$project_path" &
  running_processes=$((running_processes + 1))
done

wait

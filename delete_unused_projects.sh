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
deletable_virtualenv_paths=""
found_projects_message="## Deletable projects ##"
for project_path in ${project_paths[@]}; do
  code_path=$(cat $project_path)
  if [ ! -d $code_path ]; then
    virtualenv_path=${project_path//\/${PROJECT_BASENAME}}
    virtualenv_size=$(du -hs $virtualenv_path | cut -f 1)

    deletable_virtualenv_paths="$virtualenv_path $deletable_virtualenv_paths"
    found_projects_message="$found_projects_message\n$virtualenv_path <-x- $code_path(size: $virtualenv_size)"
  fi
done
deletable_virtualenv_paths=( $deletable_virtualenv_paths )

if [ ${#deletable_virtualenv_paths[@]} -le 0 ]; then
  echo "no deletable virtualenvs found."
  exit 0
else
  echo -e $found_projects_message
fi

read -p "Delete unused virtualenvs? (y/N): " yn
if [[ $yn = [yY] ]]; then
  for virtualenv_path in ${deletable_virtualenv_paths[@]}; do
    if ! rm -i -rf $virtualenv_path ; then
      echo "failed to remove $virtualenv_path."
      exit 1
    fi
  done
  echo "succeeded."
else
  echo "aborted."
fi

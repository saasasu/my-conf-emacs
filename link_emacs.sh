#!/bin/bash

# Define the source .emacs file in this repository
REPO_EMACS="$(pwd)/.emacs"

# Define the target .emacs file in the user's home directory
HOME_EMACS="${HOME}/.emacs"

echo "Checking for existing ${HOME_EMACS}..."

# Check if the target exists and is not the desired symbolic link
if [ -e "${HOME_EMACS}" ]; then
  # If it's the correct link, we're done
  if [ -L "${HOME_EMACS}" ] && [ "$(readlink "${HOME_EMACS}")" = "${REPO_EMACS}" ]; then
    echo "${HOME_EMACS} is already correctly linked."
    exit 0
  else
    # If it's a file or a different link, error out
    echo "Error: A file or different link already exists at ${HOME_EMACS}." >&2
    echo "Please rename or delete it and run this script again." >&2
    exit 1
  fi
fi

echo "Creating symbolic link from ${REPO_EMACS} to ${HOME_EMACS}..."

# Create a symbolic link because it's more robust against editor save
# strategies that can break hard links.
ln -s "${REPO_EMACS}" "${HOME_EMACS}"

if [ $? -eq 0 ]; then
  echo "Symbolic link created successfully: ${HOME_EMACS} now points to ${REPO_EMACS}"
else
  echo "Error: Failed to create the symbolic link." >&2
  exit 1
fi

exit 0

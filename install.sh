#!/bin/bash
echo "Starting installation of my latest tmux config"
echo "Pulling latest version from github"
git pull
echo "Success"

echo "Checking if a tmux config file already exists"
if [ ! -f $HOME/.tmux.conf ]; then
	echo "No config file found, skipping backup";
else
	echo "Creating backup of current file"
	mv $HOME/.tmux.conf $HOME/.tmux.conf.$(date -u +"%Y-%m-%dT%H:%M:%SZ")
	echo "Success"
fi

echo "Copying latest config file to home directory"
cp tmux.conf $HOME/.tmux.conf

echo "tmux config file successfully installed"


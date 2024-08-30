#!/bin/bash

SESSION="PAY"
OPTSTRING=":rh"
HELP=false
RECREATE=false

source ./aliases.sh

print_help() {
	echo "This script initializes my tmux environment"
	echo -e "\n\t\tOptions: "
	echo -e "\t\t-h Print this help text"
	echo -e "\t\t-r Recreate the tmux session in case it already exists (i.e destroy it and create other with the same name). This is useful when we change the session config file and need to apply the new configuration."
}

create_tmux_session() {
	tmux new-session -d -s $SESSION
	echo "Success."

	echo "Checking if $SESSION session config file exists"
	if [ -f $SESSION.sh ]; then
		echo "running config script for $SESSION"
		/bin/bash $SESSION.sh $SESSION
		echo "Success."
	else
		echo "Session $SESSION config file do not exists. Skipping specific configuration."
	fi
}

while getopts ${OPTSTRING} opt; do
	case ${opt} in
		h)
			HELP=true
			;;
		r)
			RECREATE=true
			;;
		?)
			echo "Invalid option: -${OPTARG}."
			exit 1
			;;
	esac
done

if [ "$HELP" = true ]; then
	print_help
	exit 0
fi




echo "Checking if session $SESSION already exists"

tmux has-session -t $SESSION 2>/dev/null

if [ $? != 0 ]; then
	echo "Session $SESSION do not exist. Creating session $SESSION..."
	create_tmux_session	
else
	echo "Session $SESSION already exists, checking if parameter recreate is true."
	if [ "$RECREATE" = true ]; then
		echo "Recreate paramater was passed. Destroying $SESSION session"
		tmux kill-session -t $SESSION
		echo "Success."
		echo "Creating $SESSION session"
		create_tmux_session
		echo "Success"
	fi
fi

tmux attach-session -t $SESSION:0


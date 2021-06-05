#!/bin/sh

# Program Data
PROGRAM="$(basename "$0")"
LICENSE="GNU GPLv3"
VERSION="1.0"
AUTHOR="Hamza Kerem Mumcu <hamzamumcu@protonmail.com>"
USAGE="Usage: $PROGRAM"

err(){
	# Print error message, "$1", to stderr and exit.
	[ "$suppress_bool" -ne 0 ] && printf "%s Exitting.\n" "$1" >&2
	exit 1
}

warn(){
	# Print warning message, "$1", to stderr. Don't exit.
	[ "$quiet_bool" -ne 0 ] && printf "%s\n" "$1" >&2
	return 1
}

show_help(){
	# Print program usage.
	printf "%s\n" "$USAGE"	
	exit 0
}

show_version(){
	# Print program version info.
	printf "%s\n" "$PROGRAM $VERSION"
	printf "Licensed under %s\n" "$LICENSE"
	printf "Written by %s\n" "$AUTHOR"
	exit 0
}

parse_opts(){
	# Parse and evaluate each option one by one 
	quiet_bool=1
	suppress_bool=1

	while [ "$#" -gt 0 ]; do
		case "$1" in
		 -q|--quiet) quiet_bool=0;;	
   -s|--no-messages) suppress_bool=0;;	
				 --) break;;
	    		  *) err "Unknown option. Please see '--help'.";;
		esac
		shift
	done
}

parse_opts "$@"

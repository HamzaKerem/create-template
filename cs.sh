#!/bin/sh

# Program Data
PROGRAM_NAME="cs"
ALT_PROGRAM_NAME="create-script"
LICENSE="GNU GPLv3"
VERSION="1.0"
AUTHOR="Hamza Kerem Mumcu <hamzamumcu@protonmail.com>"
USAGE="Usage: $PROGRAM"

# Configuration Data
config_dir="$HOME/.config"
config_file="$config_dir/.$PROGRAM.conf"

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
	printf "%s\n" "$PROGRAM_NAME - $ALT_PROGRAM_NAME $VERSION"
	printf "Licensed under %s\n" "$LICENSE"
	printf "Written by %s\n" "$AUTHOR"
	exit 0
}

parse_opts(){
	# Parse and evaluate each option one by one 
	quiet_bool=1
	suppress_bool=1
	lang_nick=

	while [ "$#" -gt 0 ]; do
		case "$1" in
		  -h|--help) show_help;;
	   -v|--version) show_version;;
		 -q|--quiet) quiet_bool=0;;	
   -s|--no-messages) suppress_bool=0;;	
				 --) break;;
	    		 -*) err "Unknown option. Please see '--help'.";;
				  *) lang_nick="$1";;
		esac
		shift
	done

	[ -z "$lang_nick" ] && err "Language nickname not given."
}

read_config(){
	[ -r "$config_file" ] || err "Failed to read $config_file. Please create the configuration file if you haven't done so."
	found_lang_bool=1
	line_num=0

	while read -r line; do
		line_num=$((line_num+1))

		# remove all whitespace
		line="$(printf "%s" "$line" | tr -d [:space:])"
		# check if line is a comment, if so continue on with next iteration
		[ "$(printf "%s" "$line" | cut -b 1)" = "#" ] && continue
		
		i=1
		while [ "$i" -lt 5 ]; do
#			printf "%s\n" "$(printf "%s" "$line" | cut -d ':' -f "$i")"
			[ -z "$(printf "%s" "$line" | cut -d ':' -f "$i")" ] && err "Empty values detected in $config_file on line $line_num."
			i=$((i+1))
		done

		read_lang_nick="$(printf "%s" "$line" | cut -d ':' -f 2)"
		[ "$read_lang_nick" = "$lang_nick" ] || continue

		printf "$line\n"
		found_lang_bool=0
	done < "$config_file"	

	[ "$found_lang_bool" -ne 0 ] && err "Language nickname $lang_nick was not found."
}

parse_opts "$@"

read_config

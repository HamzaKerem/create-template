#!/bin/sh

# Program Data
PROGRAM_NAME="cs"
ALT_PROGRAM_NAME="create-script"
LICENSE="GNU GPLv3"
VERSION="1.0"
AUTHOR="Hamza Kerem Mumcu <hamzamumcu@protonmail.com>"
USAGE="Usage: $PROGRAM_NAME [-g|--generate] [-r|--reset] [-q|--quiet] [-s|--no-messages] 
[-h|--help] [-v|--version] FILE [TEMPLATE]"

# Configuration Data
config_dir="$HOME/.config/$PROGRAM_NAME"
config_file="$config_dir/.$PROGRAM_NAME.conf"

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

get_ext(){
	file="$1"
	[ -z "$file" ] && return 1
	
	strlen="${#file}"
	dot_index=-1
	i=$((strlen-1))
	
	# Get dot index
	while [ "$i" -gt -1 ]; do
		char="$(printf "%s" "$file" | cut -b $((i+1)))"
		[ "$char" = '.' ] && dot_index="$i" && break
		i=$((i-1))
	done
	
	[ "$dot_index" -eq -1 ] && return 1

	# Get filename without extension
	i=1
	while [ "$i" -le "$dot_index" ]; do
		char="$(printf "%s" "$file" | cut -b $i)"
		file_name="${file_name}${char}"
		i=$((i+1))
	done

	# Get extension
	i=$((dot_index+2))
	while [ "$i" -le "$strlen" ]; do
		char="$(printf "%s" "$file" | cut -b $i)"
		file_ext="${file_ext}${char}"
		i=$((i+1))
	done	
}

parse_opts(){
	# Parse and evaluate each option one by one 
	quiet_bool=1
	suppress_bool=1
	file_name=
	file_ext=

	while [ "$#" -gt 0 ]; do
		case "$1" in
		  -h|--help) show_help;;
	   -v|--version) show_version;;
		 -q|--quiet) quiet_bool=0;;	
   -s|--no-messages) suppress_bool=0;;	
				 --) break;;
	    		 -*) err "Unknown option. Please see '--help'.";;
				  *) 
					if [ -z "$file_name" ] && [ -z "$file_ext" ]; then
						get_ext "$1"
					else
						warn "Only a single file can be created at a time. $1 will not be proccessed."
					fi;;
		esac
		shift
	done
	
	# Error checking. 
	if [ -z "$file_name" ] || [ -z "$file_ext" ]; then
		err "Failed to process file name and extension. Input file must have an extension."
	fi
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
		# check if line is empty, if so continue on with next iteration
		[ "$line" = "" ] && continue


		# Get variable values from config file.
		read_extension="$(printf "%s" "$line" | cut -d ':' -f 4)"
		[ -n "$read_extension" ] && { [ "$file_ext" = "$read_extension" ] || continue; }
		read_lang_nick="$(printf "%s" "$line" | cut -d ':' -f 2)"
		read_type="$(printf "%s" "$line" | cut -d ':' -f 1)"
		read_lang_full="$(printf "%s" "$line" | cut -d ':' -f 3)"
		
		# Raise error if empty value is met
		if [ -z "$read_type" ] || [ -z "$read_lang_full" ] || [ -z "$read_lang_nick" ]; then
				err "Empty values detected in $config_file on line $line_num."
		fi

		found_lang_bool=0
		break

	done < "$config_file"	

	[ "$found_lang_bool" -ne 0 ] && err "Language belonging to extension .$file_ext was not found."
}

parse_opts "$@"

read_config

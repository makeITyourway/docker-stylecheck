#!/bin/bash

# by Michael Schiessl - 2019
# mail: mike@makeITyourway.de






# CODE FROM HERE

# Functions
function line {
	LS="[DSC]"		# Set Line Header
	echo -e "${LS} - $1 "
}


function dsc {
	my_name=${1}
	my_result=${2}
	my_operator=${3} 
	my_reason=${4}

	#echo "--> ${my_operator} "${my_result}" "
	
	if [ ${my_operator} "${my_result}" ] ; then
		line "${my_name} \t\t\t ok"	
	else
		line "${my_name} \t\t\t failed"
		if [[ ! -z $my_reason ]] ; then
			line "REASON: \n\t$my_reason"
		fi
		exit 1
	fi
}

# PRERUN CHECKS
line "Docker StyleCheck toolkit ... starting"
line "2019 by makeITyourway.de"
line ""


my_file=$1
if [[ -z "${my_file}" ]]  ; then
        line "PLEASE SPECIFY A DOCKERFILE TO CHECK"
	line "exiting !"
        exit 1
elif [[ ! -f "${my_file}" ]] ; then
        line "File $1 not found or not accessible"
	line "exiting !"
        exit 1
fi

#ws="[^[:space:]]"
# GENERIC RULESET

dsc "ONLY ONE 'FROM' LINE    " 	"$(cat ${my_file} | egrep -i "^from" | wc -l )"		 		'1 =='		"To avoid misúnderstandings, only 1 FROM line should be in your Dockerfile, even when only the last one will be used"
dsc "VOLUME MAY NOT BE USED  "	"$(cat ${my_file} | egrep -i "^volume" | wc -l )"			'0 ==' 		"VOLUME keyword may not occur in Dockerfile - it does not make any sense"
dsc "AVOID INLINE UPGRADES   " 	"$(cat ${my_file} | egrep -i "^run.*[apt|yum].*[update|upgrade]" )" 	'-z' 		"Immutable docker images are key ! Avoid inline updates to prevent errors by broken package dependencies ."
dsc "AVOID 'FROM LATEST'     " 	"$(cat ${my_file} | egrep -i "^from.*latest" )" 			'-z' 		"Immutable docker images are key ! Avoid 'from latest' to avoid accidentially breaking your image ."
dsc "USE COPY INSTEAD OF ADD "	"$(cat ${my_file} | egrep -i "^add" )"					'-z'		"Use 'COPY' instead of 'ADD' - ADD might lead to unexpected behaviour"

dsc "ENSURE TO DROP ROOT     "  "$(cat ${my_file} | egrep -i "^user" )"					'! -z'		"Ensure to run your container as specific user and not as root by using the 'USER' command"
dsc "DEFINE STRICT ENTRYPOINT"  "$(cat ${my_file} | egrep -i "^entrypoint" )"				'! -z'		"Entrypoints prevent unexperienced users from doing unwanted things"

# WORSPACE
# Entrypoint
# CMD

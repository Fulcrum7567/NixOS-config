{ pkgs-default, currentHost, ... }:
	let
		scriptDir = "/home/fulcrum/testConfig/system/scripts";
		script = ''
			#!/bin/sh

no_usage=false


print_usage_force() {
	echo "Possible commands:"
	echo "hive"
	echo "     rebuild <system | home | full?>             Rebuild the configuration"
	echo "     update                                      Update the configuration"
	echo "     switch"
	echo "            desktop  <new profile name?>         Select new desktop profile"
	echo "            theme    <new profile name?>         Select new theme profile"
	echo "            packages <new profile name?>         Select new package profile"
	echo "            state"
	echo "                  system <stable | unstable?>    Select new system state"
	echo "                  packages <stable | unstable?>  Select new default package state"
	echo ""
	echo "     package"
	echo "             add <package name?>                 Install new package"
	echo "             edit <binary name?>                 Edit existing binary package"
	echo "             group"
	echo "                   add <group name?>             Create new package group"
	echo "                   edit <group name?>            Edit existing package group"
	echo "             profile"
	echo "                     add <profile name?>         Create new package profile"
	echo "                     edit <profile name?>        Edit existing package profile"
	echo ""
}

print_usage() {
    if [ "$no_usage" = false ]; then
        print_usage_force
    fi
} 

print_debug() {
    if [ "$debug" = true ]; then
        echo "[Debug]: $1"
    fi
}

print_error() {
    echo "[Error]: $1"
}



if [ "$#" -lt 1 ]; then
	print_error "$0 needs at least one attribute"
	print_usage
	exit 1
fi

case "$1" in
	rebuild)
		if [ "$#" -eq 1 ]; then
			sh "${scriptDir}/interactive/rebuild.sh"
		else
			arg=""
			case "$2" in
				system)
					arg="--system"
					;;
				home)
					arg="--home-manager"
					;;
				full)
					arg="--full"
					;;
				*)
					print_error "Unknown argument \"$2\""
					exit 1
			esac
			if [ "$#" -gt 2 ]; then
				shift 2
				sh "${scriptDir}/interactive/rebuild.sh" "$arg" "$@"
			else
				sh "${scriptDir}/interactive/rebuild.sh" "$arg"
			fi
		fi
		;;
	update)
		if [ "$?" -eq 1 ]; then
			sh "${scriptDir}/interactive/update.sh"
		else
			shift 1
			sh "${scriptDir}/interactive/update.sh" "$@"
		fi
		;;
	switch)
		if [ "$#" -eq 1 ]; then
			result=$(gum choose Desktop Theme Packages State --header="What would you like to switch?")
			switcher=$(echo "$result" | tr '[:upper:]' '[:lower:]')
		else
			switcher="$2"
		fi

		case "$switcher" in
			desktop)
				sh "${scriptDir}/interactive/switchDesktop.sh" "--host" "${currentHost}"
			;;
			theme)
				sh "${scriptDir}/interactive/switchTheme.sh" "--host" "${currentHost}"
			;;
			packages)
				sh "${scriptDir}/interactive/switchPackages.sh" "--host" "${currentHost}"
			;;
			state)
				if [ "$#" -lt 2 ]; then
					result=$(gum choose System Packages --header="Of what woud you like to switch the state of?")
					type=$(echo "$result" | tr '[:upper:]' '[:lower:]')
				else
					type="$3"
				fi
				case "$type" in
					system)
						sh "${scriptDir}/interactive/switchSystemState.sh" "--host" "${currentHost}"
						;;
					packages)
						sh "${scriptDir}/interactive/switchDefaultPackageState.sh" "--host" "${currentHost}"
						;;
					*)
						print_error "Invalid type \"$type\""
						exit 1
						;;
				esac
				;;
			*)
				print_debug "Invalid switch"
				exit 2
				;;
		esac

		;;

esac

		'';
	in
{
	environment.systemPackages = [
		(pkgs-default.writeScriptBin "hive" script)
	];
	
} 

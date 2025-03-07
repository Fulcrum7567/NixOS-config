{ pkgs-default, ... }:
	let
		script = ''
			#!/bin/sh

no_usage=false


print_usage_force() {
	echo "Possible commands:"
	echo "hive"
	echo "     rebuild <system | home | full?>             Rebuild the configuration"
	echo "     update                                      Update the configuration"
	echo "     switch"
	echo "            desktop <new profile name?>          Select new desktop profile"
	echo "            theme <new profile name?>            Select new theme profile"
	echo "            packages <new profile name?>         Select new package profile"
	echo "            state"
	echo "                  system <stable | unstable?>    Select new system state"
	echo "                  packages <stable | unstable?>  Select new default package state"
	echo ""
	echo "     package"
	echo "         	   add <package name?>                 Install new package"
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
		if [ "$#" -eq 2 ]; then
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
			esac
			if [ "$#" -gt 2 ];
				shift 2
				sh "${scriptDir}/interactive/rebuild.sh" "$arg" "$@"
			else
				sh "${scriptDir}/interactive/rebuild.sh" "$arg"
			fi
		fi
		;;
esac

		''
	in
{
	environment.systemPackages = [
		(pkgs-default.writeScriptBin "hive" script)
	];
	
} 

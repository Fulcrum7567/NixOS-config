{ pkgs-default, currentHost, hostSettings, ... }:
	let
		scriptDir = "${hostSettings.dotfilesDir}/system/scripts";
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
	echo "     package add <package name?>                 Install new package"
	echo "                 group <group name?>             Create new package group"
	echo "                 profile <profile name?>         Create new package profile"
	echo ""
	echo "     edit"
	echo "          package <package name?>"
	echo "                  group <group name?>"
	echo "                  profile <profile name?>"
	echo "          desktop <profile name?>"
	echo "          theme <profile name?>"
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
	package)
		if [ "$#" -lt 2 ]; then
			print_error "Too few arguments!"
			exit 1
		fi

		if [ "$2" = "add" ]; then
			if [ "$#" -lt 3 ]; then
				sh "${scriptDir}/interactive/addPackage.sh"
			else
				case "$3" in
					group)
						if [ "$#" -lt 4 ]; then
							sh "${scriptDir}/interactive/addPackageGroup.sh"
						else
							sh "${scriptDir}/interactive/addPackageGroup.sh" "--name" "$4"
						fi
						;;
					profile)
						if [ "$#" -lt 4 ]; then
							sh "${scriptDir}/interactive/addPackageProfile.sh"
						else
							"${scriptDir}/interactive/addPackageProfile.sh" "--name" "$4"
						fi
						;;
					*)
						sh "${scriptDir}/interactive/addPackage.sh" "--name" "$3"
						;;
				esac
			fi
		fi
	;;
	edit)
		print_error "Not yet implemented"
	;;

	*)
		print_error "Invalid Argument \"$1\""
	;;

esac

		'';
	in
{
	environment.systemPackages = [
		(pkgs-default.writeScriptBin "hive" script)
	];
	
} 

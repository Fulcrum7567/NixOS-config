# Home-manager
{ userSettings, ... }:
{
	programs.bash = {
    	enable = true;
    	enableCompletion = true;
    	sessionVariables = {
			TERM = userSettings.terminal;
    	};
    	initExtra = ''
	    	# include .profile if it exists
	      	[[ -f ~/.profile ]] && . ~/.profile
	    '';
  	};

} 

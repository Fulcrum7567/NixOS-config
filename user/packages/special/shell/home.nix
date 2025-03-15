# Home-manager
{ userSettings, pkgs, ... }:
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

  	programs.zsh = {
	    enable = true;
	    enableAutosuggestions = true;
	    syntaxHighlighting.enable = true;
	    enableCompletion = true;
	    initExtra = ''
	    PROMPT=" ◉ %U%F{magenta}%n%f%u@%U%F{blue}%m%f%u:%F{yellow}%~%f
	     %F{green}→%f "
	    [ $TERM = "dumb" ] && unsetopt zle && PS1='$ '
	    bindkey '^P' history-beginning-search-backward
	    bindkey '^N' history-beginning-search-forward
	    '';
	  };


} 

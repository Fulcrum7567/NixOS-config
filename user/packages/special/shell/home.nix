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
	    autosuggestion.enable = true;
	    syntaxHighlighting.enable = true;
	    enableCompletion = true;
	    initContent = ''
	    PROMPT=" ◉ %U%F{magenta}%n%f%u@%U%F{blue}%m%f%u:%F{yellow}%~%f
	     %F{green}→%f "
	     
	    if [[ -n "$DIRENV_DIR" ]]; then
		    PROMPT="%F{green}❄️ nix-shell%f $PROMPT"
		fi
	    '';
	  };

	programs.direnv = {
	    enable = true;
	    nix-direnv.enable = true;
	    enableZshIntegration = true;
	};


} 

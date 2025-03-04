# Imported by home-manager

{ userSettings, hostSettings, ... }:
{
	home.sessionVariables = {
		EDITOR = userSettings.editor;
		TERM = userSettings.terminal;
	};

	programs.bash = {
    enable = true;
    enableCompletion = true;
  };
  
} 

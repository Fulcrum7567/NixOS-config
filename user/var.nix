# Imported by home-manager

{ userSettings, ... }:
{
	home.sessionVariables = {
		EDITOR = userSettings.editor;
		TERM = userSettings.terminal;
	};

	
  
} 

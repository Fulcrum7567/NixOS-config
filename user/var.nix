# Imported by home-manager

{ userSettings, hostSettings, ... }:
{
	home.sessionVariables = {
		EDITOR = "TEST";
		TERM = userSettings.terminal;
		test_var = "test";
	};

	programs.bash = {
    enable = true;
    enableCompletion = true;
  };
  
} 

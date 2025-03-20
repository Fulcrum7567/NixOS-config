# Imported by home-manager

{ userSettings, editorSettings, browserSettings, explorerSettings, terminalSettings, ... }:
{
	home.sessionVariables = {
		EDITOR = userSettings.editor;
		TERM = userSettings.terminal;
		
	};

	xdg.mimeApps = {
		enable = true;
		defaultApplications = {
			"text/html" = editorSettings.gnomeAppName;
			"x-scheme-handler/http" = browserSettings.gnomeAppName;
      		"x-scheme-handler/https" = browserSettings.gnomeAppName;
			"x-scheme-handler/about" = browserSettings.gnomeAppName;
			"x-scheme-handler/unknown" = browserSettings.gnomeAppName;
			"inode/directory" = [ explorerSettings.gnomeAppName ];
			"x-scheme-handler/terminal" = [ terminalSettings.gnomeAppName ];

		};
	};
  
} 

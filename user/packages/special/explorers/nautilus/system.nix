{ userSettings, ... }:
{
	programs.nautilus-open-any-terminal = {
		enable = true;
		terminal = userSettings.terminal;
	};
}
rec {
    username = "fulcrum";
    displayName = "Fulcrum";
	emails = {
		git = "dragon.fighter@outlook.de";
	};
	git = {
		userName = displayName;
		userEmail = emails.git;
	};
	editor = "sublime";
	terminal = "kitty";
	browser = "zen";
	explorer = "nautilus";
}

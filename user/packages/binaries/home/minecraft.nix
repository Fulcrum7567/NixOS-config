{ pkgs-default, ... }:
{
	home.packages = with pkgs-default; [
		(prismlauncher.override {
    		# Add binary required by some mod
    		additionalPrograms = [ ffmpeg ];
    	})
	];
}

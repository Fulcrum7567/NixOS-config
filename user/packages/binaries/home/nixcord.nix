{ inputs, pkgs-default, ... }:
{
	imports = [
		inputs.nixcord.homeModules.nixcord
	];

	programs.nixcord = {
		enable = true;
		vesktop = {
			enable = true;
			package = pkgs-default.vesktop.overrideAttrs (prev: {
				desktopItems = [
					(pkgs-default.makeDesktopItem {
						name = "discord";
						desktopName = "Discord";
						exec = "vesktop %U";
						icon = "discord";
						startupWMClass = "Discord";
						genericName = "Internet Messenger";
						keywords = [
							"discord"
							"vencord"
							"vesktop"
						];
					})
				];
			});
		};
		discord.enable = false;
		config = {
			useQuickCss = true;
			themeLinks = [
				# "https://refact0r.github.io/midnight-discord/build/midnight.css"
				"https://github.com/refact0r/midnight-discord/blob/master/themes/flavors/midnight-nord.theme.css"
			];

			enabledThemes = [
				"midnight-nord"
			];

			frameless = true;

			plugins = {
				alwaysAnimate.enable = true;
				betterFolders = {
					enable = true;
					closeAllFolders = true;
					closeAllHomeButton = true;
					closeOthers = true;
					forceOpen = true;
				};
				betterSessions.enable = true;
				betterSettings.enable = true;
				callTimer.enable = true;
				clearURLs.enable = true;
				copyFileContents.enable = true;
				customIdle = {
					enable = true;
					idleTimeout = 5.0;
					remainInIdle = true;
				};
				disableCallIdle.enable = true;
				experiments.enable = true;
				fakeNitro = {
					enable = true;
					enableEmojiBypass = false;
					enableStickerBypass = false;
					enableStreamQualityBypass = true;
				};
				favoriteEmojiFirst.enable = true;
				friendsSince.enable = true;
				gameActivityToggle.enable = true;
				implicitRelationships.enable = true;
				moreKaomoji.enable = true;
				mutualGroupDMs.enable = true;
				newGuildSettings = {
					enable = true;
					guild = true;
					messages = "nothing";
				};
				noOnboardingDelay.enable = true;
				noPendingCount = {
					enable = true;
					hideFriendRequestsCount = false;
					hideMessageRequestCount = false;
					hidePremiumOffersCount = true;
				};
				noProfileThemes.enable = true;
				nsfwGateBypass.enable = true;
				oneko.enable = true;
				platformIndicators.enable = true;
				reviewDB.enable = true;
				secretRingToneEnabler.enable = true;
				summaries.enable = true;
				serverListIndicators = {
					enable = true;
					mode = "both";
				};
				userVoiceShow.enable = true;
				volumeBooster = {
					enable = true;
					multiplier = 5;
				};
			};
		};

		userPlugins = {
			#notifyUserChanges = "github:D3SOX/vc-notifyUserChanges/4b36010991c762581bc941ed0e74b42989f584e7";
			#hideUsers = "github:SpiderUnderUrBed/hideUsers/beec09944f5b7e516fd9e5baec734739f83ec2b2";
			#betterActivities = "github:D3SOX/vc-betterActivities/044b504666b8b753ab45d82c0cd0d316b1ea7e60";
		};

		extraConfig = {
			SKIP_HOST_UPDATE = true;
			#notifyUserChanges.enable = false;
			#hideUsers.enable = true;
			#betterActivities.enable = true;
		};


    	
	};
}
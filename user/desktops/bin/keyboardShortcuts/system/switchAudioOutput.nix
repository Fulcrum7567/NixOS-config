{ ... }:
{
	services.actkbd = {
		enable = true;
		bindings = [
			{ keys = [ 29 56 75 ]; events = [ "key" ]; command = "notify-send 'test'"; }
		];
	};
}

package;

import haxe.ui.HaxeUIApp;

class Main {
	public static function main() {
		Config.load();

		var app = new HaxeUIApp();
		app.ready(function() {
			app.addComponent(new MainView());

			app.start();
		});
	}
}

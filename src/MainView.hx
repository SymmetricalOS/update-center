package;

import hx.widgets.ListItem;
import hx.widgets.ListItem;
import haxe.ui.components.Label;
import hx.widgets.ListItem;
import hx.widgets.DataViewItem;
import haxe.ui.events.UIEvent;
import haxe.ui.events.MouseEvent;
import haxe.ui.containers.VBox;

@:build(haxe.ui.ComponentBuilder.build("assets/main-view.xml"))
class MainView extends VBox {
	public function new() {
		super();

		dropdown.text = Config.channel;
		dropdown.onChange = updateList;

		updateList(null);
	}

	@:bind(close, MouseEvent.CLICK)
	function closeButton(_) {
		Sys.exit(0);
	}

	@:bind(update, MouseEvent.CLICK)
	function install(_) {
		update.disabled = true;
		for (pkg in Updater.scan()) {
			Updater.download(pkg);
			Updater.install(pkg);
		}
		updateList(null);
	}

	function updateList(_) {
		update.disabled = true;
		Config.channel = dropdown.text;
		updates.dataSource.clear();
		updates.dataSource.add({id: "item", text: "Loading..."});
		var pkgs = Updater.scan();
		updates.dataSource.clear();
		for (pkg in pkgs) {
			updates.dataSource.add({id: "item", text: '${pkg.name} ${pkg.version}'});
		}
		if (pkgs.length > 0) {
			update.disabled = false;
		}
	}
}

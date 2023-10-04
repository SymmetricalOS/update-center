import sys.io.File;
import haxe.Json;
import sys.Http;

using StringTools;

class Updater {
	public static final url = "http://localhost:8080";

	public static function scan():Array<Pkg> {
		var list = new Array<Pkg>();

		var req = new Http('$url/packages.json');
		var data:Array<Dpkg> = [];
		req.onData = (res:String) -> data = Json.parse(res);
		req.request();

		for (pkg in data) {
			var symmver = File.getContent("/etc/symmos/version");
			var kernelver = File.getContent("/proc/sys/kernel/osrelease");

			if (pkg.symmvers.contains(symmver)) {
				if (pkg.pkg.name == "Symmetrical OS" && pkg.pkg.version != symmver)
					list.push(pkg.pkg);
				if (pkg.pkg.name == "Kernel" && pkg.pkg.version != kernelver)
					list.push(pkg.pkg);
			}
		}

		return list;
	}

	public static function download(pkg:Pkg) {
		Sys.command('wget $url/${pkg.name.replace(" ", "-")}-${pkg.version.replace(" ", "-")}');
		Sys.command('unzip ${pkg.name.replace(" ", "-")}-${pkg.version.replace(" ", "-")}');
	}

	public static function install(pkg:Pkg) {
		Sys.command('./${pkg.name.replace(" ", "-")}-${pkg.version.replace(" ", "-")}/install.sh');
	}
}

import haxe.Json;
import sys.Http;

class Updater {
	public static function scan():Array<Pkg> {
		var list = new Array<Pkg>();

		var req = new Http("http://localhost:8080/packages.json");
		var data:Array<Dpkg> = [];
		req.onData = (res:String) -> data = Json.parse(res);
		req.request();

		for (pkg in data) {
			var symmver = File.getContent("/etc/symmos/version");
			var kernelver = File.getContent("/proc/sys/kernel/osrelease");

			if (pkg.symmvers.contains(symmver))
				list.push(pkg.pkg);
		}

		return list;
	}
}

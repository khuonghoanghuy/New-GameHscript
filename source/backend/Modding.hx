package backend;

import haxe.Json;
import sys.FileSystem;
import sys.io.File;
import sys.io.FileInput;

class Modding {
    public static var mods:Array<Mod> = [];

    public static function loadMods():Void {
        var folders:Array<String> = FileSystem.readDirectory("mods");
        for (folder in folders) {
            var path = "mods/" + folder;
            if (FileSystem.exists(path + "/data.json")) {
                var jsonData:String = File.getContent(path + "/data.json");
                var modData:Dynamic = Json.parse(jsonData);
                if (modData != null) {
                    var mod = new Mod(modData);
                    ModPaths.registerModAssets(folder);
                    mods.push(mod);
                }
            }
        }
    }
}

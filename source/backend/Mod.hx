package backend;

class Mod {
    public var title:String;
    public var description:String;
    public var author:String;
    public var version:String;
    public var versionMeet:String;
    public var assets:Map<String, String>; // Store asset paths

    public function new(data:Dynamic) {
        this.title = data.title;
        this.description = data.description;
        this.author = data.author;
        this.version = data.version;
        this.versionMeet = data.versionMeet;
        this.assets = new Map<String, String>();
    }

    public function addAsset(key:String, path:String):Void {
        this.assets.set(key, path);
    }

    public function getAsset(key:String):String {
        return this.assets.get(key);
    }
}

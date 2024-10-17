package scriptsCode;

class LuaStore {
    public static var store:Map<String, Dynamic> = new Map<String, Dynamic>();
    
    public static function setVar(key:String, value:Dynamic):Void {
        store.set(key, value);
    }
    
    public static function getVar(key:String):Dynamic {
        return store.get(key);
    }
}

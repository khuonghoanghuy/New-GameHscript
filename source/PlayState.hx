package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import haxe.io.Path;
import scriptsCode.LuaCode;
import sys.FileSystem;

using StringTools;

class PlayState extends FlxState
{
	static var r_instance:PlayState = null;
	public static var instance(get, default):PlayState;

	public function new()
	{
		super();
		r_instance = this;
	}

	static function get_instance():PlayState
	{
		return r_instance;
	}

	public var images:Map<String, FlxSprite> = new Map<String, FlxSprite>();
	public var text:Map<String, FlxText> = new Map<String, FlxText>();

	static public var luaScripts:Array<LuaCode> = [];

	override public function create()
	{
		super.create();
		var folders = 'mods/' + Main.mainFolder + '/data/';
		var folderToRead = FileSystem.readDirectory(folders);
		for (file in folderToRead)
		{
			if (file.endsWith(".lua"))
			{
				var scriptPath = Path.join([folders, file]);
				luaScripts.push(new LuaCode(scriptPath));
			}
		}

		callOnScripts("onCreate", []);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		callOnScripts("onUpdate", [elapsed]);
		if (FlxG.keys.justPressed.F12)
			openSubState(new SubLogState());
	}
	private function callOnScripts(funcName:String, args:Array<Dynamic>):Dynamic
	{
		var value:Dynamic = LuaCode.Function_Continue;

		for (i in 0...luaScripts.length)
		{
			var ret:Dynamic = luaScripts[i].call(funcName, args);
			if (ret != LuaCode.Function_Continue)
			{
				value = ret;
			}
		}

		return value;
	}
}

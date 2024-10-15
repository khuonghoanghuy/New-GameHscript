package;

import flixel.*;
import flixel.text.FlxText;
import haxe.io.Path;
import scriptsCode.*;
import sys.FileSystem;

using StringTools;

class PlayState extends FlxState
{
	public static var r_instance:PlayState = null;

	public function new()
	{
		super();
		r_instance = this;
	}

	public var images:Map<String, FlxSprite> = new Map<String, FlxSprite>();
	public var text:Map<String, FlxText> = new Map<String, FlxText>();
	public var camGame:Map<String, FlxCamera> = new Map<String, FlxCamera>();

	static public var luaScripts:Array<LuaCode> = [];
	static public var hscriptScripts:Array<HScriptCode> = [];

	override public function create()
	{
		super.create();
		var folders = 'mods/' + Main.mainFolder + '/data/';
		var folderToRead = FileSystem.readDirectory(folders);
		for (file in folderToRead)
		{
			if (file.endsWith(".lua"))
			{
				Logger.log("Lua File: " + file + " added");
				var scriptPath = Path.join([folders, file]);
				luaScripts.push(new LuaCode(scriptPath));
			}
			if (file.endsWith(".hx") || file.endsWith(".hxs"))
			{
				Logger.log("Haxe File: " + file + " added");
				var scriptPath = Path.join([folders, file]);
				hscriptScripts.push(new HScriptCode(scriptPath));
			}
		}

		callOnScripts("onCreate", []);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		callOnScripts("onUpdate", [elapsed]);
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

		for (i in 0...hscriptScripts.length)
		{
			hscriptScripts[i].call(funcName, args);
		}

		return value;
	}
}

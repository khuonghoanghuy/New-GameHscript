package scriptsCode;

import flixel.FlxBasic;
import flixel.text.FlxText;
import llua.Convert;
import llua.Lua.Lua_helper;
import llua.Lua;
import llua.LuaL;
import llua.State;

using StringTools;

class LuaCode extends FlxBasic
{
	public static var Function_Stop:Dynamic = 1;
	public static var Function_Continue:Dynamic = 0;

	var lua:State;
	var playState:PlayState;

	public function new(file:String)
	{
		super();

		playState = PlayState.r_instance;

		lua = LuaL.newstate();
		LuaL.openlibs(lua);
		Lua.init_callbacks(lua);

		try
		{
			var result:Dynamic = LuaL.dofile(lua, file);
			var resultStr:String = Lua.tostring(lua, result);
			if (resultStr != null && result != 0)
			{
				Logger.log('Error loading lua script: "$file"\n' + resultStr, "[ERROR]");
				lua = null;
				return;
			}
		}
		catch (e:Dynamic)
		{
			trace(e);
			return;
		}

		add_callback("setProperty", function(tag:String, value:Dynamic)
		{
			var variable = tag.split('.');
			if (variable.length == 2)
			{
				var key = variable[1];

				if (playState.images.exists(key))
				{
					return Reflect.setProperty(playState.images.get(key), variable[0], value);
				}
				else if (playState.text.exists(key))
				{
					return Reflect.setProperty(playState.text.get(key), variable[0], value);
				}
				else
				{
					Logger.log("Key not found in images or text: " + key);
				}
			}
			else
			{
				Logger.log("Invalid tag format: " + tag);
			}
		});
		add_callback("makeLuaText", function(tag:String, x:Float = 0, y:Float = 0, fieldwidth:Int = 0, text:String = "", size:Int = 8)
		{
			var luaText:FlxText = new FlxText(x, y, fieldwidth, text, size);
			luaText.active = true;
			playState.text.set(tag, luaText);
		});

		add_callback("setTextString", function(tag:String, text:String = "")
		{
			if (getExistsTag(tag))
			{
				getCodeTag(tag).text = text;
			}
		});
		add_callback("setTextActive", function(tag:String, bool:Bool = true)
		{
			if (getExistsTag(tag))
			{
				getCodeTag(tag).active = bool;
			}
		});
		add_callback("setTextSize", function(tag:String, size:Int = 8)
		{
			if (getExistsTag(tag))
			{
				getCodeTag(tag).size = size;
			}
		});
		add_callback("setTextAutoSize", function(tag:String, bool:Bool = false)
		{
			if (getExistsTag(tag))
			{
				getCodeTag(tag).autoSize = bool;
			}
		});
		add_callback("setTextBold", function(tag:String, bool:Bool = false)
		{
			if (getExistsTag(tag))
			{
				getCodeTag(tag).bold = bool;
			}
		});
		add_callback("setTextItalic", function(tag:String, bool:Bool = false)
		{
			if (getExistsTag(tag))
			{
				getCodeTag(tag).italic = bool;
			}
		});

		add_callback("addLuaText", function(tag:String)
		{
			if (getExistsTag(tag))
			{
				playState.add(playState.text.get(tag));
			}
		});
		add_callback("removeLuaText", function(tag:String)
		{
			if (getExistsTag(tag))
			{
				playState.remove(playState.text.get(tag));
			}
		});
	}

	function getExistsTag(tag:String):Bool
	{
		var value:Bool = false;
		if (!playState.text.exists(tag))
		{
			Logger.log("Object Text " + tag + " doesn't exists!");
			value = false;
		}
		else
		{
			value = playState.text.exists(tag);
		}
		return value;
	}

	function getCodeTag(tag:String)
	{
		return playState.text.get(tag);
	}

	public function add_callback(name:String, eventToDo:Dynamic)
		return Lua_helper.add_callback(lua, name, eventToDo);

	// Friday Night Funkin' Psych Engine Code
	public function call(event:String, args:Array<Dynamic>):Dynamic
	{
		if (lua == null)
		{
			return Function_Continue;
		}

		Lua.getglobal(lua, event);

		for (arg in args)
		{
			Convert.toLua(lua, arg);
		}

		var result:Null<Int> = Lua.pcall(lua, args.length, 1, 0);
		if (result != null && resultIsAllowed(lua, result))
		{
			if (Lua.type(lua, -1) == Lua.LUA_TSTRING)
			{
				var error:String = Lua.tostring(lua, -1);
				if (error == 'attempt to call a nil value')
				{ // Makes it ignore warnings and not break stuff if you didn't put the functions on your lua file
					return Function_Continue;
				}
			}
			var conv:Dynamic = Convert.fromLua(lua, result);
			return conv;
		}
		return Function_Continue;
	}

	function resultIsAllowed(leLua:State, leResult:Null<Int>)
	{ // Makes it ignore warnings
		switch (Lua.type(leLua, leResult))
		{
			case Lua.LUA_TNIL | Lua.LUA_TBOOLEAN | Lua.LUA_TNUMBER | Lua.LUA_TSTRING | Lua.LUA_TTABLE:
				return true;
		}
		return false;
	}
}
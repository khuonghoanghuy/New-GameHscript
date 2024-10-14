package scriptsCode;

import flixel.FlxBasic;
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

		playState = PlayState.instance;

		lua = LuaL.newstate();
		LuaL.openlibs(lua);
		Lua.init_callbacks(lua);

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
	}

	function add_callback(name:String, eventToDo:Dynamic)
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
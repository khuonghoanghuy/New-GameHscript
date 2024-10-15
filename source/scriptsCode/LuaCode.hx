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

		add_callback("getProperty", function(tag:String, property:String)
		{
			var splitDot:Array<String> = property.split('.');
			var getData:Dynamic = null;
			if (splitDot.length > 1)
			{
				if (getCameraExistsTag(splitDot[0]))
				{
					getData = getCameraTag(splitDot[0]);
				}
				else if (getImagesExistsTag(splitDot[0]))
				{
					getData = getImagesTag(splitDot[0]);
				}
				else if (getTextExistsTag(splitDot[0]))
				{
					getData = getTextTag(splitDot[0]);
				}
				for (i in 1...splitDot.length - 1)
				{
					getData = Reflect.getProperty(getData, splitDot[i]);
				}
				return Reflect.getProperty(getData, splitDot[splitDot.length - 1]);
			}
			return Reflect.getProperty(getData, splitDot[splitDot.length - 1]);
		});
		add_callback("setProperty", function(tag:String, property:String, value:Dynamic)
		{
			if (getCameraExistsTag(tag))
			{
				var camera = getCameraTag(tag);
				var propertyParts:Array<String> = property.split(".");
				if (propertyParts.length > 1)
				{
					var subProperty:String = propertyParts[0];
					var subValue:String = propertyParts[1];
					Reflect.setProperty(Reflect.getProperty(camera, subProperty), subValue, value);
				}
				else
				{
					Reflect.setProperty(camera, property, value);
				}
			}
			else if (getImagesExistsTag(tag))
				{
				var sprite = getImagesTag(tag);
				var propertyParts:Array<String> = property.split(".");
				if (propertyParts.length > 1)
				{
					var subProperty:String = propertyParts[0];
					var subValue:String = propertyParts[1];
					Reflect.setProperty(Reflect.getProperty(sprite, subProperty), subValue, value);
				}
				else
				{
					Reflect.setProperty(sprite, property, value);
				}
			}
			else if (getTextExistsTag(tag))
			{
				var text = getTextTag(tag);
				var propertyParts:Array<String> = property.split(".");
				if (propertyParts.length > 1)
				{
					var subProperty:String = propertyParts[0];
					var subValue:String = propertyParts[1];
					Reflect.setProperty(Reflect.getProperty(text, subProperty), subValue, value);
				}
				else
				{
					Reflect.setProperty(text, property, value);
				}
			}
		});
		add_callback("getPropertyFromClass", function(classes:String, value:String)
		{
			var splitDot:Array<String> = value.split(".");
			var getClassProperty:Dynamic = Type.resolveClass(classes);
			if (splitDot.length > 1)
			{
				for (i in 1...splitDot.length)
				{
					getClassProperty = Reflect.getProperty(getClassProperty, splitDot[i - 1]);
				}
				return Reflect.getProperty(getClassProperty, splitDot[splitDot.length - 1]);
			}
			return Reflect.getProperty(getClassProperty, value);
		});
		add_callback("setPropertyFromClass", function(classes:String, variable:String, value:Dynamic)
		{
			var splitDot:Array<String> = variable.split('.');
			var getClassProperty:Dynamic = Type.resolveClass(classes);
			if (splitDot.length > 1)
			{
				for (i in 1...splitDot.length - 1)
				{
					getClassProperty = Reflect.getProperty(getClassProperty, splitDot[i - 1]);
				}
				return Reflect.setProperty(getClassProperty, splitDot[splitDot.length - 1], value);
			}
			return Reflect.setProperty(getClassProperty, variable, value);
		});
		// Text Parent
		presentText();
	}

	function presentText():Void
	{
		add_callback("makeLuaText", function(tag:String, x:Float = 0, y:Float = 0, fieldwidth:Int = 0, text:String = "", size:Int = 8)
		{
			var luaText:FlxText = new FlxText(x, y, fieldwidth, text, size);
			luaText.active = true;
			playState.text.set(tag, luaText);
		});
		add_callback("setTextString", function(tag:String, text:String = "")
		{
			if (getTextExistsTag(tag))
			{
				getTextTag(tag).text = text;
			}
		});
		add_callback("setTextActive", function(tag:String, bool:Bool = true)
		{
			if (getTextExistsTag(tag))
			{
				getTextTag(tag).active = bool;
			}
		});
		add_callback("setTextSize", function(tag:String, size:Int = 8)
		{
			if (getTextExistsTag(tag))
			{
				getTextTag(tag).size = size;
			}
		});
		add_callback("setTextAutoSize", function(tag:String, bool:Bool = false)
		{
			if (getTextExistsTag(tag))
			{
				getTextTag(tag).autoSize = bool;
			}
		});
		add_callback("setTextBold", function(tag:String, bool:Bool = false)
		{
			if (getTextExistsTag(tag))
			{
				getTextTag(tag).bold = bool;
			}
		});
		add_callback("setTextItalic", function(tag:String, bool:Bool = false)
		{
			if (getTextExistsTag(tag))
			{
				getTextTag(tag).italic = bool;
			}
		});
		add_callback("addLuaText", function(tag:String)
		{
			if (getTextExistsTag(tag))
			{
				playState.add(playState.text.get(tag));
			}
		});
		add_callback("removeLuaText", function(tag:String)
		{
			if (getTextExistsTag(tag))
			{
				playState.remove(playState.text.get(tag));
			}
		});
	}

	function getTextExistsTag(tag:String):Bool
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

	function getTextTag(tag:String)
	{
		return playState.text.get(tag);
	}

	function presentImages():Void {}

	function getImagesExistsTag(tag:String):Bool
	{
		var value:Bool = false;
		if (!playState.images.exists(tag))
		{
			Logger.log("Object Images " + tag + " doesn't exists!");
			value = false;
		}
		else
		{
			value = playState.images.exists(tag);
		}
		return value;
	}

	function getImagesTag(tag:String)
	{
		return playState.images.get(tag);
	}

	function getCameraExistsTag(tag:String):Bool
	{
		var value:Bool = false;
		if (!playState.camGame.exists(tag))
		{
			Logger.log("Object Camera " + tag + " doesn't exists!");
			value = false;
		}
		else
		{
			value = playState.camGame.exists(tag);
		}
		return value;
	}

	function getCameraTag(tag:String)
	{
		return playState.camGame.get(tag);
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
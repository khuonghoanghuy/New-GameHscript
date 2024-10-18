package scriptsCode;

import flixel.FlxBasic;
import flixel.FlxSprite;
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

		add_callback("getProperty", function(tagAndProperty:String):Dynamic
		{
			var parts:Array<String> = tagAndProperty.split('.');

			if (parts.length < 2)
			{
				Logger.log("Invalid tag format: " + tagAndProperty);
				return null;
			}
			var tag:String = parts.shift();
			var propertyPath:Array<String> = parts;

			var target:Dynamic = null;

			if (getCameraExistsTag(tag))
			{
				target = getCameraTag(tag);
			}
			else if (getImagesExistsTag(tag))
			{
				target = getImagesTag(tag);
			}
			else if (getTextExistsTag(tag))
			{
				target = getTextTag(tag);
			}
			else if (!getTextExistsTag(tag) || !getImagesExistsTag(tag) || !getCameraExistsTag(tag))
			{
				Logger.log("Key not found in camera, images, or text: " + tag);
				return null;
			}
			for (i in 0...propertyPath.length - 1)
			{
				target = Reflect.getProperty(target, propertyPath[i]);
				if (target == null)
				{
					Logger.log("Property path not found: " + propertyPath[i]);
					return null;
				}
			}
			return Reflect.getProperty(target, propertyPath[propertyPath.length - 1]);
		});
		add_callback("setProperty", function(tagAndProperty:String, value:Dynamic)
		{
			var parts:Array<String> = tagAndProperty.split('.');

			if (parts.length < 2)
			{
				Logger.log("Invalid tag format: " + tagAndProperty);
				return;
			}
			var tag:String = parts.shift();
			var propertyPath:Array<String> = parts;

			var target:Dynamic = null;

			if (getCameraExistsTag(tag))
			{
				target = getCameraTag(tag);
			}
			else if (getImagesExistsTag(tag))
			{
				target = getImagesTag(tag);
			}
			else if (getTextExistsTag(tag))
			{
				target = getTextTag(tag);
			}
			else if (!getTextExistsTag(tag) || !getImagesExistsTag(tag) || !getCameraExistsTag(tag))
			{
				Logger.log("Key not found in camera, images, or text: " + tag);
				return;
			}
			for (i in 0...propertyPath.length - 1)
			{
				target = Reflect.getProperty(target, propertyPath[i]);
				if (target == null)
				{
					Logger.log("Property path not found: " + propertyPath[i]);
					return;
				}
			}
			Reflect.setProperty(target, propertyPath[propertyPath.length - 1], value);
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
		add_callback("addObject", function(tag:String)
		{
			var target:Dynamic = null;
			if (getTextExistsTag(tag))
			{
				target = getTextTag(tag);
				playState.add(target);
			}
			else if (getImagesExistsTag(tag))
			{
				target = getImagesTag(tag);
				playState.add(target);
			}
			else if (!getTextExistsTag(tag) || !getImagesExistsTag(tag))
			{
				Logger.log("Key not found in images, or text: " + tag);
				return;
			}
		});
		add_callback("removeObject", function(tag:String)
		{
			var target:Dynamic = null;
			if (getTextExistsTag(tag))
			{
				target = getTextTag(tag);
				playState.remove(target);
			}
			else if (getImagesExistsTag(tag))
			{
				target = getImagesTag(tag);
				playState.remove(target);
			}
			else if (!getTextExistsTag(tag) || !getImagesExistsTag(tag))
			{
				Logger.log("Key not found in images, or text: " + tag);
				return;
			}
		});

		add_callback("setVar", function(key:String, value:Dynamic)
		{
			LuaStore.setVar(key, value);
		});
		add_callback("getVar", function(key:String):Dynamic
		{
			return LuaStore.getVar(key);
		});
		add_callback("luaTrace", function(text:String)
		{
			trace(text);
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

	function presentImages():Void
	{
		add_callback("makeLuaSprite", function(tag:String, x:Float, y:Float, ?pSprite:String = null)
		{
			var sprite:FlxSprite = new FlxSprite(x, y);
			sprite.loadGraphic(pSprite);
			sprite.active = true;
			playState.images.set(tag, sprite);
		});

		add_callback("playAnim", function(tag:String, name:String, force:Bool)
		{
			if (getImagesExistsTag(tag))
			{
				getImagesTag(tag).animation.play(tag);
			}
		});
		add_callback("addAnim", function(tag:String, name:String, numArray:Array<Int>, fps:Int = 24, looped:Bool = false)
		{
			if (getImagesExistsTag(tag))
			{
				getImagesTag(tag).animation.add(name, numArray, fps, looped);
			}
		});
		add_callback("addAnimByPrefix", function(tag:String, name:String, prefix:String, fps:Int = 24, looped:Bool = false)
		{
			if (getImagesExistsTag(tag))
			{
				getImagesTag(tag).animation.addByPrefix(name, prefix, fps, looped);
			}
		});
		add_callback("addAnimByIndices", function(tag:String, name:String, prefix:String, numArray:Array<Int>, fps:Int = 24, looped:Bool = false)
		{
			if (getImagesExistsTag(tag))
			{
				getImagesTag(tag).animation.addByIndices(name, prefix, numArray, ".png", fps, looped);
			}
		});
		add_callback("addAnimByStringIndices", function(tag:String, name:String, prefix:String, idices:Array<String>, fps:Int = 24, looped:Bool = false)
		{
			if (getImagesExistsTag(tag))
			{
				getImagesTag(tag).animation.addByStringIndices(name, prefix, idices, ".png", fps, looped);
			}
		});

		add_callback("addLuaSprite", function(tag:String)
		{
			if (getImagesExistsTag(tag))
			{
				playState.add(getImagesTag(tag));
			}
		});
		add_callback("removeLuaSprite", function(tag:String)
		{
			if (getImagesExistsTag(tag))
			{
				playState.remove(getImagesTag(tag));
			}
		});
	}

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
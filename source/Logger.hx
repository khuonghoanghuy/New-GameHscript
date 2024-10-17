package;

import flixel.FlxG;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class Logger
{
    public static function log(message:String, level:String = "INFO"):Void {
        var formattedMessage = "[" + level + "] " + message;
		trace(formattedMessage);
    }

	public static function logCrash(error:Dynamic):Void
	{
		log(Std.string(error), "[CRASH]");
	}
}

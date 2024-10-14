package;

import flixel.FlxG;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class Logger {
    private static var logText:FlxText;
    private static var logGroup:FlxGroup = new FlxGroup();

    public static function init() {
        logText = new FlxText(10, 10, FlxG.width - 20, "", true);
        logText.setFormat("_sans", 12, FlxColor.WHITE, LEFT, OUTLINE, FlxColor.BLACK);
        logGroup.add(logText);
    }

    public static function log(message:String, level:String = "INFO"):Void {
        var formattedMessage = "[" + level + "] " + message;
        trace(formattedMessage);
        updateLogText(formattedMessage);
    }

    private static function updateLogText(message:String):Void {
        logText.text += message + "\n";
        var lines = logText.text.split("\n");
        if (lines.length > 10) {
            lines.shift();
            logText.text = lines.join("\n");
        }
    }

    public static function getLogGroup():FlxGroup {
        return logGroup;
    }
}

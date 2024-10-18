package;

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

package;

import flixel.FlxG;
import flixel.FlxSubState;

class SubLogState extends FlxSubState
{
	override function create()
	{
		super.create();

		Logger.init();
		add(Logger.getLogGroup());
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		if (FlxG.keys.justPressed.F12)
			closeSubState();
	}
}
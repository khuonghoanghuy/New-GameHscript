package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;

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

	override public function create()
	{
		super.create();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		if (FlxG.keys.justPressed.F12)
			openSubState(new SubLogState());
	}
}

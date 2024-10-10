package;

import backend.Modding;
import flixel.FlxGame;
import openfl.display.Sprite;

class Main extends Sprite
{
	public function new()
	{
		super();
		Modding.reload();
		Modding.getMods();
		Modding.getParseRules();
		trace("Mods loaded: " + Modding.trackedMods);
		addChild(new FlxGame(0, 0, PlayState));
	}
}

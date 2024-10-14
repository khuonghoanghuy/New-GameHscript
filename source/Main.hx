package;

import flixel.FlxGame;
import openfl.display.Sprite;
import sys.io.File;

class Main extends Sprite
{
	public static var mainFolder:String = File.getContent("system/configFolder.txt");

	public function new()
	{
		super();
		addChild(new FlxGame(0, 0, PlayState, 60, 60, true));
	}
}

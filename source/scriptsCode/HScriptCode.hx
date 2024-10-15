package scriptsCode;

import crowplexus.iris.Iris;
import crowplexus.iris.IrisConfig;
import flixel.FlxBasic;

class HScriptCode extends FlxBasic
{
	public var myScript:Iris;

	public function new(file:String)
	{
		super();
		final rules:RawIrisConfig = {name: "hscript-iris", autoRun: false, autoPreset: true};
		final getText:String->String = #if sys sys.io.File.getContent #elseif openfl openfl.utils.Assets.getText #end;
		myScript = new Iris(getText(file), rules);
		myScript.execute();
	}

	public function call(event:String, args:Array<Dynamic>)
	{
		myScript.call(event, args);
	}
}
package scriptsCode;

import crowplexus.iris.Iris;
import crowplexus.iris.IrisConfig;
import flixel.FlxBasic;

using StringTools;

class HScriptCode extends FlxBasic
{
	public var myScript:Iris;

	public function new(file:String)
	{
		super();
		final rules:RawIrisConfig = {name: "hscript-iris", autoRun: false, autoPreset: true};
		final getText:String->String = #if sys sys.io.File.getContent #elseif openfl openfl.utils.Assets.getText #end;
		myScript = new Iris(getText(file), rules);
		myScript.preset();
		myScript.set('importClass', function(daClass:String, ?asDa:String)
		{
			final splitClassName:Array<String> = [for (e in daClass.split('.')) e.trim()];
			final className:String = splitClassName.join('.');
			final daClass:Class<Dynamic> = Type.resolveClass(className);
			final daEnum:Enum<Dynamic> = Type.resolveEnum(className);

			if (daClass == null && daEnum == null)
				Logger.log("Class/Enum you want to added not found!\nName Class/Enum: " + Std.string(className), "[ERROR]");
			else
			{
				if (daEnum != null)
				{
					var daEnumField = {};
					for (daConstructor in daEnum.getConstructors())
						Reflect.setField(daEnumField, daConstructor, daEnum.createByName(daConstructor));

					if (asDa != null && asDa != '')
						myScript.set(asDa, daEnumField);
					else
						myScript.set(splitClassName[splitClassName.length - 1], daEnumField);
				}
				else
				{
					if (asDa != null && asDa != '')
						myScript.set(asDa, daClass);
					else
						myScript.set(splitClassName[splitClassName.length - 1], daClass);
				}
			}
		});
		myScript.set("game", PlayState.r_instance);
		myScript.set("add", function(basic:FlxBasic)
		{
			return PlayState.r_instance.add(basic);
		});
		myScript.set("remove", function(basic:FlxBasic)
		{
			return PlayState.r_instance.remove(basic);
		});
		myScript.execute();
	}

	public function call(event:String, args:Array<Dynamic>)
	{
		myScript.call(event, args);
	}
}
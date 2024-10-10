package backend;

#if sys
import sys.FileSystem;
#end

using StringTools;

class Paths
{
	inline public static final DEFAULT_FOLDER:String = 'mods';

	static public function getPath(folder:Null<String>, file:String)
	{
		if (folder == null)
			folder = DEFAULT_FOLDER;
		return folder + '/' + file;
	}

	static public function file(file:String, folder:String = DEFAULT_FOLDER)
	{
		if (#if sys FileSystem.exists(folder) && #end (folder != null && folder != DEFAULT_FOLDER))
			return getPath(folder, file);
		return getPath(null, file);
	}

	inline static public function script(key:String)
		return file('$key.hx');

	inline static public function image(key:String)
		return file('images/$key.png');

	inline static public function music(key:String)
		return file('music/$key.ogg');

	inline static public function sounds(key:String)
		return file('sounds/$key.ogg');

	inline static public function data(key:String)
		return file('data/$key');

	inline static public function font(key:String)
		return file('fonts/$key');

	inline static public function formatToSongPath(path:String)
	{
		var invalidChars = ~/[~&\\;:<>#]/;
		var hideChars = ~/[.,'"%?!]/;

		var path = invalidChars.split(path.replace(' ', '-')).join("-");
		return hideChars.split(path).join("").toLowerCase();
	}
}
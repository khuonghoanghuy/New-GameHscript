package backend;

import openfl.display.BitmapData;
import openfl.media.Sound;
import openfl.net.URLRequest;
import openfl.text.Font;
import openfl.utils.Assets;
import sys.FileSystem;

using StringTools;

class ModPaths {
    public static var modsImages:Map<String, String> = new Map<String, String>();
    public static var modsFiles:Map<String, String> = new Map<String, String>();
    public static var modsSounds:Map<String, String> = new Map<String, String>();
    public static var modsFonts:Map<String, String> = new Map<String, String>();

    public static function registerModAssets(modFolder:String):Void {
        var assetPath = "mods/" + modFolder + "/assets/";
        if (FileSystem.exists(assetPath)) {
            var assetFiles:Array<String> = FileSystem.readDirectory(assetPath);
            for (assetFile in assetFiles) {
                var assetKey = assetFile;
                var assetFullPath = assetPath + assetFile;
                
                if (assetFile.endsWith(".png") || assetFile.endsWith(".jpg")) {
                    modsImages.set(assetKey, assetFullPath);
                } else if (assetFile.endsWith(".mp3") || assetFile.endsWith(".wav")) {
                    modsSounds.set(assetKey, assetFullPath);
                } else if (assetFile.endsWith(".ttf") || assetFile.endsWith(".otf")) {
                    modsFonts.set(assetKey, assetFullPath);
                } else {
                    modsFiles.set(assetKey, assetFullPath);
                }
            }
        }
    }

    public static function getImage(key:String):BitmapData {
        if (modsImages.exists(key)) {
            return Assets.getBitmapData(modsImages.get(key));
        }
        return null;
    }

    public static function getSound(key:String):Sound {
        if (modsSounds.exists(key)) {
            var soundPath:String = modsSounds.get(key);
            return new Sound(new URLRequest(soundPath));
        }
        return null;
    }
    

    public static function getFont(key:String):Font {
        if (modsFonts.exists(key)) {
            return Assets.getFont(modsFonts.get(key));
        }
        return null;
    }

    public static function getFile(key:String):String {
        if (modsFiles.exists(key)) {
            return modsFiles.get(key);
        }
        return null;
    }
}

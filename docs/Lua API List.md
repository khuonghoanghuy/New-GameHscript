# Lua API List
## Affect on any object
* getProperty(tag:String) - get value of the variable object
* setProperty(tag:String, value:Dynamic) - set a value of the variable object, can be used like `setProperty("setMe.x", "2")` and the `setMe` variable will be set on `x` by 2
* getPropertyFromClass(classesFile:String, variable:String) - get a value of the variable from a classes
* setPropertyFromClass(classesFile:String, variable:String, value:Dynamic) - set a value of the variable from a classes, can be used like `setPropertyFromClass("flixel.FlxG", "mouse.visible", false)` and the `mouse` variable from `FlxG` clases will be set as `false`
* addObject(tag:String) - added a object from images, text
* removeObject(tag:String) - remove a object from images, text
* screenCenterObject(tag:String) - set screen on center on any object with text, images
* scaleObject(tag:String, x:Float = 1, y:Float = 1) - set scale on any object with text, images
* scrollFactorObject(tag:String, x:Float = 1, y:Float = 1) - set scroll factor on any object, useful with camera thing
* setPositionObject(tag:String, x:Float = 1, y:Float = 1) - set position with `x` and `y` on any object
## Text API
* makeLuaText(tag:String, x:Float = 0, y:Float = 0, fieldwidth:Int = 0, text:String = "", size:Int = 8) - make/init a text, using `addObject` or `addLuaText` to add the current target text
* setTextString(tag:String, text:String = "") - change from a current text to a new one
* setTextActive(tag:String, bool:Bool = true) - make text active or not
* setTextSize(tag:String, size:Int = 8) - make text larger or smaller
* setTextAutoSize(tag:String, bool:Bool = false) - make text resize automatically
* setTextBold(tag:String, bool:Bool) - make text have bold or not
* setTextItalic(tag:String, bool:Bool) - make text have italic or not
* addLuaText(tag:String) - add text object into the game
* removeLuaText(tag:String) - remove text object from the game
## Sprite API
* makeLuaSprite(tag:String, x:Float, y:Float, ?pSprite:String = null) - make/init a sprite, using `addObject` or `addLuaSprite` to add the current target sprite
* playAnim(tag:String, name:String, force:Bool) - play a animation from the sprite
* addAnim(tag:String, name:String, numArray:Array(Int), fps:Int = 24, looped:Bool = false) - add a animation from the same width and height box of frames
* addAnimByPrefix(tag:String, name:String, prefix:String, fps:Int = 24, looped:Bool = false) - add a animation from the prefix of sprite sheet
* addAnimByIndices(tag:String, name:String, prefix:String, numArray:Array(Int), fps:Int = 24, looped:Bool = false) - add a animation from the prefix with advance of indices
* addAnimByStringIndices(tag:String, name:String, prefix:String, idices:Array(String), fps:Int = 24, looped:Bool = false) - same as `addAnimByIndices` but with number, string text only
* addLuaSprite(tag:String) - add sprite into the game
* removeLuaSprite(tag:String) - remove sprite from the game
## Camera API
* makeCamera(tag:String, x:Float = 0, y:Float = 0, zoom:Int = 1) - make/init a camera, using `addObject` or `addLuaCamera` to add the current target camera
* addLuaCamera(tag:String, draw:Bool = false) - add a current target camera, set `draw` to true if you wanna render the camera
* removeLuaCamera(tag:String, destroyBool:Bool = false) - remove a current target camera
## Misc
* luaTrace(text:String) - traced text onto command/terminal
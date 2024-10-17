# Lua API List
## Affect on any object (IN WORK LIKE THIS)
* getProperty(tag:String) - get value of the variable object
* setProperty(tag:String, value:Dynamic) - set a value of the variable object, can be used like `setProperty("setMe.x", "2")` and the `setMe` variable will be set on `x` by 2
* getPropertyFromClass(classesFile:String, variable:String) - get a value of the variable from a classes
* setPropertyFromClass(classesFile:String, variable:String, value:Dynamic) - set a value of the variable from a classes, can be used like `setPropertyFromClass("flixel.FlxG", "mouse.visible", false)` and the `mouse` variable from `FlxG` clases will be set as `false`
## Text API

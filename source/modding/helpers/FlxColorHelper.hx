package modding.helpers;

import flixel.util.FlxColor;

/**
 * Helper class for FlxColor as it can not be accessed in HScript because it is an abstract. 
 */
class FlxColorHelper  {
    public static final BLACK:FlxColor = FlxColor.BLACK;
    public static final BLUE:FlxColor = FlxColor.BLUE;
    public static final BROWN:FlxColor = FlxColor.BROWN;
    public static final CYAN:FlxColor = FlxColor.CYAN;
    public static final GRAY:FlxColor = FlxColor.GRAY;
    public static final GREEN:FlxColor = FlxColor.GREEN;
    public static final LIME:FlxColor = FlxColor.LIME;
    public static final MAGENTA:FlxColor = FlxColor.MAGENTA;
    public static final ORANGE:FlxColor = FlxColor.ORANGE;
    public static final PINK:FlxColor = FlxColor.PINK;
    public static final PURPLE:FlxColor = FlxColor.PURPLE;
    public static final RED:FlxColor = FlxColor.RED;
    public static final TRANSPARENT:FlxColor = FlxColor.TRANSPARENT;
    public static final WHITE:FlxColor = FlxColor.WHITE;
    public static final YELLOW:FlxColor = FlxColor.YELLOW;

    public static function fromInt(value:Int):FlxColor return FlxColor.fromInt(value);

    public static function fromRGB(r:Int, g:Int, b:Int, a:Int):FlxColor return FlxColor.fromRGB(r, g, b, a);

    public static function fromRGBFloat(r:Float, g:Float, b:Float, a:Float):FlxColor return FlxColor.fromRGBFloat(r, g, b, a);

    public static function fromCMYK(c:Float, y:Float, m:Float, k:Float, a:Float):FlxColor return FlxColor.fromCMYK(c, y, m, k, a);

    public static function fromHSB(h:Float, s:Float, b:Float, a:Float):FlxColor return FlxColor.fromHSB(h, s, b, a);

    public static function fromHSL(h:Float, s:Float, l:Float, a:Float):FlxColor return FlxColor.fromHSL(h, s, l, a);

    public static function fromString(string:String):FlxColor return FlxColor.fromString(string);

    public static function getRed(color:FlxColor):Int return color.red;

    public static function getRedFloat(color:FlxColor):Float return color.redFloat;

    public static function getGreen(color:FlxColor):Int return color.green;

    public static function getGreenFloat(color:FlxColor):Float return color.greenFloat;

    public static function getBlue(color:FlxColor):Int return color.blue;

    public static function getBlueFloat(color:FlxColor):Float return color.blueFloat;
}
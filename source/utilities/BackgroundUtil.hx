package utilities;

import openfl.utils.Assets;
import flixel.util.FlxColor;
import flixel.FlxSprite;


/**
 * Helper class for loading menu backgrounds.
 * Should be used via:
 * ```hx
 * using utilities.BackgroundUtil;
 * ```
 */
class BackgroundUtil{

    /**
     * Creates a new menu background.
     * @param sprite the `FlxSprite` to manipulate.
     * @param color the color the background should be.
     * @return FlxSprite
     */
    public static function makeBackground(sprite:FlxSprite, color:FlxColor):FlxSprite{
        if(!Options.getData("menuBGs")){
            trace(color);
            sprite.makeGraphic(1286, 730, color, true, "menuBG");
            return sprite;
        }
        sprite.color = color;
        var skin:String = Assets.exists(Paths.image('ui skins/${Options.getData('uiSkin')}/backgrounds/menuDesat')) ? Options.getData('uiSkin') : 'default';
        return sprite.loadGraphic(Paths.gpuBitmap('ui skins/${skin}/backgrounds/menuDesat'));
	}
}
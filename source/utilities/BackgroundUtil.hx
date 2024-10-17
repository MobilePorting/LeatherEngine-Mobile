package utilities;

import openfl.utils.Assets;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;


class BackgroundUtil{
    public static function makeBackground(sprite:FlxSprite, color:FlxColor):FlxSprite{
        if(!Options.getData("menuBGs")){
            sprite.makeGraphic(1286, 730, color);
            return sprite;
        }
        sprite.color = color;
        sprite.antialiasing = Options.getData("antialiasing");
        var skin:String = Assets.exists(Paths.image('ui skins/${Options.getData('uiSkin')}/backgrounds/menuDesat')) ? Options.getData('uiSkin') : 'default';
        return sprite.loadGraphic(Paths.gpuBitmap('ui skins/${skin}/backgrounds/menuDesat'));
	}
}
package ui;

#if MODDING_ALLOWED
import flixel.FlxObject;
import openfl.display.BitmapData;
import flixel.FlxSprite;

class ModIcon extends TrackerSprite {

	public function new(modID:String = 'Template Mod', ?tracker:FlxSprite, ?xOff:Float, ?yOff:Float, ?dir:TrackerSprite.TrackerDirection) {
		super(tracker, xOff, yOff, dir);

		loadGraphic(BitmapData.fromFile("mods/" + modID + "/_polymod_icon.png"));
		setGraphicSize(150, 150);
		updateHitbox();
		
		scrollFactor.set();
	}

	override function update(elapsed:Float) {
		super.update(elapsed);

		if (sprTracker != null) {
			setPosition(sprTracker.x + sprTracker.width + 10, sprTracker.y - 30);
		}
	}
}
#end
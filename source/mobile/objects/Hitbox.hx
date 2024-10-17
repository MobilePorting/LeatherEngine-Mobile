package mobile.objects;

import flixel.FlxG;
import flixel.group.FlxSpriteGroup;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.util.FlxDestroyUtil;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import openfl.display.BitmapData;
import openfl.display.Shape;
import openfl.geom.Matrix;

/**
 * A zone with 4 hints (A hitbox).
 * It's really easy to customize the layout.
 *
 * @author Mihai Alexandru (M.A. Jigsaw)
 */
class Hitbox extends FlxSpriteGroup {
	/**
	 * Array of MobileButton representing the hints.
	 */
	public var hints(default, null):Array<MobileButton>;

	final guh2:Float = 0.00001;
	final guh:Float = Options.getData("mobileCAlpha") >= 0.9 ? Options.getData("mobileCAlpha") - 0.2 : Options.getData("mobileCAlpha");

	/**
	 * Creates the zone with the specified number of hints.
	 *
	 * @param ammo The amount of hints you want to create.
	 * @param perHintWidth The width that the hints will use.
	 * @param perHintHeight The height that the hints will use.
	 * @param colors The color per hint.
	 */
	public function new(ammo:UInt, perHintWidth:Int, perHintHeight:Int, ?colors:Array<FlxColor>):Void {
		super();

		hints = new Array<MobileButton>();

		if (colors == null)
			switch (ammo) {
				case 1:
					colors = [0xCCCCCC];
				case 2:
					colors = [0xC24B99, 0xF9393F];
				case 3:
					colors = [0xC24B99, 0xCCCCCC, 0xF9393F];
				case 5:
					colors = [0xC24B99, 0x00FFFF, 0xCCCCCC, 0x12FA05, 0xF9393F];
				case 6:
					colors = [0xC24B99, 0x12FA05, 0xF9393F, 0xFFFF00, 0x00FFFF, 0x0033FF];
				case 7:
					colors = [0xC24B99, 0x12FA05, 0xF9393F, 0xCCCCCC, 0xFFFF00, 0x00FFFF, 0x0033FF];
				case 8:
					colors = [0xC24B99, 0x00FFFF, 0x12FA05, 0xF9393F, 0xFFFF00, 0x8B4AFF, 0xFF0000, 0x0033FF];
				case 9:
					colors = [
						0xC24B99,
						0x00FFFF,
						0x12FA05,
						0xF9393F,
						0xCCCCCC,
						0xFFFF00,
						0x8B4AFF,
						0xFF0000,
						0x0033FF
					];
				case 10:
					colors = [
						0xC24B99, 0x00FFFF, 0x12FA05, 0xF9393F, 0x12FA05, 0x00FFFF, 0xFFFF00, 0x8B4AFF, 0xFF0000, 0x0033FF
					];
				case 11:
					colors = [
						0xC24B99, 0x00FFFF, 0x12FA05, 0xF9393F, 0x12FA05, 0xC24B99, 0x00FFFF, 0xFFFF00, 0x8B4AFF, 0xFF0000, 0x0033FF
					];
				case 12:
					colors = [
						0xC24B99, 0x00FFFF, 0x12FA05, 0xF9393F, 0xFF0000, 0x00FFFF, 0x12FA05, 0x0033FF, 0xFFFF00, 0x8B4AFF, 0xFF0000, 0x0033FF
					];
				case 13:
					colors = [
						0xC24B99, 0x00FFFF, 0x12FA05, 0xF9393F, 0xFF0000, 0x1E29FF, 0xCCCCCC, 0x6200FF, 0x1EFF69, 0xFFFF00, 0x8B4AFF, 0xFF0000, 0x0033FF
					];
				case 14:
					colors = [
						0xC24B99, 0x00FFFF, 0x12FA05, 0xF9393F, 0xFF0000, 0x1E29FF, 0xCCCCCC, 0xC24B99, 0x6200FF, 0x1EFF69, 0xFFFF00, 0x8B4AFF, 0xFF0000,
						0x0033FF
					];
				case 15:
					colors = [
						0xC24B99, 0x00FFFF, 0x12FA05, 0xF9393F, 0xFF0000, 0x1E29FF, 0x12FA05, 0xC24B99, 0xFF8300, 0x6200FF, 0x1EFF69, 0xFFFF00, 0x8B4AFF,
						0xFF0000, 0x0033FF
					];
				case 16:
					colors = [
						0xC24B99, 0x00FFFF, 0x12FA05, 0xF9393F, 0xFF0000, 0x00FFFF, 0x12FA05, 0x1E29FF, 0x6200FF, 0xA9FF1E, 0xFF8300, 0x1EFF69, 0xFFFF00,
						0x8B4AFF, 0xFF0000, 0x0033FF
					];
				case 17:
					colors = [
						0xC24B99, 0x00FFFF, 0x12FA05, 0xF9393F, 0xC24B99, 0xFF0000, 0xCCCCCC, 0x00FFFF, 0xC24B99, 0x12FA05, 0xCCCCCC, 0x0033FF, 0xC24B99,
						0xFFFF00, 0x8B4AFF, 0xFF0000, 0x0033FF
					];
				case 18:
					colors = [
						0xC24B99, 0x00FFFF, 0x12FA05, 0xF9393F, 0xFFFF00, 0x8B4AFF, 0xFF0000, 0x0033FF, 0xCCCCCC, 0xC24B99, 0xFF0000, 0x00FFFF, 0x12FA05,
						0x0033FF, 0x8B4AFF, 0xA9FF1E, 0xFF8300, 0x1EFF69
					];
				case 19:
					colors = [
						0xC24B99, 0x00FFFF, 0x12FA05, 0xF9393F, 0xFFFF00, 0x8B4AFF, 0xFF0000, 0x0033FF, 0xFF8300, 0xC24B99, 0xA9FF1E, 0xFF0000, 0x00FFFF,
						0x12FA05, 0x0033FF, 0x8B4AFF, 0xA9FF1E, 0xFF8300, 0x1EFF69
					];
				case 20:
					colors = [
						0xC24B99, 0x00FFFF, 0x12FA05, 0xF9393F, 0xFFFF00, 0x8B4AFF, 0xFF0000, 0x0033FF, 0x8B4AFF, 0xA9FF1E, 0xFF8300, 0x12FA05, 0xFF0000,
						0x00FFFF, 0x12FA05, 0x0033FF, 0x8B4AFF, 0xA9FF1E, 0xFF8300, 0x1EFF69
					];
				case 21:
					colors = [
						0xC24B99, 0x00FFFF, 0x12FA05, 0xF9393F, 0xFFFF00, 0x8B4AFF, 0xFF0000, 0x0033FF, 0x8B4AFF, 0xA9FF1E, 0xC24B99, 0xFF8300, 0x12FA05,
						0xFF0000, 0x00FFFF, 0x12FA05, 0x0033FF, 0x8B4AFF, 0xA9FF1E, 0xFF8300, 0x1EFF69
					];
				default:
					colors = [0xC24B99, 0x00FFFF, 0x12FA05, 0xF9393F];
			}

		for (i in 0...ammo)
			add(hints[i] = createHint(i * perHintWidth, 0, perHintWidth, perHintHeight, colors[i]));

		scrollFactor.set();
	}

	/**
	 * Cleans up memory.
	 */
	override public function destroy():Void {
		super.destroy();

		for (i in 0...hints.length)
			hints[i] = FlxDestroyUtil.destroy(hints[i]);

		hints.splice(0, hints.length);
	}

	/**
	 * Creates a hint with specified properties.
	 *
	 * @param X The x position of the hint.
	 * @param Y The y position of the hint.
	 * @param Width The width of the hint.
	 * @param Height The height of the hint.
	 * @param Color The color of the hint.
	 * @return The created MobileButton representing the hint.
	 */
	private function createHint(X:Float, Y:Float, Width:Int, Height:Int, Color:Int = 0xFFFFFF):MobileButton {
		var hint:MobileButton = new MobileButton(X, Y);
		hint.loadGraphic(createHintGraphic(Width, Height, Color));

		hint._spriteLabel = new FlxSprite();
		hint.labelStatusDiff = (Options.getData("hitboxType") != "Hidden") ? guh : guh2;
		hint._spriteLabel.loadGraphic(createHintGraphic(Width, Math.floor(Height * 0.035), true));
		hint._spriteLabel.offset.y -= (hint.height - hint.label.height) / 2;

		if (Options.getData("hitboxType") != "Hidden")
		{
			var hintTween:FlxTween = null;
			var hintLaneTween:FlxTween = null;

			hint.onDown.callback = function()
			{
				if (hintTween != null)
					hintTween.cancel();

				if (hintLaneTween != null)
					hintLaneTween.cancel();

				hintTween = FlxTween.tween(hint, {alpha: guh}, guh / 100, {
					ease: FlxEase.circInOut,
					onComplete: (twn:FlxTween) -> hintTween = null
				});

				hintLaneTween = FlxTween.tween(hint._spriteLabel, {alpha: guh2}, guh / 10, {
					ease: FlxEase.circInOut,
					onComplete: (twn:FlxTween) -> hintTween = null
				});
			}

			hint.onOut.callback = hint.onUp.callback = function()
			{
				if (hintTween != null)
					hintTween.cancel();

				if (hintLaneTween != null)
					hintLaneTween.cancel();

				hintTween = FlxTween.tween(hint, {alpha: guh2}, guh / 10, {
					ease: FlxEase.circInOut,
					onComplete: (twn:FlxTween) -> hintTween = null
				});

				hintLaneTween = FlxTween.tween(hint._spriteLabel, {alpha: guh}, guh / 100, {
					ease: FlxEase.circInOut,
					onComplete: (twn:FlxTween) -> hintTween = null
				});
			}
		}

		hint.moves = hint.solid = false;
		hint.multiTouch = hint.immovable = true;
		hint.antialiasing = Options.getData("antialiasing");
		hint.scrollFactor.set();
		hint.label.alpha = hint.alpha = guh2;
		hint.canChangeLabelAlpha = false;
		hint.active = !Options.getData("botplay");
		#if FLX_DEBUG
		hint.ignoreDrawDebug = true;
		#end
		return hint;
	}

	/**
	 * Creates the graphic for a hint with specified properties.
	 *
	 * @param Width The width of the hint.
	 * @param Height The height of the hint.
	 * @param Color The color of the hint.
	 * @return The created BitmapData representing the hint graphic.
	 */
	private function createHintGraphic(Width:Int, Height:Int, Color:Int = 0xFFFFFF, ?isLane:Bool = false):BitmapData {
		var shape:Shape = new Shape();
		shape.graphics.beginFill(Color);

		if (Options.getData("hitboxType") == "No Gradient")
		{
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox(Width, Height, 0, 0, 0);

			if (isLane)
				shape.graphics.beginFill(Color);
			else
				shape.graphics.beginGradientFill(RADIAL, [Color, Color], [0, 1], [60, 255], matrix, PAD, RGB, 0);
			shape.graphics.drawRect(0, 0, Width, Height);
			shape.graphics.endFill();
		}
		else if (Options.getData("hitboxType") == "No Gradient (Old)")
		{
			shape.graphics.lineStyle(10, Color, 1);
			shape.graphics.drawRect(0, 0, Width, Height);
			shape.graphics.endFill();
		}
		else // if (Options.getData("hitboxType") == 'Gradient')
		{
			shape.graphics.lineStyle(3, Color, 1);
			shape.graphics.drawRect(0, 0, Width, Height);
			shape.graphics.lineStyle(0, 0, 0);
			shape.graphics.drawRect(3, 3, Width - 6, Height - 6);
			shape.graphics.endFill();
			if (isLane)
				shape.graphics.beginFill(Color);
			else
				shape.graphics.beginGradientFill(RADIAL, [Color, FlxColor.TRANSPARENT], [1, 0], [0, 255], null, null, null, 0.5);
			shape.graphics.drawRect(3, 3, Width - 6, Height - 6);
			shape.graphics.endFill();
		}

		var bitmap:BitmapData = new BitmapData(Width, Height, true, 0);
		bitmap.draw(shape, true);
		return bitmap;
	}
}

/*
 * Copyright (C) 2024 Mobile Porting Team
 *
 * Permission is hereby granted, free of charge, to any person obtaining a
 * copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 * DEALINGS IN THE SOFTWARE.
 */

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
 * @author Lily Ross (mcagabe19)
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
	public function new(ammo:UInt, perHintWidth:Int, perHintHeight:Int):Void {
		super();

		hints = new Array<MobileButton>();

		for (i in 0...ammo)
			add(hints[i] = createHint(i * perHintWidth, 0, perHintWidth, perHintHeight, getHintColor(ammo - 1, i)));

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

		hint.label = new FlxSprite();
		hint.labelStatusDiff = (Options.getData("hitboxType") != "Hidden") ? guh : guh2;
		hint.label.loadGraphic(createHintGraphic(Width, Math.floor(Height * 0.035), Color, true));
		hint.label.offset.y -= (hint.height - hint.label.height);

		if (Options.getData("hitboxType") != "Hidden") {
			var hintTween:FlxTween = null;
			var hintLaneTween:FlxTween = null;

			hint.onDown.callback = function() {
				if (hintTween != null)
					hintTween.cancel();

				if (hintLaneTween != null)
					hintLaneTween.cancel();

				hintTween = FlxTween.tween(hint, {alpha: guh}, guh / 100, {
					ease: FlxEase.circInOut,
					onComplete: (twn:FlxTween) -> hintTween = null
				});

				hintLaneTween = FlxTween.tween(hint.label, {alpha: guh2}, guh / 10, {
					ease: FlxEase.circInOut,
					onComplete: (twn:FlxTween) -> hintTween = null
				});
			}

			hint.onOut.callback = hint.onUp.callback = function() {
				if (hintTween != null)
					hintTween.cancel();

				if (hintLaneTween != null)
					hintLaneTween.cancel();

				hintTween = FlxTween.tween(hint, {alpha: guh2}, guh / 10, {
					ease: FlxEase.circInOut,
					onComplete: (twn:FlxTween) -> hintTween = null
				});

				hintLaneTween = FlxTween.tween(hint.label, {alpha: guh}, guh / 100, {
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

		if (Options.getData("hitboxType") == "No Gradient") {
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox(Width, Height, 0, 0, 0);

			if (isLane)
				shape.graphics.beginFill(Color);
			else
				shape.graphics.beginGradientFill(RADIAL, [Color, Color], [0, 1], [60, 255], matrix, PAD, RGB, 0);
			shape.graphics.drawRect(0, 0, Width, Height);
			shape.graphics.endFill();
		} else if (Options.getData("hitboxType") == "No Gradient (Old)") {
			shape.graphics.lineStyle(10, Color, 1);
			shape.graphics.drawRect(0, 0, Width, Height);
			shape.graphics.endFill();
		} else { // if (Options.getData("hitboxType") == 'Gradient')
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

	private function getHintColor(ammo:Int, currentAmmo:Int):FlxColor
	{
		var blah:Array<Int> = shaders.NoteColors.getNoteColor(utilities.NoteVariables.animationDirections[ammo][currentAmmo]);
		return FlxColor.fromRGB(blah[0], blah[1], blah[2]);
	}
}

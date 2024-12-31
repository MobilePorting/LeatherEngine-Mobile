/*
 * Copyright (C) 2025 Mobile Porting Team
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

package mobile.substates;

import flixel.math.FlxMath;
import game.Conductor;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxSprite;

class MobileControlsAlphaMenu extends substates.MusicBeatSubstate {
	var opacityValue:Float = 0.0;
	var offsetText:FlxText = new FlxText(0, 0, 0, "Alpha: 0", 64).setFormat(Paths.font("vcr.ttf"), 64, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BLACK);

	public function new() {
		super();

		opacityValue = Options.getData("mobileCAlpha");

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.alpha = 0;
		bg.scrollFactor.set();
		add(bg);

		FlxTween.tween(bg, {alpha: 0.5}, 1, {ease: FlxEase.circOut, startDelay: 0});

		offsetText.text = "Opacity: " + opacityValue;
		offsetText.screenCenter();
		add(offsetText);

		addVirtualPad(LEFT_RIGHT, B);
	}

	override function update(elapsed:Float) {
		super.update(elapsed);

		var leftP = controls.LEFT_P;
		var rightP = controls.RIGHT_P;

		var back = controls.BACK;

		if (back) {
			Options.setData(opacityValue, "mobileCAlpha");
			states.OptionsMenu.instance.closeSubState();
			removeVirtualPad();
		}

		if (leftP)
			opacityValue -= 0.1;
		if (rightP)
			opacityValue += 0.1;

		virtualPad.alpha = 0;
		opacityValue = virtualPad.alpha = FlxMath.roundDecimal(opacityValue, 1);

		if (opacityValue > 1)
			opacityValue = 1;

		if (opacityValue < 0)
			opacityValue = 0;

		offsetText.text = "Opacity: " + opacityValue;
		offsetText.screenCenter();
	}
}

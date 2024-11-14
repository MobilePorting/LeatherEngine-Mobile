/*
 * Copyright (C) 2024 Mobile Porting Team
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see <https://www.gnu.org/licenses/>.
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

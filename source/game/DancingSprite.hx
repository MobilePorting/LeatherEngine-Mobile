package game;

import flixel.FlxSprite;

class DancingSprite extends FlxSprite {
	var dancingRight:Bool = false;
	var oneDanceAnimation:Bool = false;

	public function new(x:Float, y:Float, ?oneDanceAnimation:Bool = false, ?antialiasing:Bool = true) {
		super(x, y);

		this.antialiasing = antialiasing;
		this.oneDanceAnimation = oneDanceAnimation;
	}

	public function dance(?altAnim:String = ''):Void {
		if (!oneDanceAnimation) {
			dancingRight = !dancingRight;

			if (dancingRight)
				animation.play('danceRight' + altAnim, true);
			else
				animation.play('danceLeft' + altAnim, true);
		} else
			animation.play('dance' + altAnim, true);
	}
}
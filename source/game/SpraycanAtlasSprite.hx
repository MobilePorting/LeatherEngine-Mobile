// fuck you hscript
package game;

import states.PlayState;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import game.FlxAtlasSprite;

class SpraycanAtlasSprite extends FlxAtlasSprite {
	public var STATE_ARCING:Int = 2; // In the air.
	public var STATE_SHOT:Int = 3; // Hit by the player.
	public var STATE_IMPACTED:Int = 4; // Impacted the player.

	public var currentState:Int = 2;

	override public function new(x:Float, y:Float) {
		super(x, y, Paths.getTextureAtlas('streets/spraycanAtlas', 'stages'), {
			FrameRate: 24.0,
			Reversed: false,
			// ?OnComplete:Void -> Void,
			ShowPivot: false,
			Antialiasing: Options.getData("antialiasing"),
			ScrollFactor: new FlxPoint(1, 1),
		});
		onAnimationFinish.add(finishCanAnimation);
	}

	public function finishCanAnimation(name:String) {
		switch (name) {
			case 'Can Start':
				playHitPico();
			case 'Can Shot':
				this.kill();
			case 'Hit Pico':
				playHitExplosion();
				this.kill();
		}
	}

	public function playHitExplosion():Void {
		var explodeEZ:FlxSprite = new FlxSprite(this.x + 1050, this.y + 150);
		explodeEZ.frames = Paths.getSparrowAtlas('streets/spraypaintExplosionEZ', 'stages');
		explodeEZ.animation.addByPrefix("idle", "explosion round 1 short0", 24, false);
		explodeEZ.animation.play("idle");

		PlayState.instance.stage.add(explodeEZ);
		explodeEZ.animation.onFinish.add((name:String) -> {
			explodeEZ.kill();
		});
	}

	public function playCanStart():Void {
		this.playAnimation('Can Start');
	}

	public function playCanShot():Void {
		this.playAnimation('Can Shot');
	}

	public function playHitPico():Void {
		this.playAnimation('Hit Pico');
	}
}

package substates;

import flixel.sound.FlxSound;
import game.FlxAtlasSprite;
import lime.utils.Assets;
import game.Character;
import states.FreeplayState;
import states.StoryMenuState;
import game.Conductor;
import states.PlayState;
import game.Boyfriend;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSubState;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import states.LoadingState;

class GameOverSubstate extends MusicBeatSubstate {
	public var bf:Character;
	public var camFollow:FlxObject;

	public static var instance:GameOverSubstate = null;

	public function new(x:Float, y:Float) {
		instance = this;
		super();
		PlayState.playCutscenes = true;
		FlxG.camera.bgColor = FlxColor.BLACK;

		FlxG.camera.scroll.set();
		FlxG.camera.target = null;

		if (Options.getData("quickRestart")) {
			PlayState.instance.call("onRetry", []);
			PlayState.SONG.speed = PlayState.previousScrollSpeed;
			FlxG.resetState();
		}

		Conductor.songPosition = 0;

		bf = new Boyfriend(x, y, PlayState.boyfriend.deathCharacter, true);
		bf.x += bf.positioningOffset[0];
		bf.y += bf.positioningOffset[1];
		add(bf);

		camFollow = new FlxObject(bf.getGraphicMidpoint().x + bf.cameraOffset[0], bf.getGraphicMidpoint().y + bf.cameraOffset[1], 1, 1);
		add(camFollow);

		if (FlxG.sound.music.active)
			FlxG.sound.music.stop();

		bfDies();

		addVirtualPad(NONE, A_B);
		addVirtualPadCamera();
	}

	function bfDies() {
		var soundPath = Paths.sound("deaths/bf-dead/death");
		bf.visible = true;
		if (Assets.exists(Paths.sound("deaths/" + bf.curCharacter + "/death")))
			soundPath = Paths.sound("deaths/" + bf.curCharacter + "/death");

		FlxG.sound.play(soundPath);

		Conductor.changeBPM(100);
		bf.playAnim('firstDeath', true);
	}

	override function update(elapsed:Float) {
		super.update(elapsed);

		if (controls.ACCEPT) {
			endBullshit();
		}

		if (controls.BACK) {
			FlxG.sound.music.stop();

			if (PlayState.isStoryMode)
				FlxG.switchState(() -> new StoryMenuState());
			else
				FlxG.switchState(() -> new FreeplayState());
		}

		if (bf.animation.curAnim.name == 'firstDeath' && bf.animation.curAnim.curFrame == 12)
			FlxG.camera.follow(camFollow, LOCKON, 0.01);

		if (bf.animation.curAnim.name == 'firstDeath' && bf.animation.curAnim.finished) {
			var soundPath = Paths.music("deaths/bf-dead/loop");

			if (Assets.exists(Paths.music("deaths/" + bf.curCharacter + "/loop")))
				soundPath = Paths.music("deaths/" + bf.curCharacter + "/loop");

			FlxG.sound.playMusic(soundPath);
			PlayState.instance.call("onDeathLoop", []);
		}

		if (FlxG.sound.music.playing) {
			Conductor.songPosition = FlxG.sound.music.time;
		}

		#if (flixel < "6.0.0")
		FlxG.camera.followLerp = elapsed * 0.6;
		#end
	}

	var isEnding:Bool = false;

	function endBullshit():Void {
		if (!isEnding) {
			PlayState.instance.call("onRetry", []);
			isEnding = true;
			bf.playAnim('deathConfirm', true);
			FlxG.sound.music.stop();

			var soundPath = Paths.music("deaths/bf-dead/retry");

			if (Assets.exists(Paths.music("deaths/" + bf.curCharacter + "/retry")))
				soundPath = Paths.music("deaths/" + bf.curCharacter + "/retry");

			FlxG.sound.play(soundPath);
			new FlxTimer().start(0.7, function(tmr:FlxTimer) {
				if (controls.mobileC) FlxTween.tween(virtualPad, {alpha: 0}, 2.7, {ease: FlxEase.smootherStepOut});
				FlxG.camera.fade(FlxColor.BLACK, 2, false, function() {
					PlayState.SONG.speed = PlayState.previousScrollSpeed;
					FlxG.resetState();
				});
			});
		}
	}
}

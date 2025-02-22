package ui;

import macros.GithubCommitHash;
import flixel.util.FlxStringUtil;
import flixel.FlxG;
import openfl.utils.Assets;
import openfl.text.TextField;
import openfl.text.TextFormat;
import external.memory.Memory;
import macros.GithubCommitHash;
import haxe.macro.Compiler;

/**
 * Shows basic info about the game.
 */
class SimpleInfoDisplay extends TextField {
	//                                      fps    mem   version console info
	public var infoDisplayed:Array<Bool> = [false, false, false, false];

	public var framerate:Int = 0;

	private var framerateTimer:Float = 0.0;
	private var framesCounted:Int = 0;

	public var version:String = CoolUtil.getCurrentVersion();

	public function new(x:Float = 10.0, y:Float = 10.0, color:Int = 0x000000, ?font:String) {
		super();

		positionFPS(x, y);
		selectable = false;
		defaultTextFormat = new TextFormat(font ?? Assets.getFont(Paths.font("vcr.ttf")).fontName, (font == "_sans" ? 12 : 14), color);

		FlxG.signals.postDraw.add(update);

		width = FlxG.width;
		height = FlxG.height;
	}

	public function update():Void {
		framerateTimer += FlxG.elapsed;

		if (framerateTimer >= 1) {
			framerateTimer = 0;

			framerate = framesCounted;
			framesCounted = 0;
		}

		framesCounted++;

		if (!visible) {
			return;
		}

		text = '';
		for (i in 0...infoDisplayed.length) {
			if (!infoDisplayed[i]) {
				continue;
			}

			switch (i) {
				case 0: // FPS
					text += '${framerate}fps\n';
				case 1: // Memory
					text += '${FlxStringUtil.formatBytes(Memory.getCurrentUsage())} / ${FlxStringUtil.formatBytes(Memory.getPeakUsage())}\n';
				case 2: // Version
					text += '$version\n';
				case 3: // Console
					text += Main.logsOverlay.logs.length > 0 ? '${Main.logsOverlay.logs.length} traced lines. F3 to view.\n' : '';
				case 4:
					text += 'Commit ${GithubCommitHash.getGitCommitHash().substring(0, 7)}';
			}
		}
	}

	public inline function positionFPS(X:Float, Y:Float, ?scale:Float = 1){
		scaleX = scaleY = #if android (scale > 1 ? scale : 1) #else (scale < 1 ? scale : 1) #end;
		x = FlxG.game.x + X;
		y = FlxG.game.y + Y;
	}
}
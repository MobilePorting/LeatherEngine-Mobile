package ui;

import haxe.Json;
import lime.utils.Assets;

class HealthIcon extends TrackerSprite {
	public var isPlayer:Bool = false;

	public var animatedIcon:Bool = false;

	public var offsetX:Float = 0.0;
	public var offsetY:Float = 0.0;

	public var startSize:Float = 1;

	public var char:String = "bf";

	public function new(char:String = 'bf', isPlayer:Bool = false) {
		super(null, 10, -30, RIGHT);

		this.isPlayer = isPlayer;

		// plays anim lol
		setupIcon(this.char = char);
		scrollFactor.set();
	}

	public function setupIcon(char:String = 'placeholder') {
		antialiasing = Options.getData("antialiasing");
		var iconPath:String = 'placeholder-icons';
		var iconConfig:HealthIconConfig = {
			offset: [0, 0],
			scale: 1,
			fps: 24,
			antialiasing: true
		};
		for (path in ['$char-icons', 'icon-$char', char]) {
			if (Assets.exists(Paths.image('icons/$path'))) {
				iconPath = path;
				break;
			}
		}

		if (Assets.exists('assets/images/icons/$iconPath.json')) {
			iconConfig = cast Json.parse(Assets.getText('assets/images/icons/$iconPath.json'));
		} else if (Assets.exists('assets/images/icons/$iconPath.txt')) {
			var textArray:Array<String> = Assets.getText('assets/images/icons/$iconPath.txt').split(" ");
			iconConfig.offset = [Std.parseFloat(textArray[0]), Std.parseFloat(textArray[1])];
			iconConfig.scale = Std.parseFloat(textArray[2]);
		}

		animatedIcon = Assets.exists('assets/images/icons/$iconPath.xml');
		if (animatedIcon) {
			frames = Paths.getSparrowAtlas('icons/$iconPath');
			animation.addByPrefix('neutral', '${char}0', iconConfig.fps, true, isPlayer);
			animation.addByPrefix('lose', '${char}-lose0', iconConfig.fps, true, isPlayer);
			animation.addByPrefix('win', '${char}-win0', iconConfig.fps, true, isPlayer);
		} else {
			loadGraphic(Paths.gpuBitmap('icons/$iconPath'), true, 150, 150);
			animation.add('neutral', [0], 0, false, isPlayer);
			animation.add('lose', [1], 0, false, isPlayer);
			animation.add('win', [2], 0, false, isPlayer);
		}
		animation.play('neutral');

		scale.set(iconConfig.scale, iconConfig.scale);
		offsetX = iconConfig.offset[0];
		offsetY = iconConfig.offset[1];
		antialiasing = (iconConfig.antialiasing || !char.endsWith('-pixel'));
		startSize = scale.x;
		updateHitbox();
		centerOffsets();
		centerOrigin();
	}
}

typedef HealthIconConfig = {
	var offset:Array<Float>;
	var scale:Float;
	var fps:Int;
	var antialiasing:Bool;
}

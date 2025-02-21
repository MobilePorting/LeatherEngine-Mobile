package ui;

import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.addons.display.FlxExtendedMouseSprite;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxColor;
import game.Boyfriend;
import game.Conductor;
import game.Character;
import game.SongLoader;
import game.StageGroup;
import game.StrumNote;
import game.TimeBar;
import states.MusicBeatState;
import states.OptionsMenu;
import ui.HealthIcon;
#if DISCORD_ALLOWED
import utilities.DiscordClient;
#end

class HUDAdjustment extends MusicBeatState {
	/**
	 * The stage.
	 */
	public var stage:StageGroup;

	/**
	 * The player character.
	 */
	public var bf:Boyfriend;

	/**
	 * The gf character.
	 */
	public var gf:Character;

	/**
	 * The opponent character.
	 */
	public var dad:Character;

	/**
		`FlxCamera` for the ratings and ui.
	**/
	public var hud:FlxCamera;

	/**
		`FlxCamera` for info ui.
	**/
	public var info:FlxCamera;

	public var rating:FlxExtendedMouseSprite;

	public var accuracyText:FlxExtendedMouseSprite;

	public var combo:FlxExtendedMouseSprite;

	private var _accuracyText:FlxText;

	public var uiSettings:Array<String> = [];

	public var maniaSize:Array<String> = [];

	public var initRatingX:Float = 0;

	public var initRatingY:Float = 0;

	public var initAccuracyTextX:Float = 0;

	public var initAccuracyTextY:Float = 0;

	public var initComboX:Float = 0;

	public var initComboY:Float = 0;

	public var initRatingTextX:Float = 0;

	public var initRatingTextY:Float = 0;

	public var timeBar:TimeBar;

	/**
		Background sprite for the health bar.
	**/
	public var healthBarBG:FlxSprite;

	/**
		The health bar.
	**/
	public var healthBar:FlxBar;

	/**
		`FlxTypedGroup` of all current strums.
	**/
	public var strums:FlxTypedGroup<StrumNote>;

	/**
		Current `health` being shown on the `healthBar`.
	**/
	public var healthShown:Float = 1;

	/**
		The icon for the player character (`bf`).
	**/
	public var iconP1:HealthIcon;

	/**
		The icon for the opponent character (`dad`).
	**/
	public var iconP2:HealthIcon;

	private var _ratingText:FlxText;

	/**
		Current text that displays your ratings (plus misses and MA/PA).
	**/
	public var ratingText:FlxExtendedMouseSprite;

	public var offsets:FlxText;

	public var guide:FlxText;


	override function create() {
		super.create();

		FlxG.mouse.visible = true;

		#if DISCORD_ALLOWED
		DiscordClient.changePresence("Changing HUD Settings", null, null, true);
		#end

		hud = new FlxCamera();
		FlxG.cameras.add(hud, false); // false so it's not a default camera

		hud.bgColor.alpha = 0;

		gf = new Character(400, 130, "gf");
		bf = new Boyfriend(770, 450, "bf");
		dad = new Character(100, 100, "dad");
		stage = new StageGroup('stage');
		add(stage);

		// FlxG.camera.zoom = stage.camZoom;

		if (gf.otherCharacters != null) {
			for (character in gf.otherCharacters) {
				add(character);
			}
		} else
			add(gf);
		if (bf.otherCharacters != null) {
			for (character in bf.otherCharacters) {
				add(character);
			}
		} else
			add(bf);

		if (dad.otherCharacters != null) {
			for (character in dad.otherCharacters) {
				add(character);
			}
		} else
			add(dad);

		stage.setCharOffsets(bf, gf, dad);

		uiSettings = CoolUtil.coolTextFile(Paths.txt("ui skins/" + Options.getData("uiSkin") + "/config"));
		maniaSize = CoolUtil.coolTextFile(Paths.txt("ui skins/" + Options.getData("uiSkin") + "/maniasize"));

		rating = new FlxExtendedMouseSprite();
		rating.loadGraphic((Paths.gpuBitmap("ui skins/" + Options.getData("uiSkin") + "/ratings/sick")));
		rating.screenCenter();
		initRatingX = rating.x -= (Options.getData("middlescroll") ? 350 : (Options.getData("playAs") == 0 ? 0 : -150));
		initRatingY = rating.y -= 60;
		rating.camera = hud;
		rating.setGraphicSize(rating.width * Std.parseFloat(uiSettings[0]) * Std.parseFloat(uiSettings[4]));
		rating.antialiasing = uiSettings[3] == "true";
		rating.updateHitbox();
		rating.draggable = true;

		accuracyText = new FlxExtendedMouseSprite();
		accuracyText.x = initAccuracyTextX = initRatingX;
		accuracyText.y = initAccuracyTextY = initRatingY + 100;
		accuracyText.camera = hud;
		accuracyText.antialiasing = uiSettings[3] == "true";
		accuracyText.draggable = true;

		_accuracyText = new FlxText();
		final ms:Float = FlxMath.roundDecimal(FlxG.random.float(-166, 166), 2);
		_accuracyText.text = ms + " ms" + (Options.getData("botplay") ? " (BOT)" : "");
		_accuracyText.borderStyle = FlxTextBorderStyle.OUTLINE_FAST;
		_accuracyText.borderSize = 1;
		_accuracyText.size = 24;
		_accuracyText.font = Paths.font("vcr.ttf");
		_accuracyText.camera = hud;
		_accuracyText.antialiasing = uiSettings[3] == "true";
		accuracyText.makeGraphic(Math.ceil(_accuracyText.width), Math.ceil(_accuracyText.height), FlxColor.TRANSPARENT);
		if (ms == 0)
			_accuracyText.color = FlxColor.PINK;
		else if (Math.abs(ms) == ms)
			_accuracyText.color = FlxColor.CYAN;
		else
			_accuracyText.color = 0xFF8800;
		_accuracyText.updateHitbox();

		combo = new FlxExtendedMouseSprite();
		combo.loadGraphic((Paths.gpuBitmap("ui skins/" + Options.getData("uiSkin") + "/numbers/num" + FlxG.random.int(0, 9))));
		combo.screenCenter();
		initComboX = combo.x -= (Options.getData("middlescroll") ? 350 : (Options.getData("playAs") == 0 ? 0 : -150)) + 90;
		initComboY = combo.y += 80;
		combo.camera = hud;
		combo.setGraphicSize(combo.width * Std.parseFloat(uiSettings[1]));
		combo.antialiasing = uiSettings[3] == "true";
		combo.updateHitbox();
		combo.draggable = true;

		rating.x += Options.getData("ratingsOffset")[0];
		rating.y += Options.getData("ratingsOffset")[1];
		accuracyText.x += Options.getData("accuracyTextOffset")[0];
		accuracyText.y += Options.getData("accuracyTextOffset")[1];
		combo.x += Options.getData("comboOffset")[0];
		combo.y += Options.getData("comboOffset")[1];

		add(rating);
		add(accuracyText);
		add(combo);

		strums = new FlxTypedGroup<StrumNote>();
		strums.camera = hud;
		add(strums);
		if (Options.getData("middlescroll")) {
			generateStaticArrows(50);
			generateStaticArrows(0.5);
		} else {
			generateStaticArrows(0);
			generateStaticArrows(1);
		}

		healthBarBG = new FlxSprite(0,
			Options.getData("downscroll") ? 60 : FlxG.height * 0.9).loadGraphic(Paths.gpuBitmap('ui skins/' + Options.getData("uiSkin") + '/other/healthBar'));
		healthBarBG.screenCenter(X);
		healthBarBG.scrollFactor.set();
		healthBarBG.pixelPerfectPosition = true;
		healthBarBG.camera = hud;
		add(healthBarBG);

		healthBar = new FlxBar(healthBarBG.x + 4, healthBarBG.y + 4, RIGHT_TO_LEFT, Std.int(healthBarBG.width - 8), Std.int(healthBarBG.height - 8), this,
			'healthShown', 0, 2);
		healthBar.scrollFactor.set();
		healthBar.createFilledBar(dad.barColor, bf.barColor);
		healthBar.pixelPerfectPosition = true;
		healthBar.camera = hud;
		add(healthBar);


		iconP1 = new HealthIcon(bf.icon, true);
		iconP1.y = healthBar.y - (iconP1.height / 2) - iconP1.offsetY;
		iconP1.camera = hud;
		add(iconP1);

		iconP2 = new HealthIcon(dad.icon, false);
		iconP2.y = healthBar.y - (iconP2.height / 2) - iconP2.offsetY;
		iconP2.visible = iconP1.visible = Options.getData("healthIcons");
		iconP2.camera = hud;
		add(iconP2);

		iconP1.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(50, 0, 100, 100, 0) * 0.01) - 26) - iconP1.offsetX;
		iconP2.x = healthBar.x
			+ (healthBar.width * (FlxMath.remapToRange(50, 0, 100, 100, 0) * 0.01))
			- (iconP2.width - 26)
			- iconP2.offsetX;

		timeBar = new TimeBar(SongLoader.loadFromJson('normal', 'bopeebo'), 'NORMAL');
		timeBar.camera = hud;
		timeBar.bar.color = dad.barColor;
		add(timeBar);

		_ratingText = new FlxText(4, 0, 0, get_ratingText());
		_ratingText.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE_FAST, FlxColor.BLACK);
		_ratingText.alignment = Options.getData("ratingTextAlign");
		_ratingText.camera = hud;
		_ratingText.screenCenter(Y);
		
		ratingText = new FlxExtendedMouseSprite(_ratingText.x, _ratingText.y);
		ratingText.makeGraphic(Math.ceil(_ratingText.width), Math.ceil(_ratingText.height), FlxColor.TRANSPARENT);
		ratingText.camera = hud;
		ratingText.draggable = true;
		add(ratingText);

		initRatingTextX = _ratingText.x;
		initRatingTextY = _ratingText.y;

		_ratingText.x += Options.getData("ratingTextOffset")[0];
		_ratingText.y += Options.getData("ratingTextOffset")[1];

		info = new FlxCamera();
		info.bgColor = FlxColor.TRANSPARENT;
		FlxG.cameras.add(info, false);
		offsets = new FlxText(0, 4, 0, "bruh");
		offsets.borderStyle = OUTLINE_FAST;
		offsets.borderSize = 1;
		offsets.size = 24;
		offsets.font = Paths.font("vcr.ttf");
		offsets.camera = info;
		offsets.alignment = RIGHT;
		add(offsets);
		
		final escape:String = controls.mobileC ? 'B' : 'ESCAPE';
		final space:String = controls.mobileC ? 'C' : 'SPACE';

		guide = new FlxText(0, 0, 0, "Press " + escape + " to exit and save.\nPress " + space +" to reset to defaults.");
		guide.borderStyle = OUTLINE_FAST;
		guide.borderSize = 1;
		guide.size = 24;
		guide.font = Paths.font("vcr.ttf");
		guide.camera = info;
		guide.alignment = RIGHT;
		guide.x = FlxG.width - guide.width - 4;
		guide.y = FlxG.height - guide.height - 4;
		add(guide);

		addVirtualPad(NONE, B_C);
	}

	public function get_ratingText():String {
		var ratingArray:Array<Int> = [
			FlxG.random.int(0, 999),
			FlxG.random.int(0, 999),
			FlxG.random.int(0, 999),
			FlxG.random.int(0, 999),
			FlxG.random.int(0, 999)
		];

		var MA:Int = FlxG.random.int(1, 69);
		var PA:Int = FlxG.random.int(1, 69);

		return ((Options.getData("marvelousRatings") ? "Marvelous: " + Std.string(ratingArray[0]) + "\n" : "")
			+ "Sick: "
			+ Std.string(ratingArray[1])
			+ "\n"
			+ "Good: "
			+ Std.string(ratingArray[2])
			+ "\n"
			+ "Bad: "
			+ Std.string(ratingArray[3])
			+ "\n"
			+ "Shit: "
			+ Std.string(ratingArray[4])
			+ "\n"
			+ "Misses: "
			+ FlxG.random.int(0, 69)
			+ "\n"
			+ (Options.getData("marvelousRatings")
				&& ratingArray[0] > 0
				&& MA > 0 ? "MA: " + Std.string(FlxMath.roundDecimal(ratingArray[0] / MA, 2)) + "\n" : "")
			+ (ratingArray[1] > 0
				&& PA > 0 ? "PA: " + Std.string(FlxMath.roundDecimal((ratingArray[1] + ratingArray[0]) / PA, 2)) + "\n" : ""));
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);

		if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;

		if (virtualPad.buttonB.justPressed || FlxG.keys.justPressed.ESCAPE) {
			Options.setData([Math.round(rating.x - initRatingX), Math.round(rating.y - initRatingY)], "ratingsOffset");
			Options.setData([
				Math.round(accuracyText.x - initAccuracyTextX),
				Math.round(accuracyText.y - initAccuracyTextY)
			], "accuracyTextOffset");
			Options.setData([Math.round(combo.x - initComboX), Math.round(combo.y - initComboY)], "comboOffset");
			Options.setData([
				Math.round(_ratingText.x - initRatingTextX),
				Math.round(_ratingText.y - initRatingTextY)
			], "ratingTextOffset");
			Options.setData(_ratingText.alignment, "ratingTextAlign");
			FlxG.switchState((Main.previousState is substates.PauseSubState.PauseOptions ? substates.PauseSubState.PauseOptions.new : OptionsMenu.new));
		}
		if (virtualPad.buttonC.justPressed || FlxG.keys.justPressed.SPACE) {
			Options.setData([0, 0], "ratingsOffset");
			Options.setData([0, 0], "accuracyTextOffset");
			Options.setData([0, 0], "comboOffset");
			Options.setData([0, 0], "ratingTextOffset");
			Options.setData(LEFT, "ratingTextAlign");
			FlxG.resetState();
		}

		if (!ratingText.isDragged) {
			if (ratingText.x <= (FlxG.width / 2) - ratingText.width / 2) {
				ratingText.x = FlxMath.lerp(ratingText.x, 4, elapsed * 10);
				_ratingText.alignment = LEFT;
			} else {
				ratingText.x = FlxMath.lerp(ratingText.x, FlxG.width - ratingText.width - 4, elapsed * 10);
				_ratingText.alignment = RIGHT;
			}
		}

		_accuracyText.x = accuracyText.x;
		_accuracyText.y = accuracyText.y;
		accuracyText.update(elapsed);

		_ratingText.x = ratingText.x;
		_ratingText.y = ratingText.y;
		ratingText.update(elapsed);

		offsets.text = 'Rating offset: ${[Math.round(rating.x - initRatingX), Math.round(rating.y - initRatingY)]}\n'
			+ 'Accuracy offset: ${[Math.round(accuracyText.x - initAccuracyTextX), Math.round(accuracyText.y - initAccuracyTextY)]}\n'
			+ 'Combo offset: ${[Math.round(combo.x - initComboX), Math.round(combo.y - initComboY)]}\n'
			+ 'Info Text offset: ${[Math.round(_ratingText.x - initRatingTextX), Math.round(_ratingText.y - initRatingTextY)]}';
		offsets.x = FlxG.width - offsets.width - 4;
	}

	override public function draw() {
		_accuracyText.draw();
		_ratingText.draw();
		super.draw();
	}

	override public function beatHit() {
		super.beatHit();
		if (dad.otherCharacters == null) {
			dad.dance();
		} else {
			for (character in dad.otherCharacters) {
				character.dance();
			}
		}

		if (bf.otherCharacters == null) {
			bf.dance();
		} else {
			for (character in bf.otherCharacters) {
				character.dance();
			}
		}

		if (gf.otherCharacters == null) {
			gf.dance();
		} else {
			for (character in gf.otherCharacters) {
				character.dance();
			}
		}
	}

	public function generateStaticArrows(pos:Float):Void {
		var usedKeyCount:Int = 4;
		var strumY:Int = Options.getData("downscroll") ? FlxG.height - 100 : 100;
		for (i in 0...usedKeyCount) {
			var babyArrow:StrumNote = new StrumNote(0, strumY, i, Options.getData("uiSkin"), uiSettings, maniaSize, usedKeyCount, pos);
			babyArrow.scrollFactor.set();
			babyArrow.x += (babyArrow.width
				+ (2
					+ Std.parseFloat(CoolUtil.coolTextFile(Paths.txt("ui skins/" + Options.getData("uiSkin") + "/maniagap"))[usedKeyCount - 1]))) * Math.abs(i)
				+ Std.parseFloat(CoolUtil.coolTextFile(Paths.txt("ui skins/" + Options.getData("uiSkin") + "/maniaoffset"))[usedKeyCount - 1]);
			babyArrow.y = strumY - (babyArrow.height / 2);
			babyArrow.y -= 10;
			babyArrow.alpha = 0;
			FlxTween.tween(babyArrow, {y: babyArrow.y + 10, alpha: 1}, 1, {ease: FlxEase.circOut, startDelay: 0.5 + (0.2 * i)});

			babyArrow.ID = i;
			strums.add(babyArrow);

			babyArrow.x += 100 - ((usedKeyCount - 4) * 16) + (usedKeyCount >= 10 ? 30 : 0);
			babyArrow.x += ((FlxG.width / 2) * pos);
		}
	}
}

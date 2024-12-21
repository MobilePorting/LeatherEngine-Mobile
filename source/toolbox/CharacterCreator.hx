package toolbox;

#if DISCORD_ALLOWED
import utilities.Discord.DiscordClient;
#end
import game.StageGroup;
import flixel.ui.FlxButton;
import openfl.events.IOErrorEvent;
import openfl.events.Event;
import openfl.net.FileReference;
import ui.FlxScrollableDropDownMenu;
import states.MusicBeatState;
import states.MainMenuState;
import states.PlayState;
import game.Character;
import flixel.addons.ui.FlxUIDropDownMenu;
import flixel.FlxG;
import flixel.FlxCamera;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxGridOverlay;
import flixel.text.FlxText;
import flixel.util.FlxColor;

using StringTools;

/**
 * DEBUG MODE
 */
@:publicFields
class CharacterCreator extends MusicBeatState {
	var char:Character;
	var ghost:Character;
	var animText:FlxText;
	var moveText:FlxText;
	var animList:Array<String> = [];
	var curAnim:Int = 0;
	var daAnim:String = 'spooky';
	var camFollow:FlxObject;
	var _file:FileReference;

	public function new(daAnim:String = 'spooky', selectedStage:String) {
		super();
		this.daAnim = daAnim;
		stages = CoolUtil.coolTextFile(Paths.txt('stageList'));

		if (selectedStage != null)
			stage_Name = selectedStage;
	}

	var characters:Map<String, Array<String>> = ["default" => ["bf", "gf"]];

	var modListLmao:Array<String> = ["default"];
	var curCharList:Array<String>;

	var offset_Button:FlxButton;
	var charDropDown:FlxScrollableDropDownMenu;
	var modDropDown:FlxScrollableDropDownMenu;
	var ghostAnimDropDown:FlxScrollableDropDownMenu;

	var gridBG:FlxSprite;

	/* CAMERA */
	var gridCam:FlxCamera;
	var charCam:FlxCamera;
	var camHUD:FlxCamera;

	/*STAGE*/
	var stage:StageGroup;
	var stagePosition:FlxSprite;

	public var stages:Array<String>;
	public var stage_Name:String = 'stage';
	public var stageData:StageData;

	var stage_Dropdown:FlxScrollableDropDownMenu;
	var objects:Array<Array<Dynamic>> = [];

	public static var lastState:String = "OptionsMenu";

	override function create() {
		#if DISCORD_ALLOWED
		DiscordClient.changePresence("Creating A Character", null, null, true);
		#end
		FlxG.mouse.visible = true;

		gridCam = new FlxCamera();
		charCam = new FlxCamera();
		charCam.bgColor.alpha = 0;
		camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;

		FlxG.cameras.reset();
		FlxG.cameras.add(gridCam, false);
		FlxG.cameras.add(charCam, true);
		FlxG.cameras.add(camHUD, false);

		FlxG.cameras.setDefaultDrawTarget(charCam, true);

		FlxG.camera = charCam;

		if (FlxG.sound.music != null && FlxG.sound.music.active)
			FlxG.sound.music.stop();

		gridBG = FlxGridOverlay.create(10, 10);
		gridBG.scrollFactor.set(0, 0);
		gridBG.cameras = [gridCam];
		add(gridBG);

		stagePosition = new FlxSprite().makeGraphic(32, 32, 0xFFFF0000);
		add(stagePosition);

		ghost = new Character(0, 0, daAnim);
		ghost.debugMode = true;
		ghost.color = FlxColor.BLACK;
		ghost.alpha = 0.5;

		char = new Character(0, 0, daAnim);
		char.debugMode = true;

		reloadStage();
		add(ghost);
		add(char);
		animText = new FlxText(4, 4, 0, "BRUH BRUH BRUH: [0,0]", 20);
		animText.font = Paths.font("vcr.ttf");
		animText.scrollFactor.set();
		animText.color = FlxColor.WHITE;
		animText.borderColor = FlxColor.BLACK;
		animText.borderStyle = OUTLINE;
		animText.borderSize = 2;
		animText.cameras = [camHUD];
		add(animText);

		moveText = new FlxText(4, 4, 0, "", 20);
		moveText.font = Paths.font("vcr.ttf");
		moveText.x = FlxG.width - moveText.width - 4;
		moveText.scrollFactor.set();
		moveText.color = FlxColor.WHITE;
		moveText.borderColor = FlxColor.BLACK;
		moveText.borderStyle = OUTLINE;
		moveText.borderSize = 2;
		moveText.alignment = RIGHT;
		moveText.cameras = [camHUD];
		add(moveText);

		genBoyOffsets();

		camFollow = new FlxObject(0, 0, 2, 2);
		camFollow.screenCenter();
		add(camFollow);

		FlxG.sound.playMusic(Paths.music('breakfast'));

		charCam.follow(camFollow);

		var characterData:Array<String> = CoolUtil.coolTextFile(Paths.txt('characterList'));
		var position = stage.getCharacterPos(char.isPlayer ? 0 : 1, char);
		char.setPosition(position[0], position[1]);
		ghost.setPosition(position[0], position[1]);

		if (char.isPlayer)
			stagePosition.setPosition(stage.player_1_Point.x, stage.player_1_Point.y);
		else
			stagePosition.setPosition(stage.player_2_Point.x, stage.player_2_Point.y);

		for (item in characterData) {
			var characterDataVal:Array<String> = item.split(":");

			var charName:String = characterDataVal[0];
			var charMod:String = characterDataVal[1];

			var charsLmao:Array<String> = [];

			if (characters.exists(charMod))
				charsLmao = characters.get(charMod);
			else
				modListLmao.push(charMod);

			charsLmao.push(charName);
			characters.set(charMod, charsLmao);
		}

		curCharList = characters.get("default");

		charDropDown = new FlxScrollableDropDownMenu(10, 500, FlxUIDropDownMenu.makeStrIdLabelArray(curCharList, true), function(character:String) {
			remove(char);
			char.kill();
			char.destroy();

			remove(ghost);
			ghost.kill();
			ghost.destroy();

			daAnim = curCharList[Std.parseInt(character)];

			ghost = new Character(0, 0, daAnim);
			ghost.debugMode = true;
			ghost.color = FlxColor.BLACK;
			ghost.alpha = 0.5;
			add(ghost);

			char = new Character(0, 0, daAnim);
			char.debugMode = true;
			add(char);

			var position = stage.getCharacterPos(char.isPlayer ? 0 : 1, char);
			char.setPosition(position[0], position[1]);
			ghost.setPosition(position[0], position[1]);

			if (char.isPlayer)
				stagePosition.setPosition(stage.player_1_Point.x, stage.player_1_Point.y);
			else
				stagePosition.setPosition(stage.player_2_Point.x, stage.player_2_Point.y);

			animList = [];
			genBoyOffsets(true);
			remove(ghostAnimDropDown);
			ghostAnimDropDown.kill();
			ghostAnimDropDown.destroy();
			ghostAnimDropDown = new FlxScrollableDropDownMenu(stage_Dropdown.x + stage_Dropdown.width + 1, stage_Dropdown.y,
				FlxUIDropDownMenu.makeStrIdLabelArray(animList, true), function(animName:String) {
					ghost.playAnim(animList[Std.parseInt(animName)], true);

					var position = stage.getCharacterPos(ghost.isPlayer ? 0 : 1, ghost);
					ghost.setPosition(position[0], position[1]);

					if (ghost.isPlayer)
						stagePosition.setPosition(stage.player_1_Point.x, stage.player_1_Point.y);
					else
						stagePosition.setPosition(stage.player_2_Point.x, stage.player_2_Point.y);

					genBoyOffsets(false);
			});

			ghostAnimDropDown.scrollFactor.set();
			ghostAnimDropDown.cameras = [camHUD];
			add(ghostAnimDropDown);
		});

		charDropDown.selectedLabel = daAnim;
		charDropDown.scrollFactor.set();
		charDropDown.cameras = [camHUD];
		add(charDropDown);

		modDropDown = new FlxScrollableDropDownMenu(charDropDown.x + charDropDown.width + 1, charDropDown.y,
			FlxUIDropDownMenu.makeStrIdLabelArray(modListLmao, true), function(modID:String) {
				var mod:String = modListLmao[Std.parseInt(modID)];

				if (characters.exists(mod)) {
					curCharList = characters.get(mod);
					charDropDown.setData(FlxUIDropDownMenu.makeStrIdLabelArray(curCharList, true));
					charDropDown.selectedLabel = curCharList[0];

					remove(char);
					char.kill();
					char.destroy();

					remove(ghost);
					ghost.kill();
					ghost.destroy();

					daAnim = curCharList[0];
					ghost = new Character(0, 0, daAnim);
					ghost.debugMode = true;
					ghost.alpha = 0.5;
					ghost.color = FlxColor.BLACK;
					add(ghost);

					char = new Character(0, 0, daAnim);
					char.debugMode = true;
					add(char);

					var position = stage.getCharacterPos(char.isPlayer ? 0 : 1, char);
					char.setPosition(position[0], position[1]);

					if (char.isPlayer)
						stagePosition.setPosition(stage.player_1_Point.x, stage.player_1_Point.y);
					else
						stagePosition.setPosition(stage.player_2_Point.x, stage.player_2_Point.y);

					animList = [];
					genBoyOffsets(true);
				}
		});

		modDropDown.selectedLabel = "default";
		modDropDown.scrollFactor.set();
		modDropDown.cameras = [camHUD];
		add(modDropDown);

		stage_Dropdown = new FlxScrollableDropDownMenu(modDropDown.x + modDropDown.width + 1, modDropDown.y,
			FlxUIDropDownMenu.makeStrIdLabelArray(stages, true), function(stageName:String) {
				stage_Name = stages[Std.parseInt(stageName)];
				reloadStage();
				remove(ghost);
				ghost.kill();
				ghost.destroy();
				remove(char);
				char.kill();
				char.destroy();
				daAnim = curCharList[0];

				ghost = new Character(0, 0, daAnim);
				ghost.debugMode = true;
				ghost.color = FlxColor.BLACK;
				ghost.alpha = 0.5;
				add(ghost);

				char = new Character(0, 0, daAnim);
				char.debugMode = true;
				add(char);

				var position = stage.getCharacterPos(char.isPlayer ? 0 : 1, char);
				char.setPosition(position[0], position[1]);

				if (char.isPlayer)
					stagePosition.setPosition(stage.player_1_Point.x, stage.player_1_Point.y);
				else
					stagePosition.setPosition(stage.player_2_Point.x, stage.player_2_Point.y);

				animList = [];
				genBoyOffsets(true);
		});

		stage_Dropdown.selectedLabel = stage_Name;
		stage_Dropdown.scrollFactor.set();
		stage_Dropdown.cameras = [camHUD];
		add(stage_Dropdown);

		ghostAnimDropDown = new FlxScrollableDropDownMenu(stage_Dropdown.x + stage_Dropdown.width + 1, stage_Dropdown.y,
			FlxUIDropDownMenu.makeStrIdLabelArray(animList, true), function(animName:String) {
				ghost.playAnim(animList[Std.parseInt(animName)], true);

				var position = stage.getCharacterPos(ghost.isPlayer ? 0 : 1, ghost);
				ghost.setPosition(position[0], position[1]);

				if (ghost.isPlayer)
					stagePosition.setPosition(stage.player_1_Point.x, stage.player_1_Point.y);
				else
					stagePosition.setPosition(stage.player_2_Point.x, stage.player_2_Point.y);

				genBoyOffsets(false);
		});

		ghostAnimDropDown.scrollFactor.set();
		ghostAnimDropDown.cameras = [camHUD];
		add(ghostAnimDropDown);

		offset_Button = new FlxButton(charDropDown.x, charDropDown.y - 30, "Save Offsets", function() {
			saveOffsets();
		});
		offset_Button.scrollFactor.set();
		offset_Button.cameras = [camHUD];
		add(offset_Button);

		addVirtualPad(LEFT_FULL, CHARACTER_CREATOR);
		addVirtualPadCamera();

		super.create();
	}

	function genBoyOffsets(pushList:Bool = true):Void {
		animText.text = "";

		for (anim => offsets in char.animOffsets) {
			if (pushList)
				animList.push(anim);

			animText.text += anim + (anim == animList[curAnim] ? " (current) " : "") + ": " + offsets + "\n";
		}

		if ((char.offsetsFlipWhenPlayer && char.isPlayer) || (char.offsetsFlipWhenEnemy && !char.isPlayer))
			animText.text += "(offsets flipped)";
	}

	override function update(elapsed:Float) {
		if (FlxG.keys.pressed.E || virtualPad.buttonX.pressed && charCam.zoom < 2)
			charCam.zoom += elapsed * charCam.zoom * (FlxG.keys.pressed.SHIFT || virtualPad.buttonC.pressed ? 0.1 : 1);
		if (FlxG.keys.pressed.Q || virtualPad.buttonY.pressed && charCam.zoom >= 0.1)
			charCam.zoom -= elapsed * charCam.zoom * (FlxG.keys.pressed.SHIFT || virtualPad.buttonC.pressed ? 0.1 : 1);
		if (FlxG.mouse.wheel != 0 && charCam.zoom >= 0.1 && charCam.zoom < 2)
			charCam.zoom += (FlxG.keys.pressed.SHIFT || virtualPad.buttonC.pressed) ? FlxG.mouse.wheel / 100.0 : FlxG.mouse.wheel / 10.0;

		if (charCam.zoom > 2)
			charCam.zoom = 2;
		if (charCam.zoom < 0.1)
			charCam.zoom = 0.1;
		if (virtualPad.buttonG.justPressed || FlxG.keys.justPressed.Z)
			stage.foregroundSprites.visible = stage.infrontOfGFSprites.visible = stage.visible = !stage.visible;
		if (virtualPad.buttonA.justPressed || FlxG.keys.justPressed.X) {
			char.isPlayer = !char.isPlayer;
			char.flipX = !char.flipX;

			ghost.isPlayer = !ghost.isPlayer;
			ghost.flipX = !ghost.flipX;

			var position = stage.getCharacterPos(char.isPlayer ? 0 : 1, char);
			char.setPosition(position[0], position[1]);
			ghost.setPosition(position[0], position[1]);

			if (char.isPlayer)
				stagePosition.setPosition(stage.player_1_Point.x, stage.player_1_Point.y);
			else
				stagePosition.setPosition(stage.player_2_Point.x, stage.player_2_Point.y);

			char.loadOffsetFile(char.curCharacter);
			char.playAnim(animList[curAnim], true);
			animList = [];
			genBoyOffsets(true);
		}

		var shiftThing:Int = (FlxG.keys.pressed.SHIFT || virtualPad.buttonC.pressed) ? 5 : 1;

		if ((FlxG.keys.pressed.I || (virtualPad.buttonZ.pressed && virtualPad.buttonUp.pressed)) || (FlxG.keys.pressed.J || (virtualPad.buttonZ.pressed && virtualPad.buttonLeft.pressed)) || (FlxG.keys.pressed.K || (virtualPad.buttonZ.pressed && virtualPad.buttonDown.pressed)) || (FlxG.keys.pressed.L || (virtualPad.buttonZ.pressed && virtualPad.buttonRight.pressed))) {
			if (FlxG.keys.pressed.I || (virtualPad.buttonZ.pressed && virtualPad.buttonUp.pressed))
				camFollow.velocity.y = -90 * shiftThing;
			else if (FlxG.keys.pressed.K || (virtualPad.buttonZ.pressed && virtualPad.buttonDown.pressed))
				camFollow.velocity.y = 90 * shiftThing;
			else
				camFollow.velocity.y = 0;

			if (FlxG.keys.pressed.J || (virtualPad.buttonZ.pressed && virtualPad.buttonLeft.pressed))
				camFollow.velocity.x = -90 * shiftThing;
			else if (FlxG.keys.pressed.L || (virtualPad.buttonZ.pressed && virtualPad.buttonRight.pressed))
				camFollow.velocity.x = 90 * shiftThing;
			else
				camFollow.velocity.x = 0;
		} else {
			camFollow.velocity.set();
		}

		if (virtualPad.buttonV.justPressed || FlxG.keys.justPressed.W) {
			curAnim--;
		}

		if (virtualPad.buttonB.justPressed || FlxG.keys.justPressed.ESCAPE) {
			if (lastState == "OptionsMenu") {
				FlxG.switchState(new MainMenuState());
			} else {
				FlxG.switchState(new PlayState());
			}
		}

		if (virtualPad.buttonD.justPressed || FlxG.keys.justPressed.S) {
			curAnim++;
		}

		if (curAnim < 0)
			curAnim = animList.length - 1;

		if (curAnim >= animList.length)
			curAnim = 0;

		if ((virtualPad.buttonD.justPressed || FlxG.keys.justPressed.S) || (virtualPad.buttonV.justPressed || FlxG.keys.justPressed.W) || FlxG.keys.justPressed.SPACE) {
			char.playAnim(animList[curAnim], true);

			var position = stage.getCharacterPos(char.isPlayer ? 0 : 1, char);
			char.setPosition(position[0], position[1]);

			if (char.isPlayer)
				stagePosition.setPosition(stage.player_1_Point.x, stage.player_1_Point.y);
			else
				stagePosition.setPosition(stage.player_2_Point.x, stage.player_2_Point.y);

			genBoyOffsets(false);
		}

		var upP = ((virtualPad.buttonUp.justPressed && !virtualPad.buttonZ.pressed) || FlxG.keys.justPressed.UP);
		var rightP = ((virtualPad.buttonRight.justPressed && !virtualPad.buttonZ.pressed) || FlxG.keys.justPressed.RIGHT);
		var downP = ((virtualPad.buttonDown.justPressed && !virtualPad.buttonZ.pressed) || FlxG.keys.justPressed.DOWN);
		var leftP = ((virtualPad.buttonLeft.justPressed && !virtualPad.buttonZ.pressed) || FlxG.keys.justPressed.LEFT);

		var holdShift = (FlxG.keys.pressed.SHIFT || virtualPad.buttonC.pressed);
		var multiplier = 1;
		if (holdShift)
			multiplier = 10;

		if (upP || rightP || downP || leftP) {
			if (upP) {
				char.animOffsets.get(animList[curAnim])[1] += 1 * multiplier;
				ghost.animOffsets.get(animList[curAnim])[1] += 1 * multiplier;
			}
			if (downP) {
				char.animOffsets.get(animList[curAnim])[1] -= 1 * multiplier;
				ghost.animOffsets.get(animList[curAnim])[1] -= 1 * multiplier;
			}
			if (leftP) {
				char.animOffsets.get(animList[curAnim])[0] += 1 * multiplier;
				ghost.animOffsets.get(animList[curAnim])[0] += 1 * multiplier;
			}
			if (rightP) {
				char.animOffsets.get(animList[curAnim])[0] -= 1 * multiplier;
				ghost.animOffsets.get(animList[curAnim])[0] -= 1 * multiplier;
			}

			genBoyOffsets(false);
			char.playAnim(animList[curAnim], true);
		}

		charCam.zoom = flixel.math.FlxMath.roundDecimal(charCam.zoom, 2) <= 0 ? 1 : charCam.zoom;
		moveText.text = (controls.mobileC) ? 'Hold Z and Use Arrow keys to move the camera\nX and Y to zoom the camera\nC for faster moving offset or camera\nG to toggle the stage\nA to toggle playing side\n' : 'Use IJKL to move the camera\nE and Q to zoom the camera\nSHIFT for faster moving offset or camera\nZ to toggle the stage\nX to toggle playing side\n' + 'Camera Zoom: ${flixel.math.FlxMath.roundDecimal(charCam.zoom, 2)}\n';
		moveText.x = FlxG.width - moveText.width - 4;

		super.update(elapsed);
	}

	function saveOffsets() {
		var offsetsText:String = "";
		var flipped = (char.offsetsFlipWhenPlayer && char.isPlayer) || (char.offsetsFlipWhenEnemy && !char.isPlayer);

		for (anim => offsets in char.animOffsets) {
			offsetsText += anim + " " + (flipped ? -offsets[0] : offsets[0]) + " " + offsets[1] + "\n";
		}

		if ((offsetsText != "") && (offsetsText.length > 0)) {
			if (offsetsText.endsWith("\n"))
				offsetsText = offsetsText.substr(0, offsetsText.length - 1);

			#if mobile
			StorageUtil.saveContent('offsets.txt', offsetsText);
			#else
			_file = new FileReference();
			_file.addEventListener(Event.COMPLETE, onSaveComplete);
			_file.addEventListener(Event.CANCEL, onSaveCancel);
			_file.addEventListener(IOErrorEvent.IO_ERROR, onSaveError);

			_file.save(offsetsText, "offsets.txt");
			#end
		}
	}

	function onSaveComplete(_):Void {
		_file.removeEventListener(Event.COMPLETE, onSaveComplete);
		_file.removeEventListener(Event.CANCEL, onSaveCancel);
		_file.removeEventListener(IOErrorEvent.IO_ERROR, onSaveError);
		_file = null;
		FlxG.log.notice("Successfully saved OFFSETS FILE.");
	}

	/**
	 * Called when the save file dialog is cancelled.
	 */
	function onSaveCancel(_):Void {
		_file.removeEventListener(Event.COMPLETE, onSaveComplete);
		_file.removeEventListener(Event.CANCEL, onSaveCancel);
		_file.removeEventListener(IOErrorEvent.IO_ERROR, onSaveError);
		_file = null;
	}

	function onSaveError(_):Void {
		_file.removeEventListener(Event.COMPLETE, onSaveComplete);
		_file.removeEventListener(Event.CANCEL, onSaveCancel);
		_file.removeEventListener(IOErrorEvent.IO_ERROR, onSaveError);
		_file = null;
		trace("Problem saving offsets file", ERROR);
	}

	function reloadStage() {
		objects = [];

		if (stage != null) {
			remove(stage);
		}
		add(camFollow);

		stage = new StageGroup(stage_Name);
		add(stage);

		stageData = stage.stage_Data;

		var position = stage.getCharacterPos(char.isPlayer ? 0 : 1, char);
		char.setPosition(position[0], position[1]);
		ghost.setPosition(position[0], position[1]);

		remove(stage.infrontOfGFSprites);
		add(stage.infrontOfGFSprites);

		if (ghost.otherCharacters == null) {
			remove(ghost);
			add(ghost);
		} else {
			for (character in ghost.otherCharacters) {
				remove(character);
				add(character);
			}
		}

		if (char.otherCharacters == null) {
			remove(char);
			add(char);
		} else {
			for (character in char.otherCharacters) {
				remove(character);
				add(character);
			}
		}

		remove(stage.foregroundSprites);
		add(stage.foregroundSprites);
	}
}

package toolbox;

import states.MainMenuState;
import states.MusicBeatState;
import states.PlayState;
import utilities.Options;
import utilities.MusicUtilities;
import ui.Option;
import toolbox.ChartingState;
import toolbox.CharacterCreator;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.util.FlxColor;
import lime.utils.Assets;
import toolbox.StageMakingState;
import toolbox.util.NewModState;

using utilities.BackgroundUtil;

class ToolboxState extends MusicBeatState {
	public var curSelected:Int = 0;

	public static var inMenu = false;

	public var pages:Map<String, Array<Dynamic>> = [
		"Categories" => [
			#if sys
			new GameStateOption("New Mod", new NewModState()),
			#end
			new ToolboxPageOption("Tools", "Tools",),
			new ToolboxPageOption("Documentation", "Documentation")
		],
		"Tools" => [
			new GameStateOption("Charter", new ChartingState()),
			new CharacterCreatorOption("Character Creator", new CharacterCreator("dad", "stage")),
			new GameStateOption("Stage Editor", new StageMakingState("stage")),
			#if MODCHARTING_TOOLS
			new GameStateOption("Modchart Editor", new modcharting.ModchartEditorState())
			#end
		],
		"Documentation" => [
			new OpenUrlOption("Wiki", "Wiki", "https://github.com/Leather128/LeatherEngine/wiki"),
			new OpenUrlOption("HScript Api", "HScript Api", "https://vortex2oblivion.github.io/Leather-Engine-Docs/"),
			new OpenUrlOption("Lua Api", "Lua Api", "https://github.com/Vortex2Oblivion/LeatherEngine-Extended-Support/wiki/Lua-api-documentation-(WIP)"),
			new OpenUrlOption("Polymod Docs", "Polymod Docs", "https://polymod.io/docs/")
		]
	];

	public var page:FlxTypedGroup<Option> = new FlxTypedGroup<Option>();

	public static var instance:ToolboxState;

	public var menuBG:FlxSprite;

	override function create():Void {
		if (PlayState.instance == null) {
			pages["Tools"][3] = null;
			pages["Tools"][0] = null;
		}

		MusicBeatState.windowNameSuffix = "";
		instance = this;

		menuBG = new FlxSprite().makeBackground(0x00FF6A);
		menuBG.scale.set(1.1, 1.1);
		menuBG.updateHitbox();
		menuBG.screenCenter();
		add(menuBG);

		super.create();

		add(page);

		LoadPage("Categories");

		if (FlxG.sound.music == null)
			FlxG.sound.playMusic(MusicUtilities.getOptionsMusic(), 0.7, true);

		addVirtualPad(UP_DOWN, A_B);
	}

	public static function LoadPage(pageName:String):Void {
		inMenu = true;
		instance.curSelected = 0;

		var curPage:FlxTypedGroup<Option> = instance.page;
		curPage.clear();

		for (x in instance.pages.get(pageName).copy()) {
			curPage.add(x);
		}

		inMenu = false;
		var bruh:Int = 0;

		for (x in instance.page.members) {
			x.alphabetText.targetY = bruh - instance.curSelected;
			bruh++;
		}
	}

	override function update(elapsed:Float) {
		super.update(elapsed);

		if (!inMenu) {
			if (-Math.floor(FlxG.mouse.wheel) != 0) {
				curSelected -= Math.floor(FlxG.mouse.wheel);
				FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
			}

			if (controls.UP_P) {
				curSelected--;
				FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
			}

			if (controls.DOWN_P) {
				curSelected++;
				FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
			}

			if (controls.BACK)
				FlxG.switchState(new MainMenuState());
		} else {
			if (controls.BACK)
				inMenu = false;
		}

		if (curSelected < 0)
			curSelected = page.length - 1;

		if (curSelected >= page.length)
			curSelected = 0;

		var bruh = 0;

		for (x in page.members) {
			x.alphabetText.targetY = bruh - curSelected;
			bruh++;
		}

		for (x in page.members) {
			if (x.alphabetText.targetY != 0) {
				for (item in x.members) {
					item.alpha = 0.6;
				}
			} else {
				for (item in x.members) {
					item.alpha = 1;
				}
			}
		}
	}
}

/**
 * Very simple option that transfers you to a different page when selecting it.
 */
class ToolboxPageOption extends ui.Option {
	// OPTIONS //
	public var pageName:String = "Categories";

	override public function new(_optionName:String = "", _pageName:String = "Categories", _Description:String = "Test Description") {
		super(_optionName, _pageName);

		// SETTING VALUES //
		this.pageName = _pageName;
	}

	override function update(elapsed:Float) {
		super.update(elapsed);

		if (FlxG.keys.justPressed.ENTER && Std.int(alphabetText.targetY) == 0 && !ToolboxState.inMenu)
			ToolboxState.LoadPage(pageName);
	}
}

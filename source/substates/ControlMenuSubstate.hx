package substates;

import game.StrumNote;
import utilities.PlayerSettings;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import utilities.NoteVariables;
import flixel.tweens.FlxTween;
import flixel.group.FlxGroup;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxSprite;
import openfl.utils.Assets;

class ControlMenuSubstate extends MusicBeatSubstate
{
    public var keyCount:Int = 4;
    public var strumGroup:FlxTypedGroup<StrumNote> = new FlxTypedGroup<StrumNote>();
    public var textGroup:FlxTypedGroup<FlxText> = new FlxTypedGroup<FlxText>();

    public var ui_settings:Array<String>;
    public var mania_size:Array<String>;
    public var mania_offset:Array<String>;

    public var arrow_Configs:Map<String, Array<String>> = new Map<String, Array<String>>();

    public var binds:Array<Array<String>> = Options.getData("binds", "binds");

    public var selectedControl:Int = 0;
    public var selectingStuff:Bool = false;

    final escape:String = controls.mobileC ? 'B' : 'ESCAPE';

    public var coolText:FlxText = new FlxText(0,25,0,"Use LEFT and RIGHT to change number of keys\nESCAPE to save binds and exit menu\nRESET+SHIFT to Reset Binds to default\n", 32);

    public var killKey:FlxSprite = new FlxSprite();
    public var killBind:String = Options.getData("kill", "binds");
    public var killText:FlxText = new FlxText();

    public var fullscreenKey:FlxSprite = new FlxSprite();
    public var fullscreenBind:String = Options.getData("fullscreenBind", "binds");
    public var fullscreenText:FlxText = new FlxText();

    public var pauseKey:FlxSprite = new FlxSprite();
    public var pauseBind:String = Options.getData("pauseBind", "binds");
    public var pauseText:FlxText = new FlxText();

    public var mania_gap:Array<String>;

    public function new()
    {
        FlxG.mouse.visible = true;

        ui_settings = CoolUtil.coolTextFile(Paths.txt("ui skins/default/config"));
        mania_size = CoolUtil.coolTextFile(Paths.txt("ui skins/default/maniasize"));
        mania_offset = CoolUtil.coolTextFile(Paths.txt("ui skins/default/maniaoffset"));
        mania_gap = CoolUtil.coolTextFile(Paths.txt("ui skins/default/maniagap"));

        arrow_Configs.set("default", CoolUtil.coolTextFile(Paths.txt("ui skins/default/default")));

        super();

        coolText.text = 'Use LEFT and RIGHT to change number of keys\n$escape to save binds and exit menu\n${(!controls.mobileC) ? 'RESET+SHIFT to Reset Binds to default\n' : ''}';
        coolText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BLACK);
        coolText.screenCenter(X);
        
        var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
        bg.alpha = 0;
        bg.scrollFactor.set();
        add(bg);

        FlxTween.tween(bg, {alpha: 0.5}, 1, {ease: FlxEase.circOut, startDelay: 0});

        #if PRELOAD_ALL
        create_Arrows();
        add(strumGroup);
        #else
        Assets.loadLibrary("shared").onComplete(function (_) {
            create_Arrows();
            add(strumGroup);
        });
        #end
        
        add(textGroup);
        add(coolText);

        setupKeySprite(fullscreenKey, -190);

        var fullscreenIcon:FlxSprite = new FlxSprite();
        fullscreenIcon.frames = Paths.getSparrowAtlas("Bind_Menu_Assets", "preload");
        fullscreenIcon.animation.addByPrefix("idle", "Fullscreen Symbol", 24);
        fullscreenIcon.animation.play("idle");
        fullscreenIcon.updateHitbox();

        fullscreenIcon.x = fullscreenKey.x + (fullscreenKey.width / 2) - (fullscreenIcon.width / 2);
        fullscreenIcon.y = fullscreenKey.y - fullscreenIcon.height - 11;

        fullscreenText.setFormat(Paths.font("vcr.ttf"), 38, FlxColor.WHITE, LEFT, OUTLINE, FlxColor.BLACK);

        fullscreenText.text = fullscreenBind;
        fullscreenText.x = fullscreenKey.x + (fullscreenKey.width / 2) - (fullscreenText.width / 2);
        fullscreenText.y = fullscreenKey.y;

        add(fullscreenKey);
        add(fullscreenIcon);
        add(fullscreenText);

        setupKeySprite(killKey, 0);

        var killIcon:FlxSprite = new FlxSprite();
        killIcon.frames = Paths.getSparrowAtlas("Bind_Menu_Assets", "preload");
        killIcon.animation.addByPrefix("idle", "Death Icon", 24);
        killIcon.animation.play("idle");
        killIcon.updateHitbox();

        killIcon.x = killKey.x + (killKey.width / 2) - (killIcon.width / 2);
        killIcon.y = killKey.y - killIcon.height - 16;

        killText.setFormat(Paths.font("vcr.ttf"), 38, FlxColor.WHITE, LEFT, OUTLINE, FlxColor.BLACK);

        killText.text = killBind;
        killText.x = killKey.x + (killKey.width / 2) - (killText.width / 2);
        killText.y = killKey.y;

        add(killKey);
        add(killIcon);
        add(killText);

        setupKeySprite(pauseKey, 190);

        var pauseIcon:FlxSprite = new FlxSprite();
        pauseIcon.frames = Paths.getSparrowAtlas("Bind_Menu_Assets", "preload");
        pauseIcon.animation.addByPrefix("idle", "Pause Icon", 24);
        pauseIcon.animation.play("idle");
        pauseIcon.updateHitbox();

        pauseIcon.x = pauseKey.x + (pauseKey.width / 2) - (pauseIcon.width / 2);
        pauseIcon.y = pauseKey.y - pauseIcon.height - 16;

        pauseText.setFormat(Paths.font("vcr.ttf"), 38, FlxColor.WHITE, LEFT, OUTLINE, FlxColor.BLACK);

        pauseText.text = pauseBind;
        pauseText.x = pauseKey.x + (pauseKey.width / 2) - (pauseText.width / 2);
        pauseText.y = pauseKey.y;

        add(pauseKey);
        add(pauseIcon);
        add(pauseText);

        addVirtualPad(LEFT_RIGHT, B);
    }

    override function update(elapsed:Float) {
        super.update(elapsed);

        var leftP = controls.LEFT_P;
		var rightP = controls.RIGHT_P;
        var reset = controls.RESET;
        var back = controls.BACK;
        var shift = FlxG.keys.pressed.SHIFT;

        if(strumGroup != null)
        {
            if(reset && shift)
            {
                binds = NoteVariables.defaultBinds;
                fullscreenBind = "F11";
                killBind = "R";
                pauseBind = "ENTER";
            }
            
            if(back)
            {
                Options.setData(this.binds, "binds", "binds");
                Options.setData(fullscreenBind, "fullscreenBind", "binds");
                Options.setData(killBind, "kill", "binds");
                Options.setData(pauseBind, "pauseBind", "binds");
    
                PlayerSettings.player1.controls.loadKeyBinds();
    
                FlxG.mouse.visible = false;
                states.OptionsMenu.instance.closeSubState();
                removeVirtualPad();
            }
    
            if(FlxG.mouse.overlaps(fullscreenKey) && FlxG.mouse.justPressed && !selectingStuff)
            {
                selectedControl = -1;
                selectingStuff = true;
            }
            else if(FlxG.mouse.overlaps(fullscreenKey))
                fullscreenKey.color = FlxColor.GRAY;
            else
                fullscreenKey.color = FlxColor.WHITE;
    
            if(FlxG.mouse.overlaps(killKey) && FlxG.mouse.justPressed && !selectingStuff)
            {
                selectedControl = -2;
                selectingStuff = true;
            }
            else if(FlxG.mouse.overlaps(killKey))
                killKey.color = FlxColor.GRAY;
            else
                killKey.color = FlxColor.WHITE;

            if(FlxG.mouse.overlaps(pauseKey) && FlxG.mouse.justPressed && !selectingStuff)
            {
                selectedControl = -3;
                selectingStuff = true;
            }
            else if(FlxG.mouse.overlaps(pauseKey))
                pauseKey.color = FlxColor.GRAY;
            else
                pauseKey.color = FlxColor.WHITE;

    
            for(x in strumGroup)
            {
                if(FlxG.mouse.overlaps(x) && FlxG.mouse.justPressed && !selectingStuff)
                {
                    selectedControl = x.ID;
                    selectingStuff = true;
                }
    
                if(FlxG.mouse.overlaps(x) || x.ID == selectedControl && selectingStuff)
                    x.color = FlxColor.GRAY;
                else
                    x.color = FlxColor.WHITE;
            }
    
            if(selectingStuff && FlxG.keys.justPressed.ANY)
            {
                var curKey = FlxG.keys.getIsDown()[0].ID.toString();
    
                if(selectedControl > -1)
                    this.binds[keyCount - 1][selectedControl] = curKey;
                else
                {
                    switch(selectedControl)
                    {
                        case -1:
                            fullscreenBind = curKey;
                        case -2:
                            killBind = curKey;
                        case -3:
                            pauseBind = curKey;
                    }
                }
            }
    
            if(!selectingStuff && (leftP || rightP))
            {
                if(leftP)
                    keyCount --;
    
                if(rightP)
                    keyCount ++;
    
                if(keyCount < 1)
                    keyCount = 1;
    
                if(keyCount > NoteVariables.maniaDirections.length)
                    keyCount = NoteVariables.maniaDirections.length;
    
                create_Arrows();
            }
    
            if(selectingStuff && FlxG.keys.justPressed.ANY)
                selectingStuff = false;
    
            update_Text();
        }
    }

    function update_Text()
    {
        for(i in 0...textGroup.length)
        {
            textGroup.members[i].text = binds[keyCount - 1][i];
        }

        fullscreenText.text = fullscreenBind;
        fullscreenText.x = fullscreenKey.x + (fullscreenKey.width / 2) - (fullscreenText.width / 2);
        fullscreenText.y = fullscreenKey.y + (fullscreenKey.height / 2) - (fullscreenText.height / 2);

        killText.text = killBind;
        killText.x = killKey.x + (killKey.width / 2) - (killText.width / 2);
        killText.y = killKey.y + (killKey.height / 2) - (killText.height / 2);

        pauseText.text = pauseBind;
        pauseText.x = pauseKey.x + (pauseKey.width / 2) - (pauseText.width / 2);
        pauseText.y = pauseKey.y + (pauseKey.height / 2) - (pauseText.height / 2);
    }

    function create_Arrows(?new_keyCount)
    {
        if(new_keyCount != null)
            keyCount = new_keyCount;

        strumGroup.clear();
        
        textGroup.forEach(function(text:FlxText) {
            textGroup.remove(text);
            text.kill();
            text.destroy();
        });

        textGroup.clear();

        var strumLine:FlxSprite = new FlxSprite(0, FlxG.height / 2);

		for (i in 0...keyCount)
        {
            var babyArrow:StrumNote = new StrumNote(0, strumLine.y, i, "default", ui_settings, mania_size, keyCount);
			babyArrow.x += (babyArrow.width + (2 + Std.parseFloat(mania_gap[keyCount - 1]))) * Math.abs(i) + Std.parseFloat(mania_offset[keyCount - 1]);
			babyArrow.y = strumLine.y - (babyArrow.height / 2);
            babyArrow.y -= 10;
            babyArrow.alpha = 0;
            FlxTween.tween(babyArrow, {y: babyArrow.y + 10, alpha: 1}, 1, {ease: FlxEase.circOut, startDelay: 0.5 + (0.2 * i)});
			babyArrow.ID = i;
			babyArrow.x += 100 - ((keyCount - 4) * 16) + (keyCount >= 10 ? 30 : 0);
			babyArrow.x += ((FlxG.width / 2) * 0.5);
            strumGroup.add(babyArrow);

            //var coolWidth = Std.int(40 - ((keyCount - 5) * 2) + (keyCount == 10 ? 30 : 0));
                                                    // funny 4 key math i guess, full num is 2.836842105263158 (width / previous key width thingy which was 38)
            var coolWidth = Math.ceil(babyArrow.width / 2.83684);

            var coolText:FlxText = new FlxText((babyArrow.x + (babyArrow.width / 2)) - (coolWidth / 2), babyArrow.y - (coolWidth / 2), coolWidth, binds[keyCount - 1][i], coolWidth);
            coolText.borderStyle = SHADOW_XY(6, 6);
            add(coolText);

            textGroup.add(coolText);
        }
    }

    public function setupKeySprite(key:FlxSprite, ?x:Float = 0.0)
    {
        key.frames = Paths.getSparrowAtlas("Bind_Menu_Assets", "preload");
        key.animation.addByPrefix("idle", "Button", 24);
        key.animation.play("idle");
        key.updateHitbox();

        key.screenCenter(X);
        key.y = FlxG.height - key.height - 8;

        key.x += x;
    }
}
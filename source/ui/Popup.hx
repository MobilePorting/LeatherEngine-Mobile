package ui;

import flixel.ui.FlxButton;
import flixel.addons.ui.FlxUITabMenu;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;

class Popup extends FlxSpriteGroup {
    
	public var bg:FlxSprite;
	public var popup:FlxUITabMenu;

	public function new(type:PopupType = ALERT, callbacks:Array<Void->Void>, title:String = "Hey!", showBg:Bool = true) {
		super();
		bg = new FlxSprite();
		bg.makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.screenCenter();
		bg.alpha = 0.5;
		if (showBg)
			add(bg);

		popup = new FlxUITabMenu(null, [{name: title, label: title},], true);
		popup.resize(640 * 0.667, 480 * 0.667);
		popup.screenCenter();
		add(popup);

		switch (type) {
			case BOOL:
                var yes:FlxButton = new FlxButton(0, 0, "Yes", callbacks[0]);
				yes.scale.set(2, 2);
				yes.label.scale.set(2, 2);
				yes.updateHitbox();
				yes.label.updateHitbox();
				yes.screenCenter();
                yes.y -= 75;
				add(yes);

                var no:FlxButton = new FlxButton(0, 0, "No", callbacks[1]);
				no.scale.set(2, 2);
				no.label.scale.set(2, 2);
				no.updateHitbox();
				no.label.updateHitbox();
				no.screenCenter();
				add(no);
			case ALERT:
				var close:FlxButton = new FlxButton(0, 0, "Ok", callbacks[0]);
				close.scale.set(2, 2);
				close.label.scale.set(2, 2);
				close.updateHitbox();
				close.label.updateHitbox();
				close.screenCenter();
				add(close);
		}
	}
}

enum PopupType {
	BOOL;
	ALERT;
}

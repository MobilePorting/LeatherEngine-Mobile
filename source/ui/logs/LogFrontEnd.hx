package ui.logs;

import flixel.system.debug.log.LogStyle;

class LogFrontEnd extends flixel.system.frontEnds.LogFrontEnd {
    override public function advanced(data:Any, ?style:LogStyle, fireOnce:Bool = false) {
        if (style == null)
			style = LogStyle.NORMAL;
		
	    if (!(data is Array))
			data = [data];
		
		// Check null game since `FlxG.save.bind` may be called before `new FlxGame`
        #if FLX_DEBUG 
		if (FlxG.game == null || FlxG.game.debugger == null)
		{
			_standardTraceFunction(data);
		}
		else if (FlxG.game.debugger.log.add(data, style, fireOnce))
		{
        #end
			#if (FLX_DEBUG && FLX_SOUND_SYSTEM && !FLX_UNIT_TEST)
			if (style.errorSound != null)
			{
				final sound = FlxAssets.getSound(style.errorSound);
				if (sound != null)
					FlxG.sound.load(sound).play();
			}
			#end
			
            #if FLX_DEBUG
			if (style.openConsole)
				FlxG.debugger.visible = true;
            #end
			
            if (style.callbackFunction != null)
                style.callbackFunction();
                
            if (style.callback != null)
                style.callback(data);

        #if FLX_DEBUG
		}
		#end
		if (style.throwException)
			throw style.toLogString(data);
    }
}
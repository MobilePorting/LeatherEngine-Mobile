package game;

import flixel.util.FlxStringUtil;
import flixel.group.FlxContainer.FlxTypedContainer;
import flixel.sound.FlxSound;
import flixel.FlxG;

class SoundGroup extends FlxTypedContainer<FlxSound> {
	/**
	 * The volume of this group
	 */
	public var volume(default, set):Float;

	#if FLX_PITCH
	/**
	 * The pitch of this group
	 */
	public var pitch(default, set):Float;
	#end

	/**
	 * The position of this group in milliseconds.
	 * If set while paused, changes only come into effect after a `resume()` call.
	 */
	public var time(default, set):Float;

	/**
	 * The length of the *longest* sound in the group
	 */
	public var maxLength(get, never):Float;

	/**
	 * Whether or not the sound group is currently playing.
	 */
	public var playing(default, null):Bool;

	public function new(maxSize:Int = 0) {
		super(maxSize);
		#if FLX_SOUND_SYSTEM
		FlxG.signals.focusGained.add(onFocus);
		FlxG.signals.focusLost.add(onFocusLost);
		#end
	}

	override public function destroy() {
		#if FLX_SOUND_SYSTEM
		FlxG.signals.focusGained.remove(onFocus);
		FlxG.signals.focusLost.remove(onFocusLost);
		#end
		super.destroy();
	}

	public function play(forceRestart:Bool = false, startTime:Float = 0.0, ?endTime:Float) {
		for (member in members) {
			member.play(forceRestart, startTime, endTime);
		}
		playing = true;
	}

	public function stop() {
		for (member in members) {
			member.stop();
		}
		playing = false;
	}

	public function resume() {
		for (member in members) {
			member.resume();
		}
		playing = true;
	}

	public function pause() {
		for (member in members) {
			member.pause();
		}
		playing = false;
	}

	function set_volume(volume:Float):Float {
		this.volume = volume;
		for (sound in members) {
			sound.volume = volume;
		}
		return volume;
	}

	function set_time(time:Float):Float {
		this.time = time;
		for (sound in members) {
			sound.time = time;
		}
		return time;
	}

	#if FLX_PITCH
	function set_pitch(pitch:Float):Float {
		this.pitch = pitch;
		for (sound in members) {
			sound.pitch = pitch;
		}
		return pitch;
	}
	#end

	function get_maxLength():Float {
		var m:Float = 0.0;
		for (sound in members) {
			if (sound.length > m) {
				m = sound.length;
			}
		}
		return m;
	}

	#if FLX_SOUND_SYSTEM
	function onFocus():Void {
		for (sound in members)
			@:privateAccess sound?.onFocus();
	}

	function onFocusLost():Void {
		for (sound in members)
			@:privateAccess sound?.onFocusLost();
	}
	#end

	override public function toString():String {
		return FlxStringUtil.getDebugString([
			LabelValuePair.weak("playing", playing),
			LabelValuePair.weak("time", time),
			LabelValuePair.weak("length", length),
			LabelValuePair.weak("volume", volume)
		]);
	}
}

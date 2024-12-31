/*
 * Copyright (C) 2025 Mobile Porting Team
 *
 * Permission is hereby granted, free of charge, to any person obtaining a
 * copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 * DEALINGS IN THE SOFTWARE.
 */

package android.utilities;

/**
 * Main class for handling JNI calls for Leather Engine on Android.
 * 
 * This class contains methods for interacting with various Android 
 * functionalities such as orientation, clipboard, and activity title.
 * 
 * @author Lily Ross (mcagabe19)
 */
import lime.system.JNI;

class LeatherJNI #if (lime >= "8.0.0") implements JNISafety #end
{
	/** Represents an unknown screen orientation. */
	public static final SDL_ORIENTATION_UNKNOWN:Int = 0;

	/** Represents landscape screen orientation. */
	public static final SDL_ORIENTATION_LANDSCAPE:Int = 1;

	/** Represents flipped landscape screen orientation. */
	public static final SDL_ORIENTATION_LANDSCAPE_FLIPPED:Int = 2;

	/** Represents portrait screen orientation. */
	public static final SDL_ORIENTATION_PORTRAIT:Int = 3;

	/** Represents flipped portrait screen orientation. */
	public static final SDL_ORIENTATION_PORTRAIT_FLIPPED:Int = 4;

	/**
	 * Set the screen orientation.
	 * 
	 * @param width The width of the screen.
	 * @param height The height of the screen.
	 * @param resizeable Whether the screen is resizable.
	 * @param hint A hint for setting the orientation.
	 * @return A dynamic result from the JNI call.
	 */
	public static inline function setOrientation(width:Int, height:Int, resizeable:Bool, hint:String):Dynamic
		return setOrientation_jni(width, height, resizeable, hint);

	/**
	 * Get the current orientation as a string.
	 * 
	 * @return A string representing the current orientation.
	 */
	public static inline function getCurrentOrientationAsString():String {
		return switch (getCurrentOrientation_jni()) {
			case SDL_ORIENTATION_PORTRAIT: "Portrait";
			case SDL_ORIENTATION_LANDSCAPE: "LandscapeRight";
			case SDL_ORIENTATION_PORTRAIT_FLIPPED: "PortraitUpsideDown";
			case SDL_ORIENTATION_LANDSCAPE_FLIPPED: "LandscapeLeft";
			default: "Unknown";
		}
	}

	/**
	 * Check if the screen keyboard is shown.
	 * 
	 * @return A dynamic result from the JNI call.
	 */
	public static inline function isScreenKeyboardShown():Dynamic
		return isScreenKeyboardShown_jni();

	/**
	 * Check if the clipboard has text.
	 * 
	 * @return A dynamic result from the JNI call.
	 */
	public static inline function clipboardHasText():Dynamic
		return clipboardHasText_jni();

	/**
	 * Get text from the clipboard.
	 * 
	 * @return A dynamic result from the JNI call.
	 */
	public static inline function clipboardGetText():Dynamic
		return clipboardGetText_jni();

	/**
	 * Set text to the clipboard.
	 * 
	 * @param string The text to be set to the clipboard.
	 * @return A dynamic result from the JNI call.
	 */
	public static inline function clipboardSetText(string:String):Dynamic
		return clipboardSetText_jni(string);

	/**
	 * Manually trigger the back button.
	 * 
	 * @return A dynamic result from the JNI call.
	 */
	public static inline function manualBackButton():Dynamic
		return manualBackButton_jni();

	/**
	 * Set the activity title.
	 * 
	 * @param title The title to be set for the activity.
	 * @return A dynamic result from the JNI call.
	 */
	public static inline function setActivityTitle(title:String):Dynamic
		return setActivityTitle_jni(title);

	@:noCompletion private static var setOrientation_jni:Dynamic = JNI.createStaticMethod('org/libsdl/app/SDLActivity', 'setOrientation',
		'(IIZLjava/lang/String;)V');
	@:noCompletion private static var getCurrentOrientation_jni:Dynamic = JNI.createStaticMethod('org/libsdl/app/SDLActivity', 'getCurrentOrientation', '()I');
	@:noCompletion private static var isScreenKeyboardShown_jni:Dynamic = JNI.createStaticMethod('org/libsdl/app/SDLActivity', 'isScreenKeyboardShown', '()Z');
	@:noCompletion private static var clipboardHasText_jni:Dynamic = JNI.createStaticMethod('org/libsdl/app/SDLActivity', 'clipboardHasText', '()Z');
	@:noCompletion private static var clipboardGetText_jni:Dynamic = JNI.createStaticMethod('org/libsdl/app/SDLActivity', 'clipboardGetText',
		'()Ljava/lang/String;');
	@:noCompletion private static var clipboardSetText_jni:Dynamic = JNI.createStaticMethod('org/libsdl/app/SDLActivity', 'clipboardSetText',
		'(Ljava/lang/String;)V');
	@:noCompletion private static var manualBackButton_jni:Dynamic = JNI.createStaticMethod('org/libsdl/app/SDLActivity', 'manualBackButton', '()V');
	@:noCompletion private static var setActivityTitle_jni:Dynamic = JNI.createStaticMethod('org/libsdl/app/SDLActivity', 'setActivityTitle',
		'(Ljava/lang/String;)Z');
}

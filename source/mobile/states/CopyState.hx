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

package mobile.states;

import states.TitleState;
import lime.utils.Assets as LimeAssets;
import openfl.utils.Assets as OpenFLAssets;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import openfl.utils.ByteArray;
import haxe.io.Path;
import flixel.ui.FlxBar;
import flixel.ui.FlxBar.FlxBarFillDirection;
import lime.system.ThreadPool;
#if sys
import sys.io.File;
import sys.FileSystem;
#end

/**
 * The CopyState class handles the copying of missing game assets from internal storage
 * to the appropriate directories on the file system.
 * 
 * @author: Karim Akra
 */
class CopyState extends states.MusicBeatState {
	/**
	 * A list of file extensions that are considered text files.
	 * These file types will be handled appropriately during the copy process.
	 */
	private static final textFilesExtensions:Array<String> = ['ini', 'txt', 'xml', 'hxs', 'hx', 'lua', 'json', 'frag', 'vert'];

	/**
	 * The name of the file that contains a list of folders to ignore during the copy process.
	 */
	public static final IGNORE_FOLDER_FILE_NAME:String = "CopyState-Ignore.txt";

	/**
	 * A list of directories that shouldn't be copy during the copy process.
	 */
	private static var directoriesToIgnore:Array<String> = [];

	/**
	 * Static variables to store located files, maximum loop times, and the name of the ignore file.
	 */
	public static var locatedFiles:Array<String> = [];

	/**
	 * The maximum number of iterations the copy loop will perform.
	 * This value is determined by the number of files that need to be copied.
	 */
	public static var maxLoopTimes:Int = 0;

	@:dox(hide) public var loadingImage:FlxSprite;
	@:dox(hide) public var loadingBar:FlxBar;
	@:dox(hide) public var loadedText:FlxText;

	/**
	 * A thread pool that handles the file copying process.
	 * It will iterate through the files to be copied and handle each file concurrently.
	 */
	public var thread:ThreadPool;

	var failedFilesStack:Array<String> = [];
	var failedFiles:Array<String> = [];
	var shouldCopy:Bool = false;
	var canUpdate:Bool = true;
	var loopTimes:Int = 0;

	override function create() {
		locatedFiles = [];
		maxLoopTimes = 0;
		checkExistingFiles();
		if (maxLoopTimes <= 0) {
			FlxG.switchState(new TitleState());
			return;
		}

		CoolUtil.showPopUp("Seems like you have some missing files that are necessary to run the game\nPress OK to begin the copy process", "Notice!");

		shouldCopy = true;

		add(new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, 0xffcaff4d));

		loadingImage = new FlxSprite(0, 0, Paths.image('funkay'));
		loadingImage.setGraphicSize(0, FlxG.height);
		loadingImage.updateHitbox();
		loadingImage.screenCenter();
		add(loadingImage);

		loadingBar = new FlxBar(0, FlxG.height - 26, FlxBarFillDirection.LEFT_TO_RIGHT, FlxG.width, 26);
		loadingBar.setRange(0, maxLoopTimes);
		add(loadingBar);

		loadedText = new FlxText(loadingBar.x, loadingBar.y + 4, FlxG.width, '', 16);
		loadedText.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, CENTER);
		add(loadedText);

		thread = new ThreadPool(0, CoolUtil.getCPUThreadsCount(), MULTI_THREADED);
		new FlxTimer().start(0.5, (tmr) -> {
			thread.run(function(poop, shit) {
				for (file in locatedFiles) {
					loopTimes++;
					copyAsset(file);
				}
			}, null);
		});

		super.create();
	}

	override function update(elapsed:Float) {
		if (shouldCopy) {
			if (loopTimes >= maxLoopTimes && canUpdate) {
				if (failedFiles.length > 0) {
					CoolUtil.showPopUp(failedFiles.join('\n'), 'Failed To Copy ${failedFiles.length} File.');
					if (!FileSystem.exists('logs'))
						FileSystem.createDirectory('logs');
					File.saveContent('logs/' + Date.now().toString().replace(' ', '-').replace(':', "'") + '-CopyState' + '.txt', failedFilesStack.join('\n'));
				}

				FlxG.sound.play(Paths.sound('confirmMenu')).onComplete = () -> {
					FlxG.switchState(new TitleState());
				};

				canUpdate = false;
			}

			if (loopTimes >= maxLoopTimes)
				loadedText.text = "Completed!";
			else
				loadedText.text = '$loopTimes/$maxLoopTimes';

			loadingBar.percent = Math.min((loopTimes / maxLoopTimes) * 100, 100);
		}
		super.update(elapsed);
	}

	/**
	 * Function to copy an asset from internal storage to the file system.
	 */
	public function copyAsset(file:String) {
		if (!FileSystem.exists(file)) {
			var directory = Path.directory(file);
			if (!FileSystem.exists(directory))
				FileSystem.createDirectory(directory);
			try {
				if (OpenFLAssets.exists(getFile(file))) {
					if (textFilesExtensions.contains(Path.extension(file)))
						createContentFromInternal(file);
					else
						File.saveBytes(file, getFileBytes(getFile(file)));
				} else {
					failedFiles.push(getFile(file) + " (File Dosen't Exist)");
					failedFilesStack.push('Asset ${getFile(file)} does not exist.');
				}
			} catch (e:haxe.Exception) {
				failedFiles.push('${getFile(file)} (${e.message})');
				failedFilesStack.push('${getFile(file)} (${e.stack})');
			}
		}
	}

	/**
	 * Function to create content from internal storage for text files.
	 * @param file The file path to copy.
	 */
	public function createContentFromInternal(file:String) {
		var fileName = Path.withoutDirectory(file);
		var directory = Path.directory(file);
		try {
			var fileData:String = OpenFLAssets.getText(getFile(file));
			if (fileData == null)
				fileData = '';
			if (!FileSystem.exists(directory))
				FileSystem.createDirectory(directory);
			File.saveContent(Path.join([directory, fileName]), fileData);
		} catch (e:haxe.Exception) {
			failedFiles.push('${getFile(file)} (${e.message})');
			failedFilesStack.push('${getFile(file)} (${e.stack})');
		}
	}

	/**
	 * Function to get the byte content of a file.
	 * @param file The file path to get bytes from.
	 * @return The byte array of the file.
	 */
	public function getFileBytes(file:String):ByteArray {
		switch (Path.extension(file).toLowerCase()) {
			case 'otf' | 'ttf':
				return ByteArray.fromFile(file);
			default:
				return OpenFLAssets.getBytes(file);
		}
	}

	/**
	 * Function to get the file path from assets.
	 * @param file The file path to check.
	 * @return The actual file path in the assets.
	 */
	public static function getFile(file:String):String {
		if (OpenFLAssets.exists(file))
			return file;

		@:privateAccess
		for (library in LimeAssets.libraries.keys()) {
			if (OpenFLAssets.exists('$library:$file') && library != 'default')
				return '$library:$file';
		}

		return file;
	}

	/**
	 * Function to check for existing files and update the list of files to be copied.
	 * @return Whether there are files to copy.
	 */
	public static function checkExistingFiles():Bool {
		locatedFiles = OpenFLAssets.list();

		// removes unwanted assets
		var assets = locatedFiles.filter(folder -> folder.startsWith('assets/'));
		var mods = locatedFiles.filter(folder -> folder.startsWith('mods/'));
		locatedFiles = assets.concat(mods);
		locatedFiles = locatedFiles.filter(file -> !FileSystem.exists(file));

		var filesToRemove:Array<String> = [];

		for (file in locatedFiles) {
			if (filesToRemove.contains(file))
				continue;

			if (file.endsWith(IGNORE_FOLDER_FILE_NAME) && !directoriesToIgnore.contains(Path.directory(file)))
				directoriesToIgnore.push(Path.directory(file));

			if (directoriesToIgnore.length > 0) {
				for (directory in directoriesToIgnore) {
					if (file.startsWith(directory))
						filesToRemove.push(file);
				}
			}
		}

		locatedFiles = locatedFiles.filter(file -> !filesToRemove.contains(file));

		maxLoopTimes = locatedFiles.length;

		return (maxLoopTimes <= 0);
	}
}

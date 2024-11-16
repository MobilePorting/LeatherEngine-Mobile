package;

import sys.FileSystem;
import flxanimate.frames.FlxAnimateFrames;
import lime.utils.Assets;
import flixel.FlxG;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.graphics.FlxGraphic;
import flixel.system.FlxAssets.FlxGraphicAsset;
import openfl.utils.AssetType;
import openfl.utils.Assets as OpenFlAssets;
import openfl.display.BitmapData;

/**
 * Assets paths helper class
 */
class Paths {
	public static var currentLevel:String = "preload";

	public static var graphics:Map<String, FlxGraphic> = new Map<String, FlxGraphic>();

	public static function getPath(file:String, type:AssetType, library:Null<String>):String {
		if (library != null)
			return getLibraryPath(file, library);

		if (currentLevel != null) {
			var levelPath = getLibraryPathForce(file, currentLevel);

			if (OpenFlAssets.exists(levelPath, type))
				return levelPath;

			levelPath = getLibraryPathForce(file, "shared");

			if (OpenFlAssets.exists(levelPath, type))
				return levelPath;
		}

		return getPreloadPath(file);
	}

	static public function getLibraryPath(file:String, library = "preload"):String
		return if (library == "preload" || library == "default") getPreloadPath(file); else getLibraryPathForce(file, library);

	inline static function getLibraryPathForce(file:String, library:String):String
		return '$library:assets/$library/$file';

	inline static public function getPreloadPath(file:String):String
		return 'assets/$file';

	inline static public function lua(key:String, ?library:String):String
		return getPath('data/$key.lua', TEXT, library);

	inline static public function hx(key:String, ?library:String):String
		return getPath('$key.hx', TEXT, library);

	inline static public function frag(key:String, ?library:String):String
		return getPath('shaders/$key.frag', TEXT, library);

	inline static public function vert(key:String, ?library:String):String
		return getPath('shaders/$key.vert', TEXT, library);

	inline static public function file(file:String, type:AssetType = TEXT, ?library:String):String
		return getPath(file, type, library);

	inline static public function txt(key:String, ?library:String):String
		return getPath('data/$key.txt', TEXT, library);

	inline static public function xml(key:String, ?library:String):String
		return getPath('data/$key.xml', TEXT, library);

	inline static public function ui(key:String, ?library:String):String
		return getPath('ui/$key.xml', TEXT, library);

	inline static public function json(key:String, ?library:String):String
		return getPath('data/$key.json', TEXT, library);

	inline static public function video(key:String, ext:String = "mp4"):String
		return 'assets/videos/$key.$ext';

	inline static public function sound(key:String, ?library:String):String
		return getPath('sounds/$key.ogg', SOUND, library);

	inline static public function soundRandom(key:String, min:Int, max:Int, ?library:String):String
		return sound(key + FlxG.random.int(min, max), library);

	inline static public function music(key:String, ?library:String):String
		return getPath('music/$key.ogg', MUSIC, library);

	inline static public function image(key:String, ?library:String):String {
		return getPath('images/$key.png', IMAGE, library);
	}

	/**
	 * Gets an image in any mod or base asset to the gpu when possible.
	 * @see https://github.com/Ralsin/FNF-MintEngine/blob/1c681b35e081c1b297f47ed06815503f6ed7089a/source/funkin/api/FileManager.hx#L45
	 * @param key The path of the image
	 * @param library The image package. (ex shared). NOTE: Will search through other packages to find the image when possible.
	 * @param avoidGPU Force loading to  of the graphic to the cpu.
	 * @return The image as a `FlxGraphic`. Will retrun the image path if gpu caching is not possible.
	 */
	static public function gpuBitmap(key:String, ?library:String, avoidGPU:Bool = false):FlxGraphicAsset {
		var file:String = image(key, library);
		var bitmap:BitmapData = OpenFlAssets.getBitmapData(file);
		if (!Options.getData("gpuCaching") || avoidGPU || bitmap.image == null) {
			bitmap = null;
			return file;
		}
		@:privateAccess {
			if(!graphics.exists(file)){
				bitmap.disposeImage();
			}
			else{
				bitmap = null;
				return graphics.get(file);
			}
		}	
		var graphic:FlxGraphic = FlxGraphic.fromBitmapData(bitmap, false, file, false);
		graphic.persist = Options.getData("memoryLeaks");
		graphics.set(file, graphic);
		return graphic;
	}

	inline static public function font(key:String):String
		return 'assets/fonts/$key';

	inline static public function ndll(key:String, ?library:String):String
		return getPath('ndlls/$key.ndll', TEXT, library);

	static public function voices(song:String, ?difficulty:String, ?character:String, ?mix:String):String {
		var voicesPath:String = 'songs:assets/songs/${song.toLowerCase()}/';
		var voicesFile:String = 'Voices';

		if(character != null && mix != null && (Assets.exists('$voicesPath$voicesFile-$character.ogg') || Assets.exists('$voicesPath$voicesFile-$character-$mix.ogg'))){
			voicesFile += '-$character';
		}

		if(mix != null && Assets.exists('$voicesPath$voicesFile-$mix.ogg')){
			voicesFile += '-$mix';
		}

		if (difficulty != null) {
			if (difficulty.toLowerCase() == 'nightmare') {
				if (Assets.exists('$voicesPath$voicesFile-erect.ogg'))
					voicesFile += '-erect';
			}
			if (Assets.exists('Voices-$difficulty.ogg'))
				voicesFile += '-$difficulty';
		}

		return '$voicesPath$voicesFile.ogg';
	}

	static public function inst(song:String, ?difficulty:String, ?mix:String):String {
		var instPath:String = 'songs:assets/songs/${song.toLowerCase()}/';
		var instFile:String = 'Inst';

		if(mix != null && Assets.exists('$instPath$instFile-$mix.ogg')){
			instFile += '-$mix';
		}

		if (difficulty != null) {
			if (difficulty.toLowerCase() == 'nightmare') {
				if (Assets.exists('$instPath$instFile-erect.ogg'))
					instFile += '-erect';
			}
			if (Assets.exists('Inst-$difficulty.ogg'))
				instFile += '-$difficulty';
		}


		return '$instPath$instFile.ogg';
	}

	static public function songEvents(song:String, ?difficulty:String):String {
		if (difficulty != null) {
			if (difficulty.toLowerCase() == 'nightmare') {
				if (Assets.exists(Paths.json("song data/" + song.toLowerCase() + '/events-erect')))
					return Paths.json("song data/" + song.toLowerCase() + '/events-erect');
			}
			if (Assets.exists(Paths.json("song data/" + song.toLowerCase() + '/events-${difficulty.toLowerCase()}')))
				return Paths.json("song data/" + song.toLowerCase() + '/events-${difficulty.toLowerCase()}');
		}

		return Paths.json("song data/" + song.toLowerCase() + "/events");
	}

	inline static public function getSparrowAtlas(key:String, ?library:String, avoidGPU:Bool = false):FlxAtlasFrames {
		if (Assets.exists(file('images/$key.xml', library)))
			return FlxAtlasFrames.fromSparrow(gpuBitmap(key, library, avoidGPU), file('images/$key.xml', library));
		else
			return FlxAtlasFrames.fromSparrow(gpuBitmap("Bind_Menu_Assets", "preload", avoidGPU), file('images/Bind_Menu_Assets.xml', "preload"));
	}

	inline static public function getPackerAtlas(key:String, ?library:String, avoidGPU:Bool = false):FlxAtlasFrames {
		if (Assets.exists(file('images/$key.txt', library)))
			return FlxAtlasFrames.fromSpriteSheetPacker(gpuBitmap(key, library, avoidGPU), file('images/$key.txt', library));
		else
			return FlxAtlasFrames.fromSparrow(gpuBitmap("Bind_Menu_Assets", "preload", avoidGPU), file('images/Bind_Menu_Assets.xml', "preload"));
	}

	inline static public function getTextureAtlas(key:String, ?library:String):String {
		return getPath('images/$key', TEXT, library);
	}

	inline static public function getJsonAtlas(key:String, ?library:String):FlxAtlasFrames {
		return FlxAnimateFrames.fromJson(getPath('images/$key.json', TEXT, library));
	}

	inline static public function getEdgeAnimateAtlas(key:String, ?library:String):FlxAtlasFrames {
		return FlxAnimateFrames.fromEdgeAnimate(getPath('images/$key.eas', TEXT, library));
	}

	inline static public function getCocos2DAtlas(key:String, ?library:String):FlxAtlasFrames {
		return FlxAnimateFrames.fromCocos2D(getPath('images/$key.plist', TEXT, library));
	}

	inline static public function getEaselJSAtlas(key:String, ?library:String):FlxAtlasFrames {
		return FlxAnimateFrames.fromEaselJS(getPath('images/$key.js', TEXT, library));
	}

	inline static public function existsInMod(path:String, mod:String):Bool {
		return FileSystem.exists(path.replace('assets', 'mods/$mod'));
	}
}

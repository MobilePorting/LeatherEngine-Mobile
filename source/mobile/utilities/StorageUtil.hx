package mobile.utilities;

import lime.system.System as LimeSystem;
#if android
import android.os.Build.VERSION as AndroidVersion;
import android.os.Build.VERSION_CODES as AndroidVersionCode;
import android.os.Environment as AndroidEnvironment;
import android.Permissions as AndroidPermissions;
import android.Settings as AndroidSettings;
#end
#if sys
import sys.FileSystem;
import sys.io.File;
#end

using StringTools;

/**
 * A storage utility class for mobile platforms.
 * Provides methods for handling storage directories, creating directories, saving content, and requesting permissions for android.
 * 
 * @author Mihai Alexandru (M.A. Jigsaw) and Lily Ross (mcagabe19)
 */
class StorageUtil {
	#if sys
	/**
	 * The root directory for application storage.
	 */
	public static final rootDir:String = LimeSystem.applicationStorageDirectory;

	/**
	 * Gets the storage directory based on the platform and optional forced storage type.
	 * 
	 * @param forcedType The optional forced storage type.
	 * @return The path to the storage directory.
	 */
	public static function getStorageDirectory(?forcedType:Null<String>):String {
		var daPath:String = Sys.getCwd();
		#if android
		if (!FileSystem.exists(rootDir + 'storagetype.txt'))
			File.saveContent(rootDir + 'storagetype.txt', Options.getData("storageType"));
		var curStorageType:String = File.getContent(rootDir + 'storagetype.txt');
		if (forcedType != null)
			curStorageType = forcedType;
		daPath = switch (curStorageType) {
			case "EXTERNAL": AndroidEnvironment.getExternalStorageDirectory() + '/.' + lime.app.Application.current.meta.get('file');
			case "OBB": android.content.Context.getObbDir();
			case "MEDIA": AndroidEnvironment.getExternalStorageDirectory() + '/Android/media/' + lime.app.Application.current.meta.get('packageName');
			default: android.content.Context.getExternalFilesDir();
		}
		daPath = haxe.io.Path.addTrailingSlash(daPath);
		#elseif ios
		daPath = LimeSystem.documentsDirectory;
		#else
		daPath = Sys.getCwd();
		#end

		return daPath;
	}

	/**
	 * Saves content to a file in the saves directory.
	 * 
	 * @param fileName The name of the file.
	 * @param fileExtension The extension of the file. Defaults to '.json'.
	 * @param fileData The content to save in the file. Defaults to a placeholder string.
	 */
	public static function saveContent(fileName:String, fileData:String):Void {
		try {
			if (!FileSystem.exists('saves'))
				FileSystem.createDirectory('saves');

			File.saveContent('saves/$fileName', fileData);
			CoolUtil.showPopUp('$fileName has been saved.', "Success!");
		} catch (e:haxe.Exception)
			CoolUtil.coolError('$fileName couldn\'t be saved. (${e.message})');
	}

	#if android
	/**
	 * Requests Android permissions for external storage access.
	 */
	public static function requestPermissions():Void {
		if (AndroidVersion.SDK_INT >= AndroidVersionCode.TIRAMISU)
			AndroidPermissions.requestPermissions(['READ_MEDIA_IMAGES', 'READ_MEDIA_VIDEO', 'READ_MEDIA_AUDIO']);
		else
			AndroidPermissions.requestPermissions(['READ_EXTERNAL_STORAGE', 'WRITE_EXTERNAL_STORAGE']);

		if (!AndroidEnvironment.isExternalStorageManager()) {
			if (AndroidVersion.SDK_INT >= AndroidVersionCode.S)
				AndroidSettings.requestSetting('REQUEST_MANAGE_MEDIA');
			AndroidSettings.requestSetting('MANAGE_APP_ALL_FILES_ACCESS_PERMISSION');
		}

		if ((AndroidVersion.SDK_INT >= AndroidVersionCode.TIRAMISU
			&& !AndroidPermissions.getGrantedPermissions().contains('android.permission.READ_MEDIA_IMAGES'))
			|| (AndroidVersion.SDK_INT < AndroidVersionCode.TIRAMISU
				&& !AndroidPermissions.getGrantedPermissions().contains('android.permission.READ_EXTERNAL_STORAGE')))
			CoolUtil.showPopUp('If you accepted the permissions you are all good!' + '\nIf you didn\'t then expect a crash' + '\nPress OK to see what happens',
				'Notice!');

		try {
			if (!FileSystem.exists(StorageUtil.getStorageDirectory()))
				FileSystem.createDirectory(StorageUtil.getStorageDirectory());
		} catch (e:Dynamic) {
			CoolUtil.showPopUp('Please create folder to\n' + StorageUtil.getStorageDirectory() + '\nPress OK to close the game', 'Error!');
			LimeSystem.exit(1);
		}
	}
	#end
	#end
}

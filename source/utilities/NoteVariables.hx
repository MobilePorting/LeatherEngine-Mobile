package utilities;

class NoteVariables {
	public static var maniaDirections:Array<Array<String>>;
	public static var defaultBinds:Array<Array<String>>;
	public static var animationDirections:Array<Array<String>>;
	public static var characterAnimations:Array<Array<String>>;

	/**
	 * @see https://step-mania.fandom.com/wiki/Notes
	 */
	public static final beats:Array<Int> = [4, 6, 8, 12, 16, 24, 32, 48, 64, 128, 192];

	public static function init() {
		maniaDirections = CoolUtil.coolTextFileOfArrays(Paths.txt("mania data/maniaDirections"));
		defaultBinds = CoolUtil.coolTextFileOfArrays(Paths.txt("mania data/defaultBinds"));
		animationDirections = CoolUtil.coolTextFileOfArrays(Paths.txt("mania data/maniaAnimationDirections"));
		characterAnimations = CoolUtil.coolTextFileOfArrays(Paths.txt("mania data/maniaCharacterAnimations"));
	}
}

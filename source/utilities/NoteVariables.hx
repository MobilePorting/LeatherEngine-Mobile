package utilities;

class NoteVariables {
	public static var maniaDirections:Array<Array<String>>;
	public static var defaultBinds:Array<Array<String>>;
	public static var animationDirections:Array<Array<String>>;
	public static var characterAnimations:Array<Array<String>>;

	public static function init() {
		maniaDirections = CoolUtil.coolTextFileOfArrays(Paths.txt("mania data/maniaDirections"));
		defaultBinds = CoolUtil.coolTextFileOfArrays(Paths.txt("mania data/defaultBinds"));
		animationDirections = CoolUtil.coolTextFileOfArrays(Paths.txt("mania data/maniaAnimationDirections"));
		characterAnimations = CoolUtil.coolTextFileOfArrays(Paths.txt("mania data/maniaCharacterAnimations"));
	}
}

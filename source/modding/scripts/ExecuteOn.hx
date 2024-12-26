package modding.scripts;

enum abstract ExecuteOn(String) to String from String {
    var BOTH = "BOTH";
	var MODCHART = "MODCHART";
	var STAGE = "STAGE";
    var NEVER = "NEVER";
}
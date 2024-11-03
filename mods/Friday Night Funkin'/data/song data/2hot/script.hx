import game.graphics.SpraycanAtlasSprite;

var STATE_ARCING:Int = 2; // In the air.
var STATE_SHOT:Int = 3; // Hit by the player.
var STATE_IMPACTED:Int = 4; // Impacted the player.
var spawnedCans:Array<SpraycanAtlasSprite> = [];

function createPost() {
	for (i in 1...4) { // precache sounds
		FlxG.sound.cache(Paths.sound('shot' + i));
	}
	// precache can
	var cacheCan:SpraycanAtlasSprite = new SpraycanAtlasSprite(0, 0);
}

function playerOneSing(data, time, type) {
	switch (type.toLowerCase()) {
		case "weekend-1-cockgun": // lol
			bf.playAnim("cock", true);
			gunCocked = true;
			new FlxTimer().start(1.0, function() {
				gunCocked = false;
			});
		case "weekend-1-firegun":
			if (gunCocked) {
				trace('Firing gun!');
				bf.playAnim("shoot", true);
				FlxG.sound.play(Paths.soundRandom('shot', 1, 4));
				shootNextCan();
			} else {
				trace('Cannot fire gun!');
			}
	}
}

function playerTwoSing(data, time, type) {
	switch (type.toLowerCase()) {
		case "weekend-1-lightcan":
			dad.playAnim("lightCan", true);
		case "weekend-1-kickcan":
			var newCan:SpraycanAtlasSprite = new SpraycanAtlasSprite(0, 0);

			var spraycanPile = PlayState.instance.stage.getNamedProp('spraycanPile');

			newCan.x = spraycanPile.x - 430;
			newCan.y = spraycanPile.y - 840;
			newCan.playCanStart();

			PlayState.instance.add(newCan);
			spawnedCans.push(newCan);
			dad.playAnim("kickCan", true);
		case "weekend-1-kneecan":
			dad.playAnim("kneeCan", true);
	}
}

function getNextCanWithState(desiredState:Int) {
	for (index in 0...spawnedCans.length) {
		var can = spawnedCans[index];
		var canState = can.currentState;

		if (canState == desiredState) {
			// Return the can we found.
			return can;
		}
	}
	return null;
}

function shootNextCan() {
	var can = getNextCanWithState(STATE_ARCING);

	if (can != null) {
		can.currentState = STATE_SHOT;
		can.playCanShot();

		new FlxTimer().start(1 / 24, function(tmr) {
			darkenStageProps();
		});
	}
}

function darkenStageProps() {
	for (stageProp in  PlayState.instance.stage.members) {
		// If not excluded, darken.
		stageProp.color = 0xFF111111;
		new FlxTimer().start(1 / 24, (tmr) -> {
			stageProp.color = 0xFF222222;
			FlxTween.color(stageProp, 1.4, 0xFF222222, 0xFFFFFFFF);
		});
	}
}

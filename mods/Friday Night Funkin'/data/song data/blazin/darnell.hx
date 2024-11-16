function playerOneSing(a, b, c) {
	switch (c.toLowerCase()) {
		case "weekend-1-punchlow":
			playHitLowAnim();
		case "weekend-1-punchlowblocked":
			playBlockAnim();
		case "weekend-1-punchlowdodged":
			playDodgeAnim();
		case "weekend-1-punchlowspin":
			playSpinAnim();

		case "weekend-1-punchhigh":
			playHitHighAnim();
		case "weekend-1-punchhighblocked":
			playBlockAnim();
		case "weekend-1-punchhighdodged":
			playDodgeAnim();
		case "weekend-1-punchhighspin":
			playSpinAnim();

		// Attempt to punch, Pico dodges or gets hit.
		case "weekend-1-blockhigh":
			playPunchHighAnim();
		case "weekend-1-blocklow":
			playPunchLowAnim();
		case "weekend-1-blockspin":
			playPunchHighAnim();

		// Attempt to punch, Pico dodges or gets hit.
		case "weekend-1-dodgehigh":
			playPunchHighAnim();
		case "weekend-1-dodgelow":
			playPunchLowAnim();
		case "weekend-1-dodgespin":
			playPunchHighAnim();

		// Attempt to punch, Pico ALWAYS gets hit.
		case "weekend-1-hithigh":
			playPunchHighAnim();
		case "weekend-1-hitlow":
			playPunchLowAnim();
		case "weekend-1-hitspin":
			playPunchHighAnim();

		// Fail to dodge the uppercut.
		case "weekend-1-picouppercutprep":
			// Continue whatever animation was playing before
			// playIdleAnim();
		case "weekend-1-picouppercut":
			playUppercutHitAnim();

		// Attempt to punch, Pico dodges or gets hit.
		case "weekend-1-darnelluppercutprep":
			playUppercutPrepAnim();
		case "weekend-1-darnelluppercut":
			playUppercutAnim();

		case "weekend-1-idle":
			playIdleAnim();
	}
	cantUppercut = false;
}

function playerTwoSing(a, b, c) {
	switch (c.toLowerCase()) {
		case "weekend-1-punchlow":
			playHitLowAnim();
		case "weekend-1-punchlowblocked":
			playBlockAnim();
		case "weekend-1-punchlowdodged":
			playDodgeAnim();
		case "weekend-1-punchlowspin":
			playSpinAnim();

		case "weekend-1-punchhigh":
			playHitHighAnim();
		case "weekend-1-punchhighblocked":
			playBlockAnim();
		case "weekend-1-punchhighdodged":
			playDodgeAnim();
		case "weekend-1-punchhighspin":
			playSpinAnim();

		// Attempt to punch, Pico dodges or gets hit.
		case "weekend-1-blockhigh":
			playPunchHighAnim();
		case "weekend-1-blocklow":
			playPunchLowAnim();
		case "weekend-1-blockspin":
			playPunchHighAnim();

		// Attempt to punch, Pico dodges or gets hit.
		case "weekend-1-dodgehigh":
			playPunchHighAnim();
		case "weekend-1-dodgelow":
			playPunchLowAnim();
		case "weekend-1-dodgespin":
			playPunchHighAnim();

		// Attempt to punch, Pico ALWAYS gets hit.
		case "weekend-1-hithigh":
			playPunchHighAnim();
		case "weekend-1-hitlow":
			playPunchLowAnim();
		case "weekend-1-hitspin":
			playPunchHighAnim();

		// Fail to dodge the uppercut.
		case "weekend-1-picouppercutprep":
			// Continue whatever animation was playing before
			// playIdleAnim();
		case "weekend-1-picouppercut":
			playUppercutHitAnim();

		// Attempt to punch, Pico dodges or gets hit.
		case "weekend-1-darnelluppercutprep":
			playUppercutPrepAnim();
		case "weekend-1-darnelluppercut":
			playUppercutAnim();

		case "weekend-1-idle":
			playIdleAnim();
		case "weekend-1-fakeout":
			playCringeAnim();
		case "weekend-1-taunt":
			playPissedConditionalAnim();
		case "weekend-1-tauntforce":
			playPissedAnim();
		case "weekend-1-reversefakeout":
			playFakeoutAnim();
	}
	cantUppercut = false;
}

var cantUppercut:Bool = false;

function willMissBeLethal():Bool {
	return (PlayState.instance.health + 0.035) <= 0.0;
}

function playerOneMiss(a, b, c) {
	if (dad.curAnimName() == 'uppercutPrep') {
		playUppercutAnim();
		return;
	}

	if (willMissBeLethal()) {
		playPunchLowAnim();
		return;
	}

	if (cantUppercut) {
		playPunchHighAnim();
		return;
	}

	// Override the hit note animation.
	switch (c) {
		// Pico tried and failed to punch, punch back!
		case "weekend-1-punchlow":
			playPunchLowAnim();
		case "weekend-1-punchlowblocked":
			playPunchLowAnim();
		case "weekend-1-punchlowdodged":
			playPunchLowAnim();
		case "weekend-1-punchlowspin":
			playPunchLowAnim();

		// Pico tried and failed to punch, punch back!
		case "weekend-1-punchhigh":
			playPunchHighAnim();
		case "weekend-1-punchhighblocked":
			playPunchHighAnim();
		case "weekend-1-punchhighdodged":
			playPunchHighAnim();
		case "weekend-1-punchhighspin":
			playPunchHighAnim();

		// Attempt to punch, Pico dodges or gets hit.
		case "weekend-1-blockhigh":
			playPunchHighAnim();
		case "weekend-1-blocklow":
			playPunchLowAnim();
		case "weekend-1-blockspin":
			playPunchHighAnim();

		// Attempt to punch, Pico dodges or gets hit.
		case "weekend-1-dodgehigh":
			playPunchHighAnim();
		case "weekend-1-dodgelow":
			playPunchLowAnim();
		case "weekend-1-dodgespin":
			playPunchHighAnim();

		// Attempt to punch, Pico ALWAYS gets hit.
		case "weekend-1-hithigh":
			playPunchHighAnim();
		case "weekend-1-hitlow":
			playPunchLowAnim();
		case "weekend-1-hitspin":
			playPunchHighAnim();

		// Successfully dodge the uppercut.
		case "weekend-1-picouppercutprep":
			playHitHighAnim();
			cantUppercut = true;
		case "weekend-1-picouppercut":
			playDodgeAnim();

		// Attempt to punch, Pico dodges or gets hit.
		case "weekend-1-darnelluppercutprep":
			playUppercutPrepAnim();
		case "weekend-1-darnelluppercut":
			playUppercutAnim();

		case "weekend-1-idle":
			playIdleAnim();
		case "weekend-1-fakeout":
			playCringeAnim(); // TODO: Which anim?
		case "weekend-1-taunt":
			playPissedConditionalAnim();
		case "weekend-1-tauntforce":
			playPissed();
		case "weekend-1-reversefakeout":
			playFakeoutAnim(); // TODO: Which anim?
	}

	cantUppercut = false;
}


var alternate:Bool = false;

function doAlternate():String {
	alternate = !alternate;
	return alternate ? '1' : '2';
}

function playBlockAnim() {
	dad.playAnim('block', true, false);
	PlayState.instance.camGame.shake(0.002, 0.1);
	moveToBack();
}

function playCringeAnim() {
	dad.playAnim('cringe', true, false);
	moveToBack();
}

function playDodgeAnim() {
	dad.playAnim('dodge', true, false);
	moveToBack();
}

function playIdleAnim() {
	dad.playAnim('idle', true, false);
	moveToBack();
}

function playFakeoutAnim() {
	dad.playAnim('fakeout', true, false);
	moveToBack();
}

function playPissedConditionalAnim() {
	if (dad.curAnimName() == "cringe") {
		playPissedAnim();
	} else {
		playIdleAnim();
	}
}

function playPissedAnim() {
	dad.playAnim('pissed', true, false);
	moveToBack();
}

function playUppercutPrepAnim() {
	dad.playAnim('uppercutPrep', true, false);
	moveToFront();
}

function playUppercutAnim() {
	dad.playAnim('uppercut', true, false);
	moveToFront();
}

function playUppercutHitAnim() {
	dad.playAnim('uppercutHit', true, false);
	moveToBack();
}

function playHitHighAnim() {
	dad.playAnim('hitHigh', true, false);
	PlayState.instance.camGame.shake(0.0025, 0.15);
	moveToBack();
}

function playHitLowAnim() {
	dad.playAnim('hitLow', true, false);
	PlayState.instance.camGame.shake(0.0025, 0.15);
	moveToBack();
}

function playPunchHighAnim() {
	dad.playAnim('punchHigh' + doAlternate(), true, false);
	moveToFront();
}

function playPunchLowAnim() {
	dad.playAnim('punchLow' + doAlternate(), true, false);
	moveToFront();
}

function playSpinAnim() {
	dad.playAnim('hitSpin', true, false);
	PlayState.instance.camGame.shake(0.0025, 0.15);
	moveToBack();
}

function moveToBack() {
	PlayState.instance.remove(dad);
	PlayState.instance.addBehindBF(dad);
}

function moveToFront() {
	PlayState.instance.remove(bf);
	PlayState.instance.addBehindDad(bf);
}

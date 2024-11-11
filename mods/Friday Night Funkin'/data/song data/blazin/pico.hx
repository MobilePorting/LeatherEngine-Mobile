var cantUppercut:Bool = false;

function isPlayerLowHealth():Bool {
	return PlayState.instance.health <= 0.30 * 2.0;
}

function isDarnellPreppingUppercut():Void {
	return dad.curAnimName() == 'uppercutPrep';
}

function playerOneSing(a, b, c) {
	var shouldDoUppercutPrep = isPlayerLowHealth() && isDarnellPreppingUppercut();

	if (shouldDoUppercutPrep) {
		playPunchHighAnim();
		return;
	}

	if (cantUppercut) {
		playBlockAnim();
		cantUppercut = false;
		return;
	}
	switch (c.toLowerCase()) {
		case "weekend-1-punchlow":
			playPunchLowAnim();
		case "weekend-1-punchlowblocked":
			playPunchLowAnim();
		case "weekend-1-punchlowdodged":
			playPunchLowAnim();
		case "weekend-1-punchlowspin":
			playPunchLowAnim();

		case "weekend-1-punchhigh":
			playPunchHighAnim();
		case "weekend-1-punchhighblocked":
			playPunchHighAnim();
		case "weekend-1-punchhighdodged":
			playPunchHighAnim();
		case "weekend-1-punchhighspin":
			playPunchHighAnim();

		case "weekend-1-blockhigh":
			playBlockAnim();
		case "weekend-1-blocklow":
			playBlockAnim();
		case "weekend-1-blockspin":
			playBlockAnim();

		case "weekend-1-dodgehigh":
			playDodgeAnim();
		case "weekend-1-dodgelow":
			playDodgeAnim();
		case "weekend-1-dodgespin":
			playDodgeAnim();

		// Pico ALWAYS gets punched.
		case "weekend-1-hithigh":
			playHitHighAnim();
		case "weekend-1-hitlow":
			playHitLowAnim();
		case "weekend-1-hitspin":
			playHitSpinAnim();

		case "weekend-1-picouppercutprep":
			playUppercutPrepAnim();
		case "weekend-1-picouppercut":
			playUppercutAnim(true);

		case "weekend-1-darnelluppercutprep":
			playIdleAnim();
		case "weekend-1-darnelluppercut":
			playUppercutHitAnim();

		case "weekend-1-idle":
			playIdleAnim();
		case "weekend-1-fakeout":
			playFakeoutAnim();
		case "weekend-1-taunt":
			playTauntConditionalAnim();
		case "weekend-1-tauntforce":
			playTauntAnim();
		case "weekend-1-reversefakeout":
			playIdleAnim();
	}
}

function isDarnellInUppercut():Void {
	return
		dad.curAnimName() == 'uppercut'
		|| dad.curAnimName() == 'uppercut-hold';
}

function willMissBeLethal():Bool {
	return (PlayState.instance.health + 0.035) <= 0.0;
}

function playerOneMiss(a, b, c) {

	if (isDarnellInUppercut()) {
		playUppercutHitAnim();
		return;
	}

	if (willMissBeLethal()) {
		playHitLowAnim();
		return;
	}

	if (cantUppercut) {
		playHitHighAnim();
		return;
	}

	switch (c.toLowerCase()) {
		case "weekend-1-punchlow":
			playHitLowAnim();
		case "weekend-1-punchlowblocked":
			playHitLowAnim();
		case "weekend-1-punchlowdodged":
			playHitLowAnim();
		case "weekend-1-punchlowspin":
			playHitSpinAnim();

		// Pico fails to punch, and instead gets hit!
		case "weekend-1-punchhigh":
			playHitHighAnim();
		case "weekend-1-punchhighblocked":
			playHitHighAnim();
		case "weekend-1-punchhighdodged":
			playHitHighAnim();
		case "weekend-1-punchhighspin":
			playHitSpinAnim();

		// Pico fails to block, and instead gets hit!
		case "weekend-1-blockhigh":
			playHitHighAnim();
		case "weekend-1-blocklow":
			playHitLowAnim();
		case "weekend-1-blockspin":
			playHitSpinAnim();

		// Pico fails to dodge, and instead gets hit!
		case "weekend-1-dodgehigh":
			playHitHighAnim();
		case "weekend-1-dodgelow":
			playHitLowAnim();
		case "weekend-1-dodgespin":
			playHitSpinAnim();

		// Pico ALWAYS gets punched.
		case "weekend-1-hithigh":
			playHitHighAnim();
		case "weekend-1-hitlow":
			playHitLowAnim();
		case "weekend-1-hitspin":
			playHitSpinAnim();

		// Fail to dodge the uppercut.
		case "weekend-1-picouppercutprep":
			playPunchHighAnim();
			cantUppercut = true;
		case "weekend-1-picouppercut":
			playUppercutAnim(false);

		// Darnell's attempt to uppercut, Pico dodges or gets hit.
		case "weekend-1-darnelluppercutprep":
			playIdleAnim();
		case "weekend-1-darnelluppercut":
			playUppercutHitAnim();

		case "weekend-1-idle":
			playIdleAnim();
		case "weekend-1-fakeout":
			playHitHighAnim();
		case "weekend-1-taunt":
			playTauntConditionalAnim();
		case "weekend-1-tauntforce":
			playTauntAnim();
		case "weekend-1-reversefakeout":
			playIdleAnim();
	}
}

var alternate:Bool = false;

function doAlternate():String {
	alternate = !alternate;
	return alternate ? '1' : '2';
}

function playBlockAnim() {
	bf.playAnim('block', true, false);
	PlayState.instance.camGame.shake(0.002, 0.1);
	moveToBack();
}

function playCringeAnim() {
	bf.playAnim('cringe', true, false);
	moveToBack();
}

function playDodgeAnim() {
	bf.playAnim('dodge', true, false);
	moveToBack();
}

function playIdleAnim() {
	bf.playAnim('idle', false, false);
	moveToBack();
}

function playFakeoutAnim() {
	bf.playAnim('fakeout', true, false);
	moveToBack();
}

function playUppercutPrepAnim() {
	bf.playAnim('uppercutPrep', true, false);
	moveToFront();
}

function playUppercutAnim(hit:Bool) {
	bf.playAnim('uppercut', true, false);
	if (hit) {
		PlayState.instance.camGame.shake(0.005, 0.25);
	}
	moveToFront();
}

function playUppercutHitAnim() {
	bf.playAnim('uppercutHit', true, false);
	PlayState.instance.camGame.shake(0.005, 0.25);
	moveToBack();
}

function playHitHighAnim() {
	bf.playAnim('hitHigh', true, false);
	PlayState.instance.camGame.shake(0.0025, 0.15);
	moveToBack();
}

function playHitLowAnim() {
	bf.playAnim('hitLow', true, false);
	PlayState.instance.camGame.shake(0.0025, 0.15);
	moveToBack();
}

function playHitSpinAnim() {
	bf.playAnim('hitSpin', true, false, true);
	PlayState.instance.camGame.shake(0.0025, 0.15);
	moveToBack();
}

function playPunchHighAnim() {
	bf.playAnim('punchHigh' + doAlternate(), true, false);
	moveToFront();
}

function playPunchLowAnim() {
	bf.playAnim('punchLow' + doAlternate(), true, false);
	moveToFront();
}

function playTauntConditionalAnim() {
	if (bf.curAnimName() == "fakeout") {
		playTauntAnim();
	} else {
		playIdleAnim();
	}
}

function playTauntAnim() {
	bf.playAnim('taunt', true, false);
	moveToBack();
}

function moveToBack() {
	PlayState.instance.remove(bf);
	PlayState.instance.addBehindDad(bf);
}

function moveToFront() {
	PlayState.instance.remove(dad);
	PlayState.instance.addBehindBF(dad);
}

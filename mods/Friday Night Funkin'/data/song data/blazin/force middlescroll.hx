function createPost() {
    if(Options.getData("middlescroll")) return;
    for(strum in PlayState.playerStrums)
        strum.x -= ((FlxG.width / 2) * 0.5);
    for(strum in PlayState.enemyStrums)
        strum.x -= 1000;
}
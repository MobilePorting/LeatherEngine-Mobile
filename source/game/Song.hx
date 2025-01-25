package game;

import game.SongLoader;

@:deprecated("Use SongLoader instead!")
@:keep
class Song{
    public function loadFromJson(difficulty:String, ?folder:String):SongData {
        return SongLoader.loadFromJson(difficulty, folder);
    }
}
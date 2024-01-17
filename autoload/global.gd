extends Node

enum GameMode {
    ATTRACT,
    PLAYING,
    PAUSED,
    GAME_OVER
}
var game_mode:GameMode = GameMode.ATTRACT
var game_paused:bool = false

var teams: Array = []
var players: Dictionary = {}

extends CanvasLayer
class_name MainMenuUI

var IsActive:bool:
	get:
		return !_anim_player.is_playing() && self.visible

var _anim_player:AnimationPlayer

func _ready():
	_anim_player = self.find_children("", "AnimationPlayer", false)[0]

func play_start_anim():
	_anim_player.play("start_game")

func reset():
	if _anim_player != null:
		_anim_player.play("RESET")

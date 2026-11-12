extends CanvasLayer
class_name DeathUI

var _anim_player:AnimationPlayer

func _ready():
	_anim_player = self.find_children("", "AnimationPlayer", false)[0]

func play_death_anim():
	_anim_player.play("death_screen")

func reset():
	if _anim_player != null:
		_anim_player.play("RESET")

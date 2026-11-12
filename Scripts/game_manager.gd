extends Node
class_name GameManager

static var Instance:GameManager:
	get:
		return _instance
static var _instance:GameManager

var Play_Scene:Node2D:
	get:
		return _play_scene

@export var _play_scene:Node2D
@export var _pause_ui:PauseUI
@export var _death_ui:DeathUI

var _is_game_over:bool = false

func _ready():
	if _instance == null:
		_instance = self
	else:
		self.queue_free()

func _input(event):
	if _is_game_over && event.is_action_pressed("Restart"):
		#quick and dirty method of restarting game
		get_tree().call_deferred("reload_current_scene")

func game_over():
	pause_game(true)
	_death_ui.play_death_anim()
	_is_game_over = true

func pause_game(do_pause:bool):
	_play_scene.process_mode = (
		Node.PROCESS_MODE_DISABLED if do_pause else Node.PROCESS_MODE_INHERIT)
		
	if _pause_ui:
		_pause_ui.visible = do_pause

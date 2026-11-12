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
@export var _pause_ui:CanvasLayer

func _ready():
	if _instance == null:
		_instance = self
	else:
		self.queue_free()

func pause_game(do_pause:bool):
	_play_scene.process_mode = (
		Node.PROCESS_MODE_DISABLED if do_pause else Node.PROCESS_MODE_INHERIT)
		
	if _pause_ui:
		_pause_ui.visible = do_pause

func play_game():
	_play_scene.process_mode = Node.PROCESS_MODE_INHERIT
	_play_scene.visible = true

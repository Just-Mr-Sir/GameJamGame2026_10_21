extends Node
class_name GameManager

static var Instance:GameManager:
	get:
		return _instance
static var _instance:GameManager

signal sig_game_over

var Play_Scene:Node2D:
	get:
		return _play_scene_instance

@export var _play_scene_prefab:PackedScene
@export var _pause_ui:PauseUI
@export var _death_ui:DeathUI
@export var _main_menu_ui:MainMenuUI
@export var _background_music:AudioStreamPlayer

var _play_scene_instance:Node2D
var _is_game_over:bool = false

func _ready():
	if _instance == null:
		_instance = self
	else:
		self.queue_free()
	
	_main_menu_ui.visible = true
	_pause_ui.visible = false

func _input(event):
	if _is_game_over && event.is_action_pressed("Restart"):
		#quick and dirty method of restarting game
		start_game()
	elif _main_menu_ui.IsActive && event is InputEventKey && event.pressed && !event.echo:
		start_game()

func start_game():
	_is_game_over = false
	_death_ui.reset()
	_background_music.restart()
	
	#check if game is started from main menu
	if _main_menu_ui.IsActive:
		_main_menu_ui.play_start_anim()
	
	#make new play scene
	if _play_scene_instance:
		_play_scene_instance.queue_free()
	
	var instance = _play_scene_prefab.instantiate()
	_play_scene_instance = instance
	get_tree().current_scene.add_child(_play_scene_instance)

func game_over():
	pause_game(true, false)
	_death_ui.play_death_anim()
	_is_game_over = true
	sig_game_over.emit()

func pause_game(do_pause:bool, show_ui:bool=true):
	if _is_game_over || _main_menu_ui.IsActive:
		return
	
	_play_scene_instance.process_mode = (
		Node.PROCESS_MODE_DISABLED if do_pause else Node.PROCESS_MODE_INHERIT)
		
	if _pause_ui and show_ui:
		_pause_ui.visible = do_pause
	
	_background_music.playing = !do_pause

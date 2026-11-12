extends CanvasLayer
class_name ProgressUI

@export var _progress_texture:TextureRect
@export var _player:Node2D
@export var _killing_floor:Node2D
@export var _y_end:float

var _y_start:float
#width as a percentage of total length
var _player_line_width:float = 0.05
var _gradient:Gradient

func _ready():
	_y_start = _killing_floor.global_position.y
	_gradient = _progress_texture.texture.gradient
	
	GameManager.Instance.sig_game_over.connect(_on_game_over)

func _process(_delta):
	var diff1 = abs(_killing_floor.global_position.y - _y_start)
	var diff2 = diff1 + abs(_player.global_position.y - _killing_floor.global_position.y)
	var diff3 = diff2 + _player_line_width * abs(_y_end-_y_start)
	_gradient.offsets = PackedFloat32Array([
		0,
		diff1 / abs(_y_end),
		diff2 / abs(_y_end),
		diff3 / abs(_y_end)
		])

func _on_game_over():
	self.visible = false

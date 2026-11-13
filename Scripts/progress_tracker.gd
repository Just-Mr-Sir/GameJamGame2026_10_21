extends Node
class_name ProgressTracker

var Progress:float:
	get:
		return abs(_player.global_position.y-_y_start) / _dis
var Y_Start:float:
	get:
		return _y_start
var Y_End:float:
	get:
		return _y_end

@export var _y_end:float = -27000
@export var _player:Node2D

var _y_start:float
var _dis:float

func _ready():
	_y_start = _player.global_position.y
	_dis = abs(_y_end-_y_start)

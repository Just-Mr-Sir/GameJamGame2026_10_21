extends Node2D

@export var _falling_objects:Array[PackedScene]
@export var _flat_spawntime:float
@export var _initial_delay:float
@export var _time_til_spawntime_decrease:float
@export var _spawntime_decrease_amount:float
@export var _spawn_area_width:float

var _delay_time:float
var _cur_time:float
var _cur_time_tile_spawntime_decrease:float
var _spawn_time:float

func _ready():
	_spawn_time = _flat_spawntime

func _process(delta:float):
	if _delay_time < _initial_delay:
		_delay_time += delta
		return
	
	_cur_time += delta
	
	if _cur_time >= _spawn_time:
		_spawn_item()
		_cur_time = 0
	
	_cur_time_tile_spawntime_decrease += delta
	
	if _cur_time_tile_spawntime_decrease >= _time_til_spawntime_decrease:
		_spawn_time = max(0.1,
			_spawn_time - _spawntime_decrease_amount)
		_cur_time_tile_spawntime_decrease = 0

func _spawn_item():
	var instance = _falling_objects[
					randi_range(0, _falling_objects.size()-1)
					].instantiate()
	instance.global_position.x = randf_range(-1, 1) * _spawn_area_width
	instance.global_position.y = self.global_position.y
	GameManager.Instance.Play_Scene.add_child(instance)

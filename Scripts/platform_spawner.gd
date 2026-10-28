extends Node2D

@export var _falling_objects:Array[PackedScene]
@export var _flat_spawntime:float
@export var _spawn_area_width:float

var _cur_time:float

func _process(delta:float):
	_cur_time += delta
	
	if _cur_time >= _flat_spawntime:
		_spawn_item()
		_cur_time = 0

func _spawn_item():
	var instance = _falling_objects[
					randi_range(0, _falling_objects.size()-1)
					].instantiate()
	instance.global_position.x = randf_range(-1, 1) * _spawn_area_width
	self.add_child(instance)

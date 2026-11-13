extends Node2D

@export var _falling_objects:Array[PackedScene]
#defines the spawn delay depending how far the
#player has progressed in the level.
@export var _spawntime_curve:Curve
@export var _progress_tracker:ProgressTracker
@export var _spawn_area_width:float
@export var _initial_delay:float

var _delay_time:float
var _cur_time:float

func _process(delta:float):
	if _delay_time < _initial_delay:
		_delay_time += delta
		return
	
	_cur_time += delta
	
	if _cur_time >= _spawntime_curve.sample(_progress_tracker.Progress):
		_spawn_item()
		_cur_time = 0

func _spawn_item():
	var instance = _falling_objects[
					randi_range(0, _falling_objects.size()-1)
					].instantiate()
	instance.global_position.x = randf_range(-1, 1) * _spawn_area_width
	instance.global_position.y = self.global_position.y
	GameManager.Instance.Play_Scene.add_child(instance)

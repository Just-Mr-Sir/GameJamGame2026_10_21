extends Node2D

#time until the shard starts to become transparent
@export var _time_until_trans_start:float = 1.
#the total time it takes to become completely transparent
@export var _trans_time:float = 1.
#range of randomized break force allowed
@export var _break_force:Vector2 = Vector2(100, 150)
@export var _break_torque:Vector2 = Vector2(10, 20)

var _shards:Array[RigidBody2D]
var _cur_trans_eta:float
var _cur_trans_time:float

func _ready():
	for child in get_children():
		if child is RigidBody2D:
			_shards.append(child)
			apply_random_velocity(child)
			apply_random_rotation(child)

func _process(delta:float):
	if _cur_trans_eta > _time_until_trans_start:
		_cur_trans_time += delta
		
		if _cur_trans_time > _trans_time:
			self.queue_free()
		else:
			for body in _shards:
				body.modulate.a = 1. - _cur_trans_time / _trans_time
	else:
		_cur_trans_eta += delta

func apply_random_velocity(body):
	var force_mag = randf_range(_break_force.x, _break_force.y)
	var dir = (body.global_position - self.global_position).normalized()
	#ensure shards bounce upwards
	dir.y = -abs(dir.y)
	
	body.linear_velocity = force_mag*dir

func apply_random_rotation(body):
	body.angular_velocity = randi_range(-1, 1) * randf_range(_break_torque.x, _break_torque.y)

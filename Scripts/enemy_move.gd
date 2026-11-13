extends RigidBody2D
class_name EnemyMove

@export var _speed:float
#the length of time between when an enemy reaches a waypoint
#and when they start to travel to the next waypoint.
@export var _waypoint_pause_length:float
#waypoints for the enemy to move along, relative to the player
@export var _rel_waypoints:Array[Vector2]

var _rel_pos: Vector2:
	get:
		return self.global_position - _origin_pos
var _origin_pos:Vector2
var _next_waypoint_index:int
var _cur_pause_time:float

func _ready():
	_origin_pos = self.global_position

func _process(delta:float):
	_cur_pause_time += delta
	
	if _rel_waypoints.size() == 0 || _cur_pause_time < _waypoint_pause_length:
		return
	
	_move(delta)
	
	#check if has reached waypoint
	if _rel_pos.is_equal_approx(_rel_waypoints[_next_waypoint_index]):
		_next_waypoint_index = (0 if _next_waypoint_index >= _rel_waypoints.size()-1
								else _next_waypoint_index + 1)
		_cur_pause_time = 0

func _move(_delta:float) -> void:
	if _rel_waypoints.size() == 0:
		return
	
	var dir = _rel_waypoints[_next_waypoint_index] - _rel_pos
	dir = dir.normalized()
	self.linear_velocity = _speed * dir
	
	#snap to waypoint if enemy has "gone past" it
	var from_index = _rel_waypoints.size()-1 if _next_waypoint_index == 0 else _next_waypoint_index-1
	var waypoint_dir = _rel_waypoints[_next_waypoint_index] - _rel_waypoints[from_index]
	if dir.dot(waypoint_dir) < 0:
		self.global_position = _origin_pos + _rel_waypoints[_next_waypoint_index]

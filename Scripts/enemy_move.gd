extends Area2D
class_name Enemy

@export var _speed:float
#waypoints for the enemy to move along, relative to the player
@export var _rel_waypoints:Array[Vector2]

var _rel_pos: Vector2:
	get:
		return self.global_position - _origin_pos
var _origin_pos:Vector2
var _next_waypoint_index:int

func _ready():
	_origin_pos = self.global_position
	$Sprite2D.play("turkey")

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if _rel_waypoints.size() == 0:
		return
	
	var dir = _rel_waypoints[_next_waypoint_index] - _rel_pos
	dir = dir.normalized()
	state.linear_velocity = _speed * dir
	
	#snap to waypoint if enemy has "gone past" it
	var from_index = _rel_waypoints.size()-1 if _next_waypoint_index == 0 else _next_waypoint_index-1
	var waypoint_dir = _rel_waypoints[_next_waypoint_index] - _rel_waypoints[from_index]
	if dir.dot(waypoint_dir) < 0:
		self.global_position = _origin_pos + _rel_waypoints[_next_waypoint_index]

func _process(delta:float):
	if _rel_waypoints.size() == 0:
		return
	
	if _rel_pos.is_equal_approx(_rel_waypoints[_next_waypoint_index]):
		_next_waypoint_index = (0 if _next_waypoint_index >= _rel_waypoints.size()-1
								else _next_waypoint_index + 1)

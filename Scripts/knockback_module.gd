extends Node2D

@export var _area2d:Area2D
@export var _hit_filters:Array[String]
@export var _bounce_force:float

func _ready():
	_area2d.body_entered.connect(_on_body_entered)

func _on_body_entered(body:Node):
	for filter in _hit_filters:
		if body.is_in_group(filter):
			var dir:Vector2 = body.global_position - _area2d.global_position
			dir = dir.normalized()
			if body is PlayerMove:
				body.velocity = _bounce_force * dir
				body.become_bounced()
			elif body is RigidBody2D:
				body.apply_force(_bounce_force * dir)
			break

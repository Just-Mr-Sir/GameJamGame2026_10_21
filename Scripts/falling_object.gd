extends Area2D

@export var _hit_filters:Array[String]

func _ready():
	self.body_entered.connect(_on_body_entered)

func _process(delta:float):
	self.global_position.y += 245*delta #gravity

func _on_body_entered(body:Node2D):
	if body.is_in_group("Player"):
		(body as PlayerMove).stun()
	
	for filter in _hit_filters:
		if body.is_in_group(filter):
			self.queue_free()
			break

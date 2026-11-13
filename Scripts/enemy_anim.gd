extends AnimatedSprite2D
class_name EnemyAnim

@export var _idle_anim_name:String
@export var _do_flip_going_right:bool = false
@export var _offset_on_flip:Vector2

var _last_pos:Vector2

func _ready():
	self.play(_idle_anim_name)

func _process(_delta: float) -> void:
	#if not moving, don't flip sprite
	if !is_zero_approx(self.global_position.x - _last_pos.x):
		if self.global_position.x - _last_pos.x > 0:
			self.flip_h = _do_flip_going_right
		else:
			self.flip_h = !_do_flip_going_right
		
		if self.flip_h:
			self.offset = _offset_on_flip
		else:
			self.offset = Vector2.ZERO
	
	_last_pos.x = self.global_position.x

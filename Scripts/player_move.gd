extends CharacterBody2D
class_name PlayerMove

@export var _anim_sprite:AnimatedSprite2D
@export var _max_speed:float
@export var _ground_acceleration:float
@export var _airborne_acceleration:float
@export var _jump_velocity = -400.0
@export var _gravity_mult = 1.0
@export var _time_stunned:float = 1.

var _cur_stun_time:float
var _is_bounced:bool = false

func _process(delta:float):
	_cur_stun_time -= delta

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta * _gravity_mult
	
	if !_is_bounced && _cur_stun_time < 0:
		# Handle jump.
		if Input.is_action_just_pressed("Jump") and is_on_floor():
			velocity.y = _jump_velocity
			_anim_sprite.play("jump")
		
		# Get the input direction and handle the movement/deceleration.
		var direction := Input.get_axis("MoveLeft", "MoveRight")
		var acc:float = (_ground_acceleration if is_on_floor()
			else _airborne_acceleration)
		
		if direction:
			velocity.x = min(
				_max_speed,
				velocity.x + direction*acc
			)
			if is_on_floor():
				_anim_sprite.play("walk")
			if direction < 0:
				_anim_sprite.flip_h = true
			else:
				_anim_sprite.flip_h = false
		else:
			#slow down to a stop
			velocity.x = move_toward(velocity.x, 0, 20.)
			if is_on_floor():
				_anim_sprite.play("idle")
	
	move_and_slide()
	
	try_stop_bounced()

func become_bounced():
	_is_bounced = true

func try_stop_bounced():
	#stops being bounced if has collided with anything
	if get_slide_collision_count() > 0:
		_is_bounced = false

func stun():
	_cur_stun_time = _time_stunned

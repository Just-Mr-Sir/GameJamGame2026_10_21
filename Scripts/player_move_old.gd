extends CharacterBody2D
class_name Player

@export var _speed = 300.0
@export var _jump_velocity = -400.0
@export var _gravity_mult = 1.0

var _is_bounced:bool = false

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta * _gravity_mult
	
	if !_is_bounced:
		# Handle jump.
		if Input.is_action_just_pressed("Jump") and is_on_floor():
			velocity.y = _jump_velocity
		
		# Get the input direction and handle the movement/deceleration.
		var direction := Input.get_axis("MoveLeft", "MoveRight")
		if direction:
			velocity.x = direction * _speed
		else:
			velocity.x = move_toward(velocity.x, 0, _speed)
	
	move_and_slide()
	
	try_stop_bounced()

func become_bounced():
	_is_bounced = true

func try_stop_bounced():
	#stops being bounced if has collided with anything
	if get_slide_collision_count() > 0:
		_is_bounced = false

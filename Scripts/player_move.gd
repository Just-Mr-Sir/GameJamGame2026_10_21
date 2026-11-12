extends CharacterBody2D
class_name PlayerMove

@export var _anim_sprite:AnimatedSprite2D
@export var _confusion_sprite:Sprite2D
@export var _max_speed:float
@export var _ground_acceleration:float
@export var _airborne_acceleration:float
@export var _normal_gravity = 1.0
@export var _min_jump_gravity = 0.5
@export var _max_jump_gravity = 0.8
@export var _gravity_lose_rate:float
@export var _move_down_gravity:float = 3
@export var _jump_force:float
@export var _time_stunned:float = 1.

var _cur_stun_time:float
var _cur_gravity:float
var _is_bounced:bool = false
var _is_dead:bool = false

func _process(delta:float):
	_cur_stun_time -= delta

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta * _cur_gravity
	
	if !_is_dead:
		if !_is_bounced && _cur_stun_time < 0:
			_confusion_sprite.visible = false
			
			# Handle jumping
			if Input.is_action_just_pressed("Jump") and is_on_floor():
				_cur_gravity = _max_jump_gravity
				velocity.y -= _jump_force
			elif Input.is_action_pressed("Jump") && velocity.y < 0:
				_cur_gravity = max(_min_jump_gravity,
					_cur_gravity - _gravity_lose_rate)
			elif Input.is_action_just_pressed("MoveDown"):
				_cur_gravity = _move_down_gravity
			else:
				_cur_gravity = _normal_gravity
			
			# Get the input direction and handle the movement/deceleration.
			var direction := Input.get_axis("MoveLeft", "MoveRight")
			var acc:float = (_ground_acceleration if is_on_floor()
				else _airborne_acceleration)
			
			if direction:
				velocity.x = min(
					_max_speed,
					velocity.x + direction*acc
				)
				if direction < 0:
					_anim_sprite.flip_h = true
				else:
					_anim_sprite.flip_h = false
			else:
				#slow down to a stop
				velocity.x = move_toward(velocity.x, 0, 20.)
		else:
			#slow down to a stop
			velocity.x = move_toward(velocity.x, 0, 20.)
		
		play_animations()
	
	move_and_slide()
	try_stop_bounced()

func play_animations():
	if Input.is_action_just_pressed("Jump"):
		_anim_sprite.play("jump")
	#play other animations only if not jumping or
	# is jumping but is on floor
	elif (_anim_sprite.animation != "jump" || is_on_floor()):
		if velocity.x != 0:
			_anim_sprite.play("walk")
		else:
			_anim_sprite.play("idle")

func become_bounced():
	_is_bounced = true

func try_stop_bounced():
	#stops being bounced if has collided with anything
	if get_slide_collision_count() > 0:
		_is_bounced = false

func stun():
	_cur_stun_time = _time_stunned
	_confusion_sprite.visible = true

func die():
	if _is_dead:
		return
	
	_is_dead = true
	_anim_sprite.play("death")
	#for a "fun" death bounce
	velocity.y = -500
	_cur_gravity = _normal_gravity
	velocity.x = 0

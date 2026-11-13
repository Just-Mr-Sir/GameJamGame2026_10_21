extends Node2D
class_name Chimney

@export var _player:Node2D
@export var _killing_floor:Node2D
@export var _platform_scenes:Array[PackedScene]
@export var _speed_per_second_increase:float
@export var _progress_tracker:ProgressTracker

const base_speed = 50
const jumpheight = 140

var speed:float:
	get:
		return base_speed + speed_mod
var speed_mod = 0
var platform
var camera: Camera2D
var nextplatform
var platformlist: Array
var platform_count = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	camera = get_node("Camera2D")
	var nplatforms = floor(camera.get_viewport_rect().size.y / jumpheight)-1
	for i in nplatforms:
		generate_platform(camera.position.y + jumpheight * i)
	nextplatform = jumpheight


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Move objects and background down at a constant speed
	camera.position.y = camera.position.y - speed * delta
	if (camera.position.y - jumpheight * 2 <= -nextplatform &&
		-nextplatform-jumpheight > _progress_tracker.Y_End):
		generate_platform(-nextplatform)
		nextplatform += jumpheight
	
	#move camera if player far enough vertically
	var diff_upper = (camera.global_position.y + 
		0.45 * camera.get_viewport_rect().size.y - _player.global_position.y)
	var diff_lower = (camera.global_position.y + 
		0.65 * camera.get_viewport_rect().size.y - _player.global_position.y)
	if diff_upper > 0:
		camera.position.y -= diff_upper*delta
	elif diff_lower < 0:
		#lower camera only so far
		camera.position.y = min(camera.position.y-25*diff_lower*delta,
						_killing_floor.position.y - 0.75*camera.get_viewport_rect().size.y)
	
	#move killing floor slightly faster than camera
	_killing_floor.global_position.y -= 1.01 * speed * delta
	
	#increase speed of camera movement
	speed_mod += _speed_per_second_increase * delta
	
	free_below_killzone()

func free_below_killzone():
	for i in platformlist:
		if i.global_position.y >= _killing_floor.global_position.y:
			platformlist.erase(i)
			i.queue_free()

#DEPRECATED
func free_below_camera():
	for i in platformlist:
		if i.position.y >= camera.get_viewport_rect().size.y + camera.position.y:
			platformlist.erase(i)
			i.queue_free()
	
	if (_player != null && _player.global_position.y  >= 
		camera.get_viewport_rect().size.y + camera.position.y):
			_player.queue_free()

func generate_platform(y):
	var newplatform = _platform_scenes[1 if platform_count % 10 == 0 else 0].instantiate()
	newplatform.position.y = y
	var platform_sprite:Node2D = newplatform.find_child("PlatformSprite")
	newplatform.position.x = randi_range(0.5*platform_sprite.texture.get_width() * platform_sprite.scale.x, \
		camera.get_viewport_rect().size.x - 0.5*platform_sprite.texture.get_width() * platform_sprite.scale.x)
	self.add_child(newplatform)
	platformlist.append(newplatform)
	
	platform_count += 1

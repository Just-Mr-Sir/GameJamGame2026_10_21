extends Node2D

@export var _player:Node2D
const speed = 50
const jumpheight = 140
var platform
var camera: Camera2D
var nextplatform
var platformlist: Array

# Called when the node enters the scene tree for the first time.
func _ready():
	platform = get_node("Platform")
	camera = get_node("Camera2D")
	var nplatforms = floor(camera.get_viewport_rect().size.y / jumpheight)
	for i in nplatforms:
		generate_platform(camera.position.y + jumpheight * i)
	nextplatform = jumpheight


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Move objects and background down at a constant speed
	camera.position.y = camera.position.y - speed * delta
	if camera.position.y - jumpheight * 2 <= -nextplatform:
		generate_platform(-nextplatform)
		nextplatform += jumpheight
	for i in platformlist:
		if i.position.y >= camera.get_viewport_rect().size.y + camera.position.y:
			platformlist.erase(i)
			i.queue_free()
	
	if (_player != null && _player.global_position.y  >= 
		camera.get_viewport_rect().size.y + camera.position.y):
			_player.queue_free()

func generate_platform(y):
	var newplatform = platform.duplicate()
	newplatform.visible = true
	newplatform.position.y = y
	newplatform.position.x = randi_range(0, \
		camera.get_viewport_rect().size.x - newplatform.find_child("PlatformSprite").texture.get_width())
	self.add_child(newplatform)
	platformlist.append(newplatform)
	
	pass

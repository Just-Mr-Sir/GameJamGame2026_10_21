extends Sprite2D

@export var _camera:Camera2D

func _process(_delta):
	self.region_rect.position.y = _camera.position.y

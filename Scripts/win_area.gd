extends Area2D

@export var _progress_tracker:ProgressTracker
@export var _win_spot:Node2D
@export var _hard_stoppers:Array[Node]
@export var _kill_floor:KillingFloor
@export var _chimney:Chimney
@export var _camera:Camera2D
@export var _anim_player:AnimationPlayer

var _dis:float
var _is_winning:bool
var _player:PlayerMove

func _ready():
	self.visible = false
	self.monitoring = false

func _process(delta:float):
	if !_is_winning:
		if _dis == 0:
			_dis = abs(_progress_tracker.Y_End - _progress_tracker.Y_Start)
		
		if !self.visible && _progress_tracker.Progress * _dis > _dis-1000:
			_initialize_win_area()
	else:
		var step:float = 75*delta
		var diff = _win_spot.global_position-_player.global_position
		if diff.length() < step:
			_player.global_position = _win_spot.global_position
		else:
			_player.global_position += 100*delta*(diff).normalized()
		_camera.global_position.y = move_toward(
			_camera.global_position.y,
			(_player.global_position.y - 0.8*_camera.get_viewport_rect().size.y),
			5
			)

func _initialize_win_area():
	self.visible = true
	self.monitoring = true
	
	self.global_position.y = _progress_tracker.Y_End

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		_player = body
		_player.win()
		_is_winning = true
		
		for node in _hard_stoppers:
			node.queue_free()
		
		#janky way of stopping the killing floor without removing it
		_chimney.call_deferred("set_script", null)
		
		#stop the fire sounds
		if _kill_floor.find_child("AudioStreamPlayer"):
			_kill_floor.find_child("AudioStreamPlayer").queue_free()
		
		GameManager.Instance.game_win()
		
		_anim_player.play("default")

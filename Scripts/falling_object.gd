extends Area2D

@export var _hit_filters:Array[String]
@export var _shards_scene:PackedScene
@export var _fall_speed:float = 245.
@export var _break_sounds:Array[AudioStream]

func _ready():
	self.body_entered.connect(_on_body_entered)

func _process(delta:float):
	#gravity
	self.global_position.y += _fall_speed*delta

func _on_body_entered(body:Node2D):
	if body.is_in_group("Player"):
		(body as PlayerMove).stun()
	
	for filter in _hit_filters:
		if body.is_in_group(filter):
			if _shards_scene != null:
				var instance = _shards_scene.instantiate()
				instance.global_position = self.global_position
				GameManager.Instance.Play_Scene.call_deferred("add_child", instance)
			
			if len(_break_sounds) > 0:
				var stream_player = find_children("", "AudioStreamPlayer2D")[0]
				stream_player.stream = _break_sounds[randi_range(0, len(_break_sounds)-1)]
				stream_player.play()
				stream_player.reparent(self.get_parent())
			
			self.queue_free()
			break

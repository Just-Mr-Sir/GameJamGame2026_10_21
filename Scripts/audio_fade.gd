extends Node

@export var _audio_stream:AudioStreamPlayer
@export var _listener:Node2D
@export var _producer:Node2D
@export var _db_start = 0

func _process(_delta:float):
	var dis:float = (_listener.global_position - _producer.global_position).length()
	_audio_stream.volume_db = max(-80, -pow(8, dis/1000) + _db_start)
	print(_audio_stream.volume_db)

extends AudioStreamPlayer2D

func _ready():
	self.finished.connect(_on_finished)

func _on_finished():
	self.queue_free()

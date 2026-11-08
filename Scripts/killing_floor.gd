extends Area2D
class_name KillingFloor

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		(body as PlayerMove).die()

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Platform"):
		body.queue_free()

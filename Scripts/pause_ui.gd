extends CanvasLayer



func _input(event):
	if event.is_action_pressed("PauseGame"):
		GameManager.Instance.pause_game(!self.visible)

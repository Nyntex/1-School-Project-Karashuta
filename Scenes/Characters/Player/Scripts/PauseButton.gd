extends TextureButton

func _on_PauseButton_pressed():
	Input.action_press("Pause");
	yield(get_tree().create_timer(0), "timeout")
	Input.action_release("Pause");

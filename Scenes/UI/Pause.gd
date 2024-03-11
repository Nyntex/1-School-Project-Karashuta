extends Control

func _on_Continue_pressed():
	visible = false;
	get_tree().paused = false;

func _on_Close_pressed():
	get_tree().quit();


func _on_ReturnToHub_pressed():
	visible = false;
	get_tree().paused = false;


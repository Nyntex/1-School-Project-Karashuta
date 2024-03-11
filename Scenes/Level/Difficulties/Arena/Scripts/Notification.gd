extends Control

func activate():
	$NotificationDuration.start();
	visible = true;

func _on_NotificationDuration_timeout():
	visible = false;

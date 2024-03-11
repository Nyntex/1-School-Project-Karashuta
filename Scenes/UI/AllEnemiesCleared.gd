extends Control

func Activate():
	if $Duration.is_stopped():
		visible = true;
		$AnimationPlayer.play("Open");
		$Duration.start();
	
func DeActivate(var force = false):
	if !$Duration.is_stopped() || force:
		$AnimationPlayer.play_backwards("Open");
		$Duration.stop();

func _on_Duration_timeout():
	DeActivate(true);

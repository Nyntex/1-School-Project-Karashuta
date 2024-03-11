extends Node2D

func Emit(var color):
	match color:
		ColorEnum.colors.BLUE:
			$Blue.visible = true;
			$Blue.emitting = true;
		ColorEnum.colors.RED:
			$Red.visible = true;
			$Red.emitting = true;
		ColorEnum.colors.YELLOW:
			$Yellow.visible = true;
			$Yellow.emitting = true;
	
	$DeathTimer.start();
	
func _on_DeathTimer_timeout():
	queue_free();

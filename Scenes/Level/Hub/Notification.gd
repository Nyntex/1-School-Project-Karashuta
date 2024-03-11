extends CanvasLayer

func Appear():
	visible = true;
	$Timer.start();

func Disappear():
	visible = false; 

func _on_Timer_timeout():
	$Timer.stop();
	Disappear();

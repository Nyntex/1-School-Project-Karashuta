extends Control

signal start();

func DeActivate():
	visible = false;

func _on_Start_pressed():
	emit_signal("start");

func _on_Credits_pressed():
	$Credits/AnimationPlayer.play("Open"); 
	$Main.highlighted = false;
	
	yield(get_tree().create_timer(0), "timeout")
	$Credits.Activate();

func _on_CloseCredits_pressed():
	$Credits/AnimationPlayer.play_backwards("Open");
	$Credits.highlighted = false;
	
	yield(get_tree().create_timer(0), "timeout")
	$Main.Activate();

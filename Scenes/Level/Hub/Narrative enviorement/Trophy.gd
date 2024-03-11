extends Node2D

func _process(delta):
	if $CanvasLayer.visible:
		return;

	if $Notification.visible || $ControllerSelected.visible:
		if Input.is_action_just_pressed("Interact") && visible || Input.is_action_just_pressed("SELECT") && visible:
			yield(get_tree().create_timer(0), "timeout")
			
			Open();

func _on_Area2D_body_entered(body):
	if visible:
		if !controller:
			$Notification.visible = true;
		else:
			$ControllerSelected.visible = true;

func _on_Area2D_body_exited(body):
	$Notification.visible = false;
	$ControllerSelected.visible = false;
	
func _on_TextureButton_pressed():
	Close();

func Open():
	$CanvasLayer/AnimationPlayer.play("Appear");
	$CanvasLayer/Window.UpdateScore();
	$CanvasLayer.Activate();
	get_tree().paused = true;

func Close():
	$CanvasLayer/AnimationPlayer.play_backwards("Appear");
	get_tree().paused = false;


#Controller Support
var controller = false;

func _input(event):
	if visible:
		controller = event is InputEventJoypadButton || event is InputEventJoypadMotion;
		if controller:
			Input.mouse_mode = Input.MOUSE_MODE_HIDDEN;
		else:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE;

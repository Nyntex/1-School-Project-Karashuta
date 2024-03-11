extends Node2D

func _on_Area2D_body_entered(_body):
	if visible:
		if !controller:
			$Notification.visible = true;
		else:
			$ControllerSelected.visible = true;


func _on_Area2D_body_exited(_body):
	if visible:
		$ControllerSelected.visible = false;
		$Notification.visible = false;
		
func _process(_delta):
	if $CanvasLayer.visible:
		return;

	if $Notification.visible || $ControllerSelected.visible:
		if Input.is_action_just_pressed("Interact") && visible || Input.is_action_just_pressed("SELECT") && visible:
			yield(get_tree().create_timer(0), "timeout")
			$CanvasLayer.visible = true;
			get_tree().paused = true;

func _on_Button_pressed():
	get_tree().paused = false;
	$CanvasLayer.visible = false;
	$ButtonClickSound.ImprovedPlay();

func _on_Button_mouse_entered():
	$HoverSound.ImprovedPlay();

#Controller Support
var controller = false;

func _input(event):
	if visible:
		controller = event is InputEventJoypadButton || event is InputEventJoypadMotion;
		if controller:
			Input.mouse_mode = Input.MOUSE_MODE_HIDDEN;
		else:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE;

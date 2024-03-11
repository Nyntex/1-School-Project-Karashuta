extends Node2D
signal RestartTutorial;


func _on_Area2D_body_entered(_body):
	if visible:
		if !controller:
			$Notification.visible = true;
		else:
			$ControllerSelected.visible = true;

func _on_Area2D_body_exited(_body):
	if !visible:
		return;
		
	$Notification.visible = false;
	$ControllerSelected.visible = false;

func _process(_delta):
	if $CanvasLayer.visible:
		return;

	if $Notification.visible || $ControllerSelected.visible:
		if Input.is_action_just_pressed("Interact") && visible || Input.is_action_just_pressed("SELECT") && visible:
			yield(get_tree().create_timer(0), "timeout")
			$CanvasLayer.Activate();
			get_tree().paused = true;

func _on_Yes_pressed():
	get_tree().paused = false;
	$CanvasLayer.visible = false;
	emit_signal("RestartTutorial");
	$ButtonClickSound.ImprovedPlay();
	$CanvasLayer.highlighted = false;

func _on_No_pressed():
	get_tree().paused = false;
	$CanvasLayer.visible = false;
	$ButtonClickSound.ImprovedPlay();
	$CanvasLayer.highlighted = false;

func _on_Yes_mouse_entered():
	$HoverSound.ImprovedPlay();

func _on_No_mouse_entered():
	$HoverSound.ImprovedPlay();

var controller = false;

func _input(event):
	if visible:
		controller = event is InputEventJoypadButton || event is InputEventJoypadMotion;
		if controller:
			Input.mouse_mode = Input.MOUSE_MODE_HIDDEN;
		else:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE;

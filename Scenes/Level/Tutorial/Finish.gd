extends Node2D

signal finished();

func Start():
	yield(get_tree().create_timer(2.0), "timeout")
	visible = true;
	$CanvasLayer.visible = true;
	get_tree().paused = true;

func _on_TextureButton_pressed():
	emit_signal("finished");
	visible = false;
	$CanvasLayer.visible = false;
	get_tree().paused = false;


#Controller Support
var lastButton = null;
var lastNormal = null;
var controller;

func _input(event):
	if !visible:
		return;
	
	controller = event is InputEventJoypadButton || event is InputEventJoypadMotion;
	if controller:
		Input.mouse_mode = Input.MOUSE_MODE_HIDDEN;
		SimulateMousePosition($CanvasLayer/TextureRect/TextureButton);
	else:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE;
		ResetLastButton()

	$CanvasLayer/TextureRect/TextureButton/ControllerSelected.visible = controller;

func _process(delta):
	if visible && controller && Input.is_action_just_pressed("SELECT"):
		SimulateMouseClick();

func SimulateMousePosition(var button):
	if !visible || button == null || button == lastButton:
		return;
	
	ResetLastButton();
	
	lastButton = button;
	lastNormal = button.texture_normal;
	
	button.texture_normal = button.texture_hover;
	button.emit_signal("mouse_entered")


func SimulateMouseClick():
	if !visible || lastButton == null || lastButton.disabled:
		return;
	
	lastButton.emit_signal("pressed")

func ResetLastButton():
	if lastButton != null && lastNormal != null:
		lastButton.emit_signal("mouse_exited");
		lastButton.texture_normal = lastNormal;

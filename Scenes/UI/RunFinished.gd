extends Control

signal OnReturnToHub();

func Activate(var hub, var stats, var killedEnemies):
	visible = true;
	get_tree().paused = true;
	
	var bossLevel = hub.get_node("HubLevel").GetProgress(3).level;
	$ReturnToHub.visible = bossLevel >= 4;
	$ReturnToHub.disabled = !(bossLevel >= 4);
	
	hub.get_node("HubLevel").GetProgress(3).LevelUp();
	
	$Progress.SetProgress(bossLevel);
	$Stats.UpdateAllStats(stats, killedEnemies);

func _on_Button_pressed():
	visible = false;
	get_tree().paused = false;
	emit_signal("OnReturnToHub");

func OnUnlock():
	$ReturnToHub.visible = true;
	$ReturnToHub.disabled = false;


#Controller Support
var controller = false;
var lastButton;
var lastNormal;

func _input(event):
	if visible:
		controller = event is InputEventJoypadButton || event is InputEventJoypadMotion;
		
		$ReturnToHub/ControllerSelected.visible = controller;
		
		if controller:
			Input.mouse_mode = Input.MOUSE_MODE_HIDDEN;
			SimulateMousePosition($ReturnToHub);
		else:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE;
			ResetLastButton();

func _process(delta):
	if controller && Input.is_action_just_pressed("SELECT"):
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

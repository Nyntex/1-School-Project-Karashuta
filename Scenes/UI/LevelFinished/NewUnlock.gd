extends Control

signal OnClose();

func Activate(var hub, var levelStats):
	highlighted = true;
	$AnimationPlayer.play("Open");
	
	var room = "";
	match levelStats.difficulty:
		0:
			room = "Hub";
		1:
			room = "Library";
		2:
			room = "Bedroom";
	
	var progress = hub.get_node("HubLevel").GetProgress(levelStats.difficulty);
	
	if progress.GetCurrentUnlock() != null:
		$Window/Label.text = "You Unlocked " + progress.GetCurrentUnlock().name + " in the " + room + ". Check it out the next time you visit the hub"
	else:
		$AnimationPlayer.play("RESET");

func DeActivate():
	$AnimationPlayer.play_backwards("Open");
	emit_signal("OnClose");
	highlighted = false;

func _on_Continue_pressed():
	DeActivate();

#Controller support
var highlighted = false;
var controller = false;
var lastButton = null;
var lastNormal = null;

func _process(delta):
	if !highlighted || !controller:
		return;
	if Input.is_action_just_pressed("SELECT"):
		SimulateMouseClick();

func _input(event):
	controller = event is InputEventJoypadButton || event is InputEventJoypadMotion;
	if controller:
		Input.mouse_mode = Input.MOUSE_MODE_HIDDEN;
	else:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE;
		ResetLastButton()

	UpdateControllerSelectedSign();

func UpdateControllerSelectedSign():
	$Window/Continue/ControllerSelected.visible = false;
	
	if controller:
		$Window/Continue/ControllerSelected.visible = true;
		SimulateMousePosition($Window/Continue);


func SimulateMousePosition(var button):
	if !highlighted || button == null || button == lastButton:
		return;
	
	ResetLastButton();
	
	lastButton = button;
	lastNormal = button.texture_normal;
	
	button.texture_normal = button.texture_hover;
	button.emit_signal("mouse_entered")


func SimulateMouseClick():
	if !highlighted || lastButton == null || lastButton.disabled:
		return;
	
	lastButton.emit_signal("pressed")

func ResetLastButton():
	if lastButton != null && lastNormal != null:
		lastButton.emit_signal("mouse_exited");
		lastButton.texture_normal = lastNormal;

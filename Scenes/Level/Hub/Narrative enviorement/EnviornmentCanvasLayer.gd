extends CanvasLayer

#Controller Support
var controller = false;
var lastButton;
var lastNormal;

func _process(delta):
	if Input.is_action_just_pressed("SELECT"):
		SimulateMouseClick();

func _input(event):
	if visible:
		controller = event is InputEventJoypadButton || event is InputEventJoypadMotion;
		if controller:
			Input.mouse_mode = Input.MOUSE_MODE_HIDDEN;
		else:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE;
			ResetLastButton();
			
		UpdateControllerSelectedSign();

func UpdateControllerSelectedSign():
	$Button/ControllerSelected.visible = false;
	
	if controller:
		$Button/ControllerSelected.visible = true;
		SimulateMousePosition($Button);

func SimulateMousePosition(var button):
	if !visible || button == null || button == lastButton:
		return;
	
	lastButton = button;
	lastNormal = button.texture_normal;
	
	ResetLastButton();
	
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

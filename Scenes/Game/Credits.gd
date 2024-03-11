extends Control

var highlighted = false;
var controller = false;

func Activate():
	highlighted = true;
	UpdateControllerSelectedSign();

func _process(delta):
	if !controller || !highlighted:
		return;
	
	UpdateControllerSelectedSign()
	
	if Input.is_action_just_pressed("SELECT"):
		SimulateMouseClick();

func _input(event):
	controller = event is InputEventJoypadButton || event is InputEventJoypadMotion;
	if controller:
		Input.mouse_mode = Input.MOUSE_MODE_HIDDEN;
		UpdateControllerSelectedSign();
	else:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE;
		ResetLastButton()

func UpdateControllerSelectedSign():
	$ControllerSelected.visible = false;
	
	if controller:
		$ControllerSelected.visible = true;
		SimulateMousePosition($Window/Return);

var lastButton = null;
var lastNormal = null;
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

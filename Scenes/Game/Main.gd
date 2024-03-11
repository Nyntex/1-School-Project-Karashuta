extends Control

enum buttons {Start, Settings, CustomRun, Credits, Quit}

var currentButton = buttons.Start;
var highlighted = true;
var controller = false;

func Activate():
	highlighted = true;
	UpdateControllerSelectedSign();

func _process(delta):
	if !controller || !highlighted:
		return;

	if Input.is_action_just_pressed("DOWN"):
		currentButton += 1;
		if currentButton >= 5:
			currentButton = 0;
		UpdateControllerSelectedSign();
			
	if Input.is_action_just_pressed("UP"):
		currentButton -= 1;
		if currentButton <= -1:
			currentButton = 4;
		UpdateControllerSelectedSign();
		
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
	$Start/ControllerSelected.visible = false;
	$Settings/ControllerSelected.visible = false;
	$CustomRun/ControllerSelected.visible = false;
	$Credits/ControllerSelected.visible = false;
	$Quit/ControllerSelected.visible = false;
	
	if controller:
		match currentButton:
			buttons.Start:
				$Start/ControllerSelected.visible = true;
				SimulateMousePosition($Start);
			buttons.Settings:
				$Settings/ControllerSelected.visible = true;
				SimulateMousePosition($Settings);
			buttons.CustomRun:
				$CustomRun/ControllerSelected.visible = true;
				SimulateMousePosition($CustomRun);
			buttons.Credits:
				$Credits/ControllerSelected.visible = true;
				SimulateMousePosition($Credits);
			buttons.Quit:
				$Quit/ControllerSelected.visible = true;
				SimulateMousePosition($Quit);

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

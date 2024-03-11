extends Control

var saver = Saver.new()

func activate():
	$AnimationPlayer.play("Open");
	get_tree().paused = true;
	highlighted = true;
	
func DeActivate():
	$AnimationPlayer.play_backwards("Open");
	get_tree().paused = false;
	
func _on_Continue_pressed():
	DeActivate();

func _on_Close_pressed():
	get_tree().quit();

func _on_Return_pressed():
	pass # Replace with function body.

#Controller Support
enum buttons {Quit, Settings, ReturnToHub, CustomRun, Continue}

var currentButton = buttons.Settings;
var highlighted = false;
var controller = false;

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
	if !highlighted:
		return;
	
	controller = event is InputEventJoypadButton || event is InputEventJoypadMotion;
	if controller:
		Input.mouse_mode = Input.MOUSE_MODE_HIDDEN;
	else:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE;
		ResetLastButton()

	UpdateControllerSelectedSign();

func UpdateControllerSelectedSign():
	$Settings/ControllerSelected.visible = false;
	$ReturnToHub/ControllerSelected.visible = false;
	$CustomRun/ControllerSelected.visible = false;
	$Continue/ControllerSelected.visible = false;
	$Quit/ControllerSelected.visible = false;
	
	if controller:
		match currentButton:
			buttons.Settings:
				$Settings/ControllerSelected.visible = true;
				SimulateMousePosition($Settings);
			buttons.ReturnToHub:
				$ReturnToHub/ControllerSelected.visible = true;
				SimulateMousePosition($ReturnToHub);
			buttons.CustomRun:
				$CustomRun/ControllerSelected.visible = true;
				SimulateMousePosition($CustomRun);
			buttons.Continue:
				$Continue/ControllerSelected.visible = true;
				SimulateMousePosition($Continue);
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

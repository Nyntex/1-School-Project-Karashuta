extends Control

func _on_Yes_pressed():
	get_tree().quit();


func _on_No_pressed():
	$AnimationPlayer.play_backwards("Open");
	highlighted = false;


#Controller Support
enum buttons {Yes, No}

var currentButton = buttons.No;
var highlighted = false;
var controller = false;

func Activate():
	highlighted = true;
	UpdateControllerSelectedSign();
	$AnimationPlayer.play("Open");

func _process(delta):
	if !controller || !highlighted:
		return;
	
	if Input.is_action_just_pressed("DOWN") || Input.is_action_just_pressed("UP"):
		if currentButton == 0:
			currentButton = 1;
		else:
			currentButton = 0;
			
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
	$Yes/ControllerSelected.visible = false;
	$No/ControllerSelected.visible = false;
	
	if controller:
		match currentButton:
			buttons.Yes:
				$Yes/ControllerSelected.visible = true;
				SimulateMousePosition($Yes);
			buttons.No:
				$No/ControllerSelected.visible = true;
				SimulateMousePosition($No);


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

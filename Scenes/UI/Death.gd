extends Control

export (Array, String) var deathTexts;

func Activate():
	visible = true;
	highlighted = true;
	highlighted = true;
	UpdateControllerSelectedSign();
	
	
	$Title.text = deathTexts[randi() % deathTexts.size()]

func _on_ReturnToHub_pressed():
	visible = false;



#Controller Support
enum buttons {ReturnToHub, Quit}

var currentButton = buttons.ReturnToHub;
var highlighted = false;
var controller = false;

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
	$Quit/ControllerSelected.visible = false;
	$ReturnToHub/ControllerSelected.visible = false;
	
	if controller:
		match currentButton:
			buttons.ReturnToHub:
				$ReturnToHub/ControllerSelected.visible = true;
				SimulateMousePosition($ReturnToHub);
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

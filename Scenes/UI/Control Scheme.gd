extends Control

signal OnControlSchemeSet();
var save = Saver.new();

var selectedScheme = 1;
func _ready():
	save = Saver.new();
	save.LoadSave();
	selectedScheme = int(save.settingsSave.controlType);
	
	UpdateVisuals();
	
func _on_Scheme1_pressed():
	selectedScheme = 0;
	UpdateVisuals();
	emit_signal("OnControlSchemeSet");

	save.LoadSave();
	save.settingsSave.controlType = selectedScheme;
	save.WriteSave();

func _on_Scheme2_pressed():
	selectedScheme = 1;
	UpdateVisuals();
	emit_signal("OnControlSchemeSet");
	
	save.LoadSave();
	save.settingsSave.controlType = selectedScheme;
	save.WriteSave();

func _on_Scheme3_pressed():
	selectedScheme = 2;
	UpdateVisuals();
	emit_signal("OnControlSchemeSet");

	save.LoadSave();
	save.settingsSave.controlType = selectedScheme;
	save.WriteSave();


func UpdateVisuals():
	$Scheme1.disabled = false;
	$Scheme2.disabled = false;
	$Scheme3.disabled = false;
	
	match selectedScheme:
		0:
			$Scheme1.disabled= true;
		1:
			$Scheme2.disabled = true;
		2:
			$Scheme3.disabled = true;

func _on_Return_pressed():
	visible = false;

func GetScheme():
	return selectedScheme;

# Controler Support
func _input(event):
	if !visible:
		return;
	
	var controller = event is InputEventJoypadButton || event is InputEventJoypadMotion;
	$Scheme1.visible = !controller;
	$Scheme2.visible = !controller;
	$Scheme3.visible = !controller;
	$ControllerControls.visible = controller;

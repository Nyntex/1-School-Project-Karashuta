extends Node2D

signal finished();
var presses = 0;

func Start(var player):
	visible = true;
	$CanvasLayer.visible = true;
	
	$CanvasLayer/Text/Scheme1.visible = false;
	$CanvasLayer/Text/Scheme2.visible = false;
	$CanvasLayer/Text/Scheme3.visible = false;
	
	if !controller:
		match player.get_node("Containers/ControlContainer").controlScheme:
			0:
				$CanvasLayer/Text/Scheme1.visible = true;
				$CanvasLayer/Text/Label.text = "Change your shield color with Left or Right Mouse Button"
			1:
				$CanvasLayer/Text/Scheme2.visible = true;
				$CanvasLayer/Text/Label.text = "Change your shield color with Right Mouse Button"
			2:
				$CanvasLayer/Text/Scheme3.visible = true;
				$CanvasLayer/Text/Label.text = "Change your shield color with Space button"
	else:
		$CanvasLayer/Text/Label.text = "Change your shield color with L"
	
func OnPlayerColorSwitch():
	if visible:
		presses += 1;
		if presses >= 2:
			emit_signal("finished");
			visible = false;
			$CanvasLayer.visible = false;

#Controller support
var controller = false;
func _input(event):
	controller = event is InputEventJoypadButton || event is InputEventJoypadMotion;

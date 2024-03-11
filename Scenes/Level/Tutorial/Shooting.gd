extends Node2D

signal finished();
var player = null;

func Start(var player_):
	player = player_;
	
	visible = true;
	$NeutralDummies/Neutral1.set_collision_layer_bit(1, true);
	$NeutralDummies/Neutral2.set_collision_layer_bit(1, true);
	$CanvasLayer.visible = true;
	
func _on_NeutralDummies_child_exiting_tree(_node):
	yield(get_tree().create_timer(0), "timeout") # wait a frame to make sure the enemy got fully freed
	UpdateText();
	
	if $NeutralDummies.get_child_count() == 0:
		
		emit_signal("finished");
		visible = false;
		$CanvasLayer.visible = false;

#Controller support
var controller = false;
func _input(event):
	controller = event is InputEventJoypadButton || event is InputEventJoypadMotion;

func UpdateText():
	if !controller:
		match player.get_node("Containers/ControlContainer").controlScheme:
			0:
				$CanvasLayer/Text/Label.text = "You can shoot with Left or Right Click. Destroy these enemies ("+ str(2 - $NeutralDummies.get_child_count())+"/2)";
			1:
				$CanvasLayer/Text/Label.text = "You can shoot with Left Click. Destroy these enemies ("+ str(2 - $NeutralDummies.get_child_count())+"/2)";
			2:
				$CanvasLayer/Text/Label.text = "You can shoot with Left Click. Destroy these enemies ("+ str(2 - $NeutralDummies.get_child_count())+"/2)";
	else:
		$CanvasLayer/Text/Label.text = "You can shoot with R. Destroy these enemies ("+ str(2 - $NeutralDummies.get_child_count())+"/2)";

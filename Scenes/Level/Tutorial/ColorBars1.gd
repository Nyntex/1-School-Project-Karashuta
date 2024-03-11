extends Node2D

signal finished();
var player;

func Start(var player_):
	if player_ == null:
		printerr("ColorBars1.gd: PLAYER IS MISSING!")
		return
		
	$CanvasLayer.visible = true;
	player = player_;
	
	player.get_node("Containers/ColorContainer").connect("OnAbsorb", self, "OnColorBarFilling")
	player.get_node("Containers/ColorContainer").StartHighLight();
	player.get_node("Containers/ColorContainer").Show();
	player.get_node("Containers/ColorContainer").ReduceMaxValue(10);
	
	visible = true;
	
	$Dummies/Enemy.Setup(player);
	
	$Dummies/Enemy.set_collision_layer_bit(1, true);
	
	$Dummies/Enemy.set_collision_mask_bit(0, true);
	$Dummies/Enemy.set_collision_mask_bit(1, true);

func OnColorBarFilling():
	$CanvasLayer/Text/Label.text = "The fuller the bar is, the more damage you deal. Kill this healing enemy"

func _on_Dummies_child_exiting_tree(_node):
	yield(get_tree().create_timer(0), "timeout") # wait a frame to make sure the enemy got fully freed
	if $Dummies.get_child_count() == 0:
		player.get_node("Containers/ColorContainer").EndHighLight();
		emit_signal("finished");
		visible = false;
		$CanvasLayer.visible = false;

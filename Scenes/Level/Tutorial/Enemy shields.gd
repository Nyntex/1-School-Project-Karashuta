extends Node2D

signal finished();

func Start():
	visible = true;
	$CanvasLayer.visible = true;
	
	$ShieldedDummies/RedHitDummy.set_collision_layer_bit(1,true);
	$ShieldedDummies/BlueHitdummy.set_collision_layer_bit(1,true);
	
	$ShieldedDummies/RedHitDummy.set_collision_mask_bit(3, true);
	$ShieldedDummies/BlueHitdummy.set_collision_mask_bit(3, true);

func _on_Shielded_Dummies_child_exiting_tree(_node):
	yield(get_tree().create_timer(0), "timeout") # wait a frame to make sure the enemy got fully freed
	$CanvasLayer/Text/Label.text = "Shielded enemies can absorb shots of the same color. Destroy them (1/2)";
	
	if $ShieldedDummies.get_child_count() == 0:
		visible = false;
		$CanvasLayer.visible = false;
		emit_signal("finished");

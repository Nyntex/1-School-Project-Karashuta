extends Node2D

signal finished();

func Start():
	visible = true;
	$Enemies/Enemy.set_collision_mask_bit(0, true);
	$Enemies/Enemy.set_collision_mask_bit(1, true);
	$Enemies/Enemy2.set_collision_mask_bit(0, true);
	$Enemies/Enemy2.set_collision_mask_bit(1, true);
	
	$Enemies/Enemy.set_collision_layer_bit(1, true);
	$Enemies/Enemy2.set_collision_layer_bit(1, true);
		
func _on_Enemies_child_exiting_tree(_node):
	yield(get_tree().create_timer(0), "timeout") # wait a frame to make sure the enemy got fully freed
	if $Enemies.get_child_count() == 0:
		visible = false;
		emit_signal("finished");

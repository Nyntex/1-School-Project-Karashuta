extends Node2D

signal finished();
var player;

func Start(var player_):
	player = player_;
	player.Healdamage(INF);
	
	visible = true;
	$CanvasLayer.visible = true;
	
	$Enemies/Enemy.set_collision_mask_bit(0, true);
	$Enemies/Enemy.set_collision_mask_bit(1, true);
	$Enemies/Enemy2.set_collision_mask_bit(0, true);
	$Enemies/Enemy2.set_collision_mask_bit(1, true);
	
func _on_One_body_entered(_body):
	if visible:
		$Enemies/Enemy.Setup(player)
		$Enemies/Enemy2.Setup(player)
		
		$Enemies/Enemy.visible = true;
		$Enemies/Enemy2.visible = true;
		
		$Checkmark.queue_free();
		
		$Enemies/Enemy.set_collision_layer_bit(1, true);
		$Enemies/Enemy2.set_collision_layer_bit(1, true);
		
		$CanvasLayer/Text/Label.text = "Defeated enemies (0/2)";


func _on_Enemies_child_exiting_tree(_node):
	yield(get_tree().create_timer(0), "timeout") # wait a frame to make sure the enemy got fully freed
	$CanvasLayer/Text/Label.text = "Defeated enemies (1/2)";
	
	if $Enemies.get_child_count() == 0:
		visible = false;
		emit_signal("finished");
		$CanvasLayer.visible = false;

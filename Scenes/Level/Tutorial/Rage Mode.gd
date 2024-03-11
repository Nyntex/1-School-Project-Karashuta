extends Node2D

signal finished();

var player;
func Start(var player_):
	player = player_;
	var health = player.get_node("Containers/HealthContainer");
	
	while health.health > 1000:
		health.TakeDamage(1000, true);
	
	$NeutralDummies/Neutral1.set_collision_layer_bit(1, true);
	$NeutralDummies/Neutral2.set_collision_layer_bit(1, true);
	$NeutralDummies/Neutral3.set_collision_layer_bit(1, true);
	$NeutralDummies/Neutral4.set_collision_layer_bit(1, true);
	
	visible = true;
	$CanvasLayer.visible = true;

func _on_NeutralDummies_child_exiting_tree(node):
	yield(get_tree().create_timer(0), "timeout")
	$CanvasLayer/Text/Label.text = "Your damage and speed are increased if you are at 1 health. Try to defeat these enemies (" + str(4 - $NeutralDummies.get_child_count()) + "/4)"
	
	if $NeutralDummies.get_child_count() <= 0:
		emit_signal("finished");
		visible = false;
		$CanvasLayer.visible = false;

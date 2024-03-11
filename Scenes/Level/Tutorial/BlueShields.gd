extends Node2D

signal finished();

func Start():
	visible = true;
	$WalkingSpots/Checkmark/Area2D.set_collision_layer_bit(0, true);

func _on_Area2D_body_entered(_body):
	if visible:
		$WalkingSpots/Checkmark/Area2D.set_collision_layer_bit(0, false);
		emit_signal("finished");
		visible = false;

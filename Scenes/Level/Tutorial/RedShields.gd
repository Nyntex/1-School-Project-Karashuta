extends Node2D

signal Finished();

func Start():
	visible = true;
	$CanvasLayer.visible = true;
	
	$WalkingSpots/Checkmark/Area2D.set_collision_mask_bit(0, true);

func _on_Area2D_body_entered(_body):
	$WalkingSpots/Checkmark.visible = false;
	$WalkingSpots/Checkmark/Area2D.set_collision_mask_bit(0, false);

	$WalkingSpots/Checkmark2.visible = true;
	$WalkingSpots/Checkmark2/Area2D2.set_collision_mask_bit(0, true);
	$CanvasLayer/Text/Label.text = "You can absorb damage with the same color as your shield. Go to the marked spots (1/3)"

func _on_Area2D2_body_entered(body):
	$WalkingSpots/Checkmark2.visible = false;
	$WalkingSpots/Checkmark2/Area2D2.set_collision_mask_bit(0, false);

	$WalkingSpots/Checkmark3.visible = true;
	$WalkingSpots/Checkmark3/Area2D3.set_collision_mask_bit(0, true);
	$CanvasLayer/Text/Label.text = "You can absorb damage with the same color as your shield. Go to the marked spots (2/3)"

func _on_Area2D3_body_entered(body):
	$WalkingSpots/Checkmark3.visible = false;
	$WalkingSpots/Checkmark3/Area2D3.set_collision_mask_bit(0, false);
	
	visible = false;
	$CanvasLayer.visible = false;
	
	emit_signal("Finished");

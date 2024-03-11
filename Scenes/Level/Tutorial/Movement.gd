extends Node2D

signal finished();

func Start():
	visible = true;
	$CanvasLayer.visible = true;
	
	$WalkingSpots/Checkmark2.visible = false;
	$WalkingSpots/Checkmark3.visible = false;
	$WalkingSpots/Checkmark4.visible = false;
	
	$WalkingSpots/Checkmark/One.set_collision_mask_bit(0, true);
	
func _on_One_body_entered(_body):
	$WalkingSpots/Checkmark.visible = false;
	$WalkingSpots/Checkmark/One.set_collision_mask_bit(0, false);

	$WalkingSpots/Checkmark2.visible = true;
	$WalkingSpots/Checkmark2/Two.set_collision_mask_bit(0, true);
	
	if !controller:
		$CanvasLayer/Text/Label.text = "Welcome to the Tutorial! Start by moving (WASD) to the marked Spots (1 /4)"
	else:
		$CanvasLayer/Text/Label.text = "Welcome to the Tutorial! Start by moving (left stick) to the marked Spots (1 /4)"
		
func _on_Two_body_entered(_body):
	$WalkingSpots/Checkmark2.visible = false;
	$WalkingSpots/Checkmark2/Two.set_collision_mask_bit(0, false);

	$WalkingSpots/Checkmark3.visible = true;
	$WalkingSpots/Checkmark3/Three.set_collision_mask_bit(0, true);

	if !controller:
		$CanvasLayer/Text/Label.text = "Welcome to the Tutorial! Start by moving (WASD) to the marked Spots (2 /4)"
	else:
		$CanvasLayer/Text/Label.text = "Welcome to the Tutorial! Start by moving (left stick) to the marked Spots (2 /4)"

func _on_Three_body_entered(_body):
	$WalkingSpots/Checkmark3.visible = false;
	$WalkingSpots/Checkmark3/Three.set_collision_mask_bit(0, false);

	$WalkingSpots/Checkmark4.visible = true;
	$WalkingSpots/Checkmark4/Four.set_collision_mask_bit(0, true);

	if !controller:
		$CanvasLayer/Text/Label.text = "Welcome to the Tutorial! Start by moving (WASD) to the marked Spots (3 /4)"
	else:
		$CanvasLayer/Text/Label.text = "Welcome to the Tutorial! Start by moving (left stick) to the marked Spots (3 /4)"

func _on_Four_body_entered(_body):
	$WalkingSpots/Checkmark4.visible = false;
	$WalkingSpots/Checkmark4/Four.set_collision_mask_bit(0, false);
	
	visible = false;
	$CanvasLayer.visible = false;
	emit_signal("finished");

#Controller support
var controller = false;
func _input(event):
	controller = event is InputEventJoypadButton || event is InputEventJoypadMotion;

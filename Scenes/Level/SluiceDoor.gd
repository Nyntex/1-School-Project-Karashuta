extends AnimatedSprite

var open = false;

func Open():
	if !open:
		$KinematicBody2D.set_collision_mask_bit(0, false)
		$KinematicBody2D.set_collision_mask_bit(2, false)
		$KinematicBody2D.set_collision_layer_bit(2, false);
		play("Open");
		open = true;

func Close():
	if open:
		$KinematicBody2D.set_collision_mask_bit(0, true)
		$KinematicBody2D.set_collision_mask_bit(2, true)
		$KinematicBody2D.set_collision_layer_bit(2, true);
		play("Close");
		open = false;

func OnAnimationFinished():
	if open:
		play("Opened");
	else:
		play("Closed");

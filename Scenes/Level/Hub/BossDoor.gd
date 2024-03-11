extends AnimatedSprite

func _ready():
	Close();

func Open():
	play("Opened");
	$KinematicBody2D.set_collision_layer_bit(2, false);

func Close():
	play("Closed");
	$KinematicBody2D.set_collision_layer_bit(2, true);

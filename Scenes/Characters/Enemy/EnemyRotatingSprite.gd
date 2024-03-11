extends AnimatedSprite

var baseRotation;
export (float) var directions = 8.0; #You have to manually enter how many animations this animSprite has

func _ready():
	baseRotation = global_rotation;

func RotateSpriteTowards(var targetPos):
	look_at(targetPos);
	
	rotation_degrees += 360 / directions / 2;
	
	if rotation_degrees <= 0:
		rotation_degrees += 360;
		
	if rotation_degrees >= 360:
		rotation_degrees -= 360;
		
	frame = int(rotation_degrees / (360 / directions));
	global_rotation = baseRotation;

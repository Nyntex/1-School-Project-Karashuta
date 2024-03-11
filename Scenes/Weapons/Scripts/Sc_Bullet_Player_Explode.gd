extends KinematicBody2D

export (PackedScene) var explosion;

var currentColor;
var direction = Vector2(1,0);
var bulletSpeed = 0;
var damage = 0;
var source = null;
var baseSpeed = 0;
var size = 1.0;

export (float) var berserkBonusDamage

func SetUp(var newBulletSpeed, var newDamage, var newDirection, var color, source_, var newSize):
	bulletSpeed = newBulletSpeed;
	damage = newDamage;
	currentColor = color;
	direction = newDirection;
	source = source_;
	size = newSize;
	
	$ColorSpriteHolder.changeColor(ColorEnum.colors.RED);
	$ColorSpriteHolder.look_at(to_global(direction))
	$DirectionMarker.visible = false;
	$ColorSpriteHolder.scale = $ColorSpriteHolder.scale * size
	
#	if $Area2D/AreaShape.shape is CapsuleShape2D:
#		$Area2D/AreaShape.shape.radius = $Area2D/AreaShape.shape.radius * size
#		$Area2D/AreaShape.shape.height = $Area2D/AreaShape.shape.height * size
#	elif $Area2D/AreaShape.shape is CircleShape2D:
#		$Area2D/AreaShape.shape.radius = $Area2D/AreaShape.shape.radius * size
	
	baseSpeed = bulletSpeed;

func _physics_process(delta):
	#var _velocity = move_and_slide(direction.rotated(rotation) * bulletSpeed)
	global_position += direction.rotated(rotation) * bulletSpeed * delta;

func _on_Area2D_body_entered(_body):
	var instance = explosion.instance();
	get_tree().root.add_child(instance);
	instance.global_position = global_position;
	
	for body_ in $ExplosionArea.get_overlapping_bodies():
		if body_.has_method("TakeDamage"):
			if source.get("berserk") != null && typeof(source.berserk) == TYPE_BOOL && source.berserk:
				body_.TakeDamage(ColorEnum.colors.NEUTRAL, damage + berserkBonusDamage, self);
			else:
				body_.TakeDamage(ColorEnum.colors.NEUTRAL, damage, self);
	
	if get_node_or_null("ImpactSound") != null:
		var impactSound = $ImpactSound
		remove_child(impactSound)
		get_tree().root.add_child(impactSound)
		if is_instance_valid(impactSound):
			impactSound.connect("finished", impactSound, "_on_ImpactSound_finished")
			impactSound.ImprovedPlay();
	
	queue_free();

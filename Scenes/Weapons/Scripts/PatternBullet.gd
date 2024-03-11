extends KinematicBody2D

export (PackedScene) var damageNumber;
export (PackedScene) var impactEffect

var currentColor;
var direction = Vector2(1,0);
var bulletSpeed = 0;
var damage = 0;
var source = null;
var baseSpeed = 0;
var size = 1.0

func SetUp(var newBulletSpeed, var newDamage, var newDirection, var color, source_, var newSize):
	bulletSpeed = newBulletSpeed;
	damage = newDamage;
	currentColor = color;
	direction = newDirection;
	source = source_;
	size = newSize
	
	$ColorSpriteHolder.changeColor(currentColor);
	$ColorSpriteHolder.look_at(to_global(direction))
	$DirectionMarker.visible = false;
	$ColorSpriteHolder.scale = Vector2(size, size)
	
	if $Area2D/AreaShape.shape is CapsuleShape2D:
		var radius = $Area2D/AreaShape.shape.radius
		var height = $Area2D/AreaShape.shape.height
		$Area2D/AreaShape.shape.radius = radius * size
		$Area2D/AreaShape.shape.height = height * size
		pass
	elif $Area2D/AreaShape.shape is CircleShape2D:
#		$Area2D/AreaShape.shape.radius = $Area2D/AreaShape.shape.radius * size
		var radius = $Area2D/AreaShape.shape.radius
		$Area2D/AreaShape.shape.radius = radius * size
		#print(radius)
		pass
	
	baseSpeed = bulletSpeed;
	
	
func _physics_process(_delta):
	#var _velocity = move_and_slide(direction.rotated(rotation) * bulletSpeed)
	global_position += direction.rotated(rotation) * bulletSpeed * _delta;

func _on_Area2D_body_entered(body):

	
	if source == null || bulletSpeed == 0 || !visible:
		return;

	if !body.has_method("CanGetHitByColor"):
		SummonImpactParticles()
	
	if body.has_method("TakeDamage"):
		body.TakeDamage(currentColor, damage, self);
		if is_instance_valid(source) && source.has_method("OnBulletHit"):
			source.OnBulletHit(body);
			
		if damageNumber != null && body.has_method("CanGetHitByColor") && body.CanGetHitByColor(currentColor):
			var number = damageNumber.instance();
			get_tree().root.add_child(number);
			number.SetText(str(int(damage)));
			number.rect_position = global_position + Vector2(rand_range(-10,10), rand_range(-10,10));
				
	elif is_instance_valid(source) && source.has_method("OnBulletMiss"):
		source.OnBulletMiss();
		
	if is_instance_valid(get_node_or_null("ImpactSound")):
		var impactSound = $ImpactSound
		var position = impactSound.global_position;
		remove_child(impactSound)
		get_tree().root.add_child(impactSound)
		impactSound.global_position = position;
		impactSound.connect("finished", impactSound, "_on_ImpactSound_finished")
		impactSound.ImprovedPlay();
		
	queue_free();


func SummonImpactParticles():
	if impactEffect != null:
		var impactInstance = impactEffect.instance()
		impactInstance.global_rotation_degrees = $ColorSpriteHolder.global_rotation_degrees + 180
		impactInstance.global_position = global_position
		match currentColor:
			ColorEnum.colors.BLUE:
				impactInstance.modulate = ColorEnum.blueColor
			ColorEnum.colors.RED:
				impactInstance.modulate = ColorEnum.redColor
			ColorEnum.colors.NEUTRAL:
				impactInstance.modulate = ColorEnum.neutralColor
		get_tree().root.add_child(impactInstance)
		impactInstance.Emit()
	pass

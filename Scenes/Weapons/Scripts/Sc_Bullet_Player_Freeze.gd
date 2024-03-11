extends KinematicBody2D

export (float) var stunDuration = 10.0;

var currentColor;
var direction = Vector2(1,0);
var bulletSpeed = 0;
var damage = 0;
var source = null;
var baseSpeed = 0;
var size = 1.0

export (PackedScene) var dotEffect = null
export (PackedScene) var impactEffect = null
export (PackedScene) var enemyImpactEffect = null

func SetUp(var newBulletSpeed, var newDamage, var newDirection, var color, source_, var newSize):
	bulletSpeed = newBulletSpeed;
	damage = newDamage;
	currentColor = color;
	direction = newDirection;
	source = source_;
	size = newSize;
	
	$ColorSpriteHolder.changeColor(ColorEnum.colors.BLUE);
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
	
func _on_Area2D_body_entered(body):
	if source == null:
		pass
	elif !body.has_method("CanGetHitByColor"):
		SummonImpactParticles()
	
	if body.has_method("Stun"):
		body.Stun(stunDuration)
		SummonStunParticles(body)
	
	if body.has_method("TakeDamage"):
		body.TakeDamage(ColorEnum.colors.NEUTRAL, damage, self);
		if source.get("berserk") != null && typeof(source.berserk) == TYPE_BOOL && source.berserk:
			if dotEffect != null:
				var dotEffectInst = dotEffect.instance()
				dotEffectInst.damagingObject = body
				body.add_child(dotEffectInst)
		
	PlayImpactSound();
	queue_free();

func SummonStunParticles(body):
	if enemyImpactEffect != null:
		var enemyImpactInstance = enemyImpactEffect.instance()
		body.add_child(enemyImpactInstance)
		enemyImpactInstance.global_position = body.global_position
		if enemyImpactInstance.has_method("Emit"):
			enemyImpactInstance.Emit()


func SummonImpactParticles():
	if impactEffect != null:
		var impactInstance = impactEffect.instance()
		impactInstance.global_rotation_degrees = $ColorSpriteHolder.global_rotation_degrees + 180
		impactInstance.global_position = global_position
#		match currentColor:
#			ColorEnum.colors.BLUE:
#				impactInstance.modulate = ColorEnum.blueColor
#			ColorEnum.colors.RED:
#				impactInstance.modulate = ColorEnum.redColor
#			ColorEnum.colors.NEUTRAL:
#				impactInstance.modulate = ColorEnum.neutralColor
		get_tree().root.add_child(impactInstance)
		if impactInstance.has_method("Emit"):
			impactInstance.Emit()

func PlayImpactSound():
	var impactSound = get_node_or_null("ImpactSound");
	if impactSound != null:
		remove_child(impactSound)
		get_tree().root.add_child(impactSound)
		if is_instance_valid(impactSound):
			impactSound.connect("finished", impactSound, "_on_ImpactSound_finished")
			impactSound.ImprovedPlay();

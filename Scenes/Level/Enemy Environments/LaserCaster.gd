extends RayCast2D

var cast_point
var currentColor
export (float) var damagePerSecond
var laserRange = 200.0

onready var particles = [$ShootPointparticles, $CollisionParticles, $BeamParticles]
var setuped = false


func _physics_process(delta):
	cast_to.x = laserRange
	cast_point = cast_to
	force_raycast_update()
	
	if is_colliding():
		cast_point = to_local(get_collision_point())
		$CollisionParticles.global_rotation = get_collision_normal().angle()
		$CollisionParticles.position = cast_point + Vector2(5.0, 0.0)
		var body = get_collider()
		if body.has_method("CanGetHitByColor"):
			if body.CanGetHitByColor(currentColor):
				if body.has_method("TakeDamage"):
					body.TakeDamage(currentColor, damagePerSecond * 0.5, self)
			elif !body.CanGetHitByColor(currentColor):
				if body.has_method("TakeDamage"):
					body.TakeDamage(currentColor, damagePerSecond * delta, self)
	
	$CollisionParticles.emitting = is_colliding()
	
	$Line2D.points[1] = cast_point
	$BeamParticles.position = cast_point * 0.5
	$BeamParticles.process_material.emission_box_extents.x = cast_point.length() * 0.5

func SetupColor(givenColor):
	currentColor = givenColor
	
	match currentColor:
		ColorEnum.colors.BLUE:
			for particle in particles:
				particle.modulate = ColorEnum.blueColor
				$Line2D.modulate = ColorEnum.blueColor
		
		ColorEnum.colors.RED:
			for particle in particles:
				particle.modulate = ColorEnum.redColor
				$Line2D.modulate = ColorEnum.redColor
		
		ColorEnum.colors.YELLOW:
			for particle in particles:
				particle.modulate = ColorEnum.yellowColor
				$Line2D.modulate = ColorEnum.yellowColor
		
		ColorEnum.colors.NEUTRAL:
			for particle in particles:
				particle.modulate = ColorEnum.yellowColor
				$Line2D.modulate = ColorEnum.yellowColor

func Setup():
	setuped = true

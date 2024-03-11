extends KinematicBody2D

signal OnBulletFire();

var direction = Vector2.ZERO
var player:KinematicBody2D = null

export (ColorEnum.colors) var currentColor
export (NodePath) var spriteHolder
export (PackedScene) var deathParticles;
onready var navigationAgent = $NavigationAgent2D
onready var rotationNode = $RotationNode
onready var rayCaster = $RayCaster
onready var walkingDirection = $WalkingDirection

#movement settings
export (float) var safeDistance = 160.0;
export (float) var minDistanceToPlayer = 150.0;
onready var startingPosition = global_position

#current Weapon of the Enemy changeable in inspector
export (PackedScene) var weaponScene
var weapon

#Stats of the Enemy
export (float) var maxHealth = 10.0;
var health = 1.0
export (float) var baseMovementSpeed = 100.0;
var movementSpeed = 1.0
export (float) var maxVisionDegrees = 50.0;

enum States{
	IDLE,
	SEARCHING,
	ENGAGING, 
}

var currentState = States.IDLE

export (float) var searchDuration = 15.0;
export (bool) var canFlee = true;
export (bool) var stopWhenNearPlayer = true;
export (float) var detectionTime = 1.0;
export (float) var alertEngageRange = 100.0;
export (float) var engageRange = 100.0;

var stunDuration = 0.0;

var lastFramePosition = Vector2.ZERO
var directionLastFrame = Vector2.ZERO

func _ready():
	get_node(spriteHolder).changeColor(currentColor)
	movementSpeed = baseMovementSpeed
	yield(get_tree().create_timer(0.25), "timeout")
	$IdleMovement.startingPosition = global_position
#	$SpriteManager.source = self

func Setup(_player):
	player = _player 
	$IdleMovement.origin = self
	$IdleMovement.player = player
	
	$SearchingMovement.origin = self
	$SearchingMovement.player = player
	
	$EngagingMovement.origin = self
	$EngagingMovement.player = player
	$EngagingMovement.keepDistance = canFlee
	
	health = maxHealth
	
	$EnemyHealth.SetUp(health);
	
	#Add the weapon to the Enemy
	weapon = weaponScene.instance()
	weapon.currentColor = currentColor
	call_deferred("add_child", weapon) #add_child(weapon)
	$ColorSpriteHolder.changeColor(currentColor)

func _process(delta):
	stunDuration -= delta
	if stunDuration > 0:
		$FrozenFeedback.visible = true
	elif stunDuration <= 0:
		$FrozenFeedback.visible = false
	
	UpdateMovementAnimation()

func _physics_process(_delta):
	if player == null || stunDuration > 0:
		$IdleMovement.disabled = true;
		$SearchingMovement.disabled = true;
		$EngagingMovement.disabled = true;
		return
		
	match currentState:
		States.IDLE:
			$IdleMovement.disabled = false
			$SearchingMovement.disabled = true
			$EngagingMovement.disabled = true
			if RayCastAtPlayer():
				if VisionRangeCheck() >= maxVisionDegrees * -1.0 && VisionRangeCheck() <= maxVisionDegrees:
					Engage()
				
		States.SEARCHING:
			$IdleMovement.disabled = true
			$SearchingMovement.disabled = false
			$EngagingMovement.disabled = true
			if RayCastAtPlayer():
				if VisionRangeCheck() >= maxVisionDegrees * -1.0 && VisionRangeCheck() <= maxVisionDegrees:
					Engage()
				
		States.ENGAGING:
			$IdleMovement.disabled = true
			$SearchingMovement.disabled = true
			$EngagingMovement.disabled = false


#Zielt auf Gegner schaut aber in Laufrichtung
func LookInWalkingDirection():
	rotationNode.look_at(player.global_position)
	walkingDirection.look_at(global_position + (direction * 2.0))
	

func VisionRangeCheck():
	if SimplifyDegreeRotation(rotationNode.rotation_degrees - walkingDirection.rotation_degrees) >= 360 - maxVisionDegrees:
		return SimplifyDegreeRotation(rotationNode.rotation_degrees - walkingDirection.rotation_degrees) - 360
	if SimplifyDegreeRotation(rotationNode.rotation_degrees - walkingDirection.rotation_degrees) < -360 + maxVisionDegrees:
		return SimplifyDegreeRotation(rotationNode.rotation_degrees - walkingDirection.rotation_degrees) + 360
	return SimplifyDegreeRotation(rotationNode.rotation_degrees - walkingDirection.rotation_degrees)

func SimplifyDegreeRotation(inputRotation):
	while inputRotation >= 360:
		inputRotation -= 360
	while inputRotation <= -360:
		inputRotation += 360
	return inputRotation


func TakeDamage(color,takenDamage, _source):
	#Schaden nur wenn Farbe korrekt
	if color != currentColor: # Sollte er von einer anderen Farbe getroffen werden als der die er hat bekommt er schaden
		health -= takenDamage
		$EnemyHealth.changeHealth(health)
		$AnimationPlayer.play("DamageAnimation");
		if health <= 0: #Bei 0 HP verschwindet er
			Die();
	currentState = States.ENGAGING

func Die():
	var particles = deathParticles.instance();
	get_tree().root.add_child(particles)
	particles.global_position = global_position;
	particles.Emit(currentColor);
	
	var deathSound = $DeathSound
	if deathSound != null:
		remove_child(deathSound)
		get_tree().root.add_child(deathSound)
		deathSound.global_position = global_position
		deathSound.ImprovedPlay()
	
	queue_free()

func ShootWeapon(shootDirection):
	if weapon == null:
		#push_error(str(self) + ": ERROR 404: WEAPON NOT FOUND OR NOT ASSIGNED!")
		return
	weapon.TryFire((shootDirection).normalized(), self)


func FindDirectionToTarget(targetPosition):
	# nav Agent bekommt das Ziel und macht einen Weg dahin
	navigationAgent.set_target_location(targetPosition)


func Flee(fleeTarget):
	fleeTarget = global_position - fleeTarget
	
	# Hier wird der Richtungsvektor in die entgegengesetzte Richtung verwendet, damit der Gegner wegläuft
	#fleeTarget = fleeTarget + fleeTarget
	navigationAgent.set_target_location(global_position + fleeTarget.normalized()) 
	direction = global_position.direction_to(navigationAgent.get_next_location()) 
	navigationAgent.set_velocity(direction.normalized() * movementSpeed) 
#	var _velocity = move_and_slide(direction.normalized() * movementSpeed, Vector2.UP)
	walkingDirection.look_at(player.global_position)


func _on_Timer_timeout():
	#print("Timer finished")
	if baseMovementSpeed > 0:
		match currentState:
			States.IDLE:
				$Timer.wait_time = rand_range(2.5,3.75)
				$IdleMovement.IdleWallCheck()
			States.SEARCHING:
				$Timer.wait_time = rand_range(1.5,2.0)
				if $SearchingMovement.searchAreaReached:
					$SearchingMovement.SearchingWallCheck()
			States.ENGAGING:
				$Timer.wait_time = rand_range(0.4,0.6)
				if player != null:
					$EngagingMovement.FindOriginTarget(player.global_position)
		#print(currentState)


func GetAlerted(_alertDirection):
	#print(self, " alarm!")
#	if global_position.distance_to(alertDirection) <= alertEngageRange:
#		Engage()
#	if currentState != States.ENGAGING && currentState != States.SEARCHING:
#		$SearchingMovement.searchAreaReached = false
#		$SearchingMovement.startingPosition = alertDirection
#		direction = alertDirection
#		navigationAgent.set_target_location(direction)
#		currentState = States.SEARCHING
	pass

func Engage():
	currentState = States.ENGAGING


func RayCastAtPlayer():
	if global_position.distance_to(player.global_position) <= engageRange:
		rayCaster.set_cast_to(player.global_position - rayCaster.global_position)
		if rayCaster.get_collider() == player:
			return true


func Stun(var duration):
	stunDuration = duration
	

func CanGetHitByColor(var color):
	if color == ColorEnum.colors.NEUTRAL:
		return true;
	elif currentColor == color:
		return false;
	return true;

func UpdateMovementAnimation():
	$MovementAnimation.SetColorAndAnimation(currentColor, SimplifyDegreeRotation(walkingDirection.global_rotation_degrees), lastFramePosition != global_position)
	lastFramePosition = global_position

func OnBulletFire(var _direction):
	emit_signal("OnBulletFire");

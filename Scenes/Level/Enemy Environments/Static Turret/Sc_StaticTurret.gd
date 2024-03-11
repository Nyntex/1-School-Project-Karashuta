extends StaticBody2D

export (ColorEnum.colors) var currentColor

enum LookDirection{
	N,
	E,
	S,
	W,
}

export (LookDirection) var lookDirection = LookDirection.N

#Stats of the Enemy
export (float) var health = 5.0
var stunDuration = 0;
var direction = Vector2.ZERO

#current Weapon of the Enemy changeable in inspector
export (PackedScene) var weaponScene
var weapon
export (PackedScene) var deathParticles;
var setuped = false

func Stun(var duration):
	stunDuration = duration;

func _process(delta):
	stunDuration -= delta;
	if stunDuration > 0.0:
		$FrozenFeedback.visible = true
	else:
		$FrozenFeedback.visible = false

func _physics_process(_delta):
	ShootWeapon()

func _ready():
	#Add the weapon to the Enemy
	weapon = weaponScene.instance()
	weapon.currentColor = currentColor
	$ShotRotator/WeaponSlot.add_child(weapon)
	MatchSpriteColor()
	MatchLookDirection()

func TakeDamage(color,takenDamage, _source):
	#Schaden nur wenn Farbe korrekt
	if color != currentColor: # Sollte er von einer anderen Farbe getroffen werden als der die er hat bekommt er schaden
		health -= takenDamage
		if health <= 0: #Bei 0 HP verschwindet er
			Die();

func Die():
	queue_free()
	if deathParticles != null && deathParticles.has_method("instance"):
		deathParticles = deathParticles.instance();
		get_tree().root.add_child(deathParticles)
		deathParticles.global_position = global_position;
		deathParticles.Emit(currentColor);
	
func ShootWeapon():
	if setuped:
		if stunDuration <= 0.0:
			$ShotRotator/WeaponSlot.global_rotation = 0
			weapon.TryFire(direction.normalized(), self)

func MatchLookDirection():
	match lookDirection:
		LookDirection.N:
			$Spriteholder.frame = 3
			$ShotRotator.rotation_degrees = 270
			direction = Vector2(0.0,-1.0)
		LookDirection.E:
			$Spriteholder.frame = 0
			$ShotRotator.rotation_degrees = 0
			direction = Vector2(1.0,0.0)
		LookDirection.S:
			$Spriteholder.frame = 1
			$ShotRotator.rotation_degrees = 90
			direction = Vector2(0.0,1.0)
		LookDirection.W:
			$Spriteholder.frame = 2
			$ShotRotator.rotation_degrees = 180
			direction = Vector2(-1.0,0.0)

func MatchSpriteColor():
	match currentColor:
		ColorEnum.colors.RED:
			$Spriteholder.animation = "Red"
		ColorEnum.colors.BLUE:
			$Spriteholder.animation = "Blue"
		ColorEnum.colors.NEUTRAL:
			$Spriteholder.animation = "Neutral"

func MakeReady():
	setuped = true

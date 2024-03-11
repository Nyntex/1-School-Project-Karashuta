extends StaticBody2D

var player = null

signal OnBulletFire();

export (ColorEnum.colors) var currentColor
export (PackedScene) var deathParticles;
onready var spriteHolder = $ColorAndSpriteHolder
onready var rayCaster = $RayCast2D

#current Weapon of the Enemy changeable in inspector
export (PackedScene) var weaponScene
var weapon

#Stats of the Enemy
export (float) var health
var stunDuration = 0;

func Stun(var duration):
	stunDuration = duration;

func _process(delta):
	stunDuration -= delta;
	if stunDuration > 0:
		$FrozenFeedback.visible = true
	elif stunDuration <= 0:
		$FrozenFeedback.visible = false


func Setup(_player):
	player = _player
	
	$EnemyHealth.SetUp(health);

func _ready():
	#Add the weapon to the Enemy
	weapon = weaponScene.instance()
	weapon.currentColor = currentColor
	add_child(weapon)
	
	spriteHolder.changeColor(currentColor)

func _physics_process(_delta):
	if player != null && stunDuration <= 0: #Nur wenn der Spieler existiert soll der Gegner sich Bewegen etc.
		ShootWeapon()
		LookAtPlayer();

func LookAtPlayer():
	rayCaster.set_cast_to(player.global_position - rayCaster.global_position)
	if rayCaster.get_collider() != null && rayCaster.get_collider() == player:
		spriteHolder.ChangeDirection(player.global_position);

func TakeDamage(color,takenDamage, _source):
	#Schaden nur wenn Farbe korrekt
	if color != currentColor: # Sollte er von einer anderen Farbe getroffen werden als der die er hat bekommt er schaden
		health -= takenDamage
		$EnemyHealth.changeHealth(health);
		$AnimationPlayer.play("DamageAnimation");
		if health <= 0: #Bei 0 HP verschwindet er
			Die();

func Die():
	var particles = deathParticles.instance();
	get_tree().root.add_child(particles)
	particles.global_position = global_position;
	particles.Emit(currentColor);
	
	var deathSound = $DeathSound
	remove_child(deathSound)
	get_tree().root.add_child(deathSound)
	deathSound.global_position = global_position
	deathSound.ImprovedPlay()
	
	queue_free()
	
func ShootWeapon():
	#first set the position where the raycast should shoot at IN LOCAL SPACE
	rayCaster.set_cast_to(player.global_position - rayCaster.global_position)

	#check if the enemy can see the player through the raycast
	if rayCaster.get_collider() != null && rayCaster.get_collider() == player:
		weapon.TryFire((player.global_position - global_position).normalized(), self)

func CanGetHitByColor(var color):
	if color == ColorEnum.colors.NEUTRAL:
		return true;
	elif currentColor == color:
		return false;
	return true;


func _on_Enemies_child_exiting_tree(_node):
	pass # Replace with function body.


func _on_Enemies_tree_exited():
	pass # Replace with function body.

func OnBulletFire(var _direction):
	emit_signal("OnBulletFire");

extends StaticBody2D

var player = null

export (ColorEnum.colors) var currentColor
export (PackedScene) var deathParticles;
onready var spriteHolder = $ColorAndSpriteHolder
onready var rayCaster = $RayCast2D

#Stats of the Enemy
export (float) var health
var maxHealth;
var stunDuration = 0;

export (float) var healingAmount;

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
	

func _ready():
	spriteHolder.changeColor(currentColor)
	maxHealth = health;
	$EnemyHealth.SetUp(health);

func _physics_process(_delta):
	if player != null && stunDuration <= 0: #Nur wenn der Spieler existiert soll der Gegner sich Bewegen etc.
		LookAtPlayer();

func LookAtPlayer():
	rayCaster.set_cast_to(player.global_position - rayCaster.global_position)
	if rayCaster.get_collider() != null && rayCaster.get_collider() == player:
		spriteHolder.ChangeDirection(player.global_position);

func TakeDamage(color,takenDamage, _source):
	#Schaden nur wenn Farbe korrekt
	if color != currentColor: # Sollte er von einer anderen Farbe getroffen werden als der die er hat bekommt er schaden
		health = clamp(health - takenDamage, 0, maxHealth);
		$EnemyHealth.changeHealth(health);
		if health <= 0: #Bei 0 HP verschwindet er
			Die();

func Die():
	var particles = deathParticles.instance();
	get_tree().root.add_child(particles)
	particles.global_position = global_position;
	particles.Emit(currentColor);
	
	queue_free()

func CanGetHitByColor(var color):
	if color == ColorEnum.colors.NEUTRAL:
		return true;
	elif currentColor == color:
		return false;
	return true;


func _on_HealingTimer_timeout():
	TakeDamage(ColorEnum.colors.NEUTRAL, - healingAmount, self);

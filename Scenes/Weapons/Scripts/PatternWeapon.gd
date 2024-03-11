extends Node2D

#Fires a specified bulled in a specified pattern
export (NodePath) var bulletSpawnPoint;
export (PackedScene) var bulletPattern;
export (PackedScene) var bullet;

onready var noiseRangeSphere:CollisionShape2D = $NoiseRangeArea/NoiseRangeSphere
onready var noiseRangeArea = $NoiseRangeArea

export (float) var baseFireRate = 1.0;
var fireRate
export (float) var baseBulletDamage = 5.0;
var bulletDamage
export (float) var baseBulletSpeed = 300.0;
var bulletSpeed
export (float) var baseNoiseRange = 500.0;
var noiseRange
#export (float) var baseSize = 1.0
var size = 1;

var activeFireCooldown = 0;
export (ColorEnum.colors) var currentColor;

#checking for potential errors
func _ready():
	if bulletPattern == null:
		push_error("Pattern Error: Weapon " + "'" + name + "'" + " is missing a Bulletpattern");
	if (bullet == null):
		push_error("Bullet Error: Weapon " + "'" + name + "'" + " is missing a Bullet");
	bulletDamage = baseBulletDamage
	bulletSpeed = baseBulletSpeed
	fireRate = baseFireRate
	noiseRange = baseNoiseRange

func _process(delta):
	activeFireCooldown -= delta;

func TryFire(var direction, var source, var bonusDamage = 0, var bonusSize = 0):
	if activeFireCooldown <= 0:
		bulletDamage += clamp(bonusDamage, 0, INF);
		size += bonusSize;
		
		Fire(direction, source);
		
		size -= bonusSize;
		bulletDamage -= clamp(bonusDamage, 0, INF);
	
func Fire(var direction, var source):
	look_at(global_position + direction);
	activeFireCooldown = 1 / fireRate;
	var activePattern = bulletPattern.instance();
	add_child(activePattern);
	
	activePattern.global_position = get_node(bulletSpawnPoint).global_position;
	activePattern.shootingDirection = transform.x;
	activePattern.connect("BulletFired", self, "PlaySound");
	
	AlertEnemies()
	
	if activePattern.has_method("StartPattern"):
		activePattern.StartPattern(currentColor, bullet, bulletSpeed, bulletDamage, source, size)

func AlertEnemies():
	noiseRangeSphere.shape.radius = noiseRange
	for body in noiseRangeArea.get_overlapping_bodies():
		if body.has_method("GetAlerted"):
			if body != self:
				#print(body, " was alerted!")
				body.GetAlerted(global_position + (Vector2(rand_range(-10,10),rand_range(-10,10))))
	pass

func PlaySound():
	$ShotSound.ImprovedPlay();

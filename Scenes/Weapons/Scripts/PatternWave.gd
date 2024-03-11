extends Node2D
signal bulletFired();

export (float) var bonusSpeed = 0.0;
export (float) var bonusDamage = 0.0;
export (float) var bulletSpawnDelay = 0.0;
export (float) var delayUntilNextWave = 0.0;

var color;
var bullet;
var direction;
var bulletSpeed;
var damage;
var source;
var size;

func _ready():
	for i in get_children():
		if i != $WaveTimer:
			i.visible = false;

#Spawns and shoots the bullets with the specified properties
func StartWave(var color_, var bullet_, var direction_, var bulletSpeed_, var damage_, var source_, var size_):
	color = color_;
	bullet = bullet_;
	direction = direction_;
	bulletSpeed = bulletSpeed_;
	damage = damage_;
	source = source_;
	size = size_
	
	visible = true;
	
	if bulletSpawnDelay == 0:
		for i in get_children():
			FireWave();
	else:
		$WaveTimer.start(bulletSpawnDelay);

func FireWave():
	SpawnBulletHolderIfNeccesary();
	
	var BulletInstance = bullet.instance();
	var PlaceholderBullet = get_child(0);
	
	if(PlaceholderBullet != $WaveTimer):
		
		PlaceholderBullet.scale *= size;
		SetUpBullet(BulletInstance, PlaceholderBullet);
		PlaceholderBullet.free()
		if source.has_method("OnBulletFire"):
			source.OnBulletFire(direction);
		emit_signal("bulletFired");
		
	else:
		$WaveTimer.stop();
		
func SpawnBulletHolderIfNeccesary():
	if get_tree().root.get_node_or_null("BulletHolder") == null:
		var BulletHolder = Node2D.new()
		BulletHolder.set_name("BulletHolder")
		get_tree().root.add_child(BulletHolder)
		
func SetUpBullet(var BulletInstance, var PlaceholderBullet):
	get_tree().root.get_node("BulletHolder").add_child(BulletInstance);
	BulletInstance.global_position = PlaceholderBullet.global_position;
	BulletInstance.rotation = PlaceholderBullet.rotation;
	BulletInstance.scale = PlaceholderBullet.scale;
	BulletInstance.SetUp(bulletSpeed + bonusSpeed,damage + bonusDamage, direction, color, source, size);
	
	


func _on_WaveTimer_timeout():
	FireWave();

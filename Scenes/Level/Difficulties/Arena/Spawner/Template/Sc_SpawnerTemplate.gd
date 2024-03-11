extends Node2D

export (PackedScene) var enemyType = null
export (float) var spawningTime = 3.0
export (float) var spawnVariance = 0.0;

var player = null
var enemiesNode = null
export (ColorEnum.colors) var colorOfEnemy

func SpawnerSetup(var newPlayer, levelEnemiesNode):
	player = newPlayer
	enemiesNode = levelEnemiesNode
	$Timer.start(spawningTime / 2 + rand_range(spawnVariance * -1, spawnVariance) / 2)
	_on_Timer_timeout();

func _on_Timer_timeout():
	$Timer.start(spawningTime + rand_range(spawnVariance * -1, spawnVariance))
	
	if enemyType != null:
		var enemyInstance = enemyType.instance()
		
		if enemyInstance.has_method("Setup"):
			enemiesNode.add_child(enemyInstance)
			enemyInstance.global_position = global_position
			enemyInstance.currentColor = GetColor();
			
			enemyInstance.Setup(player)
			enemyInstance.engageRange = INF;
			
		else:
			printerr(enemyInstance, " has no method of name 'Setup'.")
			return 
		
	pass

func GetColor():
	if colorOfEnemy == ColorEnum.colors.RANDOM:
		return int(rand_range(0,2))
	return colorOfEnemy;

func IncreaseSpawnSpeed(var amount):
	spawningTime -= amount;
	$Timer.wait_time = spawningTime;
	$Timer.start();

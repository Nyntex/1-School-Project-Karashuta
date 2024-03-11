extends Node2D

signal ReturnToHub();
signal LevelStarted();

var difficulty = 0;
var maxEnemies = INF;

var player;
var pastLevelStats;
var hub;
var actualTime = 0;
var killedEnemies = 0;

func _ready():
	$StartSluice.HideLeftDoor(true);

func _process(delta):
	actualTime += delta;

func Setup(var player_, var pastLevelStats_, var hub_, var difficulty_):
	player = player_;
	pastLevelStats = pastLevelStats_;
	hub = hub_;
	difficulty = difficulty_;
	killedEnemies = 0;
	
	$EnemyWall.SetUp(player);
	$EnemyWall2.SetUp(player);
	
	player.connect("OnDeath", self, "OnPlayerDeath");
	
func GetStartPosition():
	return $StartSluice.global_position;

func GetEndPosition():
	return global_position + Vector2(100000,0);

func _on_StartSluice_OnLevelStart():
	emit_signal("LevelStarted", self);
	
	$Environment.SetUp(player);
	$Spawner.SetUp(player);
	$ArenaUI.SetUp($ArenaDuration);
	$ArenaDuration.start();
	$DifficultyIncrease.start();
	
	$ArenaUI.Appear();

func _on_Timer_timeout():
	$Spawner.Finish();
	$ArenaUI/RunFinished.Activate(hub, pastLevelStats + [GetLevelStats()], killedEnemies)


func _on_DifficultyIncrease_timeout():
	$Spawner.IncreaseSpawningSpeed(0.5);
	$ArenaUI.ActivateNotification();
	$EnemyWall.IncreaseDifficuly(1);
	$EnemyWall2.IncreaseDifficuly(1);

func GetLevelStats():
	var stats = LevelStats.new();
	stats.name = name;
	stats.time = actualTime;
	stats.maxTime = 1000;
	stats.missedShots = player.GetStats().missedShots;
	stats.hitShots = player.GetStats().hitShots;
	stats.absorbed = player.GetStats().absorbedBullets;
	stats.score = GetLevelScore(stats);
	stats.difficulty = difficulty;
	return stats;

func GetLevelScore(var _stats):
	return killedEnemies;

func _on_RunFinished_OnReturnToHub():
	emit_signal("ReturnToHub");

func _on_Enemies_child_exiting_tree(node):
	killedEnemies += 1;
	$ArenaUI/EnemiesKilled.UpdateCounter(killedEnemies);

func OnPlayerDeath():
	$ArenaDuration.stop();

extends Node2D

signal LevelFinished(level);
signal ReturnToHub();

export (float) var recoTime = 100.0;
var actualTime = 0;
var difficulty = 0;
var maxEnemies = 0;

var pastLevelStats = [];
var hub;
var player;

func _ready():
	$StartSluice.HideLeftDoor(true);

func Setup(var player_, var pastLevelStats_, var hub_, var difficulty_):
	player = player_;
	hub = hub_;
	difficulty = difficulty_;
	
	maxEnemies = $Enemies.get_child_count();
	actualTime = 0;

	pastLevelStats = pastLevelStats_;

func _process(delta):
	actualTime += delta;

func _on_EndSluice_OnLevelEnd():
	$Environment.RemoveAll();
	$LevelCanvas.DeActivateGeneralUI();
	$LevelCanvas.ActivateLevelEndScreen(GetLevelStats(), pastLevelStats, hub);

	player.Healdamage(GetLevelStats().healthBonus * 1000);
	emit_signal("LevelFinished", self);
	
	$EndSluice.queue_free();

func _on_StartSluice_OnLevelStart():

	$Enemies.SetUp(player);
	$Environment.SetUp(player);
	
	$Barrels.SetUp(difficulty);
	
	$LevelCanvas.ActivateGeneralUI(self);
	$LevelCanvas.UpdateGeneralUI();

func _on_Enemies_child_exiting_tree(_node):
	$LevelCanvas.UpdateGeneralUI(-1);
	
	if GetAllEnemies().size() - 1 <= 0:
		$LevelCanvas.ActivateAllEnemiesCleared();
		$EndSluice.HideLeftDoor(true);

func GetAllEnemies():
	return $Enemies.get_children();

func GetAllEnviornments():
	return $Environment.get_children();

func GetStartPosition():
	return $StartSluice.global_position;

func GetEndPosition():
	return $EndSluice.global_position;

func GetLevelStats():
	var stats = LevelStats.new();
	stats.name = name;
	stats.time = actualTime;
	stats.maxTime = recoTime;
	stats.missedShots = player.GetStats().missedShots;
	stats.hitShots = player.GetStats().hitShots;
	stats.absorbed = player.GetStats().absorbedBullets;
	stats.difficulty = difficulty;
	stats.enemyBulletsShot = $Enemies.bulletsShot;
	
	stats.score = GetLevelScore(stats);
	stats.healthBonus = GetHealthBonus(stats.score);
	
	return stats;

func GetHealthBonus(score):
	return int(ceil(score / 30))
	
func GetLevelScore(Stats):
	var speedScore = clamp(float(recoTime) / float(actualTime),0,1) * 80;
	var accuracyScore = float(Stats.hitShots) / (float(Stats.hitShots) + float(Stats.missedShots)) / 2.5;
	
	var score = speedScore + accuracyScore;
	return score;

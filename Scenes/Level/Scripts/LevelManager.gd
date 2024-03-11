extends Node2D

var player;
var saver = Saver.new();
var levelStats = [];

func _ready():
	return;
	$LevelCanvas/General.Reset();
	$LevelCanvas/CustomRun.SetUp($LevelLoader.easyLevels + $LevelLoader.midLevels + $LevelLoader.hardLevels + $LevelLoader.arenaLevels);
	$LevelCanvas/CustomRun.connect("UpdatedRun",self,"_on_CustomRun_UpdatedRun");
	
	for difficulty in $LevelLoader.Difficulties:
		var stats = LevelStats.new();
		stats.difficulty = difficulty;
		levelStats.append(stats);

func _on_LevelLoader_OnLevelStarted(level):
	return;
	$LevelCanvas.visible = true;
	$LevelCanvas/General.Update(level);
	$LevelLoader/Hub.QuitTutorialIfPossible();
	$LevelLoader.GetCurrentLevel().difficulty = $LevelLoader.Difficulties[$LevelLoader.finishedLevels];

	level.connect("EnemyCleared", self, "UpdateEnemiesLeft");

	player.GetStats().Reset();

func _on_LevelLoader_OnLevelFinished(level = null):
	return;
	UpdateLevelStats();
	if !level.bossLevel:
		if level != null:
			$LevelCanvas/LevelFinished.activate(levelStats, $LevelLoader.finishedLevels, $LevelLoader/Hub);
	else:
		$LevelCanvas/RunFinished.activate($LevelLoader/Hub, levelStats);
		
	$LevelCanvas/General.Reset();
	player.Healdamage(2);

func StartTutorial(var player_):
	return;
	$LevelLoader/Hub.StartTutorial(player_);
	$LevelLoader.spawnedLevels[0].get_node("StartSluice").HideLeftDoor(false);

func UpdateLevelStats():
	return;
	var level = $LevelLoader.GetCurrentLevel();
	levelStats[$LevelLoader.finishedLevels].name = level.name;
	levelStats[$LevelLoader.finishedLevels].time = level.actualTime;
	levelStats[$LevelLoader.finishedLevels].maxTime = level.recoTime;
	levelStats[$LevelLoader.finishedLevels].missedShots = player.GetStats().missedShots;
	levelStats[$LevelLoader.finishedLevels].hitShots = player.GetStats().hitShots;
	levelStats[$LevelLoader.finishedLevels].absorbed = player.GetStats().absorbedBullets;
	levelStats[$LevelLoader.finishedLevels].score = GetLevelScore(levelStats[$LevelLoader.finishedLevels]);
	
func GetLevelScore(var Stats):
	return;
	var speedPoints = 0;
	var speed = float(Stats.time) / float(Stats.maxTime);
	
	if speed >= 1.35:
		speedPoints = 6
	elif speed >= 1.3:
		speedPoints = 8;
	elif speed >= 1.25:
		speedPoints = 10;
	elif speed >= 1.2:
		speedPoints = 12;
	elif speed >= 1.15:
		speedPoints = 14;
	elif speed >= 1.1:
		speedPoints = 16;
	elif speed >= 1.0:
		speedPoints = 18;
	else:
		speedPoints = 20;
	
	var accuracyPoints = 0;
	var accuarcy = float(Stats.hitShots) / float(Stats.missedShots + Stats.hitShots); 
	
	if accuarcy == 1:
		accuracyPoints = 1.6;
	elif accuarcy > 0.95:
		accuracyPoints = 1.5;
	elif accuarcy > 0.9:
		accuracyPoints = 1.4;
	elif accuarcy > 0.8:
		accuracyPoints = 1.3;
	elif accuarcy > 0.7:
		accuracyPoints = 1.2;
	elif accuarcy > 0.6:
		accuracyPoints = 1.1;
	elif accuarcy > 0.5:
		accuracyPoints = 1;
	else:
		accuracyPoints = 0.9;
	
	var bulletPoints = 0;
	var absorbedBullets = Stats.absorbed;
	
	if absorbedBullets >= 200:
		bulletPoints = 1;
	elif absorbedBullets >= 150:
		bulletPoints = 1.2;
	else:
		bulletPoints = 1.4;
	
	var difficultyPoints = 0;
	var difficulty = Stats.difficulty;
	
	match difficulty:
		0:
			difficultyPoints = 1;
		1:
			difficultyPoints = 1.5;
		2:
			difficultyPoints = 2;
			
	var score = 0;
	score = ((speedPoints * accuracyPoints) + ((speedPoints * accuracyPoints) / bulletPoints)) * difficultyPoints;
	
	#print(score)
	return score;


func _on_CustomRun_UpdatedRun():
	return;
	$LevelLoader.overrideLevelOrder = $LevelCanvas/CustomRun.customLevelOrder;

func _on_Hub_finishedTutorial():
	return;
	$LevelLoader.spawnedLevels[0].get_node("StartSluice").HideLeftDoor(true);
	saver.LoadSave();
	saver.playerSavingStats.tutorialFinished = true;
	saver.WriteSave();

func _on_Hub_restartTutorial():
	return;
	StartTutorial(player);

func _on_Hub_playerLeftHub():
	return;
	player.get_node("Camera2D").Zoom(Vector2(0.75,0.75), 1);


func _on_LevelLoader_OnAllEnemiesCleared(level):
	return;
	$LevelCanvas/AllEnemiesCleared.activate();

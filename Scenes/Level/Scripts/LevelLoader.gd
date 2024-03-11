extends Node2D

var saver = Saver.new()

enum difficulty{
	EASY,
	MID,
	HARD,
	ARENA,
}

signal OnReturnToHub();

export (Array, difficulty) var Difficulties;
export (Array, PackedScene) var easyLevels;
export (Array, PackedScene) var midLevels;
export (Array, PackedScene) var hardLevels;
export (Array, PackedScene) var arenaLevels;

var easyStartingLevels;
var midStartingLevels;
var hardStartingLevels;
var arenaStartingLevels;

var spawnedScenes;
var player
var finishedLevels = 0;

var spawnedLevels = [];

var overrideLevelOrder = [];

func _ready():
	easyStartingLevels = [] + easyLevels;
	midStartingLevels = [] + midLevels;
	hardStartingLevels = [] + hardLevels;
	arenaStartingLevels = [] + arenaLevels;
	
	randomize();

func LoadNextLevel():
	var copy = [] + spawnedLevels;
	DeSpawnLevel(spawnedLevels[0]);
	spawnedLevels[0] = copy[1];
	spawnedLevels[1] = copy[2];
	
	if  finishedLevels >= Difficulties.size():
		return;
	
	var nextLevel = GetLevelAtDifficulty(Difficulties[clamp(finishedLevels + 1,0,Difficulties.size() - 1)])
	nextLevel = nextLevel.instance();
		
	#call_deferred("add_child", nextLevel)
	yield(get_tree().create_timer(0.25), "timeout")
	add_child(nextLevel)
		
	#nextLevel.name = str("Level " + str(finishedLevels + 2));
	nextLevel.global_position -= nextLevel.GetStartPosition() - spawnedLevels[2].GetEndPosition()
	nextLevel.connect("LevelFinished", self, "OnLevelFinished")
	nextLevel.connect("ReturnToHub", self, "ReturnToHub");
	
	spawnedLevels[2] = nextLevel;

func LoadStartingLevels(var player_):
	DeSpawnAllLevels();
	easyLevels = [] + easyStartingLevels;
	midLevels = [] + midStartingLevels;
	hardLevels = [] + hardStartingLevels;
	arenaLevels = [] + arenaStartingLevels;
	spawnedLevels = [];
	finishedLevels = 0;
	
	player = player_;
	
	var level1 = GetLevelAtDifficulty(Difficulties[0]);
	level1 = level1.instance();
	self.add_child(level1);
	spawnedLevels.append(level1)
	
	var level2 = GetLevelAtDifficulty(Difficulties[1])
	level2 = level2.instance();
	self.add_child(level2);
	spawnedLevels.append(level2)
	
	var level3 = GetLevelAtDifficulty(Difficulties[2])
	easyLevels = RemoveFromArray(easyLevels, level3, hardStartingLevels);
	level3 = level3.instance();
	self.add_child(level3);
	spawnedLevels.append(level3)
	
	level1.Setup(player, [], $Hub, Difficulties[0]);
	
	level1.connect("LevelFinished", self, "OnLevelFinished");
	level1.connect("ReturnToHub", self, "ReturnToHub");
	level2.connect("LevelFinished", self, "OnLevelFinished");
	level2.connect("ReturnToHub", self, "ReturnToHub");
	level3.connect("LevelFinished", self, "OnLevelFinished");
	level3.connect("ReturnToHub", self, "ReturnToHub");
	
	level1.global_position -= level1.GetStartPosition() - $Hub.GetGlobalStartPosition();
	level2.global_position -= level2.GetStartPosition() - level1.GetEndPosition();
	level3.global_position -= level3.GetStartPosition() - level2.GetEndPosition();

func OnLevelFinished(var _level):
	GetNextLevel().Setup(player, GetCurrentLevel().pastLevelStats + [GetCurrentLevel().GetLevelStats()], $Hub, Difficulties[finishedLevels + 1])
	
	finishedLevels += 1;
	
	if finishedLevels > 1:
		LoadNextLevel();

func DeSpawnLevel(var level):
	if is_instance_valid(level) && get_node_or_null(level.get_path()) != null:
		level.queue_free();

func GetLevelFromArray(var array):
	return array[randi() % array.size()]

func RemoveFromArray(var array, var toRemove, var fallbackArray):
	var newArray = [];
	for i in array:
		if i != toRemove:
			newArray.append(i);
	
	if newArray.size() == 0:
		return fallbackArray;
		
	return newArray;

func DeSpawnAllLevels():
	for Level in spawnedLevels:
		DeSpawnLevel(Level);

func GetLevelAtDifficulty(var diff):
	if overrideLevelOrder.size() > 0 && overrideLevelOrder[spawnedLevels.size()] != null:
		return overrideLevelOrder[spawnedLevels.size()];
	
	match(diff):
		difficulty.EASY:
			var level = easyLevels[randi() % easyLevels.size()]
			easyLevels = RemoveFromArray(easyLevels, level, easyStartingLevels);
			return level;
		difficulty.MID:
			var level = midLevels[randi() % midLevels.size()]
			midLevels = RemoveFromArray(midLevels, level, midStartingLevels);
			return level;
		difficulty.HARD:
			var level = hardLevels[randi() % hardLevels.size()]
			hardLevels = RemoveFromArray(hardLevels, level, hardStartingLevels);
			return level;
		difficulty.ARENA:
			var level = arenaLevels[randi() % arenaLevels.size()]
			arenaLevels = RemoveFromArray(arenaLevels, level, arenaStartingLevels);
			return level;

func GetNextLevel():
	if spawnedLevels == null:
		return null;
		
	if finishedLevels == 0:
		return spawnedLevels[1]
	else:
		return spawnedLevels[2];

func GetCurrentLevel():
	if spawnedLevels == null || spawnedLevels == []:
		return null;
		
	if finishedLevels == 0:
		return spawnedLevels[0]
	else:
		return spawnedLevels[1];

func GetLastLevel():
	if spawnedLevels == null || spawnedLevels == [] || finishedLevels == 0:
		return null;
	else:
		return spawnedLevels[0];

func ReturnToHub():
	emit_signal("OnReturnToHub");

func _on_CustomRun_UpdatedRun(customOrder):
	overrideLevelOrder = customOrder;

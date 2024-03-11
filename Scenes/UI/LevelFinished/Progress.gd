extends Control

var stats = null;
var hub = null;

func SetUp(var stats_, var hub_):
	stats = stats_;
	hub = hub_;
	
	match stats.difficulty:
		0:
			$Title.text = $Title.text.replace("DIFFICULTY", "Hub");
		1:
			$Title.text = $Title.text.replace("DIFFICULTY", "Library");
		2:
			$Title.text = $Title.text.replace("DIFFICULTY", "Bedroom");
		3:
			$Title.text = $Title.text.replace("DIFFICULTY", "Arena");
	
	var progress = hub.get_node("HubLevel").GetProgress(stats.difficulty);
	$LevelUpProgress.SetUp(progress);

func AddPoints(var amount):
	var progress = hub.get_node("HubLevel").GetProgress(stats.difficulty);
	#progress.AddXP(round(stats.score));
	progress.AddXP(int(stats.score), false);
	#progress.AddXP(int(125), false)
	
	UpdateProgress(progress);

func _process(_delta):
	if hub != null && stats != null:
		var progress = hub.get_node("HubLevel").GetProgress(stats.difficulty);
		UpdateProgress(progress);

func UpdateProgress(var progress):
	if !progress.IfMaxed():
		$Progress.text = str($LevelUpProgress.value) + " / " + str(progress.XPNeeded);
		$Left/Number.text = str(progress.level);
		$Right/Number.text = str(progress.level + 1);
		
		if progress.level + 1 >= progress.GetMaxLevel():
			$Right/Number.text = "Max";
		
	else:
		$Progress.text = str(progress.XPNeeded) + " / " + str(progress.XPNeeded);
		$Left/Number.text = "Max";
		$Right/Number.text = "Max";
		$LevelUpProgress.value = $LevelUpProgress.max_value;
		

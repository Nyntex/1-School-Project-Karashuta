extends TextureRect

func UpdateText(var stats, var _hub):
	#var progress = hub.get_node("HubLevel").GetProgress(stats.difficulty);
	#$Difficulty/Window.modulate = progress.barColor;
	
	match stats.difficulty:
		0:
			$Difficulty/Label.text = "Easy";
		1:
			$Difficulty/Label.text = "Medium";
		2:
			$Difficulty/Label.text = "Hard";
		3:
			$Difficulty/Label.text = "Arena";

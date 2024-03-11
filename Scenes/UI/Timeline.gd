extends Control

export (PackedScene) var easyButton;
export (PackedScene) var midButton;
export (PackedScene) var hardButton;
export (PackedScene) var ArenaButton;

func SpawnButtons(var levelStats, var source):
	for i in levelStats.size():
		var button = null;
		match levelStats[i].difficulty:
			0:
				button = easyButton.instance();
			1:
				button = midButton.instance();
			2:
				button = hardButton.instance();
			3:
				button = ArenaButton.instance();
		
		if button != null:
			$Buttons.add_child(button);
			button.level = i;
			button.connect("OnPressed", source, "UpdateText");
			
			var direction = $Positions/RightMost.global_position - $Positions/LeftMost.global_position;
			button.rect_global_position = direction * (float(i) / 5.0) + $Positions/LeftMost.global_position;
			button.rect_global_position.y = $Positions/RightMost.global_position.y;

	UpdateButtonVisuals(levelStats.size() - 1)

func UpdateButtonVisuals(var currentLevel):
	for button in $Buttons.get_children():
		button.Enable();
	
	$Buttons.get_child(currentLevel).Disable();

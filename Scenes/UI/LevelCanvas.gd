extends CanvasLayer

func ActivateGeneralUI(var level):
	$General.Activate(level);

func DeActivateGeneralUI():
	$General.DeActivate();

func ActivateAllEnemiesCleared():
	$AllEnemiesCleared.Activate();

func DeActivateAllEnemiesCleared():
	$AllEnemiesCleared.DeActivate(true);

func ActivateLevelEndScreen(var levelStats, var pastLevelStats, var hub):
	$LevelFinished.activate(levelStats, pastLevelStats, hub);
	DeActivateAllEnemiesCleared();

func DeActivateLevelEndScreen():
	$LevelFinished.DeActivate();

func UpdateGeneralUI(var modifier = 0):
	$General.Update(modifier);

func _on_Continue_pressed():
	$ButtonClickSound.ImprovedPlay();

func _on_Continue_mouse_entered():
	$HoverSound.ImprovedPlay();

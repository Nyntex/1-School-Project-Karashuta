extends CanvasLayer


func SetAllStats(var level):
	SetProgress(level);
	SetLevelText(level);

func SetProgress(var level):
	$TextureProgress.value = level.XPLeft;
	$TextureProgress.max_value = level.XPNeeded;

func SetLevelText(var level):
	$Level/Label.text = str(level.level);

func SetBarColor(var color):
	$TextureProgress.tint_progress = color;

func SetMaxed():
	$TextureProgress.value = $TextureProgress.max_value;
	$Level/Label.text = "Max";

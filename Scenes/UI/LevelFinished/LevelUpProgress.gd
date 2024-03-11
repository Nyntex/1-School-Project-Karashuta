extends TextureProgress

signal onLevelUp();
var progress = null;

func SetUp(var progress_):
	progress = progress_;
	tint_progress = progress.barColor;
	
	if progress.IfMaxed():
		max_value = progress.XPNeeded;
		value = max_value;
	else:
		max_value = progress.XPNeeded;
		value = progress.XPLeft;
	
func _process(_delta):
	if progress != null && !progress.IfMaxed():

		if value < int(progress.XPLeft):
			value += 1;
		elif value > int(progress.XPLeft):
			value -= 1;
		if value >= int(progress.XPNeeded):
			OnFinished();

func OnFinished():
	progress.XPLeft = clamp(progress.XPLeft - progress.XPNeeded,0,INF);
	progress.Save();
	value = 0;
	emit_signal("onLevelUp");

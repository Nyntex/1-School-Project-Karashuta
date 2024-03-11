extends TextureProgress

var target = 0
var done = true;

signal OnFinished();

func SetUp(var pastLevelStats):
	value = round(clamp(float(pastLevelStats.size() - 1) / float(5), 0, INF) * 200)
	target = round(clamp(float(pastLevelStats.size()) / float(5), 0, INF) * 200);
	done = false;

func _process(_delta):
	if !done:
		if value < target:
			value += 1;
		elif value > target:
			value -= 1;
		else:
			done = true;
			emit_signal("OnFinished");

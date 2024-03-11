extends Control

var level;

func Activate(var level_):
	visible = true;
	level = level_;
	$Levelname.text = level.name;
	$AnimationPlayer.play("Open");

func DeActivate():
	level = null;
	$AnimationPlayer.play_backwards("Open");

func Update(var modifier = 0):
	if level != null && is_instance_valid(level):
		#$LevelTimer.UpdateTimeLeft(level.GetTimer())
		$EnemiesLeft.UpdateText(level, modifier);

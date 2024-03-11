extends Label

var stats
func Activate(var levelStats):
	stats = levelStats;
	if !visible:
		visible = true;
		$AnimationPlayer.play("Appear");
	else:
		$AnimationPlayer.play("ReAppear");


func Update():
	if stats == null:
		return;

	SetAbsorbed(stats);
	SetTime(stats);
	SetAccuracy(stats)
	SetName(stats);
	SetScore(stats);
	SetRank(stats);
	SetHealthBonus(stats);

func SetAbsorbed(var _stats):
	var percent = float(stats.absorbed) / float(stats.enemyBulletsShot);
	
	if percent == 1:
		$Absorbed/Stat.text = "100%";
	else:
		percent = str(percent) + "00000000";
		$Absorbed/Stat.text = str(percent)[2] + str(percent)[3] + "." + str(percent)[4] + str(percent)[5] + "%";

func SetTime(var level):
	var time = level.time;
	var minutes = int(time / 60);
	var seconds = int(time - minutes * 60);
	var miliSeconds = (level.time - minutes * 60 - seconds) * 100;
		
	if miliSeconds < 10:
		miliSeconds = "0" + str(miliSeconds);
	if seconds < 10:
		seconds = "0" + str(seconds);
	if minutes < 10:
		minutes = "0" + str(minutes);
	
	$Time/Stat.text = str(minutes) + ":" + str(seconds) + ":" + str(miliSeconds)[0] +  str(miliSeconds)[1];

func SetAccuracy(var _stats):
	if stats.missedShots > 0 || stats.hitShots > 0:
		var accuracy = str(float(stats.hitShots / float(stats.hitShots + stats.missedShots))) + "00000000";
	
		if float(stats.hitShots / float(stats.hitShots + stats.missedShots)) == 1:
			$Accuracy/Stat.text = "100.00%"
		else:
			$Accuracy/Stat.text = str(accuracy)[2] + str(accuracy)[3] + "."+ str(accuracy)[4] + str(accuracy)[5] + "%"
	else:
		$Accuracy/Stat.text = "0.00%"

func SetName(var stats):
	$Levelname/Levelname.text = stats.name;

func SetScore(var stats):
	$Summary/Score/Stat.text = str(round(stats.score));

func SetHealthBonus(var stats):
	$Summary/HealthBonus/Label.text = "X" + str(stats.healthBonus)


func SetRank(var _stats):
	var score = stats.score;
	
	if score >= 120:
		$Summary/Rank.text = "S+";
	elif score >= 110:
		$Summary/Rank.text = "S";
	elif score >= 100:
		$Summary/Rank.text = "A+";
	elif score >= 90:
		$Summary/Rank.text = "A";
	elif score >= 80:
		$Summary/Rank.text = "B+";
	elif score >= 70:
		$Summary/Rank.text = "B";
	elif score >= 60:
		$Summary/Rank.text = "C+";
	elif score >= 50:
		$Summary/Rank.text = "C";
	else:
		$Summary/Rank.text = "D";
	

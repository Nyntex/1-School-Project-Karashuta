extends Control

func UpdateAllStats(var Stats, var killedEnemies):
	UpdateTime(Stats);
	UpdateAbsorbed(Stats);
	UpdateAccuracy(Stats);
	UpdateArenaKills(killedEnemies);
	UpdateScore(Stats);
	
func UpdateTime(var Stats):
	var totalTime = 0;
	
	for Stat in Stats:
		totalTime += Stat.time;
	
	var minutes = int(totalTime / 60);
	var seconds = int(totalTime - minutes * 60);
	var miliSeconds = (totalTime - minutes * 60 - seconds) * 100;
	
	if seconds < 10:
		seconds = "0" + str(seconds);
	
	if miliSeconds < 10:
		miliSeconds = "0" + str(miliSeconds);
		
	$Time/Stat.text = str(minutes) + ":" + str(seconds) + ":" + str(miliSeconds)[0] +  str(miliSeconds)[1];

func UpdateArenaKills(var amount):
	$KilledEnemies/Stat.text = str(amount);
	
func UpdateAbsorbed(var Stats):
	pass
	#var totalAbsorbed = 0;
	
	#for Stat in Stats:
		#totalAbsorbed += Stat.absorbed;
	
	#$Absorbed/AbsorbedText.text = "Total Absorbed Damage: " + str(totalAbsorbed);

func UpdateAccuracy(var Stats):
	pass
	#var totalHit = 0;
	#var totalMissed = 0;
	
	#for Stat in Stats:
		#totalHit += Stat.hitShots;
		#totalMissed += Stat.missedShots;
	
	#var accuracy = str(float(totalHit) / float(totalMissed + totalHit)) + "000000";
	#if totalHit > 0 || totalMissed > 0:
		#$Accuracy/AccuracyText.text = "Total Accuracy: " + accuracy[0] + accuracy[1] + "." + accuracy[2] + accuracy[3] + "%";
	#else:
		#$Accuracy/AccuracyText.text = "Total Accuracy: 100.00%";

func UpdateScore(var Stats):
	var totalScore = 0;
	
	for Stat in Stats:
		totalScore += Stat.score;
	
	$Score/Stat.text = str(int(totalScore));
	
	var saver = Saver.new();
	saver.LoadSave();
	saver.playerSavingStats.highscore = totalScore;
	saver.WriteSave();

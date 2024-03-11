extends Label


func UpdateTimeLeft(var time):
	var minutes = int(time / 60);
	var seconds = int(time - minutes * 60);
	var miliSeconds = (time - minutes * 60 - seconds) * 100;
		
	var secondsString = "";
	var miliString = "";
		
	if seconds < 10:
		secondsString += "0";
	if miliSeconds < 10:
		miliString += "0";
		
	secondsString += str(seconds);
	miliString += str(int(miliSeconds));
		
	$LevelTimer/Minutes.text = str(minutes) + ":";
	$LevelTimer/Seconds.text = secondsString + ":";
	$LevelTimer/MiliSeconds.text = miliString;

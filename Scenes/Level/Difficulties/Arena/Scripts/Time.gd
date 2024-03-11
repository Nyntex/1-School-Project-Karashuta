extends Control

func UpdateTime(var time):
	var minutes = int(time / 60);
	var seconds = int(time - minutes * 60);
	var miliSeconds = (time - minutes * 60 - seconds) * 100;
		
	if miliSeconds < 10:
		miliSeconds = "0" + str(miliSeconds);
		
	$Time.text = str(minutes) + ":" + str(seconds) + ":" + str(miliSeconds)[0] +  str(miliSeconds)[1];

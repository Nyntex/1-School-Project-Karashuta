extends TextureRect

func UpdateScore():
	var saver = Saver.new();
	saver.LoadSave();
	$Score.text = str(saver.playerSavingStats.highscore);

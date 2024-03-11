extends Label

func UpdateText(var level, var modifier = 0):
	text = str(level.GetAllEnemies().size() + modifier) + " / " + str(level.maxEnemies)

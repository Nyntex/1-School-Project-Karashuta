class_name PlayerSavingStats
extends Resource

export (int) var totalBulletsHit = 0
export (int) var totalBulletsShot = 0
export (int) var totalEnemysKilled = 0
export (int) var survivedRuns = 0
export (int) var totalDeaths = 0
export (int) var totalBossesKilled = 0
export (bool) var tutorialFinished = false;

export (float) var bossDoorProgression = 0.0
export (float) var rankPoints = 0.0

export (float) var highscore = 0.0

export (bool) var gameFinished = false
export (bool) var startedForFirstTime = true

func get_data():
	return {
				"totalBulletsHit": totalBulletsHit,
				"totalBulletsShot": totalBulletsShot,
				"totalEnemysKilled": totalEnemysKilled,
				"survivedRuns": survivedRuns,
				"totalDeaths": totalDeaths,
				"totalBossesKilled": totalBossesKilled,
				"tutorialFinished": tutorialFinished,
				
				"bossDoorProgression": bossDoorProgression,
				"rankPoints": rankPoints,
				
				"highscore": highscore,
				
				"gameFinished": gameFinished,
				"startedForFirstTime": startedForFirstTime
			}

func set_data(data):
	if data.has("totalBulletShot"):
		totalBulletsShot = data.totalBulletsShot
	if data.has("totalBulletsHit"):
		totalBulletsHit = data.totalBulletsHit
	if data.has("totalEnemysKilled"):
		totalEnemysKilled = data.totalEnemysKilled
	if data.has("survivedRuns"):
		survivedRuns = data.survivedRuns
	if data.has("totalDeaths"):
		totalDeaths = data.totalDeaths
	if data.has("totalBossesKilled"):
		totalBossesKilled = data.totalBossesKilled
	if data.has("tutorialFinished"):
		tutorialFinished = data.tutorialFinished
	
	if data.has("bossDoorProgression"):
		bossDoorProgression = data.bossDoorProgression
	if data.has("rankPoints"):
		rankPoints = data.rankPoints
	if data.has("highscore"):
		highscore = data.highscore
	
	if data.has("gameFinished"):
		gameFinished = data.gameFinished
	if data.has("startedForFirstTime"):
		startedForFirstTime = data.startedForFirstTime

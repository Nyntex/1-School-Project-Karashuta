extends Node2D

func SetUp(var player):
	Enable();
	
	$Easy.SetUp();
	$Mid.SetUp();
	$Hard.SetUp();
	$Boss.SetUp(player);
	
	ShowProgress();
	UnlockThrophyIfPossible()

func HideProgress():
	$Easy.Hide();
	$Mid.Hide();
	$Hard.Hide();
	$Boss.Hide();
	$Trophy.visible = false;
	$RestartTutorial.visible = false;
	
func ShowProgress():
	$Easy.Show();
	$Mid.Show();
	$Hard.Show();
	$Boss.Show();
	UnlockThrophyIfPossible()
	$RestartTutorial.visible = true;
	
func GetProgress(var difficulty):
	match difficulty:
		0:
			return $Easy;
		1:
			return $Mid;
		2:
			return $Hard;
		3:
			return $Boss;
			
	return null;

func Disable():
	$Easy.Disable();
	$Mid.Disable();
	$Hard.Disable();
	$Boss.Disable();

func Enable():
	$Easy.Enable();
	$Mid.Enable();
	$Hard.Enable();
	$Boss.Enable();

func UnlockThrophyIfPossible():
	var saver = Saver.new();
	saver.LoadSave();
	$Trophy.visible = saver.playerSavingStats.highscore > 0

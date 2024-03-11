extends Node2D

signal finished();
var player;

func StartTutorial(var player_):
	$TutorialChapters/Movement.Start();
	$Barrels.SetUp(null);
	
	player = player_;
	player.global_position = $SpawnPoint.global_position;
	
	player.connect("OnColorSwitched", $TutorialChapters/ColorSwaping, "OnPlayerColorSwitch");

	player.get_node("Containers/ColorContainer").connect("onRedAbilityUse" ,$TutorialChapters/ColorBars3 ,"OnRedUse")
	player.get_node("Containers/ColorContainer").connect("onBlueAbilityUse" ,$TutorialChapters/ColorBars3 ,"OnBlueUse")
	player.get_node("Containers/ColorContainer").connect("onAbilityUse" ,$TutorialChapters/ColorBars3 ,"OnSpecialAbilityUsed")
		
	player.connect("OnDeath", self, "OnPlayerDeath")
	
	player.get_node("Containers/ColorContainer").Hide();
	player.get_node("Containers/ColorContainer").ReduceMaxValue(10000)
	
	player.OnHubLeft();


func OnPlayerDeath():
	if visible:
		yield(get_tree().create_timer(1), "timeout") 
		player.global_position = $SpawnPoint.global_position;
		yield(get_tree().create_timer(0), "timeout") 
		player.Ressurect();

func _on_Movement_finished():
	$TutorialChapters/ColorSwaping.Start(player);

func _on_ColorSwaping_finished():
	$TutorialChapters/Shields.Start();

func _on_Shields_Finished():
	$TutorialChapters/Shooting.Start(player);

func _on_Shooting_finished():
	$TutorialChapters/Enemyshields.Start();

func _on_Enemyshields_finished():
	$TutorialChapters/RageMode.Start(player);

func _on_RageMode_finished():
	$TutorialChapters/BulletCombat.Start(player);

func _on_BulletCombat_finished():
	$TutorialChapters/ColorBars1.Start(player);

func _on_ColorBars1_finished():
	$TutorialChapters/ColorBars2.Start(player);

func _on_ColorBars2_finished():
	$TutorialChapters/ColorBars3.Start(player);

func _on_ColorBars3_finished():
	$TutorialChapters/Finish.Start();
	
func _on_Finish_finished():
	$TutorialChapters/BlueLaser.queue_free();
	$TutorialChapters/RedLaser.queue_free();
	
	player.Healdamage(INF);
	
	var saver = Saver.new();
	saver.LoadSave();
	saver.playerSavingStats.tutorialFinished = true;
	saver.WriteSave();
	
	emit_signal("finished");



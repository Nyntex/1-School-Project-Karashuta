extends Node2D

var player:KinematicBody2D;
onready var bossStoryTelling = $BossStoryCanvas/BossStoryTelling
onready var bossDeathStoryTelling = $BossDeathStoryCanvas/BossDeathStorytelling

signal SilenceMusic

var saver = Saver.new()

func SetUp(var player_):
	player = player_;

	$StartSluice.HideLeftDoor(true);

func _on_StartSluice_OnLevelStart():
	player.set_process(false)
	player.set_physics_process(false)
	
#	bossStoryTelling.global_position = player.global_position
	bossStoryTelling.ActivateBoxes()
	$BossStoryCanvas.visible = true
	yield(bossStoryTelling, "Finished")
	$BossStoryCanvas.visible = false
	player.set_process(true)
	player.set_physics_process(true)
	
	$"Enemies/Trigger Twins Clone Manager".Setup(player);

func _on_Trigger_Twins_Clone_Manager_tree_exited():
	bossDeathStoryTelling.ActivateBoxes()
	$BossDeathStoryCanvas.visible = true
	yield(bossDeathStoryTelling, "Finished")
	$BossDeathStoryCanvas.visible = false

func _on_BossDeathStorytelling_Finished():
	#Play Drone Animation to deactivate shield
	player.set_process(false)
	player.set_physics_process(false)
	if player.has_method("PlayFinish"):
		player.connect("FinishedDeath", self, "PlayerFinished")
		player.PlayFinish()

func PlayerFinished():
	$MusicSilencer.start()
	$CreditsCanvas/AnimationPlayer.play("FadeInAndOut")

func CreditsFinished():
	player.set_process(false)
	player.set_physics_process(false)
	if player.has_method("PlayRevive"):
		player.connect("FinishedRevive", self, "PlayerRevived")
		player.PlayRevive()

func PlayerRevived():
	player.set_process(true)
	player.set_physics_process(true)
	$AnimationPlayer.play("FadeOut")

func _on_MusicSilencer_timeout():
	
	var effectVolume = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Effects"))
	var musicVolume = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music"))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Effects"), effectVolume - 2)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), musicVolume - 2)

func BackToMenu():
	saver.LoadSave()
	saver.playerSavingStats.gameFinished = true
	saver.WriteSave()
	get_tree().change_scene("res://Scenes/Game/Sc_Game.tscn")

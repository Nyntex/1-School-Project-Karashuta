extends Node2D

export (PackedScene) var playerScene;
export (bool) var autoStart = false;
var player;
var saver = Saver.new();

func _ready():
	$GameCanvas/CustomRun.SetUp($LevelLoader);
	randomize()
	if autoStart:
		_on_StartScreen_start();

func _on_StartScreen_start():
	$LevelLoader.visible = false
	$GameCanvas/BlendIn/AnimationPlayer.play("BlendInAndOut");
	$Music.EndMainMusic();
	$Music.StartHubMusic();
	$GameCanvas/StartScreen/Main.highlighted = false;

func SetUpGame(): # called through "BlendInAndOut" animation
	player = playerScene.instance();
	add_child(player);
	player.connect("OnDeath", self, "OnPlayerDeath");
	player.SetControlScheme($GameCanvas/Settings/Window/ControlScheme.GetScheme());
	
	player.global_position = $LevelLoader/Hub.global_position;
	player.OnHubEnter();
	$LevelLoader.LoadStartingLevels(player);
	$LevelLoader/Hub.SetUp(player);
	$GameCanvas/Settings/Window/OtherSettings/SmallColorBar.SetUp(player);
	
	saver.LoadSave();
	if !saver.playerSavingStats.tutorialFinished:
		$LevelLoader/Hub.StartTutorial(player);

func Reset():
	$LevelLoader.DeSpawnAllLevels();
	var bulletHolder = get_tree().root.get_node_or_null("BulletHolder");
	if bulletHolder != null:
		bulletHolder.free();
	
	player.global_position = $LevelLoader/Hub.global_position;
	player.OnHubEnter();
	
	yield(get_tree().create_timer(0), "timeout") # Wait a frame to make sure that the player position gets correctly updated, before proceeding
	
	$Music.StopRunMusic();
	$Music.StopBossMusic();
	$Music.StartHubMusic();
	
	player.SetUp();
	$LevelLoader.LoadStartingLevels(player);

func _on_ReturnToHub_pressed():
	if $LevelLoader/Hub.activeTutorial == null || !is_instance_valid($LevelLoader/Hub.activeTutorial):
		player.Ressurect();
		Reset();
		$LevelLoader/Hub.SetUp(player);
		$GameCanvas/PauseScreen.DeActivate();
		
		$GameCanvas/DeathScreen.highlighted = false;
		

func OnPlayerDeath():
	if $LevelLoader/Hub.activeTutorial == null || !is_instance_valid($LevelLoader/Hub.activeTutorial):
		$GameCanvas/DeathScreen.Activate();

func _on_ControlSchemeWindow_OnControlSchemeSet():
	if player != null:
		player.SetControlScheme($GameCanvas/Settings/Window/ControlScheme.GetScheme());

func _on_Hub_playerLeftHub():
	player.OnHubLeft();
	$Music.StartRunMusic(player);
	$Music.StopHubMusic();

func _on_Hub_playerEnterBossTunnel():
	player.OnHubLeft();
	$Music.StartBossMusic(player);
	$Music.StopHubMusic();

func _on_PreGameStoryTelling_Finished():
	$GameCanvas/BlendIn/AnimationPlayer.play("BlendIn")
	$LevelLoader.visible = true
	SetUpGame()

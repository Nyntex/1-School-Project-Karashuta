extends Node2D

signal startedTutorial();
signal finishedTutorial();
signal playerLeftHub();
signal playerEnterBossTunnel();

export (PackedScene) var TutorialScene;
var activeTutorial;

var saver = Saver.new()
var player;

func _ready():
	$HubDoor.Open();

func SetUp(var player_):
	player = player_;
	$HubLevel.SetUp(player);
	$HubDoor.Open();

func GetGlobalStartPosition():
	return $StartSluicePosition.global_position;

func StartTutorial(player_):
	QuitTutorialIfPossible();
	
	activeTutorial = TutorialScene.instance();
	add_child(activeTutorial);
	activeTutorial.global_position = $TutorialSpawnPoint.global_position;
	activeTutorial.StartTutorial(player_)
	activeTutorial.connect("finished", self, "OnTutorialFinish")
	$HubLevel.HideProgress();
	$HubLevel.Disable();
	$HubDoor.Close();
	
	emit_signal("startedTutorial");

func OnTutorialFinish():
	emit_signal("finishedTutorial");
	$HubLevel.HideProgress();
	$HubDoor.Open();
	player.Healdamage(100);

func QuitTutorialIfPossible():
	if activeTutorial != null && is_instance_valid(activeTutorial):
		activeTutorial.queue_free();
		$HubLevel.Enable();

func _on_TemplateEnviorement_RestartTutorial():
	QuitTutorialIfPossible();
	StartTutorial(player);

func _on_HubTransition_body_entered(_body):
	emit_signal("playerLeftHub");
	QuitTutorialIfPossible();
	$HubLevel.HideProgress();

func _on_BossTransition_body_entered(body):
	emit_signal("playerEnterBossTunnel");
	QuitTutorialIfPossible();
	$HubLevel.HideProgress();

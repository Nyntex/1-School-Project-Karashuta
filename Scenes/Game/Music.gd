extends Node2D

onready var run = $RunMusic
onready var boss = $BossMusic

func _ready():
	run = $RunMusic;

func StartRunMusic(var player):
	run.FadeIn();
	run.StickToNode(player);
	
func StopRunMusic():
	run.FadeOut();

func StartBossMusic(var player):
	boss.FadeIn()
	boss.StickToNode(player)

func StopBossMusic():
	boss.FadeOut()

func StartMainMusic():
	$MainMusic.FadeIn();

func EndMainMusic():
	$MainMusic.FadeOut();

func StartHubMusic():
	$HubMusic.FadeIn();

func StopHubMusic():
	$HubMusic.FadeOut();

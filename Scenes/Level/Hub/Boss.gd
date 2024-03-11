extends Node2D

var level = 0;
export (PackedScene) var bossArena;
var activeArena;
var player;

func SetUp(var player_):
	player = player_;
	Load();
	DeleteBossArenaIfPossible();
	$BossCanvas.UpdateLocks(level);

func LevelUp():
	level += 1;
	$BossCanvas.UpdateLocks(level);
	Save();

func Hide():
	#$BossCanvas/AnimationPlayer.play_backwards("Appear");
	$BossDoor.BossDoorClose();

func Show():
	#OpenDoorIfPossible();
	pass

func OpenDoorIfPossible(body:KinematicBody2D):
	if level >= 4:
		$BossDoor.Open(false, body);

func Save():
	var save = Saver.new();
	save.LoadSave();
	save.playerSavingStats.bossDoorProgression = level;
	save.WriteSave();

func Load():
	var save = Saver.new();
	save.LoadSave();
	level = save.playerSavingStats.bossDoorProgression;


func _on_Area2D_body_entered(_body):
	#$BossDoor.Close();
	DeleteBossArenaIfPossible();
	
	activeArena = bossArena.instance();
	activeArena.global_position = $BossArenaSpawnPoint.global_position;
	activeArena.global_scale = Vector2(1,1);
	add_child(activeArena);
	
	yield(get_tree().create_timer(1.0), "timeout")
	activeArena.SetUp(player);
	
func DeleteBossArenaIfPossible():
	if activeArena != null && is_instance_valid(activeArena):
		activeArena.queue_free();


func _on_UITrigger_body_entered(_body):
	$BossCanvas.visible = true;
	$BossCanvas/AnimationPlayer.play("Appear");

func _on_UITrigger_body_exited(_body):
	$BossCanvas/AnimationPlayer.play_backwards("Appear");

func Disable():
	$BossDoor/Notification.visible = false;
	$BossDoor.BossDoorClose();
	$BossCanvas.visible = false;
	$BossDoor.locked = true;
	$UITrigger.set_collision_mask_bit(0, false);

func Enable():
	#$BossDoor/Notification.visible = true;
	
	#$BossCanvas.visible = true;
#	$BossDoor/Area2D.set_collision_mask_bit(0, true);
	$UITrigger.set_collision_mask_bit(0, true);
	$BossDoor.locked = false;
	#OpenDoorIfPossible();

func _on_NotificationTrigger_body_entered(body):
	OpenDoorIfPossible(body);

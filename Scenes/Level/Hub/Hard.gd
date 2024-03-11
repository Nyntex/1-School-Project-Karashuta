extends Node2D

var level = 0;
export (float) var XPNeeded = 100.0;
var XPLeft = 0;
export (Color) var barColor;
var target = 0;


func SetUp():
	Load();
	$HardCanvas.SetAllStats(self);
	$HardUnlocks.SetUnlockedObjects(level);
	$HardCanvas.SetBarColor(barColor);
	AddXP(0, false);
	
	if IfMaxed():
		$HardCanvas.SetMaxed();

func AddXP(var amount, var autoLevelUp = true):
	XPLeft += amount;
	while(XPLeft > XPNeeded && autoLevelUp):
		XPLeft = clamp(XPLeft - XPNeeded,0,INF);
		LevelUp();
		
	$HardCanvas.SetAllStats(self);
	Save();

func LevelUp():
	level += 1;
	$HardUnlocks.SetUnlockedObjects(level);
	emit_signal("OnLevelUp");
	Save();

func Hide():
	$HardUnlocks.SetUnlockedObjects(0);

func Show():
	$HardUnlocks.SetUnlockedObjects(clamp(level - 1,0,INF));
	if level > 0:
		$HardDoor.Open(true);
	else:
		$HardDoor.Close(true);

func Save():
	var saver = Saver.new();
	saver.LoadSave();
	saver.hubStats.HardLevels = level;
	saver.hubStats.HardXPLeft = XPLeft;
	saver.WriteSave();

func Load():
	var saver = Saver.new();
	saver.LoadSave();
	level = saver.hubStats.HardLevels;
	XPLeft = saver.hubStats.HardXPLeft;


func _on_Area2D_body_shape_entered(_body_rid, _body, _body_shape_index, _local_shape_index):
	$HardCanvas/AnimationPlayer.play("Appear");

func _on_Area2D_body_shape_exited(_body_rid, _body, _body_shape_index, _local_shape_index):
	$HardCanvas/AnimationPlayer.play_backwards("Appear");

func IfMaxed():
	return level >= $HardUnlocks.get_child_count() + 1

func GetMaxLevel():
	return $HardUnlocks.get_child_count() + 1;

func GetCurrentUnlock():
	if level == 0:
		return $HardDoor;
	
	if $HardUnlocks.get_child_count()  >= level - 1:
		return $HardUnlocks.get_child(level - 2);
	
	return null;

func Disable():
	$HardCanvas.visible = false;
	$HardUnlocks.visible = false;
	$Area2D.set_collision_mask_bit(0, false);
	
	$HardDoor.Close();
	$HardDoor.locked = true;
	$HardDoor/Notification.visible = false;
	$HardDoor/NotificationTrigger.set_collision_mask_bit(0, false);
	
func Enable():
	#$HardCanvas.visible = true;
	$HardUnlocks.visible = true;
	$Area2D.set_collision_mask_bit(0, true);
	
	#$HardDoor/Notification.visible = true;
	$HardDoor/NotificationTrigger.set_collision_mask_bit(0, true);
	
	$HardDoor.locked = false;
	if level > 0:
		$HardDoor.Open();

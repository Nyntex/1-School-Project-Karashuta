extends Node2D

var level = 0;
export (float) var XPNeeded = 100.0;
var XPLeft = 0;
export (Color) var barColor;

var target = 0;

func SetUp():
	Load();
	$MidCanvas.SetAllStats(self);
	$MidUnlocks.SetUnlockedObjects(level);
	$MidCanvas.SetBarColor(barColor);
	AddXP(0, false);
	
	if IfMaxed():
		$MidCanvas.SetMaxed();

func AddXP(var amount, var autoLevelUp = true):
	XPLeft += amount;
	while(XPLeft > XPNeeded && autoLevelUp):
		XPLeft = clamp(XPLeft - XPNeeded,0,INF);
		LevelUp();

	$MidCanvas.SetAllStats(self);
	Save();

func LevelUp():
	level += 1;
	$MidUnlocks.SetUnlockedObjects(level);
	Save();

func Hide():
	$MidUnlocks.SetUnlockedObjects(0);

func Show():
	$MidUnlocks.SetUnlockedObjects(clamp(level - 1,0,INF));
	if level > 0:
		$MidDoor.Open(true);
	else:
		$MidDoor.Close(true);

func Save():
	var saver = Saver.new();
	saver.LoadSave();
	saver.hubStats.MidLevels = level;
	saver.hubStats.MidXPLeft = XPLeft;
	saver.WriteSave();

func Load():
	var saver = Saver.new();
	saver.LoadSave();
	level = saver.hubStats.MidLevels;
	XPLeft = saver.hubStats.MidXPLeft;


func _on_Area2D_body_shape_entered(_body_rid, _body, _body_shape_index, _local_shape_index):
	$MidCanvas/AnimationPlayer.play("Appear");


func _on_Area2D_body_shape_exited(_body_rid, _body, _body_shape_index, _local_shape_index):
	$MidCanvas/AnimationPlayer.play_backwards("Appear");

func IfMaxed():
	return level >= $MidUnlocks.get_child_count() + 1;

func GetMaxLevel():
	return $MidUnlocks.get_child_count() + 1;

func GetCurrentUnlock():
	if level == 0:
		return $MidDoor;
	
	if $MidUnlocks.get_child_count() >= level - 1:
		return $MidUnlocks.get_child(level - 2);
	
	return null;

func Disable():
	$MidCanvas.visible = false;
	$MidUnlocks.visible = false;
	$MidDoor/Notification.visible = false;
	$MidDoor.Close();
	$MidDoor.locked = true;
	
	$Area2D.set_collision_mask_bit(0, false);
	$MidDoor/NotificationTrigger.set_collision_mask_bit(0, false);
	
func Enable():
	#$MidCanvas.visible = true;
	$MidUnlocks.visible = true;
	$MidDoor/Notification.visible = false;
	
	$Area2D.set_collision_mask_bit(0, true);
	$MidDoor/NotificationTrigger.set_collision_mask_bit(0, true);
	
	$MidDoor.locked = false;
	if level > 0:
		$MidDoor.Open();



func _on_BossDoor_Open():
	pass # Replace with function body.

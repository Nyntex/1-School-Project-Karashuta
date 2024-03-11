extends Node2D

var level = 0;
export (float) var XPNeeded = 100.0;
var XPLeft = 0;
export (Color) var barColor;

var target = 0;

func SetUp():
	Load();
	$EasyCanvas.SetAllStats(self);
	$EasyUnlocks.SetUnlockedObjects(level);
	$EasyCanvas.SetBarColor(barColor);
	AddXP(0, false);
	
	if IfMaxed():
		$EasyCanvas.SetMaxed();

func AddXP(var amount, var autoLevelUp = true):
	XPLeft += amount;
	while(XPLeft > XPNeeded && autoLevelUp):
		XPLeft = clamp(XPLeft - XPNeeded,0,INF);
		LevelUp();
		
	$EasyCanvas.SetAllStats(self);
	Save();

func LevelUp():
	level += 1;
	$EasyUnlocks.SetUnlockedObjects(level);
	Save();

func Hide():
	$EasyUnlocks.SetUnlockedObjects(0);

func Show():
	$EasyUnlocks.SetUnlockedObjects(level);

func Save():
	var saver = Saver.new();
	saver.LoadSave();
	saver.hubStats.EasyLevels = level;
	saver.hubStats.EasyXPLeft = XPLeft;
	saver.WriteSave();

func Load():
	var saver = Saver.new();
	saver.LoadSave();
	level = saver.hubStats.EasyLevels;
	XPLeft = saver.hubStats.EasyXPLeft;


func _on_Area2D_body_shape_entered(_body_rid, _body, _body_shape_index, _local_shape_index):
	$EasyCanvas/AnimationPlayer.play("Appear");

func _on_Area2D_body_shape_exited(_body_rid, _body, _body_shape_index, _local_shape_index):
		$EasyCanvas/AnimationPlayer.play_backwards("Appear");

func IfMaxed():
	return level >= $EasyUnlocks.get_child_count() + 1;

func GetMaxLevel():
	return $EasyUnlocks.get_child_count() + 1;

func GetCurrentUnlock():
	if $EasyUnlocks.get_child_count() >= level:
		return $EasyUnlocks.get_child(level);
	
	return null;

func Disable():
	$EasyCanvas.visible = false;
	$EasyUnlocks.visible = false;
	$Area2D.set_collision_mask_bit(0, false);

func Enable():
	#$EasyCanvas.visible = true;
	$EasyUnlocks.visible = true;
	$Area2D.set_collision_mask_bit(0, true);

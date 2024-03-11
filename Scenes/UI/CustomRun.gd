extends Control

signal UpdatedRun(customOrder);

var customLevelOrder = [null, null, null, null, null, null];
var baseLevelList = [];

func Activate():
	visible = true;
	$AnimationPlayer.play("Open");

func SetUp(var levelloader):
	var levelList = levelloader.easyLevels + levelloader.midLevels + levelloader.hardLevels + levelloader.arenaLevels;
	baseLevelList = [null] + levelList;
	
	for button in $Window/Buttons.get_children():
		button.add_item("Default");
		for level in levelList:
			var temp = level.instance();
			button.add_item(temp.name);
			temp.queue_free();

func _on_Return_pressed():
	$AnimationPlayer.play_backwards("Open");


func CustomLevelSelected(index, buttonIndex):
	customLevelOrder[buttonIndex] = baseLevelList[index];
	emit_signal("UpdatedRun", customLevelOrder);


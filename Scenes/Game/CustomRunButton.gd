extends TextureButton

func _ready():
	var save = Saver.new();
	save.LoadSave();
	
	disabled = !save.playerSavingStats.gameFinished;
	if disabled:
		$Text.modulate = Color.gray;


func _on_CustomRun_mouse_entered():
	var save = Saver.new();
	save.LoadSave();
	
	disabled = !save.playerSavingStats.gameFinished;
	if disabled:
		$UnlockWindow.visible = true;


func _on_CustomRun_mouse_exited():
	$UnlockWindow.visible = false;

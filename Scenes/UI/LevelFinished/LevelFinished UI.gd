extends Control

var Stats;
var pastStats;
var hub;

func activate(var levelStats, var pastLevelStats, var hub_):
	highlighted = true;
	UpdateControllerSelectedSign();
	
	
	$AnimationPlayer.playback_speed = 1;
	$AnimationPlayer.play("Open");
	
	get_tree().paused = true;
	Stats = levelStats;
	pastStats = pastLevelStats;
	hub = hub_;
	
	$Title.UpdateText(levelStats, hub);
	$Timeline.SpawnButtons(pastLevelStats + [levelStats], self);
	
	$Progress.SetUp(levelStats, hub);
	$Timeline/TextureProgress.SetUp(pastLevelStats); 
	$Progress.AddPoints(levelStats.score);
	#$Stats.Update(levelStats); Now called through the "OnFinished" signal of the timeline TextureProgress

func UpdateText(var level):
	$Stats.Activate((pastStats + [Stats])[level]);
	$Timeline.UpdateButtonVisuals(level);

func DeActivate():
	$AnimationPlayer.playback_speed = 2;
	$AnimationPlayer.play_backwards("Open");
	get_tree().paused = false;
	highlighted = false;

func _on_TextureProgress_OnFinished():
	$Stats.Activate(Stats);

func _on_LevelUpProgress_onLevelUp():
	$NewUnlock.Activate(hub, Stats);
	highlighted = false;
	var progress = hub.get_node("HubLevel").GetProgress(Stats.difficulty);
	progress.LevelUp();


#Controller support
var highlighted = false;
var controller = false;
var lastButton = null;
var lastNormal = null;

func _process(delta):
	if !highlighted || !controller:
		return;

	if Input.is_action_just_pressed("SELECT"):
		SimulateMouseClick();

func _input(event):
	controller = event is InputEventJoypadButton || event is InputEventJoypadMotion;
	if controller:
		Input.mouse_mode = Input.MOUSE_MODE_HIDDEN;
	else:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE;
		ResetLastButton()

	UpdateControllerSelectedSign();

func UpdateControllerSelectedSign():
	$Continue/ControllerSelected.visible = false;
	
	if controller:
		$Continue/ControllerSelected.visible = true;
		SimulateMousePosition($Continue);


func SimulateMousePosition(var button):
	if !highlighted || button == null || button == lastButton:
		return;
	
	ResetLastButton();
	
	lastButton = button;
	lastNormal = button.texture_normal;
	
	button.texture_normal = button.texture_hover;
	button.emit_signal("mouse_entered")


func SimulateMouseClick():
	if !highlighted || lastButton == null || lastButton.disabled:
		return;
	
	lastButton.emit_signal("pressed")

func ResetLastButton():
	if lastButton != null && lastNormal != null:
		lastButton.emit_signal("mouse_exited");
		lastButton.texture_normal = lastNormal;

func _on_NewUnlock_OnClose():
	highlighted = true;
